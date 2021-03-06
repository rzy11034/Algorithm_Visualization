﻿unit VisibleDSA.SelectionSortData;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils;

type
  TSelectionSortData = class
  private
    _numbers: array of integer;

  public
    OrderedIndex: integer;          // [0...orderedIndex) 是有序的
    CurrentCompareIndex: integer;   // 当前正在比较的元素索引
    CurrentMinIndex: integer;       // 当前找到的最小元素的索引

    constructor Create(n, randomBound: integer);
    destructor Destroy; override;

    procedure Swap(i, j: integer);

    function Length: integer;
    function GetValue(index: integer): integer;
  end;

implementation

{ TSelectionSortData }

constructor TSelectionSortData.Create(n, randomBound: integer);
var
  i: integer;
begin
  OrderedIndex := -1;
  CurrentCompareIndex := -1;
  CurrentMinIndex := -1;

  Randomize;
  SetLength(_numbers, n);

  for i := 0 to N - 1 do
    _numbers[i] := Random(randomBound) + 1;
end;

destructor TSelectionSortData.Destroy;
begin
  inherited Destroy;
end;

function TSelectionSortData.Length: integer;
begin
  Result := System.Length(_numbers);
end;

function TSelectionSortData.GetValue(index: integer): integer;
begin
  if (index < 0) or (index >= Length) then
    raise Exception.Create('Invalid index to access Sort Data.');

  Result := _numbers[index];
end;

procedure TSelectionSortData.Swap(i, j: integer);
var
  temp: integer;
begin
  if (i < 0) or (i >= Self.Length) or (j < 0) or (j >= Self.Length) then
    raise Exception.Create('Invalid index to access Sort Data.');

  temp := _numbers[j];
  _numbers[j] := _numbers[i];
  _numbers[i] := temp;
end;

end.
