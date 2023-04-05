unit uRecord;

interface

//uses
//  Data.FmtBcd;

const
  wqQsoBank = $01;
  wqEQsl    = $02;
  wqARRL    = $04;

//type
//  TAct=(actCheck,actSelect,actInsert,actUpdate,actDelete);

type
  TQsoState=(lgClear,lgSetting,lgBrowse,lgEdit,lgTramp,lgInsert);

type TQso = record                 //  現在QSOの内容でDBに保存しないField
    Area:           string;
    CountryName:    string;
    RegionName:     string;
    EntityName:     string;
    IOTAName:       string;
    ETC1Name:       string;
    ETC2Name:       string;
    ETC3Name:       string;
    ETC4Name:       string;
    ETC5Name:       string;
    Latitude:       string;
    Longitude:      string;
    Comment:        string;

    FreqFormat:     string;
    DefaultMode:    string;
    DefaultReport:  string;

    MyCallsign:     string;
    MyEntity:       string;
    MyCountry:      string;
    MyRegion:       string;
    MyGridLoc:      string;
    MyRIG:          string;
    MyAnt:          string;
    MyMemo:         string;
    MyCountryName:  string;
    MyRegionName:   string;
    MyEntityName:   string;
    MyLatitude:     string;
    MyLongitude:    string;
    MyArea:         string;
    result:         boolean;
  end;

type TBeforeQso = record           //  同一 Callsignでの前の値
    Callsign:       string;
    OrgCallsign:    string;
    Name:           string;
    Entity:         string;
    Country:        string;
    Region:         string;
    Continent:      string;
    ItuZone:        string;
    CQZone:         string;
    Iota:           string;
    Qsl:            string;
    QSLManager:     string;
    result:         boolean;
  end;

type TPrevQso = record             //  直前のQSO内容
    Num:            integer;
    OnDateTime:     TDateTime;
    Freq:           Int64;
    RecvFreq:       Int64;
    Route:          string;
    Repeater:       string;
    Mode:           string;
    HisReport:      string;
    MyReport:       string;
  end;

type TMyDataRec = record           //  TMｙDataの値
    MyCallsign:     string;
    MyEntity:       string;
    MyCountry:      string;
    MyRegion:       string;
    MyGridLoc:      string;
    MyRIG:          string;
    MyAnt:          string;
    MyMemo:         string;
    MyCountryName:  string;
    MyRegionName:   string;
    MyEntityName:   string;
    MyLatitude:     string;
    MyLongitude:    string;
    MyArea:         string;
  end;

Type
    TOptionSummary = Record
      Callsign:       Integer;
      Entity:         Integer;
      Region:         Integer;
      Prefix:         Integer;
      Suffix:         Integer;
      JCA:            Integer;
      NotJAExec:      boolean;
      Band:           array[0..20] of boolean;
    End;

type
    POptionsData = ^TOptionsData;
    TOptionsData = record
      Callsign:           string;
      Name:               string;
      Address:            string;
      Country:            string;
      Region:             string;
      Entity:             string;
      Longitude:          Double;
      Latitude:           Double;
      GridLocator:        string;

      DbPath:             string;
      AutoBackupPath1:    string;
      AutoBackupPath2:    string;
      AutoBackup:         boolean;
      BackupGeneration:   Integer;
      JournalGeneration:  Integer;
      Precedence:         boolean;
      RealTimeInput:      boolean;
      CopyOnDate:         boolean;
      LogTabOrder:        string;
      DisplayItems:       string;          // conmma text
      NonDisplayItems:    string;          // conmma text
      Internet:           boolean;
      Jarl:               boolean;
      JarlUrl:            string;
      Mic:                boolean;
      MicUrl:             string;
      Summary:            TOptionSummary;
    end;

type TCallsignRec = record
    Callsign:       string;
    OrgCallsign:    string;
    Prefix:         string;
    Suffix:         string;
    Area:           string;
    result:         boolean;
  end;

type TCallbook = record
    Callsign:       string;
    Name:           string;
    Entity:         string;
    Country:        string;
    Region:         string;
    Comment:        string;
    result:         boolean;
  end;

