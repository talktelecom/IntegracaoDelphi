unit UAtendimento;

interface

uses  Windows,
      SysUtils,
      UGlobalAtendimento,
      Dialogs,
      Classes;
{
  Métodos da Dll

  Aqui temos a declaração das ações
  do Atendimento.

  - Logar
  - Deslogar
  - Ligações
  - Intervalos
  - Conferência
  .
  .
  .
}

// Logar
procedure LogarInt (st: Pointer); stdcall;
procedure LogarInt; external EPBX_INTEGRACAO name 'Logar';

// Alterar o intervalo
procedure AlterarIntervaloTipoInt (id: Integer); cdecl;
procedure AlterarIntervaloTipoInt; external EPBX_INTEGRACAO name 'AlterarIntervaloTipo';

// Efetuar ligação
procedure DiscarInt (Numero: Pointer;  TipoDiscagem: Integer); cdecl;
procedure DiscarInt; external EPBX_INTEGRACAO name 'Discar';

// Realiza uma consulta
procedure ConsultarInt (Numero: Pointer;  TipoDiscagem: Integer); cdecl;
procedure ConsultarInt; external EPBX_INTEGRACAO name 'Consultar';

// Realiza transferência ao número consultado ou para o número dado.
procedure TransferirInt (Numero: Pointer;  TipoDiscagem: Integer); cdecl;
procedure TransferirInt; external EPBX_INTEGRACAO name 'Transferir';

// Deslogar
procedure DeslogarInt (); stdcall;
procedure DeslogarInt; external EPBX_INTEGRACAO name 'Deslogar';

// Encerrar ligação
procedure DesligarInt (); stdcall;
procedure DesligarInt; external EPBX_INTEGRACAO name 'Desligar';

// Coloca a ligação na espera
procedure IniciarEsperaInt (); stdcall;
procedure IniciarEsperaInt; external EPBX_INTEGRACAO name 'IniciarEspera';

// Tira a ligação da espera
procedure TerminarEsperaInt (); stdcall;
procedure TerminarEsperaInt; external EPBX_INTEGRACAO name 'TerminarEspera';

// Libera a consulta realizada
procedure LiberarConsultaInt (); stdcall;
procedure LiberarConsultaInt; external EPBX_INTEGRACAO name 'LiberarConsulta';

{
  Assinatura dos Métodos de CallBack
}

type
TOnEventPointer = procedure(param: Pointer) stdcall;

{
  Métodos para registrar
  os métodos de callback
  na dll

  - SetOnLogado
  - SetOnDeslogado
  - SetOnInfoIntervaloRamal
  - SetOnTempoStatus
  - SetOnChamada
  - SetOnAtendido
  - SetOnDesliga
  .
  .
  .
}

// método set callback Wrapper dll
TSetOnEventPointer  = procedure (_proc: TOnEventPointer) cdecl;

{
  Classe Atendimento

  Integração do CRM e a DLL
}
Atendimento = class

  private
    { Propriedades }
    HInstDll : THandle;

    { procedure e function }

  public

    IntervaloAtual    : integer;

    StRetornoSucesso  : integer;
    StRetornoErro     : integer;

    { Métodos para atribuir os eventos de callbackpara a DLL }

    SetOnLogado             : TSetOnEventPointer;
    SetOnDeslogado          : TSetOnEventPointer;
    SetOnInfoIntervaloRamal : TSetOnEventPointer;
    SetOnSetIntervaloRamal  : TSetOnEventPointer;
    SetOnTempoStatus        : TSetOnEventPointer;
    SetOnInfoCliente        : TSetOnEventPointer;
    SetOnRingVirtual        : TSetOnEventPointer;
    SetOnChamada            : TSetOnEventPointer;
    SetOnAtendido           : TSetOnEventPointer;
    SetOnPathNomeDialogo    : TSetOnEventPointer;
    SetOnChamadaPerdida     : TSetOnEventPointer;
    SetOnDesliga            : TSetOnEventPointer;
    SetOnDisca              : TSetOnEventPointer;
    SetOnDiscaErro          : TSetOnEventPointer;
    SetOnInicioEspera       : TSetOnEventPointer;
    SetOnTerminoEspera      : TSetOnEventPointer;
    SetOnConsulta           : TSetOnEventPointer;
    SetOnLiberarConsulta    : TSetOnEventPointer;
    SetOnChamadaTransferida : TSetOnEventPointer;
    SetOnConsultaChamada    : TSetOnEventPointer;
    SetOnConsultaAtendido   : TSetOnEventPointer;

    { Eventos de callback Inicio }

    OnLogado              : TOnEventPointer;
    OnDeslogado           : TOnEventPointer;
    OnInfoIntervaloRamal  : TOnEventPointer;
    OnSetIntervaloRamal   : TOnEventPointer;
    OnTempoStatus         : TOnEventPointer;
    OnInfoCliente         : TOnEventPointer;
    OnRingVirtual         : TOnEventPointer;
    OnChamada             : TOnEventPointer;
    OnAtendido            : TOnEventPointer;
    OnPathNomeDialogo     : TOnEventPointer;
    OnChamadaPerdida      : TOnEventPointer;
    OnDesliga             : TOnEventPointer;
    OnDisca               : TOnEventPointer;
    OnDiscaErro           : TOnEventPointer;
    OnInicioEspera        : TOnEventPointer;
    OnTerminoEspera       : TOnEventPointer;
    OnConsulta            : TOnEventPointer;
    OnLiberarConsulta     : TOnEventPointer;
    OnChamadaTransferida  : TOnEventPointer;
    OnConsultaChamada     : TOnEventPointer;
    OnConsultaAtendido    : TOnEventPointer;

    { Eventos de callback Fim }

    destructor Destroy; override;

  published

    { Inicialização }
    constructor Create;

    function Inicia : Bool;
    procedure Finaliza;

    { Métodos para integraçào com a DLL }
    function Logar(ramal: Integer; senha: String): bool;
    function AlterarIntervaloTipo(IdIntervalo: Integer): bool;
    function Discar(Numero: PChar; TipoDiscagem: Integer): bool;
    function Consultar(Numero: PChar; TipoDiscagem: Integer): bool;
    function Transferir(Numero : PChar = nil; TipoDiscagem : Integer = 0): bool;

    function Deslogar(): bool;
    function Desligar(): bool;
    function IniciarEspera(): bool;
    function TerminarEspera(): bool;
    function LiberarConsulta() : bool;
