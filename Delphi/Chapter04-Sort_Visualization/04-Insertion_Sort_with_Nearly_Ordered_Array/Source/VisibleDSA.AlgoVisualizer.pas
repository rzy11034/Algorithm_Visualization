﻿unit VisibleDSA.AlgoVisualizer;

interface

uses
  System.SysUtils,
  System.Types,
  FMX.Graphics,
  FMX.Forms,
  VisibleDSA.AlgoVisHelper,
  VisibleDSA.InsertionSortData;

type
  TAlgoVisualizer = class(TObject)
  private
    _width: integer;
    _height: integer;
    _data: TInsertionSortData;
    _form: TForm;

    procedure __setData(orderedIndex, currentIndex: integer);

  public
    constructor Create(form: TForm; sceneWidth, sceneHeight, n: integer);
    destructor Destroy; override;

    procedure Paint(canvas: TCanvas);
    procedure Run;
  end;

implementation

uses
  VisibleDSA.AlgoForm;

{ TAlgoVisualizer }

constructor TAlgoVisualizer.Create(form: TForm; sceneWidth, sceneHeight, n: integer);
begin
  _form := form;
  _width := form.ClientWidth;
  _height := form.ClientHeight;
  _data := TInsertionSortData.Create(n, _height);

  _form.Caption := 'Insertion Sort Visualization';
end;

destructor TAlgoVisualizer.Destroy;
begin
  FreeAndNil(_data);
  inherited Destroy;
end;

procedure TAlgoVisualizer.Paint(canvas: TCanvas);
var
  w: integer;
  i: integer;
begin
  w := _width div _data.Length;

  for i := 0 to _data.Length - 1 do
  begin

    if i < _data.orderedIndex then
      TAlgoVisHelper.SetFill(CL_RED)
    else
      TAlgoVisHelper.SetFill(CL_GREY);

    if i = _data.currentIndex then
      TAlgoVisHelper.SetFill(CL_LIGHTBLUE);

    TAlgoVisHelper.FillRectangle(canvas, i * w, _height - _data.GetValue(i), w - 1, _data.GetValue(i));
  end;
end;

procedure TAlgoVisualizer.Run;
var
  i, j: integer;
begin
  __setData(0, -1);

  for i := 0 to _data.Length - 1 do
  begin

    j := i;
    while (j > 0) and (_data.GetValue(j) < _data.GetValue(j - 1)) do
    begin
      _data.swap(j, j - 1);
      __setData(i + 1, j - 1);

      j := j - 1;
    end;
  end;

  __setData(_data.Length, -1);
end;

procedure TAlgoVisualizer.__setData(orderedIndex, currentIndex: integer);
begin
  _data.orderedIndex := orderedIndex;
  _data.currentIndex := currentIndex;

  TAlgoVisHelper.Pause(10);
  AlgoForm.PaintBox.Repaint;
end;

end.