type
  TCategory = (ctCallsign, ctEntity, ctRegion, ctPrefix, ctSuffix, ctJCA);


type TCallbookEx = record
    Callsign:       string;
    OnDate:         tDate;
    Country:        string;
    Region:         string;
    Entity:         string;
    GridLoc:        string;
    Continent:      string;
    ITUZone:        string;
    CQZone:         string;
    Latitude:       string;
    Longitude:      string;
    result:         boolean;
  end;

type TCountryRec = record
    Country:        string;
    Name:           string;
    FmDate:         TDateTime;
    Name_jp:        string;
    Result:         boolean;
  end;

type TFreqRec = record
    Freq:           Int64;
    Band:           Int64;
    DefaultMode:    string;
    Result:         boolean;
  end;

type TIotaRec = record
    Entity:         string;
    Iota:           string;
    Name:           string;
    Result:         boolean;
  end;

type TModeRec = record
    Mode:           string;
    Report:         string;
    ReportRegEx:    string;
    DefaultReport:  string;
    FreqFormat:     string;
    Result:         boolean;
  end;

type TEntityRec = record
    Entity:         string;
    Name:           string;
    Country:        string;
    Continent:      string;
    ITUZone:        string;
    CQZone:         string;
    Latitude:       string;
    Longitude:      string;
    Continents:     string;
    ITUZones:       string;
    CQZones:        string;
    HamLog:         string;
    result:         boolean;
  end;

type THamLog = record
    HamLog:         string;
    Entity:         string;
    result:         boolean;
  end;

type TRegionRec = record
    Country:        string;
    Region:         string;
    Name:           string;
    Name1:          string;
    Name2:          string;
    Name3:          string;
    Rank:           string;
    Latitude:       string;
    Longitude:      string;
    FmDate:         TDate;
    ToDate:         TDate;
    result:         boolean;
  end;

type TRepeaterRec = record
    Route:          string;
    Repeater:       string;
    UplinkFreq:     Int64;
    DownlinkFreq:   Int64;
    result:         boolean;
  end;

type TRouteRec = record
    Route:          string;
    NeedRepeter:    boolean;
    result:         boolean;
  end;


type TFilterKind = (flNone, flCallsign, flEntity, flRegion, flPrefix, flNum,
                   flOnDate, flMemo);

type TFilter = record
    Kind:       TFilterKind;
    Callsign:   string;
    Entity:     string;
    Country:    string;
    Region:     string;
    FmOnDate:   TDate;
    ToOnDate:   TDate;
    FmNum:      integer;
    ToNum:      integer;
    Prefix:     string;
    Suffix:     string;
    FmDate:     boolean;
    Memo1:      string;
    Memo2:      string;
    IsCondOr:   boolean;
    Sql:        string;
  end;



type TGridLocRec = record
    GridLoc: string;
    Longitude: Double;
    Latitude:  Double;
    end;

type
  TQslState=(smNone, smQso, smEQsl, smQsl);

type TSummary = record
      Kind:       integer;
      Callsign:   string;
      Entity:     string;
      Country:    string;
      Region:     string;
      Prefix:     string;
      Suffix:     string;
  end;

type TFindJpnKind = (fjPrefecture, fjCity, fjCounty, fjWard, fjTown, fjVillage);

type TFindJpnRec = record
    Kind:         TFindJpnKind;
//    Key: word;
    Area:         string;
    Date:         TDate;
    Region:       string;
    RegionName:   string;
    Latitude:     string;
    Longitude:    string;
    end;

type TFindKind = (fiNone, fiCallsign, fiEntity, fiRegion, fiPrefix, fiNum,
                   fiOnDate, fiMemo);

type TFindLogRec = record
    Kind:         TFindKind;
    Callsign:     string;
    Entity:       string;
    Country:      string;
    Region:       string;
    Prefix:       string;
    Suffix:       string;
    FmNum:        integer;
    ToNum:        Integer;
    OnDateTime:   tDateTime;
    Memo:         string;
    end;

type
  TDataInput=(diManual, diAuto);

implementation

end.
