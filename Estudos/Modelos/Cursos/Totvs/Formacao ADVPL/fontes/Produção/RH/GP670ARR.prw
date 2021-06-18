#INCLUDE "protheus.ch"

/*
Função:GP670ARR

Descricao: Ponto de entrada na integracao do RH com o Contas a pagar.
Utilizado para adicionar informacoes em campos personalizados.

Autor: Helimar

Data: 02/09/2016
*/              

User Function GP670ARR

Local cBanco	:= ''
Local aRet := {}

nValTed := GETMV("MV_XINFPGT")
cBanco  := SA2->A2_BANCO

If empty(cBanco)
	cForPgt := "  "
ElseIf alltrim(cBanco) = '341'
	cForPgt := "01"
ElseIf RC1->RC1_VALOR <= nValTed
	cForPgt := "03"
Else
	cForPgt := "41"
EndIf

aadd(aRet,{"E2_XFORPGT",cForPgt,NIL})

Return aRet