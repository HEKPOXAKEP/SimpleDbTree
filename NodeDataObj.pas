unit NodeDataObj;

interface

type
  TNodeData = class(TObject)
    FId: integer;
    FSt: string;
    FLvl: integer;
    FHasChildren: integer;     // �-�� �����
    FChildrenLoaded: boolean;  // ���� ���������?
    // --
    constructor Create(AId: integer; ASt: string; ALvl: integer; AHasChildren:integer);
  end;

implementation

{ TNodeData }

constructor TNodeData.Create(AId: integer; ASt: string; ALvl: integer;
  AHasChildren: integer);
begin
  inherited Create;

  FId := AId;
  FSt := ASt;
  FLvl := ALvl;
  FHasChildren := AHasChildren;
end;

end.
