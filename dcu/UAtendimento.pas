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

type PLogarInt = procedure (st: Pointer); {$IFDEF WIN32} stdcall; {$ENDIF}
var LogarInt: PLogarInt;

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

// assinatura TempoStatus
type PEvtTempoStatus = procedure(Tempo: Integer) of object;
var OnTempoStatus: PEvtTempoStatus;

// m�todo de callback TempoStatus
type PEvtTempoStatusCallback = procedure(Tempo: Integer); cdecl;
var SetFuncSetOnTempoStatusInt: function(onTempoStatus: PEvtTempoStatusCallback): Integer; cdecl;

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
  -------------------------------------
  Implementa��o dos m�todos de callback
  -------------------------------------
}

procedure OnTempoStatusInt(Tempo: Integer); cdecl;
begin
  if Assigned(OnTempoStatus) then
    OnTempoStatus(Tempo);
end;

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
  @SetFuncSetOnTempoStatusInt := GetProcAddress(HInstDll, 'SetOnTempoStatus');
  if Assigned(SetFuncSetOnTempoStatusInt) then
  begin
    SetFuncSetOnTempoStatusInt(@OnTempoStatusInt);
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

