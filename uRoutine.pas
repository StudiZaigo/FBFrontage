unit uRoutine;

interface

uses Classes, SysUtils,
     Dialogs ,                             // for Debug
     Math,
     uRecord,
     SkRegExpW;
                               // 正規表現
type TSYSTEMTIME = record
    wYear:         WORD;
    wMonth:        WORD;
    wDayOfWeek:    WORD;
    wDay:          WORD;
    wHour:         WORD;
    wMinute:       WORD;
    wSecond:       WORD;
    wMilliseconds: WORD;
  end;

type TTIME_ZONE_INFORMATION = record
    Bias:          INTEGER;
    StandardName:  string[32];
    StandardDate:  TSYSTEMTIME;
    StandardBias:  INTEGER;
    DaylightName:  string[32];
    DaylightDate:  TSYSTEMTIME;
    DaylightBias:  INTEGER;
  end;

type TDirectionKind = (drLatitude, drLongitude);

////////////////////////////////////////////////////////////////////////////////
//
//   文字列に関する共通処理
//
////////////////////////////////////////////////////////////////////////////////
function DblQuotedStr(value: string): string;
function CompactStr(value: string): string;
function CopyByLength(str:string; len:Integer): string;

function FormalizeDate(pDate:string):string;
function FormalizeTime(pTime:string):string;

////////////////////////////////////////////////////////////////////////////////
//
//   Fileに関する共通処理
//
////////////////////////////////////////////////////////////////////////////////
//procedure FilesList_Get(Path: String; Attr: Integer; AddNoAttr:boolean;
//                    ClrFlag: boolean; theList: TStringList; gosubdir:  boolean;
//                    addYen:boolean; NoReadOnly: Boolean);
//    //  Path        ディレクトリフルパス
//    //  Attr:       ファイルの属性,全てならfaAnyfile(attr無しは含まれない)
//    //  AaddNoAttr  True:属性なしファイルを加える}{☆修正
//    //  clrFlag:    True:新規　false:つけ足す
//    //  theList:    一覧を格納するTStringList
//    //  gosubdir:   True:サブディレクトリも検索する
//    //  addYen:     True:ディレクトリなら\をつける
//    //  noreadonly: True:ReadOnly/Hiddenをはずす
//   {sample
//           FilesList_Get ('c:\windows', faAnyFile,True,True,
//                        newStringList,True,True,false);}
//
//procedure GetFilesList(Path: String; Attr: Integer; theList: TStringList);
//
//function RemoveFiles(Path: string):boolean;


function  StrToDeg(Value:string; Direction: TDirectionKind; var Degree: double): boolean;
function  DegToStr(Degree: double ; Directin: TDirectionKind): string;

procedure DecodeDeg(Value: Double; var sgn:string; var deg, min, sec: Integer);
function EncodeDeg(sgn:string; var deg, min, sec: Integer; var Value: Double): boolean;

//    距離と方向を計算する
function geoDistance(lat1, log1, lat2, log2, precision: double): double;
function geoDirection(lat1, log1, lat2, log2: double): Double;

function CheckGridLoc(Value: string): boolean;
function GLToDeg(GL: String; var Lon,Lat: Double): boolean;
function DegToGL(Lon, Lat: Double): string;

type
  TLocation = class(TObject)
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

const
  RD: double = 6367.0;   // 地球の半径

implementation

//{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
//
//   文字列に関する共通処理
//
////////////////////////////////////////////////////////////////////////////////
function DblQuotedStr(value:string): string;
begin
  result := '"' + value + '"';
end;

function CompactStr(value:string): string;
const
  Dis = $FEE0;
var
  Str   : String;
  i     : Integer;
  Code  : Cardinal;
  AChar : Char;
  SeriesSpace: boolean;
begin
  Str := '';
  SeriesSpace := true;
  for i := 1 to Length(Value) do
    begin                          // 全角英数記号を半角にする
    Code := Ord(Value[i]);
    case Code of
    $FF00..$FF5F:
      AChar := Chr(Code - Dis);
    $3000:
      AChar := ' ';
    else
      AChar := Value[i];
    end;
    if  AChar <> ' ' then           // 連続した空白を空白を1個にする
      begin
      Str :=  Str + AChar;
      SeriesSpace := false;
      end
    else
      begin
      if not SeriesSpace then
        begin
        Str :=  Str + AChar;
        SeriesSpace := true;
        end;
      end;
  end;
  result := Trim(Str);
