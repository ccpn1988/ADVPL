/* ===
    Esse ? um exemplo disponibilizado no Terminal de Informa??o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/10/25/funcao-converte-valor-soma1-em-advpl/
    Caso queira ver outros conte?dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zCnvSoma1
Fun??o de convers?o do Soma1
@type function
@author Atilio
@since 03/08/2016
@version 1.0
	@param cValor, character, Valor do Soma1
	@return nValConv, Valor convertido
	@example
	u_zCnvSoma1("ZZZ")
/*/

User Function zCnvSoma1(cValor)
	Local aArea    := GetArea()
	Local nValConv := 0
	Local cAtual   := ""
	Default cValor := "0"
	
	//Definindo o atual como 0
	cAtual := StrZero(0, Len(cValor))
	cAtual := StrTran(cAtual, '0', '9')
	
	//Enquanto o valor atual for diferente do parâmetro
	While cAtual != cValor
		nValConv++
		cAtual := Soma1(cAtual)
	EndDo
	
	RestArea(aArea)
Return nValConv

/*/{Protheus.doc} zCnvTipo2
Fun??o para convers?o do Soma1 (sem utilizar o While)
@type function
@author Atilio
@since 03/08/2016
@version 1.0
	@param cNumero, character, Valor do Soma1
	@return nValor, Valor Convertido
	@example
	u_zCnvSoma1("ZZ")
	@obs Essa fun??o n?o foi finalizada 100%!
	N?o foi encontrado um fator exato de convers?o, em testes realizados, com valores de tamanho 1 e 2, a fun??o funciona
	perfeitamente (por exemplo, A0, ZZ, Z, M9, etc), por?m para valores de tamanho 3 para cima n?o.
	Para valores de tamanho 1, a rotina funciona
	Para valores de tamanho 2, a rotina funciona
	Para valores de tamanho 3, a inconsistência come?a partir do AB0  (ap?s o AAZ)  - 2357  registros
	Para valores de tamanho 4, a inconsistência come?a partir do 9AB0 (ap?s o 9AAZ) - 11356 registros
/*/

User Function zCnvTipo2(cNumero)
	Local aArea     := GetArea()
	Local nValor    := 0
	Local lSoNumero := .T.
	Local nAtual    := 0
	Local cAscii    := ""
	Local nPosIni   := 0
	Local cCaract   := ""
	Local nValAux   := 0
	Local cZeros    := ""
	Local cAscii    := ""
	cNumero := Upper(cNumero)
	
	//Percorre os valores
	For nAtual := 1 To Len(cNumero)
		cCaract := SubStr(cNumero, nAtual, 1)
		
		//Se tiver alguma letra no numero
		If cCaract $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			If nPosIni == 0
				nPosIni := nAtual
			EndIf
			lSoNumero := .F.
			Exit
		EndIf
	Next
	
	//Se tiver somente numero, converte com Val
	If lSoNumero
		nValor := Val(cNumero)
		
	Else
		nValor := 0
		
		//Percorre os valores
		For nAtual := 1 To Len(cNumero)
			cCaract := SubStr(cNumero, nAtual, 1)
			cZeros  := Replicate("0", Len(cNumero)-nAtual)
			
			//Se tiver alguma letra no numero
			If cCaract $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
				cAscii := cValToChar(Asc(cCaract) - 64 + 9)
				
				//Se for a partir da segunda posi??o e n?o for a ?ltima
				If nAtual > nPosIni .And. nAtual != Len(cNumero)
					nValAux := Val(cAscii + cZeros) + Iif(nAtual != Len(cNumero), 26 * (Asc(cCaract) - 64), 0)
					nValAux *= Val(cAscii)
					nValAux += (26 + Val(cAscii))
					nValor += nValAux
					
				Else
					nValor += Val(cAscii + cZeros) + Iif(nAtual != Len(cNumero), 26 * (Asc(cCaract) - 64), 0)
				EndIf
			
			//Se for somente n?meros
			Else
				//Se for a partir da segunda posi??o e n?o for a ?ltima
				If nAtual > nPosIni .And. nAtual != Len(cNumero)
					nValor += Val(cCaract + cZeros) + (36 * 26) + (26*Val(cCaract))
				Else
					nValor += Val(cCaract + cZeros)
				EndIf
			EndIf
		Next		
	EndIf
	
	RestArea(aArea)
Return nValor