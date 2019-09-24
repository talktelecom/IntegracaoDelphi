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
  SysUtils,
  UGlobalAtendimento;

type

TFormMain = class(TForm)
    btnLogar: TButton;
    lblIntervalo: TLabel;
    lblChamada: TLabel;
    lblAtendido: TLabel;
    txtInter: TEdit;
    cboIntervalo: TComboBox;
    btnIntervalo: TButton;
    lblNumero: TLabel;
    txtNumero: TEdit;
    btnDiscar: TButton;
    txtRamal: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    txtSenha: TEdit;
    Label3: TLabel;
    lblOnChamando: TLabel;
    Label5: TLabel;
    lblOnAtendido: TLabel;
    btnDesligar: TButton;
    procedure btnLogarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDiscarClick(Sender: TObject);
    procedure btnIntervaloClick(Sender: TObject);
    procedure txtRamalKeyPress(Sender: TObject; var Key: Char);
    procedure btnDesligarClick(Sender: TObject);
private
  _thLogar: ThLogar;

  procedure Logar(ramal : Integer; senha : String);
  procedure Deslogar();

public
    { Public declarations }
end;

var
  FormMain: TFormMain;
  _atendimento : Atendimento;

implementation

uses StrUtils;

{
  Métodos de CallBack

  Aqui temos a declaração das
  funções de callbac e sua tipagem

  - OnLogado
  - OnDeslogarRetorno
  - OnIntervalo
  - OnChamada
  - OnAtendido
  .
  .
  .
}


{
  Resposta do logon
}
procedure OnLogado(param: Pointer); cdecl; //stdcall;
var
  st : StLogado;
