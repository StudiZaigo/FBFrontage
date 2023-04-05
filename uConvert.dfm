object Convert: TConvert
  Left = 0
  Top = 0
  Caption = 'Convert'
  ClientHeight = 341
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 746
    Height = 70
    Align = alTop
    Caption = 'Panel2'
    TabOrder = 0
    object lblSourceDB: TLabel
      Left = 81
      Top = 12
      Width = 56
      Height = 13
      Caption = 'lblSourceDB'
    end
    object lblDestDb: TLabel
      Left = 81
      Top = 42
      Width = 45
      Height = 13
      Caption = 'lblDestDb'
    end
    object Label3: TLabel
      Left = 454
      Top = 48
      Width = 31
      Height = 13
      Caption = 'Label3'
    end
    object DBNavigator1: TDBNavigator
      Left = 560
      Top = 18
      Width = 172
      Height = 33
      DataSource = DataSource2
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      TabOrder = 0
    end
    object btnStart: TButton
      Left = 454
      Top = 9
      Width = 60
      Height = 33
      Caption = 'Copy'#38283#22987
      TabOrder = 1
      OnClick = btnStartClick
    end
    object btnSource: TButton
      Left = 11
      Top = 8
      Width = 64
      Height = 24
      Caption = 'Copy'#20803
      TabOrder = 2
      OnClick = btnSourceClick
    end
    object btnDest: TButton
      Left = 11
      Top = 38
      Width = 64
      Height = 24
      Caption = 'Copy'#20808
      TabOrder = 3
      OnClick = btnDestClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 70
    Width = 746
    Height = 271
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 744
      Height = 269
      Align = alClient
      DataSource = DataSource2
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object IBTable2: TIBTable
    Database = IBDatabase2
    Transaction = IBTransaction2
    BufferChunks = 1000
    CachedUpdates = False
    FieldDefs = <
      item
        Name = 'NUM'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'CALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'ORGCALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'CQ'
        DataType = ftSmallint
      end
      item
        Name = 'SWL'
        DataType = ftSmallint
      end
      item
        Name = 'ONDATETIME'
        DataType = ftDateTime
      end
      item
        Name = 'OFFDATETIME'
        DataType = ftDateTime
      end
      item
        Name = 'FREQ'
        DataType = ftLargeint
      end
      item
        Name = 'BAND'
        DataType = ftLargeint
      end
      item
        Name = 'RECVFREQ'
        DataType = ftLargeint
      end
      item
        Name = 'RECVBAND'
        DataType = ftLargeint
      end
      item
        Name = 'MODE'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ROUTE'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'REPEATER'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'HISREPORT'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYREPORT'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MEMO'
        DataType = ftWideString
        Size = 256
      end
      item
        Name = 'QSL'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLSEND'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLRECV'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLSENDDATE'
        DataType = ftDate
      end
      item
        Name = 'QSLRECVDATE'
        DataType = ftDate
      end
      item
        Name = 'QSLMANAGER'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'NETLOGSEND'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'NETLOGRECV'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'PREFIX'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'SUFFIX'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'COUNTRY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'REGION'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ENTITY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'GRIDLOC'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'CONTINENT'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'ITUZONE'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'CQZONE'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'IOTA'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'ETC1'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC2'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC3'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC4'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC5'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYCALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'MYCOUNTRY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYREGION'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYENTITY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYGRIDLOC'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'MYRIG'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MYANT'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MYMEMO'
        DataType = ftWideString
        Size = 128
      end>
    IndexDefs = <
      item
        Name = 'PK_QSOLOG'
        Fields = 'NUM'
        Options = [ixUnique]
      end
      item
        Name = 'IDX_REGION'
        Fields = 'COUNTRY;REGION'
      end>
    IndexName = 'PK_QSOLOG'
    StoreDefs = True
    TableName = 'QSOLOG'
    UniDirectional = False
    Left = 232
    Top = 224
  end
  object IBTransaction1: TIBTransaction
    DefaultDatabase = IBDatabase1
    Left = 152
    Top = 152
  end
  object IBDatabase1: TIBDatabase
    DatabaseName = 'C:\LogBase Projects\LogBaseDB\LogBase.fdb'
    Params.Strings = (
      'user_name=SYSDBA'
      'PASSWORD=masterkey')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 64
    Top = 152
  end
  object DataSource2: TDataSource
    DataSet = IBTable2
    Left = 304
    Top = 224
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
  object dsQsoLog: TDataSource
    DataSet = IBTable1
    Left = 304
    Top = 152
  end
  object OpenDialog1: TOpenDialog
    Left = 448
    Top = 152
  end
  object IBDatabase2: TIBDatabase
    DatabaseName = 'C:\LogBase Projects\LogBaseDB\LogBase New.fdb'
    Params.Strings = (
      'user_name=SYSDBA'
      'PASSWORD=masterkey')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 64
    Top = 224
  end
  object IBTransaction2: TIBTransaction
    DefaultDatabase = IBDatabase2
    Left = 152
    Top = 224
  end
  object IBTable1: TIBTable
    Database = IBDatabase1
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    FieldDefs = <
      item
        Name = 'NUM'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'CALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'ORGCALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'CQ'
        DataType = ftSmallint
      end
      item
        Name = 'SWL'
        DataType = ftSmallint
      end
      item
        Name = 'ONDATETIME'
        DataType = ftDateTime
      end
      item
        Name = 'OFFDATETIME'
        DataType = ftDateTime
      end
      item
        Name = 'FREQ'
        DataType = ftLargeint
      end
      item
        Name = 'BAND'
        DataType = ftLargeint
      end
      item
        Name = 'RECVFREQ'
        DataType = ftLargeint
      end
      item
        Name = 'RECVBAND'
        DataType = ftLargeint
      end
      item
        Name = 'MODE'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ROUTE'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'REPEATER'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'HISREPORT'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYREPORT'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MEMO'
        DataType = ftWideString
        Size = 256
      end
      item
        Name = 'QSL'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLSEND'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLRECV'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLSENDDATE'
        DataType = ftDate
      end
      item
        Name = 'QSLRECVDATE'
        DataType = ftDate
      end
      item
        Name = 'QSLMANAGER'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'NETLOGSEND'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'NETLOGRECV'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'PREFIX'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'SUFFIX'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'COUNTRY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'REGION'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ENTITY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'GRIDLOC'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'CONTINENT'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'ITUZONE'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'CQZONE'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'IOTA'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'ETC1'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC2'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC3'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC4'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC5'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYCALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'MYCOUNTRY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYREGION'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYENTITY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYGRIDLOC'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'MYRIG'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MYANT'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MYMEMO'
        DataType = ftWideString
        Size = 128
      end>
    IndexDefs = <
      item
        Name = 'PK_QSOLOG'
        Fields = 'NUM'
        Options = [ixUnique]
      end
      item
        Name = 'IDX_REGION'
        Fields = 'COUNTRY;REGION'
      end>
    IndexName = 'PK_QSOLOG'
    StoreDefs = True
    TableName = 'QSOLOG'
    UniDirectional = False
    Left = 232
    Top = 152
  end
end
