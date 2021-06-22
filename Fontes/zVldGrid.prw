/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/06/27/funcao-valida-todos-os-campos-de-uma-grid/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zVldGrid
Executa as valida�ões da Grid
@author Atilio
@since 18/02/2017
@version 1.0
@type function
/*/

User Function zVldGrid()
	Local aArea      := GetArea()
	Local lOk        := .T.
	Local aColsAux   := aCols
	Local aHeaderAux := aHeader
	Local nLinBkp    := n
	Local nAtual     := 0
	Local nColAtu    := 0
	Local cCampoAtu  := 0
	Local cVldPad    := ""
	Local cVldUsr    := ""
	Local cMsgAux    := ""
	Local cVarBkp    := __ReadVar
	
	//Percorre as linhas
	For nAtual := 1 To Len(aColsAux)
		n := nAtual
		
		//Percorre o cabe�alho da linha atual
		For nColAtu := 1 To Len(aHeaderAux)
			cCampoAtu := aHeaderAux[nColAtu][2]
			__ReadVar := cCampoAtu
			cVldPad := GetSX3Cache(cCampoAtu, 'X3_VALID')
			cVldUsr := GetSX3Cache(cCampoAtu, 'X3_VLDUSR')
			
			//Se tiver valida��o padr�o, executa
			If !Empty(cVldPad)
				lOk := &(cVldPad)
				If !lOk
					cMsg += "- Campo "+cCampoAtu+CRLF
				EndIf
			EndIf
			
			//Se tiver ok e tiver valida��o de usu�rio, executa
			If lOk .And. !Empty(cVldUsr)
				lOk := &(cVldUsr)
				If !lOk
					cMsg += "- Campo "+cCampoAtu+CRLF
				EndIf
			EndIf
		Next
	Next
	
	//Caso tenha mensagem de erro nos campos, mostra ao usu�rio
	If !Empty(cMsg)
		Aviso("Aten��o", "Erros nos campos: "+CRLF+cMsg, {"OK"}, 2)
	EndIf
	
	__ReadVar := cVarBkp
	n := nLinBkp
	RestArea(aArea)
Return lOk