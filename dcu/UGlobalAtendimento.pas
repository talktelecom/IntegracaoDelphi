unit UGlobalAtendimento;

interface

{ Struct de comunicação com a DLL }
type

// Logon
PStLogar = ^StLogar;
StLogar = record
    IntervaloCustomizado    : Integer;
    Id                      : Integer;
    Ramal                   : Integer;
    RamalVirtual            : Integer;
    Porta                   : Integer;
    IpOrigem                : PChar;
    Departamento            : PChar;
    Senha                   : PChar;
    Servidor                : PChar;
end;

PStLogado = ^StLogado;
StLogado = record
  Status                    : Integer;
  QuantidadeRecados         : Integer;
  QuantidadeDialogos        : Integer;
  Volume                    : Integer;
  InterValoExterno          : Integer;
  PodeUsarConferencia       : Integer;
  RecuperarTodosDialogos    : Integer;
  PodeUsarFax               : Integer;
  PodeUsarTalkMessager      : Integer;
  ApagarDialogo             : Integer;
  CategoriaMessager         : Integer;
  UsaRotaMenosUm            : Integer;
  CategoriasDiscagem        : Integer;
  SeGravaConstante          : Integer;
  QuantidadeFaxes           : Integer;
  Maquina                   : Integer;
  PodeUsarInterValoExterno  : Integer;
  InterValoGrupo            : Integer;
  PodeUsarInterValoGrupo    : Integer;
  RotaDefault               : Integer;
  PodeAcessarVoiceMail      : Integer;
  UsaCentroCusto            : Integer;
  ValorCentroCusto          : Integer;
  CategoriaCentroCusto      : Integer;
  InterValoDialer           : Integer;
  Mensagem                  : PChar;
  NomeUsuario               : PChar;
  NumeroSigaMe              : PChar;
  RotasDiscagem             : PChar;
  IdRamal                   : PChar;

end;


{ Constantes }
const

{ Versão deste projeto }
VERSAO            = '2.0.4';

TAM_IP_ORIGEM     = 80;
TAM_DEPARTAMENTO  = 80;
TAM_SENHA         = 30;
TAM_IP_SERVIDOR   = 80;

// Do arquivo de configuração / banco de dados
IP_SERVIDOR       = '192.168.21.58';

implementation

end.

