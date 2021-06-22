/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/11/28/funcao-altera-posicao-de-um-elemento-de-um-array/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zElemAlt
Fun��o que altera a posi��o de um elemento do Array
@author Atilio
@since 02/08/2017
@version 1.0
@param aArray, array, Array com os dados que ser�o ordenados
@param nColSeq, numeric, Coluna que possui a sequência
@param nLinOld, numeric, Linha antiga que ser� alterada
@param nLinNew, numeric, Linha nova que ser� alterada
@type function
@example Exemplo abaixo
	aDados := {}
	aAdd(aDados, {"001", "ARROZ"})
	aAdd(aDados, {"002", "FEIJÃO"})
	aAdd(aDados, {"003", "BELUGA"})
	aAdd(aDados, {"004", "MARMOTA"})
	
	nColuna      := 1
	nLinhaAntiga := 4
	nLinhaNova   := 2
	
	//Altera a marmota da posi��o 4 para 2
	u_zElemAlt(@aDados, nColuna, nLinhaAntiga, nLinhaNova)
/*/

User Function zElemAlt(aArray, nColSeq, nLinOld, nLinNew)
	Local aArea      := GetArea()
	Local aLinhaBkp  := {}
	Local nTamanOrig := 0
	Local nLinAtu    := 0
	Local cSeqAtu    := ""
	Default aArray   := {}
	Default nColSeq  := 1
	Default nLinOld  := 0
	Default nLinNew  := 0
	
	//Se tiver dados no Array, e tiver linha antiga e nova
	If Len(aArray) > 0 .And. nLinOld != 0 .And. nLinNew != 0 .And. nLinOld != nLinNew
	
		//Fazendo um backup da linha, e do tamanho do array
		aLinhaBkp  := aClone(aArray[nLinOld])
		nTamanOrig := Len(aArray)
		
		//Redimensiona, aumentando o array
		aSize(aArray, nTamanOrig + 1)
		
		//Excluo da linha antiga
		aDel(aArray, nLinOld)
		
		//Insiro na linha nova
		aIns(aArray, nLinNew)
		
		//Agora a linha nova, vai ter o valor da antiga que foi excluída
		aArray[nLinNew] := aClone(aLinhaBkp)
		
		//Refa�o o tamanho do array
		aSize(aArray, nTamanOrig)
		
		//Percorre os elementos do array, e refaz a coluna de sequência
		cSeqAtu := Replace(Space(Len(aArray[1][nColSeq])), ' ', '0')
		For nLinAtu := 1 To Len(aArray)
			cSeqAtu := Soma1(cSeqAtu)
			
			aArray[nLinAtu][nColSeq] := cSeqAtu
		Next
	EndIf
	
	RestArea(aArea)
Return