end;

implementation

{
  -----------------------------------
  Implementação da Classe Atendimento
  -----------------------------------
}

{
  Inicialização e finalização
}
constructor Atendimento.Create;
begin
  inherited;
  HInstDll              := 0;

  StRetornoSucesso      := 2;
  StRetornoErro         := 3;

  { Inicializa os eventos de callback com nil!!! }

  OnLogado              := nil;
  OnDeslogado           := nil;
  OnInfoIntervaloRamal  := nil;
  OnSetIntervaloRamal   := nil;
  OnTempoStatus         := nil;
  OnInfoCliente         := nil;
  OnRingVirtual         := nil;
  OnChamada             := nil;
  OnAtendido            := nil;
  OnPathNomeDialogo     := nil;
  OnChamadaPerdida      := nil;
  OnDesliga             := nil;
  OnDisca               := nil;
  OnDiscaErro           := nil;
  OnInicioEspera        := nil;
  OnTerminoEspera       := nil;
  OnConsulta            := nil;
  OnLiberarConsulta     := nil;
  OnChamadaTransferida  := nil;
  OnConsultaChamada     := nil;
  OnConsultaAtendido    := nil;

end;

destructor Atendimento.Destroy;
begin
  Finaliza;
  inherited;
end;

{
  Inicia a classe Atendimento
  Carrega a dll em memória
  Carrega os métodos
  Seta os eventos de callback
}
function Atendimento.Inicia;
begin
  Result := true;

  // Carrega a dll
  HInstDll := LoadLibrary(EPBX_INTEGRACAO);
  if (HInstDll = 0) then begin
    { TODO : Logar erro }
    Result := false;
    exit;
  end;

  // Seta os eventos da DLL
  // para se comunicar com esta instância

  // SetOnLogado
  if Assigned(OnLogado) then
  begin
    SetOnLogado := GetProcAddress(HInstDll, 'SetOnLogado');
    if Assigned(SetOnLogado) then
      SetOnLogado(@OnLogado);
  end;

  // SetOnDeslogado
  if Assigned(OnDeslogado) then
  begin
    SetOnDeslogado := GetProcAddress(HInstDll, 'SetOnDeslogado');
    if Assigned(SetOnDeslogado) then
      SetOnDeslogado(@OnDeslogado);
  end;

  // SetOnInfoIntervaloRamal
  if Assigned(OnInfoIntervaloRamal) then
  begin
    SetOnInfoIntervaloRamal := GetProcAddress(HInstDll, 'SetOnInfoIntervaloRamal');
    if Assigned(SetOnInfoIntervaloRamal) then
      SetOnInfoIntervaloRamal(@OnInfoIntervaloRamal);
  end;

  // SetOnSetIntervaloRamal
  if Assigned(OnSetIntervaloRamal) then
  begin
    SetOnSetIntervaloRamal := GetProcAddress(HInstDll, 'SetOnSetIntervaloRamal');
    if Assigned(SetOnSetIntervaloRamal) then
      SetOnSetIntervaloRamal(@OnSetIntervaloRamal);
  end;

  // SetOnTempoStatus
  if Assigned(OnTempoStatus) then
  begin
    SetOnTempoStatus := GetProcAddress(HInstDll, 'SetOnTempoStatus');
    if Assigned(SetOnTempoStatus) then
      SetOnTempoStatus(@OnTempoStatus);
  end;

  // SetOnInfoCliente
  if Assigned(OnInfoCliente) then
  begin
    SetOnInfoCliente := GetProcAddress(HInstDll, 'SetOnInfoCliente');
    if Assigned(SetOnInfoCliente) then
      SetOnInfoCliente(@OnInfoCliente);
  end;

  // SetOnRingVirtual
  if Assigned(OnRingVirtual) then
  begin
    SetOnRingVirtual := GetProcAddress(HInstDll, 'SetOnRingVirtual');
    if Assigned(SetOnRingVirtual) then
      SetOnRingVirtual(@OnRingVirtual);
  end;

  // SetOnChamada
  if Assigned(OnChamada) then
  begin
    SetOnChamada := GetProcAddress(HInstDll, 'SetOnChamada');
    if Assigned(SetOnChamada) then
      SetOnChamada(@OnChamada);
  end;

  // SetOnAtendido
  if Assigned(OnAtendido) then
  begin
    SetOnAtendido := GetProcAddress(HInstDll, 'SetOnAtendido');
    if Assigned(SetOnAtendido) then
      SetOnAtendido(@OnAtendido);
  end;

  // SetOnPathNomeDialogo
  if Assigned(OnPathNomeDialogo) then
  begin
    SetOnPathNomeDialogo := GetProcAddress(HInstDll, 'SetOnPathNomeDialogo');
    if Assigned(SetOnPathNomeDialogo) then
      SetOnPathNomeDialogo(@OnPathNomeDialogo);
  end;

  // SetOnChamadaPerdida
  if Assigned(OnChamadaPerdida) then
  begin
    SetOnChamadaPerdida := GetProcAddress(HInstDll, 'SetOnChamadaPerdida');
    if Assigned(SetOnChamadaPerdida) then
      SetOnChamadaPerdida(@OnChamadaPerdida);
  end;

  // SetOnDesliga
  if Assigned(OnDesliga) then
  begin
    SetOnDesliga := GetProcAddress(HInstDll, 'SetOnDesliga');
    if Assigned(SetOnDesliga) then
      SetOnDesliga(@OnDesliga);
  end;

  // SetOnDisca
  if Assigned(OnDisca) then
  begin
    SetOnDisca := GetProcAddress(HInstDll, 'SetOnDisca');
    if Assigned(SetOnDisca) then
      SetOnDisca(@OnDisca);
  end;

  // SetOnDiscaErro
  if Assigned(OnDiscaErro) then
  begin
    SetOnDiscaErro := GetProcAddress(HInstDll, 'SetOnDiscaErro');
    if Assigned(SetOnDiscaErro) then
      SetOnDiscaErro(@OnDiscaErro);
  end;

  // SetOnInicioEspera
  if Assigned(OnInicioEspera) then
  begin
    SetOnInicioEspera := GetProcAddress(HInstDll, 'SetOnInicioEspera');
    if Assigned(SetOnInicioEspera) then
      SetOnInicioEspera(@OnInicioEspera);
  end;

  // SetOnTerminoEspera
  if Assigned(OnTerminoEspera) then
  begin
    SetOnTerminoEspera := GetProcAddress(HInstDll, 'SetOnTerminoEspera');
    if Assigned(SetOnTerminoEspera) then
      SetOnTerminoEspera(@OnTerminoEspera);
  end;

  // SetOnConsulta
  if Assigned(OnConsulta) then
  begin
    SetOnConsulta := GetProcAddress(HInstDll, 'SetOnConsulta');
    if Assigned(SetOnConsulta) then
      SetOnConsulta(@OnConsulta);
  end;

  // SetOnLiberarConsulta
  if Assigned(OnLiberarConsulta) then
  begin
    SetOnLiberarConsulta := GetProcAddress(HInstDll, 'SetOnLiberarConsulta');
    if Assigned(SetOnLiberarConsulta) then
      SetOnLiberarConsulta(@OnLiberarConsulta);
  end;

  // SetOnChamadaTransferida
  if Assigned(OnChamadaTransferida) then
  begin
    SetOnChamadaTransferida := GetProcAddress(HInstDll, 'SetOnChamadaTransferida');
    if Assigned(SetOnChamadaTransferida) then
      SetOnChamadaTransferida(@OnChamadaTransferida);
  end;

  // SetOnConsultaChamada
  if Assigned(OnConsultaChamada) then
  begin
    SetOnConsultaChamada := GetProcAddress(HInstDll, 'SetOnConsultaChamada');
    if Assigned(SetOnConsultaChamada) then
      SetOnConsultaChamada(@OnConsultaChamada);
  end;

  // SetOnConsultaAtendido
  if Assigned(OnConsultaAtendido) then
  begin
    SetOnConsultaAtendido := GetProcAddress(HInstDll, 'SetOnConsultaAtendido');
    if Assigned(SetOnConsultaAtendido) then
      SetOnConsultaAtendido(@OnConsultaAtendido);
  end;


