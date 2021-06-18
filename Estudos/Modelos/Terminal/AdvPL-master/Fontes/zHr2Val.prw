//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zHr2Val
Fun��o que converte Hora para Valor
@author Atilio
@since 16/02/2017
@version 1.0
@param cHora, characters, Par�metro que cont�m o conte�do da hora e minutos (por exemplo, 100:50)
@param cSep, characters, Par�metro que cont�m o separador da hora (por exemplo, ':' ou 'h')
@type function
@example u_zHr2Val("01:30", ":") --> 1,50
u_zHr2Val("01h45", "h") --> 1,75
/*/

User Function zHr2Val(cHora, cSep)
	Local aArea   := GetArea()
	Local nAux    := 0
	Local cMin    := ""
	Local nValor  := 0
	Local nPosSep := 0
	Default cHora := ""
	Default cSep  := ':'
	
	//Se tiver a hora
	If !Empty(cHora)
		nPosSep := RAt(cSep, cHora)
		nAux    := Val(SubStr(cHora, nPosSep+1, 2))
		nAux    := Int(Round((nAux*100)/60, 0))
		cMin    := Iif(nAux > 10, cValToChar(nAux), "0"+cValToChar(nAux))
		nValor  := Val(SubStr(cHora, 1, nPosSep-1)+"."+cMin)
	EndIf
	
	RestArea(aArea)
Return nValor