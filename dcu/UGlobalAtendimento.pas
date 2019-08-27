unit UGlobalAtendimento;

interface

{ Struct de comunica��o com a DLL }
type StLogar = record
    IntervaloCustomizado: Integer;
    Id: Integer;
    Ramal: Integer;
    RamalVirtual: Integer;
    Porta: Integer;
    IpOrigem: PChar;
    Departamento: PChar;
    Senha: PChar;
    Servidor: PChar;
end;

{ Constantes }
const

{ Vers�o deste projeto }
VERSAO  = '2.0.1';

TAM_IP_ORIGEM = 80;
TAM_DEPARTAMENTO = 80;
TAM_SENHA = 30;
TAM_IP_SERVIDOR = 80;

// Do arquivo de configura��o / banco de dados
IP_SERVIDOR = '192.168.21.58';

implementation

end.