end;

function CopyByLength(str:string; len:Integer): string;
var
  i: integer;
  s_Ansi: AnsiString;
  S_Uni: string;
begin
//  Ansiで必要桁数コピーする　必要性?HAMLOG用

  s_Ansi := AnsiString(str);
  if Length(s_Ansi) <= Len then
    begin
    Result := str;
    exit;
    end;
  s_Ansi := '';
  s_Uni := Str;
  while Length(s_Ansi) <= Len  do
    begin
    Result := String(s_Ansi);
    i := (Len - Length(s_Ansi)) div 2;
    if i = 0  then
      break;
    s_Ansi := s_Ansi + AnsiString(copy(s_Uni, 1, i));
    s_Uni  := copy(s_Uni, i + 1, 256);
    end;
end;



{
function isInteger(Text:string):boolean;
var
  i: integer;
begin
  Result := False;
  for i := 1 to length(Text) do
    if not CharInSet(Text[i], ['0'..'9']) then
      exit;
  Result := true;
end;
}

////////////////////////////////////////////////////////////////////////////////
//
//   日付に関する共通処理
//
////////////////////////////////////////////////////////////////////////////////
function FormalizeDate(pDate:string):string;
var
  s: string;
  i: Integer;
  L: integer;
  y,m,d: Word;
  v: TDateTime;
begin
  s := pDate;
  if TryStrToDate(s, v) then
    begin
    result := FormatDateTime('YYYY/MM/DD', v);
    exit;
    end;

  if TryStrToInt(s, i) then
    begin
    L := Length(s);
    DecodeDate(Date, Y, M, D);
    if (L <= 2) then
      D := StrToInt(s)
    else if L <= 4 then
      begin
      D := StrToInt(copy(s, L-1, 2));
      M := StrToInt(copy(s, 1, L-2));
      end
    else
      begin
      D := StrToInt(copy(s, L-1, 2));
      M := StrToInt(copy(s, L-3, 2));
      Y := StrToInt(Copy(IntToStr(CurrentYear), 1, 8-L)
        +  copy(s, 1, L-4));
      end;
    result := FormatDateTime('YYYY/MM/DD', EncodeDate(Y, M, D));
    end
  else
    result := '';
end;

function FormalizeTime(pTime:string):string;
var
  s: string;
  i: integer;
  H,N,F,MS: word;
  v: TDateTime;
begin
    s := pTime;
    if (Length(s) >2) and (TryStrToTime(s, v)) then    // 2桁以下だとエラーにならない為
      begin
      result := FormatDateTime('hh:nn', v);
      exit;
      end;

    if TryStrToInt(s, i) then
      begin
      DecodeTime(Time, H, N, F, MS);
      if Length(s) <= 2 then
        N := StrToInt(s)
      else
        begin
        N := StrToInt(copy(s, length(s)-1, 2));
        H := StrToInt(copy(s, 1, length(s)-2));
        end;
      result := FormatDateTime('hh:nn', EncodeTime(H, N, 0, 0));
      end
    else
      result := '';
end;


////////////////////////////////////////////////////////////////////////////////
//
//   外部ﾌｧｲﾙに関する共通処理
//
////////////////////////////////////////////////////////////////////////////////
//  ファイルの検索,size=0なら削除


//function RemoveFiles(Path: string):boolean;
//var
//    i: integer;
//    s: string;
////    BackupPath: string;
////    BackupGeneration: integer;
////    Newpath: string;
////    RenamePath: string;
//    DirectryList: TstringList;
////    RegStr: string;
//begin
//    Result := true;
//    DirectryList := TStringlist.Create();
//    try
//      FilesList_Get(Path, faAnyFile, true, true, DirectryList,
//                    true, true, true);
//
//      for i := 0 to DirectryList.Count - 1 do
//        begin
//        s := DirectryList[i];
//        if not DeleteFile(pchar(s)) then
//          exit;
//        end;
//    finally
//      FreeAndNil(DirectryList);
//    end;
//end;



