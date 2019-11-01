# 1 - Integração CRM e CTIServer

Projeto em Delphi que exemplifica como utilizar a biblioteca de integração do CRM e o CTIServer.

Ferramentas de desenvolvimento utilizada neste projeto:

	Borland Delphi Professional
	Versão 5.0 
	Build 6.18
	Service Pack 1

# 2 - Ambiente de desenvolvimento

1) Após baixar o projeto do git (https://github.com/talktelecom/IntegracaoDelphi.git), teremos os seguintes diretórios no root (IntegracaoDelphi)

	- IntegracaoDelphi\dcu , neste diretório fica o código fonte do projeto
	- IntegracaoDelphi\dpr , neste diretório fica o projeto do Delphi
	
2) No root (IntegracaoDelphi) criar o diretório bin.

	- IntegracaoDelphi\bin
	
3) Baixar os binários que está disponível no git (https://github.com/talktelecom/IntegracaoBinarios.git). Teremos a seguinte
estrutura de diretórios

	- IntegracaoBinarios\MSVC2017_32bit - Para SO 32 bits
	- IntegracaoBinarios\MSVC2017_64bit - Para SO 64 bits
	
4) Copiar todos o conteudo dos diretórios de acordo com o sistema operacional onde o CRM será utilizado para a pasta IntegracaoDelphi\bin.

5) Copiar o arquivo de configuração atendimento.ini root (IntegracaoDelphi) para diretório IntegracaoDelphi\bin.

6) Editar as configurações do atendimento.ini de acordo com as informações dada pelo suporte epbx.

	[config]

	// Endereço ip do CTI
	servidor=xxx.xxx.xxx.xxx 
	
	* Ramal a ser utilizado no logon
	ramal=1000
	
	* senha do logon
	senha=1234


7) Executar o arquivo vc_redist.x86.exe ou vc_redist.x64.exe para instalação das demais dependencies.

8) Abrir o projeto (Atendimento.dpr) na IDE do Delphi que se encontra no diretório \IntegracaoDelphi\dpr.

	* Lembrando que os fontes do projeto ficam no diretório IntegracaoDelphi\dcu

9) Na IDE do Delphi, vá no menu Project->Options e na Aba Directories/Conditionais, verificar se:

	Output directory: ..\bin
	Unit output directory: ..\dcu
	
10) Compilar o projeto Ctrl + F9.

# 3 - Biblioteca de integração

1) A biblioteca principal de integração é a 'EpbxIntegracao.dll'

	* vide Ambiente de desenvolvimento item 3)
	
	
