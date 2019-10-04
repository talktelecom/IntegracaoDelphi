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
    lblChamada: TLabel;
    lblAtendido: TLabel;
    cboIntervalo: TComboBox;
    lblNumero: TLabel;
    txtNumero: TEdit;
    btnDiscar: TButton;
    txtRamal: TEdit;
    lblRamal: TLabel;
    lblSenha: TLabel;
    txtSenha: TEdit;
    chkInterna: TCheckBox;
    lblErro: TLabel;
    procedure txtNumeroChange(Sender: TObject);
    procedure cboIntervaloChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLogarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDiscarClick(Sender: TObject);
    procedure txtRamalKeyPress(Sender: TObject; var Key: Char);
    procedure btnDesligarClick(Sender: TObject);
    procedure setIntervaloById(id: integer);
    procedure setCboIntervalo;
    procedure enableLogon(valor: bool);
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

{ -----------------------------------------------------------------------------
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

                          Eventos de CallBack

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
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 ----------------------------------------------------------------------------- }

{
  Resposta do logon
}
procedure OnLogado(param: Pointer); cdecl;
var
  st : StLogado;
begin
  FillChar( st, sizeof( StLogado ), #0 );
  CopyMemory(@st, param, sizeof(StLogado));

  if(st.Status = 2) then
  begin
    FormMain.Caption := 'Atendimento - ' + st.NomeUsuario;
    FormMain.btnLogar.Caption := 'Deslogar';
    FormMain.enableLogon(true);
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
  FormMain.enableLogon(false);
end;

{
  Intervalos permitidos para o ramal
}
procedure OnInfoIntervaloRamal(param: Pointer); cdecl;
var
  st : StInfoIntervaloRamal;
begin
  FillChar( st, sizeof( StInfoIntervaloRamal ), #0 );
  CopyMemory(@st, param, sizeof(StInfoIntervaloRamal));

  {  add os intervalos no combo }
  FormMain.cboIntervalo.Items.Add(IntToStr(st.RamalStatusDetalheId) + ' - ' + st.Descricao);
  FormMain.setIntervaloById(st.RamalStatusDetalheId);
end;

{
  Intervalo atual do ramal
}
procedure OnSetIntervaloRamal(param: Pointer); cdecl;
var
  st : StSetIntervaloRamal;
begin
  FillChar( st, sizeof( StSetIntervaloRamal ), #0 );
  CopyMemory(@st, param, sizeof(StSetIntervaloRamal));

  {  TODO : Tratar o intervalo atual do ramal. }
  _atendimento.IntervaloAtual := st.RamalStatusDetalheId;

end;

{
  Tempo em que o ramal está no status atual
}
procedure OnTempoStatus(param: Pointer); cdecl;
begin

  // ajustamos o intervalo atual do ramal
  FormMain.setCboIntervalo;

  {  TODO : Tratar o tempo do status atual do ramal. }

end;

{
  Informações relativas ao telefone ip, se aplicável.
}
procedure OnInfoCliente(param: String); cdecl;
begin

  {  TODO : Tratar o info do telefone ip. }

end;

{
  Ring virtual do softPhone
}
procedure OnRingVirtual(); cdecl;
begin

  {  TODO : Tratar o rinf virtual. }

end;

{
  Retorno da requisiçào de uma chamada
}
procedure OnDisca(param: Pointer); cdecl;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  {  TODO : Tratar OnDisca. }
  FormMain.btnDiscar.Caption := 'Desligar';
  FormMain.btnDiscar.Enabled := true;
end;

{
  Erro ao realizar a discagem
}
procedure onDiscaErro(param: String); cdecl;
begin

  {  TODO : Tratar onDiscaErro. }
  FormMain.btnDiscar.Enabled := true;
  FormMain.lblErro.Caption := param;
end;


{
  Ramal está recebendo uma chamada
}
procedure OnChamada(param: Pointer); cdecl;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  {  TODO : Tratar a chamada. }
  FormMain.lblChamada.Caption := 'Chamada:' + st.Telefone;
  FormMain.btnDiscar.Enabled := true;
end;

{
  Ramal atendeu a uma ligação
}
procedure OnAtendido(param: Pointer); cdecl;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  {  TODO : Tratar a ligação atendida. }
  FormMain.lblAtendido.Caption := 'Atendido:' + st.Telefone;
  FormMain.btnDiscar.Caption := 'Desligar';
  FormMain.btnDiscar.Enabled := true;
end;

{
  Full path e nome do arquivo de dialogo
}
procedure OnPathNomeDialogo(param: String); cdecl;
begin

  {  TODO : Tratar a dados do arquivo de dialogo. }

end;

{
  Ramal perdeu uma ligação
}
procedure OnChamadaPerdida(param: Pointer); cdecl;
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
procedure OnDesliga(param: Pointer); cdecl;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  {  TODO : Tratar a chamada desligada. }
  FormMain.lblChamada.Caption := 'Chamada:';
  FormMain.lblAtendido.Caption := 'Atendido:';
  FormMain.btnDiscar.Caption := 'Discar';
  FormMain.btnDiscar.Enabled := true;
end;

{ -----------------------------------------------------------------------------
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

                          Eventos do Form Atendimento

  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -----------------------------------------------------------------------------}

{$R *.DFM}

{
  Realiza o logon
}
procedure TFormMain.btnLogarClick(Sender: TObject);
begin
  if(btnLogar.Caption = 'Logar') then
    Logar( StrToInt(FormMain.txtRamal.Text), FormMain.txtSenha.Text)
  else
    Deslogar;
end;

{
  Alterou o intervalo
}
procedure TFormMain.cboIntervaloChange(Sender: TObject);
var
  letra,
  strIntervalo : string;
  intervalo,
  i,
  ret : integer;
begin
  i := 1;
  letra := '';
  while not (letra = ' ') do
  begin
    strIntervalo := strIntervalo + letra;
    letra := (cboIntervalo.Text[i]);
    i := i + 1;
  end;
  val(strIntervalo, intervalo, ret);
  if (ret = 0 and intervalo) then
      _atendimento.AlterarIntervalo(intervalo);
end;

{
  Ao iniciar o form
  iniciamos as cariaveis
  do atendimento
}
procedure TFormMain.FormCreate(Sender: TObject);
var
  ramal : string;
  senha : string;
begin

  // Inicia a aplicação
  UGlobalAtendimento.IniciaApp;

  // desabilita os componentes
  enableLogon(false);

  // Pega as informações do ini
  ramal :=
    UGlobalAtendimento.LeConfigIni(
      'config',
      'ramal',
      strDirExe + '\' + COFIG_INI,
      80);

  senha :=
    UGlobalAtendimento.LeConfigIni(
      'config',
      'senha',
      strDirExe + '\' + COFIG_INI,
      80);

  // Inicia componentes form
  txtRamal.Text := ramal;
  txtSenha.Text := senha;

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

{
  Realiza uma chamada interna / externa
}
procedure TFormMain.btnDiscarClick(Sender: TObject);
var Numero: PChar;
    _numero    : array [0..30] of char;
    direcao: Integer;
begin
  if(btnDiscar.Caption = 'Discar') then
  begin
    lblErro.Caption := '';
    Numero :=  @_numero;
    StrPCopy(_numero, txtNumero.Text);
    if(chkInterna.Checked) then
      direcao := 2
    else
      direcao := 1;
    btnDiscar.Enabled := false;
    _atendimento.Discar(Numero, direcao);
  end
  else
    _atendimento.Desligar;
end;

{
  Valida se a ligação será interna / externa
}
procedure TFormMain.txtNumeroChange(Sender: TObject);
begin
  if(Length(txtNumero.Text) < 7) then
    chkInterna.checked := true
  else
    chkInterna.checked := false;
end;

{
  Parse do ramal para aceitar apenas digitos
}
procedure TFormMain.txtRamalKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['.', ','])
     then if (pos(',', (Sender as TEdit).Text) = 0)
             then Key := ','
          else Key := #7
  else if (not(Key in ['0'..'9', #8]))
          then Key := #7;
end;

{
  Desliga a ligação em curso
}
procedure TFormMain.btnDesligarClick(Sender: TObject);
begin
      _atendimento.Desligar();
end;

{ -----------------------------------------------------------------------------
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

                          Métodos de uso Atendimento

  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  -----------------------------------------------------------------------------}
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

{
  Desloga o ramal
}
procedure TFormMain.Deslogar;
begin
  // Desabilita o botão de logar
  btnLogar.Enabled := false;
  _atendimento.Deslogar;
end;

{
  Seta o intervalo pelo id dado
}
procedure TFormMain.setIntervaloById(id: integer);
begin
    cboIntervalo.ItemIndex := id - 1;
end;

{
  Seta o intervalo inicial do ramal
  logo após o logon
}
procedure TFormMain.setCboIntervalo;
var
  posicao : Integer;
  str : string;
begin
  str := IntToStr(_atendimento.IntervaloAtual) + ' -';
  posicao := cboIntervalo.Items.IndexOf(str);
  if( posicao > 0) then
    cboIntervalo.ItemIndex := posicao;
end;

{
  Habilita / Desabilita os componentes
  do form de acordo com a ação de logar ou deslogar
}
procedure TFormMain.enableLogon(valor: bool);
begin
  cboIntervalo.Enabled := valor;
  txtNumero.Enabled := valor;
  btnDiscar.Enabled := valor;
  chkInterna.Enabled := valor;
end;

end.

