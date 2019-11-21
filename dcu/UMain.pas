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
  Messages,
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
    btnConsulta: TButton;
    btnTransfere: TButton;
    btnEspera: TButton;
    procedure txtNumeroKeyPress(Sender: TObject; var Key: Char);
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
    procedure btnEsperaClick(Sender: TObject);
    procedure btnConsultaClick(Sender: TObject);
    procedure btnTransfereClick(Sender: TObject);
private
  _thLogar: ThLogar;

  procedure Logar(ramal : Integer; senha : String;id: Integer = -1);
  procedure Deslogar();

public
    { Public declarations }
end;

var
  FormMain: TFormMain;
  _atendimento : Atendimento;

implementation

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
  begin
    FormMain.Caption := 'Atendimento - Status ' + IntToStr(st.Status);
    if(st.Mensagem[0] <> #0) then
      FormMain.lblErro.Caption := 'Erro:' + st.Mensagem
    else
      FormMain.lblErro.Caption := 'Erro: Falha no logon!'
  end;


  FormMain.btnLogar.Enabled := true;
end;

{
  Resposta do Deslogar
}
procedure OnDeslogado(param: Pointer); cdecl;
var
  st : StDeslogado;
begin
  FillChar( st, sizeof( StDeslogado ), #0 );
  CopyMemory(@st, param, sizeof(StDeslogado));

  if(st.Mensagem[0] <> #0) then
    FormMain.lblErro.Caption := 'Erro:' + st.Mensagem;

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

  if(st.Status = IntervaloPendente) then
    exit;

  if(st.Status <> IntervaloSucesso) then
  begin
    FormMain.lblErro.Caption := 'Erro para alterar o intervalo ' + IntToStr(st.Status);
    exit;
  end;

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
procedure OnDiscaErro(param: String); cdecl;
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
  {
    caso o consultado desligue, o ramal
    irá receber a ligação como um novo atendimento
  }
  FormMain.btnConsulta.Caption := 'Consultar';

  FormMain.btnDiscar.Enabled := true;
  FormMain.btnConsulta.Enabled := true;
  FormMain.btnTransfere.Enabled := true;
  FormMain.btnEspera.Enabled := true;
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
  FormMain.btnConsulta.Enabled := false;
  FormMain.btnTransfere.Enabled := false;
  FormMain.btnEspera.Enabled := false;
end;

{
  Coloca a ligação em espera
}
procedure OnInicioEspera(param: Pointer); cdecl;
var
  st : StRetorno;
begin
  FillChar( st, sizeof( StRetorno ), #0 );
  CopyMemory(@st, param, sizeof(StRetorno));

  FormMain.btnEspera.Enabled := true;

  if(st.Status <> _atendimento.StRetornoSucesso) then
  begin
    FormMain.lblErro.Caption := 'Erro ao colocar na espera ' + st.Mensagem;
    exit;
  end;

  FormMain.btnEspera.Caption := 'Tira Espera';
  FormMain.btnDiscar.Enabled := false;
  FormMain.btnConsulta.Enabled := false;
  FormMain.btnTransfere.Enabled := false;

end;

procedure OnTerminoEspera(param: Pointer); cdecl;
var
  st : StRetorno;
begin
  FillChar( st, sizeof( StRetorno ), #0 );
  CopyMemory(@st, param, sizeof(StRetorno));

  FormMain.btnEspera.Enabled := true;

  if(st.Status <> _atendimento.StRetornoSucesso) then
  begin
    FormMain.lblErro.Caption := 'Erro ao tirar da espera ' + st.Mensagem;
    exit;
  end;

  FormMain.btnEspera.Caption := 'Espera';
  FormMain.btnDiscar.Enabled := true;
  FormMain.btnConsulta.Enabled := true;
  FormMain.btnTransfere.Enabled := true;

end;

procedure OnConsulta(param: Pointer); cdecl;
var
  st : StRetorno;
begin
  FillChar( st, sizeof( StRetorno ), #0 );
  CopyMemory(@st, param, sizeof(StRetorno));

  if(st.Status <> _atendimento.StRetornoSucesso) then
  begin
    FormMain.btnConsulta.Enabled := true;
    FormMain.lblErro.Caption := 'Erro ao realizar a consulta ' + st.Mensagem;
    exit;
  end;
end;

procedure OnLiberarConsulta(param: Pointer); cdecl;
var
  st : StRetorno;
begin
  FillChar( st, sizeof( StRetorno ), #0 );
  CopyMemory(@st, param, sizeof(StRetorno));

  FormMain.btnConsulta.Enabled := true;

  if(st.Status <> _atendimento.StRetornoSucesso) then
  begin
    FormMain.lblErro.Caption := 'Erro ao liberar a consulta ' + st.Mensagem;
    exit;
  end;

  FormMain.btnDiscar.Enabled := true;
  FormMain.btnConsulta.Enabled := true;
  FormMain.btnTransfere.Enabled := true;
  FormMain.btnEspera.Enabled := true;
  FormMain.btnConsulta.Caption := 'Consultar';
end;

procedure OnChamadaTransferida (param: Pointer); cdecl;
var
  st : StRetorno;
begin
  FillChar( st, sizeof( StRetorno ), #0 );
  CopyMemory(@st, param, sizeof(StRetorno));

  if(st.Status <> _atendimento.StRetornoSucesso) then
  begin
    FormMain.btnConsulta.Enabled := true;
    FormMain.btnTransfere.Enabled := true;
    FormMain.lblErro.Caption := 'Erro ao transferir a ligação ' + st.Mensagem;
    exit;
  end;
end;

procedure OnConsultaChamada (param: Pointer); cdecl;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  FormMain.btnDiscar.Enabled := false;
  FormMain.btnConsulta.Enabled := true;
  FormMain.btnTransfere.Enabled := true;
  FormMain.btnEspera.Enabled := false;
  FormMain.btnConsulta.Caption := 'Libera Consulta';

end;

procedure OnConsultaAtendido (param: Pointer); cdecl;
var
  st : StChamada;
begin
  FillChar( st, sizeof( StChamada ), #0 );
  CopyMemory(@st, param, sizeof(StChamada));

  FormMain.btnDiscar.Enabled := false;
  FormMain.btnConsulta.Enabled := true;
  FormMain.btnTransfere.Enabled := true;
  FormMain.btnEspera.Enabled := false;
  FormMain.btnConsulta.Caption := 'Libera Consulta';
end;

procedure OnListaRamais (param: Pointer); cdecl;
var
  st : StRetorno;
begin
  FillChar( st, sizeof( StRetorno ), #0 );
  CopyMemory(@st, param, sizeof(StRetorno));

  if(st.Status <> _atendimento.StRetornoSucesso) then
  begin
    FormMain.lblErro.Caption := 'Erro ao listar os ramais ' + st.Mensagem;
    exit;
  end;

  {

    AO RECEBER ESTE EVENTO COM SUCESSO!!!

    FIM DA LISTAGEM DOS RAMAIS DO CTI

  }

end;

procedure OnInfoRamal (param: Pointer); cdecl;
var
  st : StRamal;
begin
  FillChar( st, sizeof( StRamal ), #0 );
  CopyMemory(@st, param, sizeof(StRamal));

  {

    CRIAR A LISTA DOS RAMAIS!!!!

  }

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
  FormMain.lblErro.Caption := 'Erro:';
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
      _atendimento.AlterarIntervaloTipo(intervalo);
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

  // Centraliza o form
  Left := (Screen.Width - Width) div 2;
  Top  := (Screen.Height - Height) Div 2;

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
  begin
    _atendimento.Destroy;
  end;
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
    if(Length(txtNumero.Text) < 1) then
    begin
      Application.messageBox('Digite um número para discar!','Aviso', mb_ok);
      exit;
    end;
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
  Parse do numero a discar para aceitar apenas digitos
}
procedure TFormMain.txtNumeroKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['.', ','])
     then if (pos(',', (Sender as TEdit).Text) = 0)
             then Key := ','
          else Key := #7
  else if (not(Key in ['0'..'9', #8]))
          then Key := #7;
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

{
  Coloca / Retira a ligação na espera
}
procedure TFormMain.btnEsperaClick(Sender: TObject);
begin
  lblErro.Caption := '';
  if(btnEspera.Caption = 'Espera') then
    _atendimento.IniciarEspera
  else
    _atendimento.TerminarEspera;

  lblErro.Caption := '';
  btnEspera.Enabled := false;
end;

{
  Realiza uma consulta externa / interna
}
procedure TFormMain.btnConsultaClick(Sender: TObject);
var Numero: PChar;
    _numero    : array [0..30] of char;
    direcao: Integer;
begin
  if(btnConsulta.Caption = 'Consultar') then
  begin
    if(Length(txtNumero.Text) < 1) then
    begin
      Application.messageBox('Digite um número para consultar!','Aviso', mb_ok);
      exit;
    end;
    lblErro.Caption := '';
    Numero :=  @_numero;
    StrPCopy(_numero, txtNumero.Text);
    if(chkInterna.Checked) then
      direcao := 2
    else
      direcao := 1;
    btnConsulta.Enabled := false;
    _atendimento.Consultar(Numero, direcao);
  end
  else
    _atendimento.LiberarConsulta;
end;

procedure TFormMain.btnTransfereClick(Sender: TObject);
var Numero: PChar;
    _numero    : array [0..30] of char;
    direcao: Integer;
begin

  // Está em consulta
  if(btnConsulta.Caption = 'Libera Consulta') then
  begin
    lblErro.Caption := '';
    btnTransfere.Enabled := false;
    btnConsulta.Enabled := false;
    _atendimento.Transferir();
  end
  else
  begin
    if(Length(txtNumero.Text) < 1) then
    begin
      Application.messageBox('Digite um número para transferir!','Aviso', mb_ok);
      exit;
    end;
    lblErro.Caption := '';
    Numero :=  @_numero;
    StrPCopy(_numero, txtNumero.Text);
    if(chkInterna.Checked) then
      direcao := 2
    else
      direcao := 1;
    btnTransfere.Enabled := false;
    _atendimento.Transferir(Numero, direcao);
  end;

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
procedure TFormMain.Logar(ramal: Integer; senha: String; id: Integer);
begin
  // Liberamos instancia anterior
  // Lembre-se na DLL temos que
  // Criar sempre uma nova instancia!!!
  if Assigned(_atendimento)then
    _atendimento.Destroy;

  // Cria uma nova instancia
  _atendimento := Atendimento.Create;

  { Atribuição das procedures aos respectivos eventos de callback }
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
  _atendimento.OnDisca              := @OnDisca;
  _atendimento.OnDiscaErro          := @OnDiscaErro;
  _atendimento.OnInicioEspera       := @OnInicioEspera;
  _atendimento.OnTerminoEspera      := @OnTerminoEspera;
  _atendimento.OnConsulta           := @OnConsulta;
  _atendimento.OnLiberarConsulta    := @OnLiberarConsulta;
  _atendimento.OnChamadaTransferida := @OnChamadaTransferida;
  _atendimento.OnConsultaChamada    := @OnConsultaChamada;
  _atendimento.OnConsultaAtendido   := @OnConsultaAtendido;
  _atendimento.OnListaRamais        := @OnListaRamais;
  _atendimento.OnInfoRamal          := @OnInfoRamal;

  // Desabilita o botão de logar
  btnLogar.Enabled := false;

  { Realiza o logon através de thread }
  _thLogar := ThLogar.Create (false, ramal, senha, id, _atendimento);
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
  str := IntToStr(_atendimento.IntervaloAtual);
  posicao := cboIntervalo.Items.IndexOf(str);
  if( posicao <> -1) then
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
  chkInterna.Enabled := valor;

  btnDiscar.Enabled := valor;
end;

end.

