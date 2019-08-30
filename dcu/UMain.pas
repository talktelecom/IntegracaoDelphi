unit UMain;

interface

uses
  Windows,
  Classes,
  Forms,
  StdCtrls,
  Controls,
  UThLogar,
  UAtendimento,
  Dialogs,
  SysUtils;

type

TFormMain = class(TForm)
  btnLogar: TButton;
  lblTempo: TLabel;
  procedure btnLogarClick(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
private
  _thLogar: ThLogar;

  procedure Logar(ramal : Integer; senha : String);

public
    { Public declarations }
end;

var
  FormMain: TFormMain;
  _atendimento : Atendimento;

implementation

{
  M�todos de CallBack

  Aqui temos a declara��o das
  fun��es de callbac e sua tipagem

  - OnLogado
  - OnDeslogarRetorno
  - OnIntervalo
  - OnChamada
  - OnAtendido
  .
  .
  .
}

procedure OnTempoStatus(param: Pointer); stdcall;
var
  t : Integer;
begin
  t := Integer(param);
  FormMain.lblTempo.Caption := 'Tempo = ' + IntToStr(t);
end;

{
  M�todos do Form Atendimento
}

{$R *.DFM}

procedure TFormMain.btnLogarClick(Sender: TObject);
begin
  Logar(1006, 'TalkTelecom$@2017');
end;

procedure TFormMain.Logar(ramal : Integer; senha : String);
begin
  // Liberamos instancia anterior
  if Assigned(_atendimento)then
    _atendimento.Destroy;

  // Cria uma nova instancia
  _atendimento := Atendimento.Create;

  { Inicializar m�todos e eventos }
  //_atendimento.OnLogado := @OnLogado;
  _atendimento.OnTempoStatus := @OnTempoStatus;

  { Realiza o logon atrav�s de thread }
  _thLogar := ThLogar.Create (false, ramal, senha, _atendimento, Self);
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Liberamos instancia atendimento
  if Assigned(_atendimento)then
    _atendimento.Destroy;
end;

end.



