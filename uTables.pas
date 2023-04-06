unit uTables;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, IBQuery, DBCtrls, DB, Menus, Grids,
  DBGrids, IBDatabase, IBCustomDataSet, IBTable, Bde.DBTables,
  XMLIniFile, IBSQL;

type
  TTables = class(TForm)
    IBTable1: TIBTable;
    IBTransaction1: TIBTransaction;
    IBDatabase1: TIBDatabase;
    DataSource1: TDataSource;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Database1: TDatabase;
    cmbTable: TComboBox;
    IBQuery1: TIBQuery;
    txtDB: TEdit;
    btnSelect: TButton;
    OpenDialog1: TOpenDialog;
    btnSave: TButton;
    btnLoad: TButton;
    SaveDialog1: TSaveDialog;
    btnConvert: TButton;
    btnClear: TButton;
    cbSystemTable: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure cmbTableChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    AppPath:string;
    XmlIniName:string;
    procedure TableClear;
    procedure InportFile;
    procedure ExportFile;
    procedure SetTableList;
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  Tables: TTables;

implementation

{$R *.dfm}

uses uConvert, uRoutine;

procedure TTables.btnClearClick(Sender: TObject);
begin
  TableClear;
end;

procedure TTables.btnConvertClick(Sender: TObject);
var
  Convert: TConvert;
begin
  Convert := TConvert.Create(self);
  try
  Convert.ShowModal;
//  convert.SetFocus;
  finally
  end;
end;

procedure TTables.btnLoadClick(Sender: TObject);
begin
  InportFile;
end;

procedure TTables.btnSaveClick(Sender: TObject);
begin
  ExportFile;
end;

procedure TTables.btnSelectClick(Sender: TObject);
var
  XmlIni: TXMLIniFile;
begin
  XmlIni    := TXmlIniFile.Create(XmlIniName);
  try
    with OpenDialog1 do
      begin
      Title       := 'LogBase選択';
      FileName    := txtDB.Text;
      DefaultExt  := 'FDB';
      Filter      := 'Firebird (*.FDB)|*.FDB';
      FilterIndex := 1;
      if not Execute then
        Exit;
      txtDB.Text := FileName;
      end;
    if not FileExists(txtDB.Text) then
      begin
      ShowMessage('DataBaseが存在しない');
      exit;
      end;
    XmlIni.OpenNode('/DataBase', true);
    XmlIni.WriteString('LogBase', OpenDialog1.FileName);
    XmlIni.CloseNode;
    XmlIni.UpdateFile;
    SetTableList;
  finally
    FreeAndNil(XmlIni);
  end;
end;

procedure TTables.cmbTableChange(Sender: TObject);
var
  i: integer;
