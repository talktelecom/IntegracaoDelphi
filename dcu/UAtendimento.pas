unit UAtendimento;

interface

uses Windows, SysUtils, UGlobalAtendimento, Dialogs;

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

type TLogarInt = procedure (st: Pointer); {$IFDEF WIN32} stdcall; {$ENDIF}
var LogarInt: TLogarInt;

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

type TOnTempoStatus = procedure(Tempo: Integer) of object;

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

// m�todo set callback TempoStatus Wrapper dll
var SetOnTempoStatus: procedure (onTempoStatus: TOnTempoStatus); cdecl;

{
  Classe Atendimento

  Integra��o do CRM e a DLL
}
type
  Atendimento = class
    private
      { Propriedades }
      HInstDll : THandle;

      { procedure e function }

    public

      { Eventos de callback }
      OnTempoStatus: TOnTempoStatus;

      { Inicializa��o }
      constructor Create; overload;
      function Inicia : Bool;
      procedure Finaliza;

      { Eventos de callback }

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
  // Execute the parent (TObject) constructor first
  inherited;  // Call the parent Create method
  HInstDll := 0;
  OnTempoStatus := nil;
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
  HInstDll := LoadLibrary('EpbxIntegracao.dll');
  if (HInstDll = 0) then begin
    { TODO : Logar erro }
    Result := false;
    exit;
  end;

  // Seta os eventos da DLL
  // para se comunicar com esta inst�ncia

  // SetOnTempoStatus
  @SetOnTempoStatus := GetProcAddress(HInstDll, 'SetOnTempoStatus');
  if Assigned(SetOnTempoStatus) and
      Assigned(OnTempoStatus) then
  begin
    SetOnTempoStatus(OnTempoStatus);
  end;

  // Carrega todos os m�todos
  // utilizados aqui

  // Logar
  LogarInt := GetProcAddress(HInstDll, 'Logar');
  if Assigned(@LogarInt) = false then begin
    { TODO : Logar erro }
    Result := false;
    exit;
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
procedure Atendimento.Logar(ramal: Integer; senha: String);
var
  ret : Boolean;
  stL : StLogar;
  _senha : array [0..80] of char;
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

