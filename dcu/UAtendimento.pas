unit UAtendimento;

interface

uses  Windows,
      SysUtils,
      UGlobalAtendimento,
      Dialogs,
      Classes;
{
  Métodos da Dll

  Aqui temos a declaração das referência as ações do Atendimento.

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

// Lista os ramais do CTI e em caso de Ramal PA, o seu respectivo status
procedure ListaRamaisInt (TipoRamal: Integer); cdecl;
procedure ListaRamaisInt; external EPBX_INTEGRACAO name 'ListaRamais';

{
  Assinatura dos Métodos de CallBack
}

type
TOnEventPointer = procedure(param: Pointer) stdcall;

{
  Assinatura para registrar os evento de callback na dll

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

    { Referência acessar os métodos da dll para atribuir as procedures de callback }

    SetProcedureCallback    : TSetOnEventPointer;
    
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
    OnListaRamais         : TOnEventPointer;
    OnInfoRamal           : TOnEventPointer;

    { Eventos de callback Fim }

    destructor Destroy; override;

  published

    { Inicialização }
    constructor Create;

    function Inicia : Bool;
    procedure Finaliza;

    { Métodos para integraçào com a DLL }
    function Logar(ramal: Integer; senha: String; id: Integer = -1): bool;
    function AlterarIntervaloTipo(IdIntervalo: Integer): bool;
    function Discar(Numero: PChar; TipoDiscagem: Integer): bool;
    function Consultar(Numero: PChar; TipoDiscagem: Integer): bool;
    function Transferir(Numero : PChar = nil; TipoDiscagem : Integer = 0): bool;
    function ListaRamais(TipoRamal: Integer) : bool;

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
  OnListaRamais         := nil;
  OnInfoRamal           := nil;

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
var
  erroStr : string;
begin
  Result := true;

  // Carrega a dll
  HInstDll := LoadLibrary(EPBX_INTEGRACAO);
  if (HInstDll = 0) then begin
    erroStr := format('Erro em LoadLibrary %s, erro %d', [EPBX_INTEGRACAO, GetLastError]);
    Trace(erroStr);
    Result := false;
    exit;
  end;

  // Seta os eventos da DLL
  // para se comunicar com esta instância

  // SetOnLogado
  if Assigned(OnLogado) then
  begin
    SetProcedureCallback:= GetProcAddress(HInstDll, 'SetOnLogado');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnLogado)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnLogado, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnDeslogado
  if Assigned(OnDeslogado) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnDeslogado');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnDeslogado)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnDeslogado, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnInfoIntervaloRamal
  if Assigned(OnInfoIntervaloRamal) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnInfoIntervaloRamal');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnInfoIntervaloRamal)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnInfoIntervaloRamal, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnSetIntervaloRamal
  if Assigned(OnSetIntervaloRamal) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnSetIntervaloRamal');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnSetIntervaloRamal)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnSetIntervaloRamal, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnTempoStatus
  if Assigned(OnTempoStatus) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnTempoStatus');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnTempoStatus)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnTempoStatus, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnInfoCliente
  if Assigned(OnInfoCliente) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnInfoCliente');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnInfoCliente)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnInfoCliente, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnRingVirtual
  if Assigned(OnRingVirtual) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnRingVirtual');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnRingVirtual)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnRingVirtual, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnChamada
  if Assigned(OnChamada) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnChamada');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnChamada)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnChamada, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnAtendido
  if Assigned(OnAtendido) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnAtendido');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnAtendido)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnAtendido, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnPathNomeDialogo
  if Assigned(OnPathNomeDialogo) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnPathNomeDialogo');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnPathNomeDialogo)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnPathNomeDialogo, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnChamadaPerdida
  if Assigned(OnChamadaPerdida) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnChamadaPerdida');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnChamadaPerdida)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnChamadaPerdida, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnDesliga
  if Assigned(OnDesliga) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnDesliga');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnDesliga)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnDesliga, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnDisca
  if Assigned(OnDisca) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnDisca');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnDisca)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnDisca, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnDiscaErro
  if Assigned(OnDiscaErro) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnDiscaErro');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnDiscaErro)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnDiscaErro, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnInicioEspera
  if Assigned(OnInicioEspera) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnInicioEspera');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnInicioEspera)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnInicioEspera, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnTerminoEspera
  if Assigned(OnTerminoEspera) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnTerminoEspera');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnTerminoEspera)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnTerminoEspera, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnConsulta
  if Assigned(OnConsulta) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnConsulta');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnConsulta)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnConsulta, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnLiberarConsulta
  if Assigned(OnLiberarConsulta) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnLiberarConsulta');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnLiberarConsulta)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnLiberarConsulta, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnChamadaTransferida
  if Assigned(OnChamadaTransferida) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnChamadaTransferida');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnChamadaTransferida)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnChamadaTransferida, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnConsultaChamada
  if Assigned(OnConsultaChamada) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnConsultaChamada');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnConsultaChamada)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnConsultaChamada, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnConsultaAtendido
  if Assigned(OnConsultaAtendido) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnConsultaAtendido');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnConsultaAtendido)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnConsultaAtendido, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnListaRamais
  if Assigned(OnListaRamais) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnListaRamais');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnListaRamais)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnListaRamais, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
  end;

  // SetOnInfoRamal
  if Assigned(OnInfoRamal) then
  begin
    SetProcedureCallback := GetProcAddress(HInstDll, 'SetOnInfoRamal');
    if Assigned(SetProcedureCallback) then
      SetProcedureCallback(@OnInfoRamal)
    else
    begin
      erroStr := format('Erro em GetProcAddress SetOnInfoRamal, erro %d', [GetLastError]);
      Trace(erroStr);
    end;
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
function Atendimento.Logar(ramal: Integer; senha: String; id: Integer): bool;
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

    stL.Id := id;
    stL.Porta := 44900;
    stL.IntervaloCustomizado := 1;
    stL.Ramal := ramal;
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

{
  Lista Ramais
}
function Atendimento.ListaRamais(TipoRamal: Integer) : bool;
begin
  Result := false;
  if Assigned(@ListaRamaisInt) then
  begin
    ListaRamaisInt(TipoRamal);
    Result := true;
  end;
end;

end.

