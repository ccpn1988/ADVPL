//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zExcel2DBF
Fun��o que converte arquivos do excel (*.xls*) em arquivos dBase (*.dbf), utilizando o LibreOffice para convers�o
@author Atilio
@since 10/10/2014
@version 1.0
	@param cOrigem,  Caracter, Arquivo origem do Excel que ser� convertido
	@param cDestino, Caracter, Caminho dentro da Protheus_Data que ficar� o .dbf
	@return lOk, Define se o arquivo dbf foi gerado
	@example
	lGerouDbf := u_zExcel2DBF("C:\arquivo.xlsx", "\especificos\")
	@obs
	Comandos Originais testados:
	soffice --convert-to dbf "E:\TOTVS11\Protheus_Data\especificos\arquivo.xlsx" --outdir "E:\TOTVS11\Protheus_Data\especificos" --invisible
	soffice --convert-to dbf "/home/atilio/arquivo.xlsx"                            --outdir "/home/atilio/Documents/"                --invisible
	
	Vale ressaltar, que para o devido funcionamento em ambientes Windows, voc� deve adicionar o caminho de execu��o do LibreOffice na Path do sistema.
	Ex.:
		Clique com o bot�o direito em Meu Computador > Propriedades > Configura��es Avan�adas do Sistema > Vari�veis de Ambiente
		Em vari�veis do sistema, ache a vari�vel Path, clique em editar, no fim da vari�vel, pressione ';', e coloque o caminho da instala��o
		como C:\Program Files (x86)\LibreOffice 3.5\program\
	Para testar, pelo MS-DOS (Prompt de Comando), execute:
	> soffice --help
/*/

User Function zExcel2DBF(cOrigem, cDestino)
	Local cComando	:= ""
	Local cArq			:= ""
	Local cCamFull	:= GetSrvProfString ("ROOTPATH","") + cDestino
	Local lOk			:= .f.
	Local cRaiz		:= ""

	//Se for servidores, linux / unix / bsd, a barra ser� normal (/) e a ra�z ser� '/'	
	If IsSrvUnix()
		cArq		:= SubStr(cOrigem,RAT("/",cOrigem)+1,Len(cOrigem))
		cCamFull	:= StrTran(cCamFull,"\","/")
		cRaiz		:= "/"
		
	//Se n�o (Windows), a barra ser� invertida (\) e a ra�z ser� 'C:\'
	Else
		cArq		:= SubStr(cOrigem,RAT("\",cOrigem)+1,Len(cOrigem))
		cCamFull	:= StrTran(cCamFull,"/","\")
		cRaiz		:= "C:\"
	EndIf
	
	//Gerando o comando de convers�o do LibreOffice, tamb�m � poss�vel utilizar o scalc
	cComando += 'soffice --convert-to dbf "'+cCamFull+cArq+'" --outdir "'+SubStr(cCamFull,1,Len(cCamFull)-1)+'" --invisible'
	
	//Copiando o arquivo da esta��o para o servidor
	CpyT2S(cOrigem, cDestino)
	
	//Gravando e Executando o comando no servidor, aguardando ele ser executado, passando a raiz como refer�ncia
	MemoWrite(cDestino+"comando.txt", cComando)
	lOk := WaitRunSrv(cComando, .T., cRaiz)
Return lOk

/*/{Protheus.doc} zTstConv
Testa a convers�o de arquivos xls e monta uma tabela tempor�ria para manipula��o
@author Atilio
@since 10/10/2014
@version 1.0
	@example
	u_zTstConv()
/*/

User Function zTstConv()
	Local aArea		:= GetArea()
	Local cTabTmp		:= 'TMP'
	Local cArqXLS		:= 'C:\TOTVS\arquivo.xlsx'
	Local cArqDBF		:= ''
	Local cDirSrv		:= '\especificos\'
	Local nLinha		:= 1
	Local lGerou		:= .F.
	
	//Se n�o existir o diret�rio, cria
	If !ExistDir(cDirSrv)
		MakeDir(cDirSrv)
	EndIf
	
	//Pegando o nome arquivo dbf, tirando o caminho absoluto e a extens�o
	cArqDBF := SubStr(cArqXLS, RAt('\', cArqXLS)+1, Len(cArqXLS))
	cArqDBF := SubStr(cArqDBF, 1, At('.',cArqDBF))
	cArqDBF += "dbf"
	
	//Convertendo de xls para dbf
	lGerou := u_zExcel2DBF(cArqXLS, cDirSrv)

	//Se o dbf estiver gerado
	If lGerou
		//Usando o dbf como tabela tempor�ria
		dbUseArea(.T., "DBFCDXADS", cDirSrv+cArqDBF, cTabTmp, .T., .F.)
		(cTabTmp)->(DbGoTop())
		
		//Enquanto tiver registros na tabela tempor�ria
		While !((cTabTmp)->(EoF()))
			nLinha++
			(cTabTmp)->(DbSkip())
		EndDo
		(cTabTmp)->(DbCloseArea())
	EndIf
	
	RestArea(aArea)
Return