﻿unit VisibleDSA.AlgoVisualizer;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Graphics,
  Controls,
  Dialogs,
  Forms,
  LCLType,
  BGRACanvas2D,
  VisibleDSA.AlgoVisHelper,
  VisibleDSA.MineSweeperData,
  DeepStar.Utils.UString;

type
  TAlgoVisualizer = class(TObject)
  const
    D: TArr2D_int = ((-1, 0), (0, 1), (1, 0), (0, -1));

  private
    //_runningStatus: integer;
    _width: integer;
    _height: integer;
    _data: TMineSweeperData;

    procedure __setData(mbLeft: boolean; x, y: integer);
    procedure __mouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);

  public
    constructor Create(form: TForm);
    destructor Destroy; override;

    procedure Paint(canvas: TBGRACanvas2D);
    procedure Run;
  end;

implementation

uses
  Buttons,
  VisibleDSA.AlgoForm;

{ TAlgoVisualizer }

constructor TAlgoVisualizer.Create(form: TForm);
var
  blockSide, n, m, numberMine: integer;
begin
  blockSide := 32;
  n := 20;
  m := 20;
  numberMine := 50;

  _data := TMineSweeperData.Create(n, m, numberMine);

  _width := blockSide * _data.M;
  _height := blockSide * _data.N;

  form.ClientWidth := _width;
  form.ClientHeight := _height;
  TAlgoForm(form).BGRAVirtualScreen.OnMouseDown := @__mouseDown;

  form.Caption := 'Mine Sweeper --- ' + Format('W: %d, H: %d', [_width, _height]);
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
  str: UString;
  stm: TResourceStream;
begin
  w := _width div _data.M;
  h := _height div _data.N;

  for i := 0 to _data.N - 1 do
  begin
    for j := 0 to _data.M - 1 do
    begin
      if _data.Opened[i, j] then
      begin
        if _data.IsMine(i, j) then
          str := TMineSweeperData.PNG_MINE
        else
          str := TMineSweeperData.PNG_NUM(_data.Numbers[i, j]);
      end
      else
      begin
        if _data.Flags[i, j] then
          str := TMineSweeperData.PNG_FLAG
        else
          str := TMineSweeperData.PNG_BLOCK;
      end;

      stm := TResourceStream.Create(HINSTANCE, string(str), RT_RCDATA);
      TAlgoVisHelper.DrawImageFormResourceStream(canvas, stm, j * w, i * h, w, h);
    end;
  end;
end;

procedure TAlgoVisualizer.Run;
begin
  //__setData(true);
end;

procedure TAlgoVisualizer.__mouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  w, h: integer;
  i, j: integer;
  isLeft: boolean;
begin
  w := AlgoForm.BGRAVirtualScreen.Width div _data.M;
  h := AlgoForm.BGRAVirtualScreen.Height div _data.N;

  i := y div h;
  j := x div W;

  if Button = TMouseButton.mbLeft then
    isLeft := true
  else
    isLeft := false;

  __setData(isLeft, i, j);
end;

procedure TAlgoVisualizer.__setData(mbLeft: boolean; x, y: integer);
begin
  if _data.InArea(x, y) and (not _data.Opened[x, y]) then
  begin
    if mbLeft then
    begin
      if _data.IsMine(x, y) then
        _data.Opened[x, y] := true
      else
        _data.Open(x, y);
    end
    else
      _data.Flags[x, y] := not _data.Flags[x, y];

    AlgoForm.BGRAVirtualScreen.RedrawBitmap;
  end;
end;

end.
