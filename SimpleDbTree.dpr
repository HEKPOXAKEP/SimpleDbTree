program SimpleDbTree;

uses
  Forms,
  Main in 'Main.pas' {fmMain},
  DataModule in 'DataModule.pas' {DM1: TDataModule},
  NodeDataObj in 'NodeDataObj.pas',
  Relatives in 'Relatives.pas' {fmRelatives};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Simple DB Tree';
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