end;

{
  Finaliza a classe Atendimento
}
procedure Atendimento.Finaliza;
begin
  if (HInstDll <> 0) then
  begin
    Deslogar();
    FreeLibrary(HInstDll);
  end;
end;

{
  Métodos para integraçào com a DLL
}

{
  Logon do ramal
}
function Atendimento.Logar(ramal: Integer; senha: String): bool;
var
  ret       : Boolean;
  stL       : StLogar;
  _senha    : array [0..80] of char;
  _servidor : array [0..80] of char;
  strServidor : string;
begin
  Result := false;

  // Inicia a classe atendimento
  ret := Inicia;
  if (ret = false)  then begin
    UGlobalAtendimento.Trace('Erro ao iniciar a classe atendimento');
    exit;
  end;

  if Assigned(@LogarInt) then begin

    // Pega as informações do ini
    strServidor :=
      UGlobalAtendimento.LeConfigIni(
        'config',
        'servidor',
        strDirExe + '\' + COFIG_INI,
        80);

    StrPCopy(_senha, senha);
    StrPCopy(_servidor, strServidor);

    ZeroMemory(@stL,SizeOf(StLogar));

    stL.Id := 0;
    stL.Porta := 44900;
    stL.IntervaloCustomizado := 1;
    stL.Ramal := ramal;
    stL.RamalVirtual := ramal;
    stL.Senha := @_senha;
    stL.Servidor := @_servidor;

    LogarInt(@stL);

    Result := true;
  end
  else
  begin
    UGlobalAtendimento.Trace('Erro ao carregar o método Logar da ' + EPBX_INTEGRACAO);
  end;