# 4 - Referência aos métodos da biblioteca 'EpbxIntegracao.dll'

	* vide README.md do git (https://github.com/talktelecom/IntegracaoBinarios.git).

# 5 - Estrutura do Projeto

	O projeto está dividido em 4 units citadas abaixo:
	
	- UGlobalAtendimento
	- UThLogar
	- UAtendimento
	- UMain

	# 5.1 - unit UGlobalAtendimento;
	
		Nesta unit temos a declaração das variáveis, procedures, functions e etc
		a serem utilizados no escopo do projeto, ou seja, que será visível a todas
		as units.
		
	# 5.2 - unit UThLogar;
	
		Nesta unit temos a classe ThLogar que será responsável em realizar o logon
		do ramal e prpocessar os eventos do S.O na biblioteca EpbxIntegracao.dll.
		
		* o método Logar(ramal: Integer; senha: String) somente retornará quando 
		* a aplicação for finalizada ou em caso de logoff do ramal.
		
		O construtor da classe recebe os seguintes parâmetros
		
			- CreateSuspended : boolean , 	false = a thread é iniciada imediatamente 
											true a thread fica suspensa até que o método
											Start seja chamado.
											
			- 
		
		
	# 5.3 - unit UAtendimento
		
		Nesta unit temos a classe Atendimento a qual implementa as ações e eventos
		para realizar a integração com o CTIServer através da dll "EpbxIntegracao.dll" e
		esta classe será utilizada neste projeto pela unit UMain.
		A sua principal finalidade é encapsular o acesso dos métodos da dll
		para a unit UMain

		# 5.3.1 - Declaração das referência aos métodos;
		
			Declaramos as procedures para acessar os métodos da dll no inicio da unit.
			A demarcação do inicio das definições é:
			
			*{
			*	Métodos da Dll
			*
			*	Aqui temos a declaração das referência as ações do Atendimento.
			*
			*	- Logar
			*	- Deslogar
			*	- Ligações
			*	- Intervalos
			*	- Conferência
			*	.
			*	.
			*	.
			*}
			
			* Exemplo da declaração da referência ao método logar da dll
			
			// Logar
			procedure LogarInt (st: Pointer); stdcall;
			procedure LogarInt; external EPBX_INTEGRACAO name 'Logar';
			
			* Onde a variável EPBX_INTEGRACAO é uma constante declarada na unit UGlobalAtendimento

		# 5.3.2 - Assinatura dos Métodos de CallBack
		
			Usamos a seguinte assinatura para fazer referência
			as procedures que deve ser acionadas pela dll caso o evento
			ocorra.
			
			* {
			* Assinatura dos Métodos de CallBack
			* }

			* Variavel do tipo type
			TOnEventPointer = procedure(param: Pointer) stdcall;

		# 5.3.3 - Assinatura para registrar os evento de callback na dll
		
			Usamos a seguinte assinatura da procedure para registrar as 
			procedures que irão tratar os eventos de callback da dll
			
			* {
			* Assinatura para registrar os evento de callback na dll
			*
			* - SetOnLogado
			* - SetOnDeslogado
			* - SetOnInfoIntervaloRamal
			* - SetOnTempoStatus
			* - SetOnChamada
			* - SetOnAtendido
			* - SetOnDesliga
			* .
			* .
			* .
			* }

			* Variavel do tipo type
			TSetOnEventPointer  = procedure (_proc: TOnEventPointer) cdecl;
			
		# 5.3.4 - Classe atendimento
		
			# 5.3.4.1 - Propriedades
			
				* private
				* Referência a dll obtido através da api LoadLibrary()
				HInstDll : THandle
				
				* public
				
				* Intervalo atual do ramal
				IntervaloAtual    : integer
				
				* Indica sucesso no retorno da ação
				StRetornoSucesso  : integer
				
				* Indica erro no retorno da ação
				StRetornoErro     : integer
				
				* Referência acessar os métodos da dll para atribuir as procedures de callback.
				SetProcedureCallback    : TSetOnEventPointer
				
				* Eventos de callback do type TOnEventPointer
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
				OnDisca               : TOnEventPointer;
				OnDiscaErro           : TOnEventPointer;
				OnInicioEspera        : TOnEventPointer;
				OnTerminoEspera       : TOnEventPointer;
				OnConsulta            : TOnEventPointer;
				OnLiberarConsulta     : TOnEventPointer;
				OnChamadaTransferida  : TOnEventPointer;
				OnConsultaChamada     : TOnEventPointer;
				OnConsultaAtendido    : TOnEventPointer;
				
			# 5.3.4.2 - Métodos
			
				* Construtor, chamado de forma implicita ao criar
				* a instancia da classe atendimento, neste método
				* ocorre a inicialização de algumas propriedades
				* EVITE DE REALIZAR INICIALIZAÇÕES QUE POSSUI
				* DELAY ALTO PARA INICIALIZAR. SE FOR PECISO,
				* UTILIZE O MÉTODO Inicia
				constructor Create
				
				* Carrega a instancia da classe com a dll
				* e seta os eventos de callback com as
				* procedures dadas pelas propriedades
				* do type TOnEventPointer, exemplo [OnLogado]
				function Inicia : Bool;
				
				* Finaliza a classe atendimento deslogando
				* o ramal e saindo do loop de eventos do SO na dll
				procedure Finaliza;
				
				* function para integraçào com a DLL
				* estas function devem utilizar as
				* referência as ações do Atendimento
				* vide item # 5.3.1
				
				function Logar(ramal: Integer; senha: String): bool;
				function AlterarIntervaloTipo(IdIntervalo: Integer): bool;
				function Discar(Numero: PChar; TipoDiscagem: Integer): bool;
				function Consultar(Numero: PChar; TipoDiscagem: Integer): bool;
				function Transferir(Numero : PChar = nil; TipoDiscagem : Integer = 0): bool;

				function Deslogar(): bool;
				function Desligar(): bool;
				function IniciarEspera(): bool;
				function TerminarEspera(): bool;
				function LiberarConsulta() : bool;
				
	# 5.4 - unit UMain;

		Nesta unit iremos implementar o CRM que irá servir de exemplo
		para criar os CRMs de forma customizada.
		
		O inicio da aplicação ocorre com o logon do ramal,
		após esta ação o ramal está pronto para realizar as
		ações junto ao CTIServer.
		
		procedure Logar(ramal : Integer; senha : String);
		
		Este método e chamado no evento onclick do botão Logar
		e utilizamos a procedure
		
		TFormMain.Logar(ramal : Integer; senha : String);
		
		Esta procedure utilizamos a unit UThLogar
		* vide item # 5.2 - unit UThLogar;
		
		As demais ações utilizaremos as function
		para integrar com o CTIServer
		* vide item # 5.3 - unit UAtendimento
