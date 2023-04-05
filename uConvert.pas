unit uConvert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, IBQuery, DBCtrls, DB, Menus, Grids,
  DBGrids, IBDatabase, IBCustomDataSet, IBTable, Bde.DBTables,
  XMLIniFile;

type
  TConvert = class(TForm)
    btnDest: TButton;
    btnSource: TButton;
    btnStart: TButton;
    Database1: TDatabase;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    dsQsoLog: TDataSource;
    IBDatabase1: TIBDatabase;
    IBDatabase2: TIBDatabase;
    IBTable1: TIBTable;
    IBTable2: TIBTable;
    IBTransaction1: TIBTransaction;
    IBTransaction2: TIBTransaction;
    Label3: TLabel;
    lblDestDb: TLabel;
    lblSourceDB: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnDestClick(Sender: TObject);
    procedure btnSourceClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    AppPath:string;
    XmlIniName:string;
    procedure QsoLogCopy;
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  Convert: TConvert;

implementation

{$R *.dfm}

procedure TConvert.btnDestClick(Sender: TObject);
var
  XmlIni: TXMLIniFile;
begin
  XmlIni    := TXmlIniFile.Create(XmlIniName);
  try
    with OpenDialog1 do
      begin
      Title       := 'DestnationDB';
      FileName    := lblDestDB.Caption;
      DefaultExt  := 'FDB';
      Filter      := 'Firebird (*.FDB)|*.FDB';
      FilterIndex := 1;
      if not Execute then
        Exit;
      lblDestDB.Caption := FileName;
      end;
    XmlIni.OpenNode('/DataBase', true);
    XmlIni.WriteString('DestinationDB', OpenDialog1.FileName);
    XmlIni.CloseNode;
    XmlIni.UpdateFile;
  finally
    FreeAndNil(XmlIni);
  end;
end;

procedure TConvert.btnSourceClick(Sender: TObject);
var
  XmlIni: TXMLIniFile;
begin
  XmlIni    := TXmlIniFile.Create(XmlIniName);
  try
    with OpenDialog1 do
      begin
      Title       := 'SourceDB';
      FileName    := lblSourceDB.Caption;
      DefaultExt  := 'DB';
      Filter      := 'Firebird (*.FDB)|*.FDB';
      FilterIndex := 1;
      if not Execute then
        Exit;
      lblSourceDB.Caption := FileName;
      end;
    XmlIni.OpenNode('/DataBase', true);
    XmlIni.WriteString('SourceDB', OpenDialog1.FileName);
    XmlIni.CloseNode;
    XmlIni.UpdateFile;
  finally
    FreeAndNil(XmlIni);
  end;
end;

procedure TConvert.btnStartClick(Sender: TObject);
begin
    QsoLogCopy;
end;

procedure TConvert.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IBTable1.Close;
  IBDataBase1.Close;

  IBTable2.Close;
  IBDataBase2.Close;
end;

procedure TConvert.FormCreate(Sender: TObject);
var
  XmlIni: TXmlIniFile;
begin
  AppPath       := ExtractFilePath(Application.ExeName);
  XmlIniName    := ChangeFileExt(Application.ExeName, '.Xml');
  Panel1.Caption  := '';
  Panel2.Caption  := '';
  Label3.Caption  := '';
  XmlIni    := TXmlIniFile.Create(XmlIniName);
  try
    XmlIni.OpenNode('/DataBase', true);
    lblSourceDB.Caption := XmlIni.ReadString('SourceDB', '');
    lblDestDB.Caption   := XmlIni.ReadString('DestinationDB', '');
  finally;
    FreeAndNil(XmlIni);
  end;
end;

procedure TConvert.FormResize(Sender: TObject);
begin
  with DbGrid1 do
    begin
    Width := Panel1.Width;
    end;
end;

procedure TConvert.QsoLogCopy;
var
 i: integer;
 j,k: integer;
 s: string;
begin
  IBTable1.Close;
  IbDataBase1.Close;
  IbDataBase1.DatabaseName    := lblSourceDB.Caption;
  IbDataBase1.Open;
  IBTable1.Open;

  IBTable2.Close;
  IbDataBase2.Close;
  IbDataBase2.DatabaseName  := lblDestDB.Caption;
  IbDataBase2.Open;
  IBTable2.Open;
  try
    Screen.Cursor :=  crHourGlass;
    IBTable2.DisableControls;
    IBTable2.EmptyTable;
    IBTable1.Last;
    IBTable1.First;
    k := 9999;
    while not IBTable1.eof do
      begin
      j := IBTable1.RecNo * 100 div IBTable1.RecordCount;
      if j <> k then
        begin
        label3.Caption := IntToStr(IBTable1.RecNo) + '/' + IntToStr(IBTable1.RecordCount);
        label3.Update;
        k := j;
        end;
      IBTable2.Append;
      for i := 0 to IBTable1.FieldList.Count - 1 do
        begin
        s :=  IBTable1.Fields[i].FieldName;
        if (IBTable1.Fields[i].DataType = ftWideString)
        or (IBTable1.Fields[i].DataType = ftString)    then
          IBTable2.FieldByName(s).AsString := trim(IBTable1.Fields[i].asstring + ' ')
        else
          IBTable2.FieldByName(s).Value := IBTable1.Fields[i].Value;
        end;
      IBTable2.Post;
      IBTable1.Next;
      end;
    label3.Caption := IntToStr(IBTable1.RecNo) + '/' + IntToStr(IBTable1.RecordCount);
    IBTransaction2.Commit;
    IBTable2.close;
    IBTable2.open;
    IBTable2.First;
    IBTable2.EnableControls;
    for i  := 0 to DBGrid1.Columns.Count - 1 do  // í∑Ç¢ï\é¶í∑ÇíZÇ≠Ç∑ÇÈ
      begin
      if IBTable2.Fields[i].DisplayWidth > 100 then
        IBTable2.Fields[i].DisplayWidth := 100;
      end;
    Screen.Cursor :=  crDefault;
  finally
  end;
end;

end.
