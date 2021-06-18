#include 'protheus.ch'

/*
Fun��o: GENV006

Descri��o: valida digita��o dos dados de origem na nota fiscal de entrada
*/

User Function GENV006

Local _lRet := .T.

_lRet :=  RetCodUsr()$GetMv("GEN_COM019") .or. ALLTRIM(SB1->B1_XEMPRES) == "42"                        

Return _lRet