begin
  if cmbTable.Items.IndexOf(Uppercase(cmbTable.Text)) = -1 then
    begin
    btnSave.Enabled := false;
    btnLoad.Enabled := false;
    btnClear.Enabled := false;
    exit;
    end;
  cmbTable.Text :=  UpperCase(cmbTable.Text);
  IBTable1.Close;
  IBTable1.TableName  := cmbTable.Text;
  with IBQuery1 do  // PrimaryKeyを設定する
    begin
    SQL.Clear;
    SQL.Add('SELECT RDB$INDEX_NAME FROM RDB$RELATION_CONSTRAINTS');
    SQL.Add('  WHERE RDB$RELATION_NAME = ''' + cmbTable.Text + '''');
    SQL.Add('  AND RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'';');
    Open;
    if not Eof then
      IBTable1.IndexName := trim(FieldByName('RDB$INDEX_NAME').AsString);
    Close;
    end;
  IBTable1.Open;
  btnSave.Enabled := true;
  btnLoad.Enabled := true;
  btnClear.Enabled := true;
  for i  := 0 to DBGrid1.Columns.Count - 1 do  // 長い表示長を短くする
    begin
    if DBGrid1.Columns[i].Width > 500 then
      DBGrid1.Columns[i].Width := 500;
    end;
end;

// QsoLog出力でMemo欄で変なデータになってしまう
procedure TTables.ExportFile;
var
  Csv: TStringList;
  Row: TStringList;
  i: integer;
begin
  Csv := TStringList.Create;
  Row := TStringList.Create;
  try
    with SaveDialog1 do
      begin
      Title       := 'Export File選択';
      FileName    := cmbTable.Text;
      DefaultExt  := 'TXT';
      Filter      := 'Text File (*.txt)|*.txt';
      FilterIndex := 1;
      if not Execute then
        Exit;
      txtDB.Text := FileName;
      end;

    DBGrid1.Columns.BeginUpdate;
    CSV.clear;
    Row.Clear;
    for i := 0 to IBTable1.FieldList.Count - 1 do    //見出し
      begin
      Row.Add(IBTable1.FieldList.Fields[i].FieldName);
      end;
    Csv.Add(Row.CommaText);

    IBTable1.DisableControls;
    IBTable1.First;
    while Not IBTable1.EOF do         //値
      begin
      Row.Clear;
      for i := 0 to IBTable1.FieldList.Count - 1 do
        if IBTable1.FieldList.Fields[i].AsString = '' then
          Row.Add('')
        else
          begin
          if (IBTable1.FieldList.Fields[i].DataType = ftString) then
            begin
            if IBTable1.FieldList.Fields[i].AsString = 'JN7LNU' then
              ShowMessage ('一時停止');
//              if IBTable1.FieldList.Fields[i].FieldName = 'MEMO' then
//                begin
//                IBTable1.FieldList.Fields[i].AsString := '"' + IBTable1.FieldList.Fields[i].AsString  + '"';
//                end;
//            IBTable1.FieldList.Fields[i].AsString := stringReplace(IBTable1.FieldList.Fields[i].AsString, #13, #32, [rfReplaceAll]);
//            IBTable1.FieldList.Fields[i].AsString := stringReplace(IBTable1.FieldList.Fields[i].AsString, #10, #32, [rfReplaceAll]);
            end;
          Row.Add(IBTable1.FieldList.Fields[i].Value);
          end;
      Csv.Add(Row.CommaText);
      IBTable1.Next;
      end;
    Csv.SaveToFile(SaveDialog1.FileName, TEncoding.BigEndianUnicode);
    DBGrid1.Columns.EndUpdate;
    IBTable1.EnableControls;
  finally
    Row.Destroy;
    Csv.Destroy;
  end;
end;



// RAWデータ、エクスポートは思った通りに動かない
//procedure TTables.ExportFile;
//var
//  DelimitOutput: TIBOutputDelimitedFile;
//  RawOutput: TIBOutputRawFile;
//begin
//  with SaveDialog1 do
//    begin
//    Title       := 'Export File選択';
//    FileName    := cmbTable.Text;
//    DefaultExt  := 'TXT';
//    Filter      := 'Text File (*.txt)|*.txt';
//    FilterIndex := 1;
//    if not Execute then
//      Exit;
//    txtDB.Text := FileName;
//
////  IBSql1.Transaction.StartTransaction;
//  IBSql1.SQL.Text := 'SELECT * from QSOLOG;';
////  DelimitOutput := TIBOutputDelimitedFile.Create;
//  RawOutput := TIBOutputRawFile.Create;
//  try
////    DelimitOutput.Filename := txtDB.Text;
////    DelimitOutput.ColDelimiter := ',';
////    DelimitOutput.RowDelimiter := #10#13;
////    IBSql1.BatchOutput(DelimitOutput);
//
//    RawOutput.Filename :=  txtDB.Text;
//    IBSql1.BatchOutput(RawOutput);
//  finally
//    DelimitOutput.Free;
//    RawOutput.Free;
//    IBSql1.Transaction.Commit;
//  end;
//      end;
//end;

procedure TTables.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IBTable1.Close;
  IBDataBase1.Close;
end;

procedure TTables.FormCreate(Sender: TObject);
var
  XmlIni: TXmlIniFile;
begin
  AppPath       := ExtractFilePath(Application.ExeName);
  XmlIniName    := ChangeFileExt(Application.ExeName, '.Xml');
  Panel1.Caption  := '';
  Panel2.Caption  := '';
  cmbTable.Text   :=  '';
  cmbTable.Enabled  := false;
  btnSave.Enabled   :=  false;
  btnLoad.Enabled   :=  false;
  btnclear.Enabled  :=  false;
  //  btnConvert.Visible  := false;
  XmlIni    := TXmlIniFile.Create(XmlIniName);
  try
    XmlIni.OpenNode('/DataBase', true);
    txtDB.Text := XmlIni.ReadString('LogBase', '');

    if FileExists(txtDB.Text) then
      begin
      SetTableList;
      end;
  finally;
    FreeAndNil(XmlIni);
  end;end;

procedure TTables.FormResize(Sender: TObject);
begin
  with DbGrid1 do
    begin
    Width := Panel1.Width;
    end;
end;

procedure TTables.InportFile;
var
  Csv: TStringList;
  Row: TStringList;
  i,j: integer;
begin
  Csv := TStringList.Create;
  Row := TStringList.Create;
  try
    with OpenDialog1 do
      begin
      Title       := 'Inport File選択';
      FileName    := cmbTable.Text;
      DefaultExt  := 'txt';
      Filter      := 'Text File (*.txt)|*.txt';
      FilterIndex := 1;
      if not Execute then
        Exit;
      end;

    DBGrid1.Columns.BeginUpdate;
    DBNavigator1.DataSource := nil;
    Csv.LoadFromFile(OpenDialog1.FileName);
    Row.CommaText := Csv.Strings[0];
    for i := 0 to IBTable1.FieldList.Count - 1 do    //見出し
      begin
      if UpperCase(IBTable1.FieldList.Fields[i].FieldName) <> UpperCase(Row.Strings[i]) then
        begin
        ShowMessage('取り込みファイルのフォーマットが合わない');
        Exit;
        end;
      end;

    IBTable1.DisableControls;
    IBTable1.EmptyTable;
    for j := 1 to CSV.Count - 1 do         //値
      begin
      Row.CommaText := Csv.Strings[j];
      IBTable1.Append;
      for i := 0 to IBTable1.FieldList.Count - 1 do
        if (Row.Strings[i] <> '') then
          begin
          IBTable1.FieldList.Fields[i].Value := Row.Strings[i];
          end;
      IBTable1.Post;
      end;
    IBTransaction1.Commit;
    IBTable1.Close;
    IBTable1.Open;
    IBTable1.EnableControls;
    DBNavigator1.DataSource := DataSource1;
    DBGrid1.Columns.EndUpdate;
  finally
    Row.Destroy;
    Csv.Destroy;
  end;
end;

procedure TTables.SetTableList;
begin
  cmbTable.Items.Clear;
  IbDataBase1.Close;
  IbDataBase1.DatabaseName  := txtDB.Text;
  IbDataBase1.Open;
  with IBQuery1 do  // PrimaryKeyを設定する
    begin
    SQL.Clear;
    if cbSystemTable.Checked then
      SQL.Add('SELECT RDB$RELATION_NAME FROM RDB$RELATIONS;')
    else
      begin
      SQL.Add('SELECT RDB$RELATION_NAME FROM RDB$RELATIONS');
      SQL.Add('  WHERE RDB$VIEW_BLR IS NULL');
      SQL.Add('  AND (RDB$SYSTEM_FLAG IS NULL OR RDB$SYSTEM_FLAG = 0);');
    end;
    Open;
    While not Eof do
      begin
      cmbTable.Items.Add(trim(FieldByName('RDB$RELATION_NAME').AsString));
      Next;
      end;
    Close;
    end;
  IbDataBase1.Open;
  cmbTable.Enabled  := true;
end;

procedure TTables.TableClear;
begin
  try
    DBGrid1.Columns.BeginUpdate;
    DBNavigator1.DataSource := nil;
    IBTable1.EmptyTable;
    IBTransaction1.Commit;
    IBTable1.Close;
    IBTable1.Open;
    DBNavigator1.DataSource := DataSource1;
    DBGrid1.Columns.EndUpdate;
  finally

  end;
end;

end.
