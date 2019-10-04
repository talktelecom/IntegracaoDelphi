unit UAtendimento;

interface

uses  Windows,
      SysUtils,
      UGlobalAtendimento,
      Dialogs,
      Classes;
{
  M�todos da Dll

  Aqui temos a declara��o das a��es
  do Atendimento.

  - Logar
  - Deslogar
  - Liga��es
  - Intervalos
  - Confer�ncia
  .
  .
  .
}

// Logar
procedure LogarInt (st: Pointer); stdcall;
procedure LogarInt; external EPBX_INTEGRACAO name 'Logar';

// Deslogar
procedure DeslogarInt (); stdcall;
procedure DeslogarInt; external EPBX_INTEGRACAO name 'Deslogar';

// Alterar o intervalo
procedure AlterarIntervaloInt (id: Integer); cdecl;
procedure AlterarIntervaloInt; external EPBX_INTEGRACAO name 'AlterarIntervalo';

// Encerrar liga��o
procedure DesligarInt (); stdcall;
procedure DesligarInt; external EPBX_INTEGRACAO name 'Desligar';

// Efetuar liga��o
procedure DiscarInt (Numero: Pointer;  TipoDiscagem: Integer); cdecl;
procedure DiscarInt; external EPBX_INTEGRACAO name 'Discar';


{
  Assinatura dos M�todos de CallBack
}

type
TOnEventPointer = procedure(param: Pointer) stdcall;

{
  M�todos para registrar
  os m�todos de callback
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

// m�todo set callback Wrapper dll
TSetOnEventPointer  = procedure (_proc: TOnEventPointer) cdecl;

{
  Classe Atendimento

  Integra��o do CRM e a DLL
}
Atendimento = class

  private
    { Propriedades }
    HInstDll : THandle;

    { procedure e function }

  public

    IntervaloAtual : integer;

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

    { Eventos de callback Fim }

    destructor Destroy; override;

  published

    { Inicializa��o }
    constructor Create;

    function Inicia : Bool;
    procedure Finaliza;

    { M�todos para integra��o com a DLL }
    procedure Logar(ramal: Integer; senha: String);
    procedure Deslogar();
    procedure AlterarIntervalo(IdIntervalo: Integer);
    procedure Desligar();
    procedure Discar(Numero: PChar; TipoDiscagem: Integer);
end;

implementation

{
  -----------------------------------
  Implementa��o da Classe Atendimento
  -----------------------------------
}

{
  Inicializa��o e finaliza��o
}
constructor Atendimento.Create;
begin
  inherited;
  HInstDll              := 0;

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

end;

destructor Atendimento.Destroy;
begin
  Finaliza;
  inherited;
end;

{
  Inicia a classe Atendimento
  Carrega a dll em mem�ria
  Carrega os m�todos
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
  // para se comunicar com esta inst�ncia

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
      SetOnDesliga(@OnDisca);
  end;

  // SetOnDiscaErro
  if Assigned(OnDiscaErro) then
  begin
    SetOnDiscaErro := GetProcAddress(HInstDll, 'SetOnDiscaErro');
    if Assigned(SetOnDiscaErro) then
      SetOnDiscaErro(@OnDiscaErro);
  end;

end;

{
  Finaliza a classe Atendimento
}
procedure Atendimento.Finaliza;
begin
  if (HInstDll <> 0) then
    FreeLibrary(HInstDll);
end;

{
  M�todos para integra��o com a DLL
}

{
  Logon do ramal
}
procedure Atendimento.Logar(ramal: Integer; senha: String);
var
  ret       : Boolean;
  stL       : StLogar;
  _senha    : array [0..80] of char;
  _servidor : array [0..80] of char;
  strServidor : string;
begin

  // Inicia a classe atendimento
  ret := Inicia;
  if (ret = false)  then begin
    UGlobalAtendimento.Trace('Erro ao iniciar a classe atendimento');
    exit;
  end;

  if Assigned(@LogarInt) then begin

    // Pega as informa��es do ini
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
  end
  else
  begin
    UGlobalAtendimento.Trace('Erro ao carregar o m�todo Logar da ' + EPBX_INTEGRACAO);
  end;
end;

{
  Logoff do ramal
}
procedure Atendimento.Deslogar();
begin
  if Assigned(@DeslogarInt) then
    DeslogarInt;
end;

procedure Atendimento.AlterarIntervalo(IdIntervalo: Integer);
begin
  if Assigned(@AlterarIntervaloInt) then
    AlterarIntervaloInt(IdIntervalo);
end;

procedure Atendimento.Desligar();
begin
  if Assigned(@DesligarInt) then
    DesligarInt();
end;

procedure Atendimento.Discar(Numero: PChar;  TipoDiscagem: Integer);
begin
  if Assigned(@DiscarInt) then
    DiscarInt(Numero,  TipoDiscagem);
end;

end.


