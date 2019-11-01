# Integração CRM e CTIServer

Projeto em Delphi que exemplifica como utilizar a biblioteca de integração do CRM e o CTIServer.

Ferramentas de desenvolvimento utilizada neste projeto:

	Borland Delphi Professional
	Versão 5.0 
	Build 6.18
	Service Pack 1

# Ambiente de desenvolvimento

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

5) Executar o arquivo vc_redist.x86.exe ou vc_redist.x64.exe para instalação das demais dependencies.

6) Cria o arquivo de configuração atendimento.ini no diretório IntegracaoDelphi\bin.

7) Copiar as seguintes configurações no arquivo atendimento.ini, após isto editar os valores.

	[config]

	# Endereço ip do CTI
	servidor=xxx.xxx.xxx.xxx 
	
	# Ramal a ser utilizado no logon
	ramal=1000
	
	# senha do logon
	senha=1234

8) Abrir o projeto (Atendimento.dpr) na IDE do Delphi que se encontra no diretório \IntegracaoDelphi\dpr.

	* Lembrando que os fontes do projeto ficam no diretório IntegracaoDelphi\dcu

9) Na IDE do Delphi, vá no menu Project->Options e na Aba Directories/Conditionais, verificar se:

	Output directory: ..\bin
	Unit output directory: ..\dcu
	
10) Compilar o projeto Ctrl + F9.

# Estrutura do Projeto



















# Utilizando o CRM 

1) Realizar o logon através do botão "Logar"

	* Para realizar o logon na aplicação, é obrigatório ter softPhone ou telefoneIp para o ramal a ser logado.
	
	

	
	


	
	
	
	






	









# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
TODO: Describe and show how to build your code and run the tests. 

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://www.visualstudio.com/en-us/docs/git/create-a-readme). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)