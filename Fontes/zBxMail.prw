/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2020/07/24/baixando-anexos-de-e-mail-via-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"
#Include "RWMake.ch"
#Include "Ap5Mail.ch"

Static nVez := 2 //Se for caixas no hotmail.com / outlook.com, deve-se rodar a rotina duas vezes seguidas, pois ele n�o consegue "mover" de pasta na primeira vez

/*/{Protheus.doc} zBxMail
Fun��o para buscar anexos de e-Mails da Locaweb / Uol
@author Atilio
@since 27/09/2018
@version 1.0
@type function
@obs Abaixo algumas observacoes:

	1 - Essa funcao utiliza a classe tMailManager com contas IMAP, mas tambem e possivel utilizar com POP
	2 - Se for uma conta em hotmail.com / outlook.com, deve-se rodar a rotina duas vezes seguidas, pois ele n�o consegue "mover" de pasta na primeira vez
		Portanto, se estiver usando dessa forma, altere a variavel nVez para 1, para que assim ele execute "2 vezes"
	3 - Essa rotina baixa emails para a pasta \x_importacao\ dentro da Protheus Data, porem voce pode configurar para outros diretorios, dentro da Protheus Data
	4 - O download e feito a partir da linha 184, onde nesse exemplo e efetuado download de qualquer txt vindo por email, mas e possivel aplicar outros filtros
		com os atributos do objeto oMessage
/*/

User Function zBxMail()
	Local cArqSem     := "\x_importacao\semaforo_email.lck"
	Private lJobPvt   := .F.

	If nVez <= 2
		//Alert("[zBxMail] Processo iniciado - "+Time())
	
		//Se n�o tiver aberto o dicion�rio (rotina executada sem abrir o Protheus)
		If Select("SX2") <= 0
			RPCClearEnv()
			 
			RPCSetEnv("01","","","","","")
			lJobPvt := .T.
	
		Else
			If ! MsgYesNo("Deseja acessar a caixa de entrada e baixar os arquivos TXT?", "Aten��o")
				Return
			EndIf
		EndIf
		
		//Se existir o sem�foro, d� mensagem de erro
		If File(cArqSem)
			//Alert("[zBxMail] Sem�foro existente (" + MemoRead(cArqSem) + ") - "+Time())
			
			//Mostrando mensagem
			If ! lJobPvt
				Aviso("Aten��o", "Sem�foro existente (Processo iniciado em " + MemoRead(cArqSem) + ")")
			EndIf
			
		Else
			
			
			//Chamando o processamento de dados
			Processa({|| fProcessa() }, "Processando...")
		
			//Mostrando mensagem de conclus�o
			If ! lJobPvt
				Aviso("Aten��o", "Processo concluído.")
			EndIf
			
			FErase(cArqSem)
		EndIf
	
		//Atilio, 27/02/2019, para caixas Hotmail, rodar 2x para mover de pasta
		nVez++	
		u_zBxMail()
	EndIf
	
	//Alert("[zBxMail] Processo finalizado - "+Time())
Return

/*---------------------------------------------------------------*
 | Func.: fProcessa                                              |
 | Desc.: Fun��o de processamento para buscar os arquivos        |
 *---------------------------------------------------------------*/

Static Function fProcessa()
	Private cDirBase  := GetSrvProfString("RootPath", "")
	Private cDirPad   := "\x_importacao\"
	Private cConta    := ''
	Private cSenha    := ''
	Private cSrvFull  := ''
	Private cServer   := ''
	Private nPort     := 0

	//Definindo dados da conta
	cConta    := "email@empresa.com.br"
	cSenha    := "Sua Senha XXX"
	cSrvFull  := "servidor.com.br:993"
	cServer   := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
	nPort     := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 110)
	
	//Se o �ltimo caracter n�o for barra, retira ela
	If SubStr(cDirBase, Len(cDirBase), 1) == '\'
		cDirBase := SubStr(cDirBase, 1, Len(cDirBase)-1)
	EndIf
	
	//O diret�rio cheio, ser� o caminho absoluto + conte�do do parâmetro, por exemplo, D:\TOTVS\TOTVS Protheus\Protheus_Data\x_importacao_email
	cDirFull := cDirBase + cDirPad
	
	//Chama a importa��o
	fBaixa()
Return

/*---------------------------------------------------------------*
 | Func.: fBaixa                                                 |
 | Desc.: Fun��o que baixa as mensagens do e-Mail                |
 *---------------------------------------------------------------*/

