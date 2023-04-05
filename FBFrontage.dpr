program FBFrontage;

uses
  Forms,
  uRoutine in 'uRoutine.pas',
  uTables in 'uTables.pas' {Tables};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTables, Tables);
  Application.Run;
end.
