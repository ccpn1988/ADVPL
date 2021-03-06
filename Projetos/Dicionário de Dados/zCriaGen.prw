/* ===
    Esse ? um exemplo disponibilizado no Terminal de Informa??o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/07/11/funcao-cria-tabela-generica-sx5-advpl/
    Caso queira ver outros conte?dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zCriaGen
Fun??o que cria tabela gen?rica
@type function
@author Atilio
@since 03/02/2017
@version 1.0
	@param cTab, Caracter, Tabela
	@param cDesc, Caracter, Nome da Tabela
	@param aSX5, Array, Array com os dados da SX5
	@example
	u_zCriaGen("ZZ", "Teste", aSX5)
	@obs Abaixo a estrutura do array:
	SX5:
		[nLinha][01] - Chave
		[nLinha][02] - Descri??o
		[nLinha][03] - Descri??o Espanhol
		[nLinha][04] - Descri??o Inglês
/*/

User Function zCriaGen(cTab, cDesc, aSX5)
	Local aAreaX5 := SX5->(GetArea())
	Local nAtual  := 0
	Default cTab  := ""
	Default cDesc := ""
	Default aSX5  := ""
	
	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	
	//Se tiver tabela e descri??o
	If !Empty(cTab) .And. !Empty(cDesc)
		//Se n?o conseguir posicionar, cria a tabela
		If ! SX5->(DbSeek(cFilSX5 + '00' + cTab))
			RecLock('SX5', .T.)
				X5_FILIAL   := FWxFilial('SX5')
				X5_TABELA   := '00'
				X5_CHAVE    := cTab
				X5_DESCRI   := cDesc
				X5_DESCSPA  := cDesc
				X5_DESCENG  := cDesc
			SX5->(MsUnlock())
		EndIf
		
		//Se tiver dados
		If Len(aSX5) > 0
			//Percorrendo os registros
			For nAtual := 1 To Len(aSX5)
				//Se conseguir posicionar no registro, ser? altera??o
				If SX5->(DbSeek(cFilSX5 + cTab + aSX5[nAtual][01]))
					RecLock('SX5', .F.)
						X5_DESCRI   := aSX5[nAtual][02]
						X5_DESCSPA  := aSX5[nAtual][03]
						X5_DESCENG  := aSX5[nAtual][04]
					SX5->(MsUnlock())
				
				//Sen?o, ser? inclus?o
				Else
					RecLock('SX5', .T.)
						X5_FILIAL   := FWxFilial('SX5')
						X5_TABELA   := cTab
						X5_CHAVE    := aSX5[nAtual][01]
						X5_DESCRI   := aSX5[nAtual][02]
						X5_DESCSPA  := aSX5[nAtual][03]
						X5_DESCENG  := aSX5[nAtual][04]
					SX5->(MsUnlock())
				EndIf
			Next
		EndIf
	EndIf
	
	MsgInfo("Processamento finalizado!", "Aten??o")
	
	RestArea(aAreaX5)
Return