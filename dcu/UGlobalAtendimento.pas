unit UGlobalAtendimento;

interface

{ Struct de comunicação com a DLL }
type

{
  record para realizar o Logon

  Esta estrutura de dados será
  utilizada para enviar as
  informações do logo para o CTI

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string
}
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

{
  record resposta do logon

  Os dados do logon será dado
  por esta estrutura.

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string

}
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
  Mensagem                  : Array[0..255] of Char;
  NomeUsuario               : Array[0..99] of Char;
  NumeroSigaMe              : Array[0..29] of Char;
  RotasDiscagem             : Array[0..99] of Char;
  IdRamal                   : Array[0..19] of Char;
end;
{
  Valores possíveis para a propriedade
  Status de StLogado

  Erro = -1,
  Sucesso = 2,
  IdEmUso = 3,
  RamalInvalido = 4,
  RamalEmUso = 5,
  SenhaInvalida = 6,
  ParametroInvalido = 7,
  RamalNaoCadastrado = 8,
  /// <summary>
  /// Ocorre quando o softphone ou telefone sip está desconectado
  /// </summary>
  ContaSipNaoLogadaNoTelefone = 9,
  SemRecursoVozDisponivel = 10,
  ForaDaJornadaTrabalho = 11,
  NotDocumented = 12,
  ErroSistema = 13,
  /// <summary>
  /// Quando o arquivo com o intervalo é inválido
  /// </summary>
  IntervaloInvalido = 14,
  ParametrosIncompletos = 15,
  RamalGrupoInvalido = 16,
  StatusGrupoInvalido = 17
}

{
  record intervalos do ramal

  Intervalos permitidos para
  o ramal

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string
}
PStInfoIntervaloRamal = ^StInfoIntervaloRamal;
StInfoIntervaloRamal = record
  RamalStatusDetalheId      : Integer;
  Produtivo                 : Integer;
  Descricao                 : Array[0..99] of Char;
end;

{
  record intervalo atual do ramal

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string
}
StSetIntervaloRamal = record
  Status                  : Integer;
  RamalStatusDetalheId    : Integer;
  Mensagem                : Array[0..255] of Char;
end;
{
  Valores possíveis para a propriedade
  Status de StSetIntervaloRamal

  OperacaoNaoSuportada = -14,
  AguardandoResposta = -13,
  ParametroLongo = -12,
  SocketClosed = -11,
  StatusInalterado = -10,
  AcaoRamalNaoPermitida = -9,
  RamalNaoLogado = -8,
  RamalInvalido = -7,
  GrupoInvalido = -6,
  RamalGrupoInvalido = -5,
  DescricaoIntevaloVazio = -4,
  RamalStatusDetalheIdInvalido = -3,
  ParametroInvalido = -2,
  ErroSistema = -1,
  Sucesso = 0,
  Pendente = 1
}

{
  record que representa uma chamada

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string
}
StChamada = record
  { Desconhecida = 0, ChamadaRealizada = 1, ChamadaRecebida = 2 }
  Direcao                 : Integer;
  { Desconhecido = 0, LigacaoExterna = 1, LigacaoRamal = 2,
    LigacaoRamalPabx = 3, LigacaoAtiva = 4, RamalSendoConsultado = 5,
    DiscagemAtendeuRamalConsultando = 5}
  TipoChamada             : Integer;
  CodigoCampanha          : Integer;
  CanalPa                 : Array[0..19] of Char;
  Telefone                : Array[0..29] of Char;
  Servico                 : Array[0..29] of Char;
  NomeRamal               : Array[0..99] of Char;
  GlobalId                : Array[0..63] of Char;
  CodigoCliente           : Array[0..63] of Char;
  NomeCliente             : Array[0..255] of Char;
  InfoAdicional1          : Array[0..1023] of Char;
  InfoAdicional2          : Array[0..1023] of Char;
  InfoAdicional3          : Array[0..1023] of Char;
  InfoAdicional4          : Array[0..1023] of Char;
  InfoAdicional5          : Array[0..1023] of Char;
end;

{ Constantes }
const

{ Versão deste projeto }
VERSAO            = '2.0.5';

TAM_IP_ORIGEM     = 80;
TAM_DEPARTAMENTO  = 80;
TAM_SENHA         = 30;
TAM_IP_SERVIDOR   = 80;

// Do arquivo de configuração / banco de dados
IP_SERVIDOR       = '192.168.21.55';

implementation

end.

