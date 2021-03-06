﻿unit VisibleDSA.AlgoVisualizer;

interface

uses
  System.SysUtils,
  System.Types,
  FMX.Graphics,
  FMX.Forms,
  System.Generics.Collections,
  VisibleDSA.AlgoVisHelper,
  VisibleDSA.Circle;

type
  TAlgoVisualizer = class(TObject)
  private type
    TList_TPoint = TList<TPoint>;

  private
    _circle: TCircle;
    _pointLists: TList_TPoint;
    _form: TForm;
    _count: integer;

  public
    constructor Create(form: TForm; n: integer);
    destructor Destroy; override;

    procedure Paint(canvas: TCanvas);
    procedure Run;
  end;

implementation

uses
  VisibleDSA.AlgoForm;

{ TAlgoVisualizer }

constructor TAlgoVisualizer.Create(form: TForm; n: integer);
var
  x, y, r: integer;
begin
  inherited Create;

  _form := form;
  _count := n;

  x := form.ClientWidth div 2;
  y := form.ClientHeight div 2;
  r := form.ClientWidth div 2;

  _circle := TCircle.Create(x, y, r);
  _PointLists := TList_TPoint.Create;
end;

destructor TAlgoVisualizer.Destroy;
begin
  inherited Destroy;
end;

procedure TAlgoVisualizer.Paint(canvas: TCanvas);
var
  p: TPoint;
begin
  TAlgoVisHelper.SetStroke(3, CL_BLUE);

  TAlgoVisHelper.DrawCircle(canvas, _circle.X, _circle.Y, _circle.R);

  for p in _PointLists do
  begin
    if _circle.Contain(p) then
    begin
      TAlgoVisHelper.SetFill(CL_GREEN);
    end
    else
    begin
      TAlgoVisHelper.SetFill(CL_RED);
    end;

    TAlgoVisHelper.FillCircle(canvas, p.X, p.Y, 1);
  end;
end;

procedure TAlgoVisualizer.Run;
var
  x, y, i: integer;
begin
  Randomize;

  for i := 0 to _count - 1 do
  begin
    x := Random(_form.ClientWidth);
    y := Random(_form.ClientHeight);

    _pointLists.Add(TPoint.Create(x, y));
  end;

  TAlgoVisHelper.Pause(10);
  AlgoForm.PaintBox.Repaint;
end;

end.
