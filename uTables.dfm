object Tables: TTables
  Left = 0
  Top = 0
  Caption = 'LogBase Tables'
  ClientHeight = 341
  ClientWidth = 1089
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1089
    Height = 65
    Align = alTop
    Caption = 'Panel2'
    TabOrder = 0
    DesignSize = (
      1089
      65)
    object DBNavigator1: TDBNavigator
      Left = 688
      Top = 15
      Width = 390
      Height = 44
      DataSource = DataSource1
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TabStop = True
    end
    object cmbTable: TComboBox
      Left = 16
      Top = 39
      Width = 234
      Height = 21
      Sorted = True
      TabOrder = 1
      Text = 'cmbTable'
      OnChange = cmbTableChange
    end
    object txtDB: TEdit
      Left = 16
      Top = 12
      Width = 234
      Height = 21
      Enabled = False
      TabOrder = 0
      Text = 'txtDB'
    end
    object btnSelect: TButton
      Left = 256
      Top = 12
      Width = 58
      Height = 47
      Caption = 'DB'#36984#25246
      TabOrder = 2
      OnClick = btnSelectClick
    end
    object btnSave: TButton
      Left = 314
      Top = 12
      Width = 65
      Height = 47
      Caption = 'Data'#20445#23384
      TabOrder = 4
      OnClick = btnSaveClick
    end
    object btnLoad: TButton
      Left = 379
      Top = 12
      Width = 58
      Height = 47
      Caption = 'Data'#21462#36796
      TabOrder = 5
      OnClick = btnLoadClick
    end
    object btnClear: TButton
      Left = 436
      Top = 12
      Width = 58
      Height = 47
      Caption = 'Data'#28040#21435
      TabOrder = 6
      OnClick = btnClearClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 65
    Width = 1089
    Height = 276
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 1087
      Height = 274
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object btnConvert: TButton
    Left = 500
    Top = 12
    Width = 58
    Height = 47
    Caption = '&Convert'
    TabOrder = 2
    OnClick = btnConvertClick
  end
  object IBTable1: TIBTable
    Database = IBDatabase1
    Transaction = IBTransaction1
    AutoCalcFields = False
    BufferChunks = 1000
    CachedUpdates = False
    IndexDefs = <
      item
        Name = 'RDB$PRIMARY55'
        Fields = 'COUNTRY'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'COUNTRY'
    UniDirectional = False
    Left = 256
    Top = 128
  end
  object IBTransaction1: TIBTransaction
    DefaultDatabase = IBDatabase1
    Left = 168
    Top = 128
  end
  object IBDatabase1: TIBDatabase
    DatabaseName = 'C:\LogBase Projects\LogBaseDB\LOGBASE.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'PASSWORD=masterkey')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 64
    Top = 128
  end
  object DataSource1: TDataSource
    DataSet = IBTable1
    Left = 336
    Top = 128
  end
  object Database1: TDatabase
    DatabaseName = 'C:\LogBase\Data'
    DriverName = 'Microsoft ODBC for Oracle'
    LoginPrompt = False
    Params.Strings = (
      'USER NAME= ')
    SessionName = 'Default'
    Left = 65464
    Top = 440
  end
  object IBQuery1: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 256
    Top = 200
  end
  object OpenDialog1: TOpenDialog
    Left = 80
    Top = 248
  end
  object SaveDialog1: TSaveDialog
    Left = 168
    Top = 248
  end
end
