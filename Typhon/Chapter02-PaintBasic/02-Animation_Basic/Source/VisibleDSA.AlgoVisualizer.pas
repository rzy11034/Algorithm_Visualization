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
  VisibleDSA.Circle;

type
  TAlgoVisualizer = class(TObject)
  private
    _circles: array of TCircle;
    _canvasWidth: integer;
    _canvasHeight: integer;

  public
    constructor Create(form: TForm; n: integer);
    destructor Destroy; override;

    procedure Paint(canvas: TBGRACanvas2D);
    procedure Run;
    procedure CheckIsFill(x, y: single);
  end;

implementation

uses
  VisibleDSA.AlgoForm;

{ TAlgoVisualizer }

constructor TAlgoVisualizer.Create(form: TForm; n: integer);
var
  i, x, y, vx, vy, r: integer;
begin
  _canvasWidth := form.ClientWidth;
  _canvasHeight := form.ClientHeight;
  SetLength(_circles, n);
  r := 30;

  Randomize;
  for i := 0 to n - 1 do
  begin
    x := Random(_canvasWidth - r * 2) + r;
    y := Random(_canvasHeight - r * 2) + r;
    vx := Random(11) - 5;
    vy := Random(11) - 5;
    _circles[i] := TCircle.Create(x, y, r, vx, vy);
  end;
end;

procedure TAlgoVisualizer.CheckIsFill(x, y: single);
var
  c: TCircle;
begin
  for c in _circles do
  begin
    if c.Contain(x, y) then
      c.IsFilled := not c.IsFilled;
  end;
end;

destructor TAlgoVisualizer.Destroy;
var
  i: integer;
begin
  for i := 0 to High(_circles) do
  begin
    FreeAndNil(_circles[i]);
  end;

  inherited Destroy;
end;

procedure TAlgoVisualizer.Paint(canvas: TBGRACanvas2D);
var
  circle: TCircle;
begin
  TAlgoVisHelper.SetStroke(1, clRed);
  TAlgoVisHelper.SetFill(clRed);

  for circle in _circles do
  begin
    if not circle.IsFilled then
      TAlgoVisHelper.DrawCircle(canvas, circle.X, circle.Y, circle.r)
    else
      TAlgoVisHelper.FillCircle(canvas, circle.X, circle.Y, circle.r);
  end;
end;

procedure TAlgoVisualizer.Run;
var
  circle: TCircle;
begin
  for circle in _circles do
  begin
    circle.Move(0, 0, _canvasWidth, _canvasHeight);
  end;

  TAlgoVisHelper.Pause(5);
  AlgoForm.BGRAVirtualScreen.RedrawBitmap;
end;

end.