begin
  FillChar( st, sizeof( StLogado ), #0 );
  CopyMemory(@st, param, sizeof(StLogado));

  if(st.Status = 2) then
  begin
    FormMain.Caption := 'Atendimento - ' + st.NomeUsuario;
    FormMain.btnLogar.Caption := 'Deslogar';
  end
  else
    FormMain.Caption := 'Atendimento - Erro no logon';
    FormMain.btnLogar.Enabled := true;
end;

{
  Resposta do Deslogar
}
procedure OnDeslogado(); cdecl; //stdcall;
begin
  FormMain.Caption := 'Atendimento';
  FormMain.btnLogar.Caption := 'Logar';
  FormMain.btnLogar.Enabled := true;
  FormMain.txtInter.Text := '';
end;

{
  Intervalos permitidos para o ramal
}
procedure OnInfoIntervaloRamal(param: Pointer); cdecl; //stdcall;
var
  st : StInfoIntervaloRamal;
begin
  FillChar( st, sizeof( StInfoIntervaloRamal ), #0 );
  CopyMemory(@st, param, sizeof(StInfoIntervaloRamal));

  {  TODO : Salvar os intervalos do ramal. }

  if(Length(FormMain.txtInter.Text) > 0) then
    FormMain.txtInter.Text := FormMain.txtInter.Text + ' - ' + st.Descricao
  else
    FormMain.txtInter.Text := st.Descricao;
    FormMain.cboIntervalo.Items.Add(IntToStr(st.RamalStatusDetalheId) + ' - ' + st.Descricao);

end;

{
  Intervalo atual do ramal
}
procedure OnSetIntervaloRamal(param: Pointer); cdecl; //stdcall;
var
  st : StSetIntervaloRamal;
begin
  FillChar( st, sizeof( StSetIntervaloRamal ), #0 );
  CopyMemory(@st, param, sizeof(StSetIntervaloRamal));

  {  TODO : Tratar o intervalo atual do ramal. }

  FormMain.lblIntervalo.Caption := 'Intervalo: ' + st.Mensagem;

end;

{
  Tempo em que o ramal está no status atual
}
procedure OnTempoStatus(param: Pointer); cdecl; //stdcall;
//var
  //t : Integer;
begin
  //t := Integer(param);

  //FormMain.lblIntervalo.Caption := 'tempo ' + IntToStr(t);

  {  TODO : Tratar o tempo do status atual do ramal. }

end;

{
  Informações relativas ao telefone ip, se aplicável.
}
procedure OnInfoCliente(param: String); cdecl; //stdcall;
begin

  {  TODO : Tratar o info do telefone ip. }

end;

{
  Ring virtual do softPhone
}
procedure OnRingVirtual(); cdecl; //stdcall;
begin

  {  TODO : Tratar o rinf virtual. }

end;

{
  Ramal está recebendo uma chamada
}
procedure OnChamada(param: Pointer); cdecl; //stdcall;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  {  TODO : Tratar a chamada. }

  FormMain.lblOnChamando.Caption := 'Chamada:' + st.Telefone;

end;

{
  Ramal atendeu a uma ligação
}
procedure OnAtendido(param: Pointer); cdecl; //stdcall;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  {  TODO : Tratar a ligação atendida. }

  FormMain.lblOnAtendido.Caption := 'Atendido:' + st.Telefone;

end;

{
  Full path e nome do arquivo de dialogo
}
procedure OnPathNomeDialogo(param: String); cdecl; //stdcall;
begin

  {  TODO : Tratar a dados do arquivo de dialogo. }

end;

{
  Ramal perdeu uma ligação
}
procedure OnChamadaPerdida(param: Pointer); cdecl; //stdcall;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  {  TODO : Tratar a chamada perdida. }

end;

{
  Ligação desligada
}
procedure OnDesliga(param: Pointer); cdecl; //stdcall;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  {  TODO : Tratar a chamada desligada. }


  FormMain.lblIntervalo.Caption := 'Intervalo:';
  FormMain.lblChamada.Caption := 'Chamada:';
  FormMain.lblAtendido.Caption := 'Atendido:';

end;

{
  Métodos do Form Atendimento
}

{$R *.DFM}

{
  Evento para realizar o logon
}
procedure TFormMain.btnLogarClick(Sender: TObject);
begin
  if(btnLogar.Caption = 'Logar') then
    Logar( StrToInt(FormMain.txtRamal.Text), FormMain.txtSenha.Text)
  else
    Deslogar;
end;

{
  Realizar o logon através de thread
  pois no método de logon da DLL,
  o mesmo ficará em loop para tratar
  os eventos da DLL e o SO.
}
procedure TFormMain.Logar(ramal : Integer; senha : String);
begin
  // Liberamos instancia anterior
  // Lembre-se na DLL temos que
  // Criar sempre uma nova instancia!!!
  if Assigned(_atendimento)then
    _atendimento.Destroy;

  // Cria uma nova instancia
  _atendimento := Atendimento.Create;

  { Inicializar métodos e eventos }
  _atendimento.OnLogado             := @OnLogado;
  _atendimento.OnDeslogado          := @OnDeslogado;
  _atendimento.OnInfoIntervaloRamal := @OnInfoIntervaloRamal;
  _atendimento.OnSetIntervaloRamal  := @OnSetIntervaloRamal;
  _atendimento.OnTempoStatus        := @OnTempoStatus;
  _atendimento.OnInfoCliente        := @OnInfoCliente;
  _atendimento.OnRingVirtual        := @OnRingVirtual;
  _atendimento.OnChamada            := @OnChamada;
  _atendimento.OnAtendido           := @OnAtendido;
  _atendimento.OnPathNomeDialogo    := @OnPathNomeDialogo;
  _atendimento.OnChamadaPerdida     := @OnChamadaPerdida;
  _atendimento.OnDesliga            := @OnDesliga;

  // Desabilita o botão de logar
  btnLogar.Enabled := false;

  { Realiza o logon através de thread }
  _thLogar := ThLogar.Create (false, ramal, senha, _atendimento, Self);
end;

procedure TFormMain.Deslogar;
begin
  // Desabilita o botão de logar
  btnLogar.Enabled := false;
  _atendimento.Deslogar;
end;

{
  Antes de encerrar o form,
  destroi o objeto atendimento
}
procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Liberamos instancia atendimento
  if Assigned(_atendimento)then
    _atendimento.Destroy;
end;

procedure TFormMain.btnDiscarClick(Sender: TObject);
var Numero: PChar;
    _numero    : array [0..30] of char;
    direcao: Integer;
begin
  Numero :=  @_numero;

  StrPCopy(_numero, txtNumero.Text);
  direcao := 1;
  _atendimento.Discar(Numero, direcao);
end;

procedure TFormMain.btnIntervaloClick(Sender: TObject);
var select, letra, palavra : string;
    a, i : integer;

begin
  i := 1;
  while not (letra = ' ') do
  begin
    palavra := palavra + letra;
    letra := (cboIntervalo.Text[i]);
    i := i + 1;
  end;
  select := palavra;
  _atendimento.AlterarIntervalo(StrToInt(select));
end;


procedure TFormMain.txtRamalKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['.', ','])
     then if (pos(',', (Sender as TEdit).Text) = 0)
             then Key := ','
          else Key := #7
  else if (not(Key in ['0'..'9', #8]))
          then Key := #7;
end;

procedure TFormMain.btnDesligarClick(Sender: TObject);
begin
      _atendimento.Desligar();
end;

end.






