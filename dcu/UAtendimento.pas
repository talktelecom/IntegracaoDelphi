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
procedure LogarInt; external 'EpbxIntegracao.dll' name 'Logar';

{
  Assinatura dos M�todos de CallBack
}

type

TOnEvent        = procedure() stdcall;
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
TSetOnEvent         = procedure () cdecl;
TSetOnEventPointer  = procedure (_proc: TOnEventPointer) cdecl;

// TSetOnLogado

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
    { Eventos de callback Inicio }

    OnRingVirtual         : TOnEvent;
    OnLogado              : TOnEventPointer;
    OnDeslogado           : TOnEventPointer;
    OnInfoIntervaloRamal  : TOnEventPointer;
    OnSetIntervaloRamal   : TOnEventPointer;
    OnTempoStatus         : TOnEventPointer;
    OnInfoCliente         : TOnEventPointer;
    OnChamada             : TOnEventPointer;
    OnAtendido            : TOnEventPointer;
    OnPathNomeDialogo     : TOnEventPointer;
    OnChamadaPerdida      : TOnEventPointer;
    OnDesliga             : TOnEventPointer;

    { Eventos de callback Fim }

    destructor Destroy; override;

  published
    { Inicializa��o }
    constructor Create;

    function Inicia : Bool;
    procedure Finaliza;

    { M�todos para integra��o com a DLL }
    procedure Logar(ramal: Integer; senha: String);

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

  OnRingVirtual         := nil;
  OnLogado              := nil;
  OnDeslogado           := nil;
  OnInfoIntervaloRamal  := nil;
  OnSetIntervaloRamal   := nil;
  OnTempoStatus         := nil;
  OnInfoCliente         := nil;
  OnChamada             := nil;
  OnAtendido            := nil;
  OnPathNomeDialogo     := nil;
  OnChamadaPerdida      := nil;
  OnDesliga             := nil;

  ShowMessage('Novo atendimento!');
end;

destructor Atendimento.Destroy;
begin
  Finaliza;
  ShowMessage('Destroy atendimento!');
  inherited;
end;

{
  Inicia a classe Atendimento
  Carrega a dll em mem�ria
  Carrega os m�todos
  Seta os eventos de callback
}
function Atendimento.Inicia;
var
  SetOnLogado       : TSetOnEventPointer;
  SetOnTempoStatus  : TSetOnEventPointer;
begin
  Result := true;

  // Carrega a dll
  HInstDll := LoadLibrary('EpbxIntegracao.dll');
  if (HInstDll = 0) then begin
    { TODO : Logar erro }
    Result := false;
    exit;
  end;

  // Seta os eventos da DLL
  // para se comunicar com esta inst�ncia
  SetOnLogado := GetProcAddress(HInstDll, 'SetOnLogado');
  if Assigned(SetOnLogado) and
    Assigned(OnLogado) then
      SetOnLogado(@OnLogado);

  // SetOnTempoStatus
  SetOnTempoStatus := GetProcAddress(HInstDll, 'SetOnTempoStatus');
  if Assigned(SetOnTempoStatus) and
    Assigned(OnTempoStatus) then
      SetOnTempoStatus(@OnTempoStatus);

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
procedure Atendimento.Logar(ramal: Integer; senha: String);
var
  ret       : Boolean;
  stL       : StLogar;
  _senha    : array [0..80] of char;
  _servidor : array [0..80] of char;
begin

  // Inicia a classe atendimento
  ret := Inicia;
  if (ret = false)  then begin
    { TODO : Logar erro }
    exit;
  end;

  if Assigned(@LogarInt) then begin
    ZeroMemory(@stL,SizeOf(StLogar));
    stL.Id := 0;
    stL.Porta := 44900;
    stL.IntervaloCustomizado := 1;
    stL.Ramal := ramal;
    stL.RamalVirtual := ramal;
    StrPCopy(_senha, senha);
    stL.Senha := @_senha;
    StrPCopy(_servidor, IP_SERVIDOR);
    stL.Servidor := @_servidor;
    LogarInt(@stL);
  end
  else
  begin
    { TODO : Logar erro }
  end;
end;

end.


