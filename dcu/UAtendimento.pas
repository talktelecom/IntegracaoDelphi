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
Function ServidorIp() : String;

// Logar
procedure LogarInt (st: Pointer); stdcall;
procedure LogarInt; external 'EpbxIntegracao.dll' name 'Logar';

// Deslogar
procedure DeslogarInt (); stdcall;
procedure DeslogarInt; external 'EpbxIntegracao.dll' name 'Deslogar';

// Alterar o intervalo
procedure AlterarIntervaloInt (id: Integer); cdecl;
procedure AlterarIntervaloInt; external 'EpbxIntegracao.dll' name 'AlterarIntervalo';

// Encerrar ligação
procedure DesligarInt (); stdcall;
procedure DesligarInt; external 'EpbxIntegracao.dll' name 'Desligar';

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

    { Eventos de callback Fim }

    destructor Destroy; override;

  published
    { Inicialização }
    constructor Create;

    function Inicia : Bool;
    procedure Finaliza;

    { Métodos para integraçào com a DLL }
    procedure Logar(ramal: Integer; senha: String);
    procedure Deslogar();
    procedure AlterarIntervalo(IdIntervalo: Integer);
    procedure Desligar();

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
{var
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
  SetOnDesliga            : TSetOnEventPointer;}
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

{
  Logon do ramal
}
procedure Atendimento.Logar(ramal: Integer; senha: String);
var
  ret       : Boolean;
  stL       : StLogar;
  _senha    : array [0..80] of char;
  _servidor : array [0..80] of char;
  Retorno   : string;
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
    Retorno := ServidorIp;
    StrPCopy(_servidor, Retorno);
    stL.Servidor := @_servidor;
    LogarInt(@stL);

  end
  else
  begin
    { TODO : Logar erro }
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

Function ServidorIp : String;
var   arq: TextFile; { declarando a variável "arq" do tipo arquivo texto }
      nreg: Integer;
      i: Integer;
      ipremoto: string;
      linha: string;
      opcao : integer;

begin
  try
    AssignFile(arq, '..\dcu\Config.ini');

    {$I-}
    Reset(arq);
    {$I+}
    nreg := 0;

    while not Eof(arq) do { enquanto não atingir a marca de final de arquivo }
    begin
      Readln(arq, linha); { lê uma linha, com os dados de um aluno, do arquivo }

      nreg := nreg + 1;

      i := pos('=', linha);
      ipremoto := Trim(copy(linha,i + 1,20)); { recupera o nome do aluno }

    end;

    CloseFile(arq);
    result := ipremoto;

    except
      CloseFile(arq);
      result := '';
    end;
  end;


end.


