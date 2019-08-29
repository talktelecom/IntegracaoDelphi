unit UAtendimento;

interface

uses Windows, SysUtils, UGlobalAtendimento, Dialogs;

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

type TLogarInt = procedure (st: Pointer); {$IFDEF WIN32} stdcall; {$ENDIF}
var LogarInt: TLogarInt;

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

type TOnTempoStatus = procedure(Tempo: Integer) of object;

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

// método set callback TempoStatus Wrapper dll
var SetOnTempoStatus: procedure (onTempoStatus: TOnTempoStatus); cdecl;

{
  Classe Atendimento

  Integração do CRM e a DLL
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

      { Inicialização }
      constructor Create; overload;
      function Inicia : Bool;
      procedure Finaliza;

      { Eventos de callback }

      { Métodos para integraçào com a DLL }
      procedure Logar(ramal: Integer; senha: String);

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
  // Execute the parent (TObject) constructor first
  inherited;  // Call the parent Create method
  HInstDll := 0;
  OnTempoStatus := nil;
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
  HInstDll := LoadLibrary('EpbxIntegracao.dll');
  if (HInstDll = 0) then begin
    { TODO : Logar erro }
    Result := false;
    exit;
  end;

  // Seta os eventos da DLL
  // para se comunicar com esta instância

  // SetOnTempoStatus
  @SetOnTempoStatus := GetProcAddress(HInstDll, 'SetOnTempoStatus');
  if Assigned(SetOnTempoStatus) and
      Assigned(OnTempoStatus) then
  begin
    SetOnTempoStatus(OnTempoStatus);
  end;

  // Carrega todos os métodos
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
  Métodos para integraçào com a DLL
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

