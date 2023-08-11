unit DataModule;

interface

uses
  SysUtils, Classes, Forms, Dialogs, ComCtrls, IniFiles, IB_Components;

type
  TDM = class(TDataModule)
    connMain: TIB_Connection;
    opndlgDatabse: TOpenDialog;
    cursGetSubTree: TIB_Cursor;
    dsqlDelNode: TIB_DSQL;
    dsqlAddNode: TIB_DSQL;
    dsqlGetNode: TIB_DSQL;
    cursGetPathToNode: TIB_Cursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    CfgFName: string;
    Cfg: TIniFile;
    // --
    procedure RestoreCfgParams;
    procedure StoreCfgParams;
    procedure RestoreOpenDlgParams;
    procedure StoreOpenDlgParams;
    // --
    function ConnectDatabse: boolean;
    procedure LoadSubTree(AParent: TTreeNode);
    procedure LoadTreeRoots;
    procedure DelNode(ANode: TTreeNode);
    function AddNode(AParent: TTreeNode; AName: string): boolean;
    procedure AppendNode(AParent: TTreeNode; AId: integer);
  end;

var
  DM: TDM;

resourcestring
  secDatabase = 'Database';
    keyOpenDlgInitialDir = 'InitialDir';
    keyDbFileName = 'DbFileName';

implementation

uses
  NodeDataObj,
  Main;

{$R *.dfm}

function TDM.ConnectDatabse: boolean;
begin
  Result := false;

  if opndlgDatabse.Execute then with DM do begin
    connMain.Connected := false;
    StoreOpenDlgParams;
    connMain.DatabaseName := DM.opndlgDatabse.FileName;
    try
      connMain.Connected := true;
      Result := true;
    except
      on E: Exception do
        MessageDlg('Опаньки!'#13#13+E.Message,mtError,[mbOK],0);
    end;
  end;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  CfgFName := ChangeFileExt(Application.ExeName, '.ini');
  Cfg := TIniFile.Create(CfgFName);
  RestoreCfgParams;
end;

procedure TDM.RestoreCfgParams;
begin
  RestoreOpenDlgParams;
end;

procedure TDM.StoreCfgParams;
begin
  StoreOpenDlgParams;
end;

procedure TDM.RestoreOpenDlgParams;
begin
  opndlgDatabse.InitialDir := Cfg.ReadString(secDatabase, keyOpenDlgInitialDir, '');
  opndlgDatabse.FileName := Cfg.ReadString(secDatabase, keyDbFileName, '');
end;

procedure TDM.StoreOpenDlgParams;
begin
  Cfg.WriteString(secDatabase, keyOpenDlgInitialDir, opndlgDatabse.InitialDir);
  Cfg.WriteString(secDatabase, keyDbFileName, opndlgDatabse.FileName);
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  connMain.Connected := false;
end;

procedure TDM.LoadSubTree(AParent: TTreeNode);
var
  n: TTreeNode;
  p: TNodeData;

begin
  p := TNodeData(AParent.Data);
  p.FChildrenLoaded := true;

  with fmMain do begin
    tvMain.Items.BeginUpdate;

    cursGetSubTree.Close;
    if not cursGetSubTree.Prepared then
      cursGetSubTree.Prepare;

    cursGetSubTree.ParamByName('aSt').AsString := p.FSt;
    cursGetSubTree.ParamByName('aToLvl').AsInteger := p.FLvl + 1;
    cursGetSubTree.First;

    while not cursGetSubTree.Eof do begin
      with cursGetSubTree do begin
        p := TNodeData.Create(
          FieldByName('oId').AsInteger, FieldByName('oSt').AsString,
          FieldByName('oLvl').AsInteger, FieldByName('oHasChildren').AsInteger
        );
        n := tvMain.Items.AddChildObject(
          AParent,FieldByName('oName').AsString, p);
        n.HasChildren := p.FHasChildren <> 0;
      end;

      cursGetSubTree.Next;
    end;

    cursGetSubTree.Close;

    tvMain.Items.EndUpdate;
  end;
end;

procedure TDM.LoadTreeRoots;
var
  n: TTreeNode;
  p: TNodeData;

begin
  with fmMain do begin
    tvMain.Items.BeginUpdate;
    tvMain.Items.Clear;

    cursGetSubTree.Close;
    if not cursGetSubTree.Prepared then
      cursGetSubTree.Prepare;

    cursGetSubTree.ParamByName('aSt').AsString := '';
    cursGetSubTree.ParamByName('aToLvl').AsInteger := 1;
    cursGetSubTree.First;

    while not cursGetSubTree.Eof do begin
      with cursGetSubTree do begin
        p := TNodeData.Create(
          FieldByName('oId').AsInteger, FieldByName('oSt').AsString,
          FieldByName('oLvl').AsInteger, FieldByName('oHasChildren').AsInteger
        );
        n := tvMain.Items.AddObject(
          nil, FieldByName('oName').AsString, p);
      end;
      n.HasChildren := p.FHasChildren <> 0;

      cursGetSubTree.Next;
    end;

    cursGetSubTree.Close;

    if tvMain.Items.Count <> 0 then
      tvMain.Selected := tvMain.Items[0];
    tvMain.Items.EndUpdate;
  end;
end;

function TDM.AddNode(AParent: TTreeNode; AName: string): boolean;
begin
  if not dsqlAddNode.Prepared then
    dsqlAddNode.Prepare;

  with dsqlAddNode, TNodeData(AParent.Data) do begin
    ParamByName('aParentId').AsInteger := FId;
    ParamByName('aParentSt').AsString := FSt;
    ParamByName('aName').AsString := AName;
    ExecSQL;

    if FieldByName('err').AsInteger <> 0 then begin
      Result := false;
      MessageDlg('При добавлении элемента произошла ошибка:'#13#13+
        FieldByName('msg').AsString,mtError,[mbOk],0);
    end
    else begin
      Result := true;
      AppendNode(AParent,FieldByName('oId').AsInteger);
    end;
  end;
end;

procedure TDM.AppendNode(AParent: TTreeNode; AId: integer);
var
  n: TTreeNode;
  p: TNodeData;

begin
  // увеличиваем к-во детей у родителя
  Inc(TNodeData(AParent.Data).FHasChildren);
  AParent.HasChildren := true;

  // добавлять в TreeView нужно только если поддерево уже загружено,
  // а если ещё нет, этот элемент подгрузится при раскрытии узла
  if not TNodeData(AParent.Data).FChildrenLoaded then
    exit;

  if not dsqlGetNode.Prepared then
    dsqlGetNode.Prepare;

  with dsqlGetNode do begin
    ParamByName('aId').AsInteger := AId;
    ExecSQL;

    p := TNodeData.Create(
      FieldByName('oId').AsInteger, FieldByName('oSt').AsString,
      FieldByName('oLvl').AsInteger, FieldByName('oHasChildren').AsInteger
    );
    n := fmMain.tvMain.Items.AddChildObject(
      AParent, FieldByName('oName').AsString, p);
    n.HasChildren := p.FHasChildren <> 0;
  end;
end;

procedure TDM.DelNode(ANode: TTreeNode);
begin
  if not dsqlDelNode.Prepared then
    dsqlDelNode.Prepare;

  with dsqlDelNode do begin
    ParamByName('aId').AsInteger := TNodeData(ANode.Data).FId;
    ParamByName('aSt').AsString := TNodeData(ANode.Data).FSt;
    ExecSQL;
  end;
end;

end.