////////////////////////////////////////////////////////////////////////////////
//
//   角度に関する共通処理
//
////////////////////////////////////////////////////////////////////////////////
procedure DecodeDeg(Value: Double; var sgn:string; var deg, min, sec: Integer);
var
  v: double;
begin
    v := Value;
    if v >= 0 then
      sgn := '+'
    else
      begin
      sgn := '-';
      v := abs(v);
      end;
    deg := Trunc(v+0.000001);
    v := frac(v+0.000001) * 60;
    min := Trunc(v);
    v := frac(v) * 60;
    sec := (Trunc(v)+29) div 30 * 30;
end;

function EncodeDeg(sgn:string; var deg, min, sec: Integer; var Value: Double): boolean;
var
  v: double;
begin
  try
    Value := Deg + Min/60 + Sec/3600;
    if sgn <> '+' then
      Value := - Value;
    result  := true;
  except
    result  := false;
  end;
end;

/////////////////////////////////////////////////////////////////////
//
//   経度・緯度の文字列を数値(度)に変換
//    文字列は、"N43,06,38","E144,07,39"　の形式
//    TDirectionKind = (drLatitude, drLongitude)
//
////////////////////////////////////////////////////////////////////
function StrToDeg(Value:string; Direction: TDirectionKind; var Degree: double): boolean;
var
s1,s2: string;
   Sgn: Double;
   sl: TStringList;
begin
    Result := false;
    Value := RegReplace('[.]+', Value, ',');
    sl := TStringList.Create();
    try
      s1 := Copy(Value, 1, 1);
      s2 := Copy(Value, 2, 64);
      sl.CommaText := s2 + ',0,0,0';
      if (s1 = 'N') or (s1 = 'E') or (s1 = '+') then
        sgn := 1
      else
        sgn := -1;
      Degree := Sgn * StrToFloat(sl[0]) + StrToFloat('0' + sl[1])/60
            + StrToFloat('0' + sl[2])/3600;
      if Direction = drLatitude then
        begin
        if abs(Degree) > 90 then
          exit
        end
      else
        begin
        while Degree > 180 do
          degree := Degree - 360;
        while Degree < -180 do
          degree := Degree + 360;
        end;
    Result := true;
  finally
    FreeAndNil(sl);
  end;
end;

/////////////////////////////////////////////////////////////////////
//
//   数値(度)を経度・緯度の文字列に変換
//    文字列は、"N43,06,38","E144,07,39"　の形式
//
////////////////////////////////////////////////////////////////////
function  DegToStr(Degree: double; Directin: TDirectionKind): string;
var
  s: string;
  sgn: string;
  deg,min,sec: Integer;
begin
    DecodeDeg(Degree, sgn, deg, min, sec);
    if Directin = drLatitude then
      begin
      if sgn = '+' then
        sgn := 'N'
      else
        sgn := 'S'
      end
    else
      begin
      if sgn = '+' then
        sgn := 'E'
      else
        sgn := 'W'
      end;
    s := sgn + IntToStr(deg) + ',' + IntToStr(min) + ',' + IntToStr(sec);
    result := s;
end;

/////////////////////////////////////////////////////////////////////
//
//   地球上の2点間の距離・方位を計算する
//
////////////////////////////////////////////////////////////////////
function geoDistance(lat1, log1, lat2, log2, precision: double): double;
var
  a,b,f: double;
  p1, p2: double;
  x, L, d,decimal_no: double;
begin
  if (abs(lat1 - lat2) < 0.00001) and (abs(log1 - log2) < 0.00001) then
    begin
    result := 0;
    exit;
    end;

  lat1 := DegToRad(lat1);
  log1 := DegToRad(log1);    //  度分秒からラヂアンにする
  lat2 := DegToRad(lat2);
  log2 := DegToRad(log2);

  a := 6378140;
  b := 6356755;
  f := (a - b) / a;

  p1 := ArcTan((b / a) * Tan(lat1));
  p2 := ArcTan((B / A) * Tan(Lat2));

  x := ArcCos(sin(p1) * Sin(P2) + Cos(p1) * Cos(p2) * cos(log1 - log2));
  L := (F / 8)
    * ((sin(X) - X) * power((sin(P1) + sin(P2)), 2)
    / power(cos(X / 2), 2) - (sin(X) - X) * power(sin(P1) - sin(P2), 2)
    / power(sin(X), 2));

  D := A * (X + L);
  decimal_no := power(10, precision);
  D := Int(D * decimal_no) / decimal_no / 1000;

  result := D;
