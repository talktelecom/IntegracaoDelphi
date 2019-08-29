unit UMain;

interface

uses
  Windows, Classes, Forms, StdCtrls, Controls, UThLogar, UAtendimento, Dialogs,
  SysUtils;

type
  TFormMain = class(TForm)
    btnLogar: TButton;
    procedure btnLogarClick(Sender: TObject);
  private
    _thLogar: ThLogar;
    procedure Logar(ramal : Integer; senha : String);

    { Métodos de callback }
    procedure OnTempoStatus(Tempo: Integer);
    
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.DFM}

procedure TFormMain.btnLogarClick(Sender: TObject);
begin
  Logar(1006, 'TalkTelecom$@2017');
end;

procedure TFormMain.Logar(ramal : Integer; senha : String);
var
  _atendimento : Atendimento;
begin
  _atendimento := Atendimento.Create;

  { Inicializar métodos e eventos }
  _atendimento.OnTempoStatus := OnTempoStatus;

  { Realiza o logon através de thread }
  _thLogar := ThLogar.Create (false, ramal, senha, _atendimento, Self);
end;

procedure TFormMain.OnTempoStatus(Tempo: Integer);
begin
  ShowMessage('Tempo no status - ' + IntToStr(Tempo));
end;

end.



