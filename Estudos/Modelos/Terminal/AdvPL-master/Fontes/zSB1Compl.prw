//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zSB1Compl
Fun��o que gera o complemento do produto (SB5) atrav�s do produto (SB1)
@author Atilio
@since 29/08/2017
@version 1.0
@type function
@obs Executar como Administrador
/*/

User Function zSB1Compl()
	Processa({|| fProcessa()}, "Processando...")
Return

/*----------------------------------------------------------*
 | Func.: fProcessa                                         |
 | Desc.: Fun��o de processamento para gravar o complemento |
 *----------------------------------------------------------*/

Static Function fProcessa()
	Local aArea  := GetArea()
	Local nAtual := 0
	Local nTotal := 0
	Local nOk    := 0
	Local cOk    := ""
	Local cMsg   := ""
	Local lPosUM := ( SB5->(FieldPos('B5_UMIND')) != 0)
	
	//Abre o cadastro de produtos
	DbSelectArea('SB1')
	SB1->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	SB1->(DbGoTop())
	Count To nTotal
	
	//Abre o cadastro de complemento
	DbSelectArea('SB5')
	SB5->(DbSetOrder(1)) //B5_FILIAL + B5_COD
	SB5->(DbGoTop())
	
	//Posiciona no topo e percorre os registros
	SB1->(DbGoTop())
	While ! SB1->(Eof())
		nAtual++
		IncProc("Processando "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+" ("+AllTrim(SB1->B1_COD)+")...")
		
		//Se n�o existir complemento
		If ! SB5->(DbSeek(FWxFilial('SB5') + SB1->B1_COD))
			//Foi feito atrav�s de RecLock, pois o MsExecAuto da MATA180 estava travando
			RecLock('SB5', .T.)
				B5_FILIAL    := FWxFilial('SB5')
				B5_COD       := SB1->B1_COD
				B5_CEME      := SB1->B1_DESC
				If lPosUM
					B5_UMIND := '1'
				EndIf
			SB5->(MsUnlock())
			
			lMsErroAuto := .F.
			
			nOk++
			cOk += "- "+Alltrim(SB1->B1_COD)+";" + CRLF
		EndIf
		
		SB1->(DbSkip())
	EndDo
	
	//Se tiver erros ou inclus�es, mostra mensagem
	If nOk != 0
		cMsg := "Foram analisados "+cValToChar(nTotal)+" produtos..." + CRLF + CRLF
		cMsg += "Sucesso na inclus�o do complemento de "+cValToChar(nOk)+" produto(s):"+CRLF
		cMsg += cOk + CRLF
		
		Aviso("Aten��o", cMsg, {"Ok"}, 2)
	EndIf
	
	//Atualiza o grupo de perguntas
	If MsgYesNo("Deseja atualizar o par�metro do cadastro de produtos (F12)?", "Aten��o")
		u_zAtuPerg("MTA010", "MV_PAR02", 1)
	EndIf
	
	MsgInfo("Processo conclu�do.", "Aten��o")
	
	RestArea(aArea)
Return