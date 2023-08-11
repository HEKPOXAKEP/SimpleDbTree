unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, Menus, ImgList, RxMenus, ToolWin, Placemnt;

type
  TfmMain = class(TForm)
    statbarMain: TStatusBar;
    actsMain: TActionList;
    actExit: TAction;
    actConnectDb: TAction;
    toolbarMain: TToolBar;
    tbtnConnectDb: TToolButton;
    manuMain: TRxMainMenu;
    mmiFile: TMenuItem;
    imglstMain: TImageList;
    miConnectDb: TMenuItem;
    N2: TMenuItem;
    miExit: TMenuItem;
    ToolButton1: TToolButton;
    tbtnAddNode: TToolButton;
    tbtnDelNode: TToolButton;
    ToolButton4: TToolButton;
    tbtnExit: TToolButton;
    actAddNode: TAction;
    actDelNode: TAction;
    mmiEdit: TMenuItem;
    miAddNode: TMenuItem;
    miDelNode: TMenuItem;
    tvMain: TTreeView;
    actShowChildren: TAction;
    actShowParents: TAction;
    N1: TMenuItem;
    miShowChildren: TMenuItem;
    miShowParent: TMenuItem;
    tbtnShowChildren: TToolButton;
    tbtnShowParents: TToolButton;
    ToolButton2: TToolButton;
    fsMain: TFormStorage;
    imglstTree: TImageList;
    procedure actExitExecute(Sender: TObject);
    procedure actConnectDbExecute(Sender: TObject);
    procedure tvMainDeletion(Sender: TObject; Node: TTreeNode);
    procedure tvMainExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure actAddNodeExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actDelNodeExecute(Sender: TObject);
    procedure actShowChildrenExecute(Sender: TObject);
    procedure actShowParentsExecute(Sender: TObject);
    procedure tvMainGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure tvMainGetSelectedIndex(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
  public
    procedure CheckActions;
  end;

var
  fmMain: TfmMain;

implementation

uses
  NodeDataObj,
  DataModule,
  Relatives;

{$R *.dfm}
{$R Addon.res}

procedure TfmMain.FormCreate(Sender: TObject);
begin
  fsMain.IniFileName := DM.CfgFName;
  imglstTree.ResourceLoad(rtBitmap, 'SmallTreeImgs', clOlive);
  Caption := Application.Title;
  CheckActions;
end;

procedure TfmMain.actExitExecute(Sender: TObject);
begin
  DM.connMain.Connected := false;
  Close;
end;

procedure TfmMain.actConnectDbExecute(Sender: TObject);
begin
  if DM.ConnectDatabse then
    DM.LoadTreeRoots;

  CheckActions;
end;

procedure TfmMain.CheckActions;
begin
  actAddNode.Enabled := DM.connMain.Connected and
    (tvMain.Selected <>nil);
  actDelNode.Enabled := actAddNode.Enabled;
  actShowChildren.Enabled := actAddNode.Enabled;
  actShowParents.Enabled := actAddNode.Enabled;
end;

procedure TfmMain.tvMainDeletion(Sender: TObject; Node: TTreeNode);
begin
  if Node.Data <>nil then
    TNodeData(Node.Data).Free;
end;

procedure TfmMain.tvMainExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  if Node.Data = nil then begin
    AllowExpansion := false;
    exit;
  end;

  AllowExpansion := TNodeData(Node.Data).FHasChildren <> 0;

  if AllowExpansion and (not TNodeData(Node.Data).FChildrenLoaded) then
    DM.LoadSubTree(Node);

  CheckActions;
end;

procedure TfmMain.actAddNodeExecute(Sender: TObject);
var
  s: string;

begin
  if tvMain.Selected = nil then
    exit;

  s := InputBox('Имя нового элемента','Введите имя элемента','');

  if (s <> '') and DM.AddNode(tvMain.Selected, s) then
    CheckActions;
end;

procedure TfmMain.actDelNodeExecute(Sender: TObject);
begin
  if tvMain.Selected = nil then
    exit;

  if MessageDlg('Удалить узел "'+tvMain.Selected.Text+
                '" и все его дочерние элементы?',
                mtConfirmation,[mbYes,mbAbort],0) = mrYes then begin
    DM.DelNode(tvMain.Selected);
    tvMain.Items.Delete(tvMain.Selected);
    CheckActions;
  end;
end;

procedure TfmMain.actShowChildrenExecute(Sender: TObject);
begin
  with TfmRelatives.Create(Self) do begin
    LoadChildren(tvMain.Selected);
    ShowModal;
    Release;
  end;
end;

procedure TfmMain.actShowParentsExecute(Sender: TObject);
begin
  with TfmRelatives.Create(Self) do begin
    LoadParents(tvMain.Selected);
    ShowModal;
    Release;
  end;
end;

procedure TfmMain.tvMainGetImageIndex(Sender: TObject; Node: TTreeNode);
begin
  if not Node.HasChildren then
    Node.ImageIndex := 2;
end;

procedure TfmMain.tvMainGetSelectedIndex(Sender: TObject; Node: TTreeNode);
begin
  if not Node.HasChildren then
    Node.SelectedIndex := 2
  else
    Node.SelectedIndex := 1;
end;

end.

