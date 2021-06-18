//Bibliotecas
#Include "Protheus.ch"

//Constantes
#Define STR_PULA	Chr(13)+Chr(10)

/*/{Protheus.doc} zArrToTxt
Fun��o que exporta um array para Texto
@author Atilio
@since 21/08/2015
@version 1.0
	@param aAuxiliar, Array, Array com os dados que ser�o impressos
	@param lQuebr, L�gico, Define se a cada posi��o do array, quebra o texto
	@param cArqGera, Caracter, Arquivo a ser gerado com o conte�do do array
	@example
	u_zArrToTxt(aArray, .T., "E:\teste_aux.txt")
	@return cTextoAux, Vari�vel que � retornada (contendo o array em formato txt)
/*/

User Function zArrToTxt(aAuxiliar, lQuebr, cArqGera)
	Local cTextoAux	:= ""
	Local nLimite		:= 63000 //For�ando o tamanho m�ximo a 63.000 bytes
	Local nLinha		:= 0
	Local nColuna		:= 0
	Local nNivel		:= 0
	Default aAuxiliar	:= {}
	Default lQuebr	:= .T.
	Default cArqGera	:= ""
	
	//Se tiver linhas para serem processadas
	If Len(aAuxiliar) > 0
		//Percorrendo o Array
		For nLinha := 1 To Len(aAuxiliar)
			fImprArray(aAuxiliar[nLinha], @cTextoAux, nNivel, lQuebr, nLimite, nLinha)
		Next
		
		//Se n�o tiver em branco, gera o arquivo
		If !Empty(cArqGera)
			MemoWrite(cArqGera, cTextoAux)
		EndIf
	EndIf
Return cTextoAux

/*---------------------------------------------------------------------*
 | Func:  fImprArray                                                   |
 | Autor: Daniel Atilio                                                |
 | Data:  21/08/2015                                                   |
 | Desc:  Fun��o que gera a linha do arquivo (recursivamente)          |
 *---------------------------------------------------------------------*/

Static Function fImprArray(xDadAtu, cTextoAux, nNivel, lQuebr, nLimite, nPosicao)
	Local cEspac := Space(nNivel)
	Local nColuna := 0
	
	//Finaliza o la�o
	If Len(cTextoAux) >= nLimite
		Return
	EndIf
	
	//Se o tipo for num�rico
	If ValType(xDadAtu) == "N"
		cTextoAux += cEspac+"["+StrZero(nPosicao, 4)+"][Type:N] "+cValToChar(xDadAtu) + Iif(lQuebr, STR_PULA, '')
	
	//Se for Data
	ElseIf ValType(xDadAtu) == "D"
		cTextoAux += cEspac+"["+StrZero(nPosicao, 4)+"][Type:D] "+dToC(xDadAtu) + Iif(lQuebr, STR_PULA, '')
		
	//Se for Array
	ElseIf ValType(xDadAtu) == "A"
		cTextoAux += cEspac+"["+StrZero(nPosicao, 4)+"][Type:A]" + Iif(lQuebr, STR_PULA, '')
		nNivel++
		//Percorrendo o Array
		For nColuna := 1 To Len(xDadAtu)
			fImprArray(xDadAtu[nColuna], @cTextoAux, nNivel, lQuebr, nLimite, nColuna)
		Next
	
	//Se for L�gico
	ElseIf ValType(xDadAtu) == "L"
		cTextoAux += cEspac+"["+StrZero(nPosicao, 4)+"][Type:L] "+cValToChar(xDadAtu) + Iif(lQuebr, STR_PULA, '')
	
	//Sen�o, apenas mostra o conte�do (Memo, Char, etc)
	Else
		cTextoAux += cEspac+"["+StrZero(nPosicao, 4)+"][Type:"+ValType(xDadAtu)+"] "+Alltrim(xDadAtu) + Iif(lQuebr, STR_PULA, '')
	EndIf
Return