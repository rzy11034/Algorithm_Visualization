﻿unit VisibleDSA.AlgoVisualizer;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Graphics,
  Forms,
  BGRACanvas2D,
  VisibleDSA.AlgoVisHelper,
  VisibleDSA.MazeData,
  VisibleDSA.Position;

type
  TAlgoVisualizer = class(TObject)
  const
    D: TArr2D_int = ((-1, 0), (0, 1), (1, 0), (0, -1));

  private
    _runningStatus: integer;
    _width: integer;
    _height: integer;
    _data: TMazeData;

    procedure __setData(x, y: integer; finished: boolean);

  public
    constructor Create(form: TForm);
    destructor Destroy; override;

    procedure Paint(canvas: TBGRACanvas2D);
    procedure Run;
  end;

implementation

uses
  VisibleDSA.AlgoForm,
  VisibleDSA.RandomQueue;

type
  TQueue_Position = specialize TRandomQueue<TPosition>;

{ TAlgoVisualizer }

constructor TAlgoVisualizer.Create(form: TForm);
var
  blockSide, size: integer;
begin
  size := 101;
  blockSide := 808 div size;
  _data := TMazeData.Create(size, size);

  _width := blockSide * _data.M;
  _height := blockSide * _data.N;
  _runningStatus := 0;

  form.ClientWidth := _width;
  form.ClientHeight := _height;

  form.Caption := 'Maze solver visualization --- ' + Format('W: %d, H: %d', [_width, _height]);
end;

destructor TAlgoVisualizer.Destroy;
begin
  FreeAndNil(_data);
  inherited Destroy;
end;

procedure TAlgoVisualizer.Paint(canvas: TBGRACanvas2D);
var
  w, h: integer;
  i, j: integer;
begin
  w := _width div _data.N;
  h := _height div _data.M;

  for i := 0 to _data.N - 1 do
  begin
    for j := 0 to _data.M - 1 do
    begin
      if _data.GetMaze(i, j) = TMazeData.WALL then
        TAlgoVisHelper.SetFill(CL_LIGHTBLUE)
      else
        TAlgoVisHelper.SetFill(CL_WHITE);

      TAlgoVisHelper.FillRectangle(canvas, j * w, i * h, w, h);
    end;
  end;
end;

procedure TAlgoVisualizer.Run;
var
  queue: TQueue_Position;
  curPos: TPosition;
  i, newX, newY: integer;
begin
  queue := TQueue_Position.Create;
  try
    curPos := TPosition.Create(_data.EntranceX, _data.EntranceY + 1);
    queue.Enqueue(curPos);
    _data.Visited[curPos.X, curPos.Y] := True;

    while queue.Count > 0 do
    begin
      curPos := queue.Dequeue;

      for i := 0 to High(D) do
      begin
        newX := curPos.X + D[i, 0] * 2;
        newY := curPos.Y + D[i, 1] * 2;

        if _data.InArea(newX, newY) and (_data.Visited[newX, newY] = False) then
        begin
          queue.Enqueue(TPosition.Create(newX, newY));
          _data.Visited[newX, newY] := True;
          __setData(curPos.X + D[i, 0], curPos.Y + D[i, 1], False);
        end;
      end;
    end;
  finally
    queue.Free;
  end;

  __setData(-1, -1, True);
end;

procedure TAlgoVisualizer.__setData(x, y: integer; finished: boolean);
begin
  if _data.InArea(x, y) then
    _data.Maze[x, y] := TMazeData.ROAD;

  if finished or (_runningStatus >= 5) then
  begin
    TAlgoVisHelper.Pause(0);
    AlgoForm.BGRAVirtualScreen.RedrawBitmap;
    _runningStatus := 0;
  end
  else
  begin
    _runningStatus += 1;
  end;
end;

end.
