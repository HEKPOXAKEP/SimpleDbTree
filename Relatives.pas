unit Relatives;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfmRelatives = class(TForm)
    lboxRelatives: TListBox;
    btnClose: TButton;
  private
    { Private declarations }
  public
    procedure LoadChildren(ANode: TTreeNode);
    procedure LoadParents(ANode: TTreeNode);
  end;

implementation

uses
  NodeDataObj,
  DataModule, IB_Components;

{$R *.dfm}

{ TfmRelatives }

procedure TfmRelatives.LoadChildren(ANode: TTreeNode);
var
  lvl: integer;

begin
  Caption := 'Дочерние эелементы '+ANode.Text;
  lvl := TNodeData(ANode.Data).FLvl;

  with DM do begin
    cursGetSubTree.ParamByName('aSt').AsString := TNodeData(ANode.Data).FSt;
    cursGetSubTree.ParamByName('aToLvl').AsInteger := 16;
    cursGetSubTree.First;

    while not cursGetSubTree.Eof do with cursGetSubTree do begin
      lboxRelatives.Items.Add(
        StringOfChar(' ',(FieldByName('oLvl').AsInteger-lvl)*5) +
        FieldByName('oName').AsString);
      Next;
    end;
  end;
end;

procedure TfmRelatives.LoadParents(ANode: TTreeNode);
begin
  Caption := 'Родительские элементы '+ANode.Text;

  with DM.cursGetPathToNode do begin
    if not Prepared then
      Prepare;

    ParamByName('aId').AsInteger := TNodeData(ANode.Data).FId;
    ParamByName('aSt').AsString := TNodeData(ANode.Data).FSt;

    First;
    while not Eof do begin
      lboxRelatives.Items.Add(
        StringOfChar(' ',FieldByName('oLvl').AsInteger*5) +
        FieldByName('oName').AsString);
      Next;
    end;
    Close;
  end;
end;

end.