Static Function fBaixa()
	Local aArea := GetArea()
	Local cArqINI
	Local cBkpConf
	Local nRet
	Local nNumMsg
	Local nMsgAtu
	Local oManager
	Local oMessage
	Local nAnexoAtu
	Local nTotAnexo
	Local aInfAttach
	Local lOk
	Local lEntrou
	
	//Altera o arquivo appserver.ini, deixando como IMAP
	cArqINI  := GetSrvIniName()
	cBkpConf := GetPvProfString( "MAIL", "Protocol", "", cArqINI )
	WritePProString('MAIL', 'PROTOCOL', 'IMAP', cArqINI)

	//Cria a conex�o base no gerenciamento
	oManager := tMailManager():New()
	oManager:SetUseSSL(.T.)
	oManager:SetUseTLS(.T.)
	oManager:Init(cServer, "", cConta, cSenha, nPort, 0)
	
	//Caso n�o consiga setar 120 segundos como timeout (2 minutos), n�o continua
	If oManager:SetPopTimeOut(120) != 0
		//Alert("[zBxMail] Falha ao setar o timeout" )
	Else
		
		//Faz a conex�o com IMAP
		nRet := oManager:IMAPConnect()
		
		//Se n�o conseguir conectar, mostra qual � a mensagem de erro
		If nRet != 0
			//Alert("[zBxMail] Falha ao conectar" )
			//Alert("[zBxMail][ERROR] " + StrZero(nRet, 6), oManager:GetErrorString(nRet))
			
		Else
			//Alert("[zBxMail] Sucesso ao conectar" )

			//Busca o n�mero de mensagens na caixa de entrada
			nNumMsg := 0
			oManager:GetNumMsgs(@nNumMsg)
			
			//Se houver mensagens a serem processadas
			If nNumMsg > 0
				ProcRegua(nNumMsg)
				
				//Percorre o n�mero de mensagens
				For nMsgAtu := 1 To nNumMsg
					IncProc("Baixando e-Mail " + cValToChar(nMsgAtu) + " de " + cValToChar(nNumMsg) + "...")
					
					//Buscando a mensagem atual
					oMessage := tMailMessage():new()
					oMessage:Clear()
					oMessage:Receive(oManager, nMsgAtu)

					//Busca o total de Anexos
					nTotAnexo := oMessage:GetAttachCount()
					
					//Limpando a flag
					lOk := .T.
					lEntrou := .F.
					
					//Percorre todos os anexos
					For nAnexoAtu := 1 To nTotAnexo
						//Busca as informa�ões do anexo
						aInfAttach := oMessage:GetAttachInfo(nAnexoAtu)
						
						//Se tiver conte�do, e for do tipo TXT
						If ! Empty(aInfAttach[1]) .And. Upper(Right(AllTrim(aInfAttach[1]),4)) == '.TXT' //.And. "REMETENTE" $ Upper(oMessage:cFrom)
							lEntrou := .T.
							
							//Salva o arquivo na pasta correta
							If oMessage:SaveAttach(nAnexoAtu, cDirFull + aInfAttach[1])
								
								//Alert("+================================+")
								//Alert("[zBxMail] e-Mail Lido com Anexo: ")
								//Alert("e-Mail Origem:      " + cConta)
								//Alert("N�mero da Mensagem: " + cValToChar(nMsgAtu))
								//Alert("De:                 " + oMessage:cFrom)
								//Alert("C�pia:              " + oMessage:cCc)
								//Alert("Assunto:            " + oMessage:cSubject)
								//Alert("N�mero Anexo:       " + cValToChar(nAnexoAtu))
								//Alert("Anexo " + StrZero(nAnexoAtu, 3) + ":          " + aInfAttach[1] )
								//Alert("Corpo:              " + oMessage:cBody)
								//Alert("+================================+")
								
							Else
								lOk := .F.
								//Alert("[zBxMail] Erro ao salvar anexo " + cValToChar(nAnexoAtu) + ": " + aInfAttach[1] )
							EndIf
						EndIf

					Next nAnexoAtu

					//Se o anexo tiver sido salvo com sucesso
					If lOk
						If lEntrou
							If ! (oManager:MoveMsg(nMsgAtu, "Importados"))
								//Alert("[zBxMail] N�o foi possível mover a mensagem - " + cValToChar(nMsgAtu) + "...")
							EndIf
						Else
							If ! (oManager:MoveMsg(nMsgAtu, "Processados"))
								//Alert("[zBxMail] N�o foi possível mover a mensagem - " + cValToChar(nMsgAtu) + "...")
							EndIf
						EndIf
					EndIf

					//Alert(CRLF)
				Next nMsgAtu
				
			Else
				//Alert("[zBxMail] N�o existem mensagens para processamento...")
			EndIf

			//Desconecta do servidor IMAP
			oManager:IMAPDisconnect()
		EndIf
	EndIf
	
	//Volta a configura��o de Protocol no arquivo appserver.ini
	WritePProString('MAIL', 'PROTOCOL', cBkpConf, cArqINI)
	
	RestArea(aArea)
Return