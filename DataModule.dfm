object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 636
  Top = 356
  Height = 286
  Width = 322
  object connMain: TIB_Connection
    SQLDialect = 3
    Params.Strings = (
      'CHARACTER SET=WIN1251'
      'USER NAME=SYSDBA'
      'PASSWORD=masterkey'
      'PAGE SIZE=8192')
    Left = 40
    Top = 16
  end
  object opndlgDatabse: TOpenDialog
    DefaultExt = 'fdb'
    Filter = #1041#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' Firebird|*.fdb|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Title = #1042#1099#1073#1086#1088' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
    Left = 240
    Top = 16
  end
  object cursGetSubTree: TIB_Cursor
    IB_Connection = connMain
    SQL.Strings = (
      'select oId,oSt,oLvl,oHasChildren,oName'
      'from getSubTree(:aSt,:aToLvl)')
    Left = 40
    Top = 72
  end
  object dsqlDelNode: TIB_DSQL
    IB_Connection = connMain
    SQL.Strings = (
      'execute procedure delNode(:aId,:aSt);')
    Left = 40
    Top = 128
  end
  object dsqlAddNode: TIB_DSQL
    IB_Connection = connMain
    SQL.Strings = (
      'execute procedure addNode(:aParentId,:aParentSt,:aName);')
    Left = 40
    Top = 176
  end
  object dsqlGetNode: TIB_DSQL
    IB_Connection = connMain
    SQL.Strings = (
      'execute procedure getNode(:aId);')
    Left = 136
    Top = 16
  end
  object cursGetPathToNode: TIB_Cursor
    IB_Connection = connMain
    SQL.Strings = (
      'select oLvl,oName from getPathToNode(:aId,:aSt);')
    Left = 136
    Top = 96
  end
end
