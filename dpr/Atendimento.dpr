program Atendimento;

uses
  Forms,
  UMain in '..\dcu\UMain.pas' {FormMain},
  UAtendimento in '..\dcu\UAtendimento.pas',
  UThLogar in '..\dcu\UThLogar.pas',
  UGlobalAtendimento in '..\dcu\UGlobalAtendimento.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
