/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/07/18/funcao-verifica-se-um-array-esta-vazio/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zVazio
Fun��o que verifica se o array est� vazio (ou somente com linhas excluídas)
@type function
@author Atilio
@since 05/03/2016
@version 1.0
	@param aArray, Array, Array que cont�m as informa�ões (como um aCols)
	@return lRet, Se o Array est� vazio (n�o tem nenhuma posi��o v�lida)
/*/

User Function zVazio(aArray)
	Local lRet := .F.
	Local nAtual := 1
	Local nUltPos := 0
	Local nExcluidos := 0
	
	//Se o tamanho for 0, Array � vazio
	If Len(aArray) == 0
		lRet := .T.
	
	//Se tiver em branco, Array � vazio
	ElseIf Empty(aArray)
		lRet := .T.
		
	Else
		//Percorro o Array
		For nAtual := 1 To Len(aArray)
			//Pega a �ltima posi��o do aCols (a que cont�m se a linha est� excluída - .T. -, ou n�o - .F. -)
			nUltPos := Len(aArray[nAtual])
			
			//Se tiver excluído
			If aArray[nAtual][nUltPos]
				nExcluidos++
			EndIf
		Next
		
		//Se a quantidade de excluídos for igual ao tamanho do array, array est� vazio
		If nExcluidos == Len(aArray)
			lRet := .T.
		EndIf
	EndIf
Return lRet