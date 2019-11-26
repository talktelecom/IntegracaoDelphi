unit UGlobalAtendimento;

interface

uses  Windows,
      SysUtils;

{ procedures de uso global }

// inicia variáveis e etc.
procedure IniciaApp;

// trace no file
procedure Trace(const str: string);

{ function de uso global }

// Le as configurações do ini dado
function LeConfigIni(
  const section,
  key,
  fileName: string;
  size : Integer): string;

{ Struct de comunicação com a DLL }
type
{
  Dados para realizar o Logon

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
  Resposta do logon

  Os dados do logon será dado
  por esta estrutura.

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string

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
  Resposta do logoff / quebra de conexão

  Os dados do logoff será dado
  por esta estrutura.

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string
}

StDeslogado = record
  Status                  : Integer;
  Mensagem                : Array[0..255] of Char;
end;

{
  Intervalos do ramal

  Intervalos permitidos para
  o ramal

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string
}
StInfoIntervaloRamal = record
  RamalStatusDetalheId      : Integer;
  Produtivo                 : Integer;
  Descricao                 : Array[0..99] of Char;
end;

{
  Intervalo atual do ramal

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string

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
StSetIntervaloRamal = record
  Status                  : Integer;
  RamalStatusDetalheId    : Integer;
  Mensagem                : Array[0..255] of Char;
end;

{
  Representa uma chamada

  Direcao :

    Desconhecida = 0
    ChamadaRealizada = 1
    ChamadaRecebida = 2

  TipoChamada :

    Desconhecido = 0
    LigacaoExterna = 1
    LigacaoRamal = 2
    LigacaoRamalPabx = 3
    LigacaoAtiva = 4
    RamalSendoConsultado = 5
    DiscagemAtendeuRamalConsultando = 5

  PS.: Consultar a DDL Referente
  ao tamanho dos dados string
}
StChamada = record
  Direcao                 : Integer;
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

{
  Status de retornos genéricos

  Valores possíveis para a propriedade
  Status

  StRetornoSucesso = 2
  StRetornoErro = 3
  
  PS.: Consultar a DDL Referente
  ao tamanho dos dados string
}
StRetorno = record
  Status                  : Integer;
  Mensagem                : Array[0..255] of Char;
end;

{
  Informações dos ramais

  Tipo :

    RamalGrupo = 0
    Ramal = 1
    RamalFax = 2
    RamalUra = 3
    RamalPabx = 4

  StatusRamal :

    Livre = 0
    Ocupado = 1    
}
StRamal = record
  Tipo                  : Integer;
  Pa                    : Integer;
  Ramal                 : Integer;
  StatusRamal           : Integer;
  RamaisLogados         : Integer;
  Rota                  : Integer;
  Nome                  : Array[0..99] of Char;
  Departamento          : Array[0..79] of Char;
  RamalTransferir       : Array[0..19] of Char;
end;

var
  // Diretório do exe
  strDirExe   : string;

{ Constantes }
const

{ Versão deste projeto }
VERSAO            = '2.0.11';

{ nome da dll de integracao }
EPBX_INTEGRACAO   = 'EpbxIntegracao.dll';

{ Diretorio do log a partir do diretorio root da aplicação }
DIR_LOG           = 'Log';

{ Nome do arquivo de log }
AQUIVO_LOG        = 'Atendimento.log';

{ configuraçào da aplicação }
COFIG_INI         = 'Atendimento.ini';

{ Tamanho máximo do arquivo de log }
MAX_TAM_LOG       = 10000000;

{ StSetIntervaloRamal Status }
IntervaloSucesso  = 0;
IntervaloPendente = 1;

implementation

{ procedures de uso global }

procedure IniciaApp;
begin
  strDirExe := GetCurrentDir();
end;

// Trace no arquivo TalkIntegracao.log
procedure Trace(const str: string);
var
  handleFile : TextFile;
  today : TDateTime;
  dirExe,
  fullFileName,
  fileLog,
  fileBac,
  dataTime : string;
begin
  today := Now;
  dirExe := GetCurrentDir;
  dataTime := Format('%s %s ',[DateToStr(today), TimeToStr(today)]);
  fullFileName := Format('%s\%s\%s', [dirExe, DIR_LOG ,AQUIVO_LOG]);

  AssignFile(handleFile, fullFileName);
  if(FileExists(fullFileName)) then
    Append(handleFile)
  else
    ReWrite(handleFile);

  if(FileSize(handleFile) > MAX_TAM_LOG) then
  begin
    fileBac := Format('%s\%s\_%s', [dirExe, DIR_LOG, AQUIVO_LOG]);
    fileLog := Format('%s\%s\%s', [dirExe, DIR_LOG, AQUIVO_LOG]);
    CloseFile(handleFile);
    if RenameFile(fileLog, fileBac) = false then
    begin
      exit;
    end;
    AssignFile(handleFile, fullFileName);
    if(FileExists(fullFileName)) then
      Append(handleFile)
    else
      ReWrite(handleFile);
  end;
  WriteLn(handleFile, dataTime + str);
  CloseFile(handleFile);
end;

{ function de uso global }

// Le as configurações do ini dado
function LeConfigIni(const section, key, fileName: string; size : Integer): string;
var
  _section    : array [0..80] of char;
  _key        : array [0..80] of char;
  _fileName   : array [0..255] of char;
  _rtBuffer   : array [0..255] of char;
  _default    : array [0..1] of char;
Begin
  try

    StrPCopy(_section, section);
    StrPCopy(_key, key);
    StrPCopy(_fileName, fileName);
    StrPCopy(_default, '*');

    GetPrivateProfileString(
      _section,
      _key,
      _default,
      _rtBuffer,
      size,
      _fileName);
    Result := _rtBuffer;
  except
    on E : Exception do
      Trace(E.ClassName + ' error raised, with message : ' + E.Message);
  end;
End;

end.

