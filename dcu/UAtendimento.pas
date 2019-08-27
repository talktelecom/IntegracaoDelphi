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

type PLogarInt = procedure (st: Pointer); {$IFDEF WIN32} stdcall; {$ENDIF}
var LogarInt: PLogarInt;

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

// assinatura TempoStatus
type PEvtTempoStatus = procedure(Tempo: Integer) of object;
var OnTempoStatus: PEvtTempoStatus;

// método de callback TempoStatus
type PEvtTempoStatusCallback = procedure(Tempo: Integer); cdecl;
var SetFuncSetOnTempoStatusInt: function(onTempoStatus: PEvtTempoStatusCallback): Integer; cdecl;

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
  -------------------------------------
  Implementação dos métodos de callback
  -------------------------------------
}

procedure OnTempoStatusInt(Tempo: Integer); cdecl;
begin
  if Assigned(OnTempoStatus) then
    OnTempoStatus(Tempo);
end;

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
  @SetFuncSetOnTempoStatusInt := GetProcAddress(HInstDll, 'SetOnTempoStatus');
  if Assigned(SetFuncSetOnTempoStatusInt) then
  begin
    SetFuncSetOnTempoStatusInt(@OnTempoStatusInt);
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
  stL : StLogar;
  _senha : array [0..80] of char;
  _servidor : array [0..80] of char;
begin
  if Assigned(@LogarInt) then begin
    ZeroMemory(@stL,SizeOf(StLogar));
    stL.Id := 0;
    stL.Porta := 44900;
    stL.IntervaloCustomizado := 1;
    stL.Ramal := ramal;
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

