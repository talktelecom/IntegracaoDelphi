unit UAtendimento;

interface

uses Windows, SysUtils, UGlobalAtendimento, Dialogs;

type
  Atendimento = class
    private
      { declarar váriaveis aqui }
      { procedure e function }
    public
      { declarar váriaveis aqui }
      { procedure e function }
      constructor Create; overload;
      procedure Logar(ramal: Integer; senha: String);
  end;

implementation

constructor Atendimento.Create;
begin
  // Execute the parent (TObject) constructor first
  inherited;  // Call the parent Create method
end;

{ Realiza o logon }
procedure Atendimento.Logar(ramal: Integer; senha: String);
var
  hmod : THandle;
  stL : StLogar;
  _senha : array [0..80] of char;
  _servidor : array [0..80] of char;
  logar : procedure (st: Pointer); {$IFDEF WIN32} stdcall; {$ENDIF}
begin
  hmod := LoadLibrary('EpbxIntegracao.dll');
  if (hmod <> 0) then begin

    // Seta os eventos da DLL
    // para se comunicar com esta instância
    //SetEventos(hmod);

    // Carrega Todos os métodos da dll
    //CarregarMetodos(hmod);

    // e realiza o logon do ramal
    logar := GetProcAddress(hmod, 'Logar');
    if (@Logar <> nil) then begin

    ZeroMemory(@stL,SizeOf(StLogar));
    stL.Id := 0;
    stL.Porta := 44900;
    stL.IntervaloCustomizado := 1;
    stL.Ramal := ramal;
    StrPCopy(_senha, senha);
    stL.Senha := @_senha;
    StrPCopy(_servidor, IP_SERVIDOR);
    stL.Servidor := @_servidor;

    logar(@stL);
  end
  else
    ShowMessage('GetProcAddress Logar failed');
    FreeLibrary(hmod);
  end
  else
  begin
    ShowMessage('LoadLibrary Failed! - Error Code' + IntToStr(getlasterror));
  end;
end;

end.