end;

// 緯度経度 lat1, lng1 の点を出発として、緯度経度 lat2, lng2 への方位
// 北を０度で右回りの角度０～３６０度
function geoDirection(lat1, log1, lat2, log2: double): double;
var
  Lon1Rad, Lat1Rad, Lon2Rad, Lat2Rad: Double;
  LonDiff: Double;
  X,Y: Double;
  Direction: Double;
begin
//  度からラジアンに変換
  Lat1Rad := DegToRad(Lat1);
  Lat2Rad := DegToRad(Lat2);
  Lon1Rad := DegToRad(Log1);
  Lon2Rad := DegToRad(Log2);

  LonDiff := Lon2Rad - Lon1Rad;
  Y := Cos(Lat2Rad)*Sin(LonDiff);
  X := Cos(Lat1Rad)*Sin(Lat2Rad) - Sin(Lat1Rad)*Cos(Lat2Rad)*Cos(LonDiff);
  Direction := ArcTan2(Y, X);

//  ラジアンから度に変換、小数点以下切捨て
  Direction := Int(RadToDeg(Direction));
  if Direction < 0 then                  //0～360 にする。
    Direction := Direction + 360;

 Result:=Direction;
end;

/////////////////////////////////////////////////////////////////////
//
//   GridLocate計算関係
//
////////////////////////////////////////////////////////////////////
function DegToGL(Lon, Lat: Double): string;
var
  s1,s2,s3,s4,s5,s6: string;
  sLon: String;
  sLat: string;
  i,j,k : Integer;
begin
  while Lon > 180 do
    Lon := Lon - 360;
  while Lon < -180 do
    Lon := Lon + 360;
  while Lat > 90 do
    Lat := Lat - 90;
  while Lat < -90 do
    Lat := Lat + 90;

  Lon := Lon + 180;
  if Lon >= 360 then
    Lon := Lon - 360;            // 東経180度を西経180度にする
  i   := Trunc(Lon / 20);
  s1  := Chr(i + 65);
  j   := Trunc((Lon - i * 20) / 2);
  s3  := Chr(j + 48);
  k   := Trunc((Lon - i * 20 - j * 2) * 12);
  s5  := Chr(k + 65);

  Lat := Lat + 90;
  if Lat >= 180 then
    Lat := Lat - 0.01;           // 北緯90度はGL計算外のため
  i   := Trunc(Lat / 10);
  s2  := Chr(i + 65);
  j   := Trunc((Lat - i * 10));
  s4  := Chr(j + 48);
  k   := Trunc((Lat - i * 10 - j) * 24);
  s6  := Chr(k + 65);

  Result := trim(s1+s2+s3+s4+s5+s6);
end;

function GLToDeg(GL: String; var Lon,Lat: Double): boolean;
var
  s: string;
  w1,w2,w3: byte;
begin
  Lon := 0;
  Lat := 0;
  if not CheckGridLoc(GL) then
    begin
    Result := false;
    exit;
    end;

  s := GL;
  if length(GL) = 4 then
    s := s + 'AA';
  w1 := ord(s[1]) - 65;
  w2 := ord(s[3]) - 48;
  w3 := ord(s[5]) - 65;
  Lon := w1 * 20 + w2 * 2 + (w3 / 12) - 180;

  w1 := ord(s[2]) - 65;
  w2 := ord(s[4]) - 48;
  w3 := ord(s[6]) - 65;
  Lat := w1 * 10 + w2 + (w3 / 24 ) - 90;
  Result := True;
end;

function CheckGridLoc(Value: string): boolean;
var
  reg: string;
begin
  reg := '^[A-R]{2}[0-9]{2}([A-X]{2})?$';
  if RegIsMatch(reg, Value) then
    result := True
  else
    result := False;
end;


end.




