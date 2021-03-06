﻿unit VisibleDSA.AlgoVisualizer;

interface

uses
  System.SysUtils,
  System.Types,
  System.Math,
  FMX.Graphics,
  FMX.Forms,
  VisibleDSA.AlgoVisHelper,
  VisibleDSA.MazeData;

type
  TAlgoVisualizer = class(TObject)
  const
    D: TArr2D_int = [[-1, 0], [0, 1], [1, 0], [0, -1]];

  private
    _width: integer;
    _height: integer;
    _data: TMazeData;
    _form: TForm;

    procedure __setData(x, y: integer; isPath, finished: boolean);

  public
    constructor Create(form: TForm);
    destructor Destroy; override;

    procedure Paint(canvas: TCanvas);
    procedure Run;
  end;

implementation

uses
  System.Generics.Collections,
  VisibleDSA.AlgoForm,
  VisibleDSA.Position;

type
  TArray_int = TArray<integer>;
  TStack_TPosition = TStack<TPosition>;

{ TAlgoVisualizer }

constructor TAlgoVisualizer.Create(form: TForm);
var
  blockSide: integer;
begin
  blockSide := 8;
  _data := TMazeData.Create(TMazeData.FILE_NAME);

  _form := form;
  _form.ClientWidth := blockSide * _data.M;
  _form.ClientHeight := blockSide * _data.N;

  _width := _form.ClientWidth;
  _height := _form.ClientHeight;

  _form.Caption := 'Maze solver visualization' +
    Format('W: %d, H: %d', [_Width, _Height]);;
end;

destructor TAlgoVisualizer.Destroy;
begin
  FreeAndNil(_data);
  inherited Destroy;
end;

procedure TAlgoVisualizer.Paint(canvas: TCanvas);
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

      if _data.Path[i, j] then
        TAlgoVisHelper.SetFill(CL_YELLOW);

      if _data.Returned[i, j] then
        TAlgoVisHelper.SetFill(CL_RED);

      TAlgoVisHelper.FillRectangle(canvas, j * w, i * h, h, w);
    end;
  end;
end;

procedure TAlgoVisualizer.Run;
  procedure __findPath__(des: TPosition);
  var
    cur: TPosition;
  begin
    cur := des;

    while cur <> nil do
    begin
      _data.Returned[cur.X, cur.Y] := True;
      cur := cur.Prev;
    end;
  end;

var
  stack: TStack_TPosition;
  curPos: TPosition;
  i, newX, newY: integer;
  isSolved: boolean;
begin
  __setData(-1, -1, False, False);

  stack := TStack_TPosition.Create;
  _data.Visited[_data.EntranceX, _data.EntranceY] := True;
  stack.Push(TPosition.Create(_data.EntranceX, _data.EntranceY));

  isSolved := False;

  while stack.Count <> 0 do
  begin
    curPos := stack.Pop;
    __setData(curPos.X, curPos.Y, True, False);

    if (curPos.X = _data.ExitX) and (curPos.Y = _data.ExitY) then
    begin
      __findPath__(curPos);
      isSolved := True;
      Break;
    end;

    for i := 0 to High(D) do
    begin
      newX := curPos.X + D[i, 0];
      newY := curPos.Y + D[i, 1];

      if (_data.InArea(newX, newY)) and
        (_data.GetMaze(newX, newY) = TMazeData.ROAD) and
        (_data.Visited[newX, newY] = False) then
      begin
        stack.Push(TPosition.Create(newX, newY, curPos));
        _data.Visited[newX, newY] := True;
      end;
    end;
  end;

  if isSolved = False then
    WriteLn('The maze has no Solution!');

  __setData(-1, -1, False, True);
end;

var
  can: integer;

procedure TAlgoVisualizer.__setData(x, y: integer; isPath, finished: boolean);
begin
  if _data.InArea(x, y) then
    _data.Path[x, y] := isPath;

  if (finished) or (can >= 10) then
  begin
    TAlgoVisHelper.Pause(1);
    AlgoForm.PaintBox.Repaint;
    can := 0;
  end
  else
  begin
    can := can + 1
  end;
end;

end.