end;

{
  Altera o intervalo do ramal
}
function Atendimento.AlterarIntervaloTipo(IdIntervalo: Integer) : bool;
begin
  Result := false;
  if Assigned(@AlterarIntervaloTipoInt) then
  begin
    AlterarIntervaloTipoInt(IdIntervalo);
    Result := true;
  end;
end;

{
  Realiza uma chamada
}
function Atendimento.Discar(Numero: PChar;  TipoDiscagem: Integer) : bool;
begin
  Result := false;
  if Assigned(@DiscarInt) then
  begin
    DiscarInt(Numero,  TipoDiscagem);
    Result := true;
  end;
end;

{
  Realiza uma consulta
}

function Atendimento.Consultar(Numero: PChar;  TipoDiscagem: Integer) : bool;
begin
  Result := false;
  if Assigned(@ConsultarInt) then
  begin
    ConsultarInt(Numero,  TipoDiscagem);
    Result := true;
  end;
end;

function Atendimento.Transferir(Numero: PChar; TipoDiscagem: Integer): bool;
begin
  Result := false;
  if Assigned(@TransferirInt) then
  begin
    TransferirInt(Numero,  TipoDiscagem);
    Result := true;
  end;
end;

{
  Logoff do ramal
}
function Atendimento.Deslogar() : bool;
begin
  Result := false;
  if Assigned(@DeslogarInt) then
  begin
    DeslogarInt;
    Result := true;
  end;
end;

{
  Desliga a ligação atual
}
function Atendimento.Desligar() : bool;
begin
  Result := false;
  if Assigned(@DesligarInt) then
  begin
    DesligarInt();
    Result := true;
  end;
end;

{
  Coloca a ligaçào na espera
}
function Atendimento.IniciarEspera() : bool;
begin
  Result := false;
  if Assigned(@IniciarEsperaInt) then
  begin
    IniciarEsperaInt;
    Result := true;
  end;
end;

{
  Tira a ligação da espera
}
function Atendimento.TerminarEspera() : bool;
begin
  Result := false;
  if Assigned(@TerminarEsperaInt) then
  begin
    TerminarEsperaInt;
    Result := true;
  end;
end;

{
  Libera a consulta
}
function Atendimento.LiberarConsulta : bool;
begin
  Result := false;
  if Assigned(@LiberarConsultaInt) then
  begin
    LiberarConsultaInt;
    Result := true;
  end;
end;

end.

