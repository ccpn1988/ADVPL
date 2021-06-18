#INCLUDE "protheus.ch"

/*
Função:GP670ARR

Descricao: Ponto de entrada na integracao do RH com o Contas a pagar.
Utilizado para adicionar informacoes em campos personalizados.

Autor: Helimar

Data: 02/09/2016


-- Cleuto 22/05/2021
incluida 
*/              

User Function GP670ARR

// Local aArea		:= GetArea()
Local cBanco	:= ''
Local aRet		:= {}
Local cVerbasGpa:= GetMv("GEN_FIN027",.f.,"034")
Local cHistAux	:= ""
Local cCompeten	:= Right(RC1->RC1_COMPET,4)+Left(RC1->RC1_COMPET,2)

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

cHistAux	:= ALLTRIM(RC1->RC1_DESCRI)+" "+Month2Str(RC1->RC1_VENCTO)+"/"+Year2Str(RC1->RC1_VENCTO)

IF RC1->RC1_CODTIT $ cVerbasGpa	
	/* verbas de autonomo verifico se origem é gestão de pagamento */
	IF Select("TMP_SZ1") > 0
		TMP_SZ1->(DbCloseArea())
	ENDIF
	BeginSql Alias "TMP_SZ1"
		SELECT TRIM(Z1_OBS) OBS,SZ1.* FROM %Table:SZ1% SZ1
		WHERE Z1_FILIAL = %Exp:RC1->RC1_FILTIT%
		AND Z1_FORNECE = %Exp:SA2->A2_COD%
		AND Z1_LOJA = %Exp:SA2->A2_LOJA%
		AND Z1_INSS = '1' /*GERAR INSS*/
		AND Z1_STATUS = '2' /*PAGO*/
		AND SUBSTR(Z1_DATA,1,6) = %Exp:cCompeten%
		AND TRIM(Z1_OBS) IS NOT NULL
		AND SZ1.%NotDel%
		ORDER BY LENGTH(TRIM(Z1_OBS)) DESC		
	EndSql
	IF TMP_SZ1->(!EOF())
		cHistAux := AllTrim(TMP_SZ1->OBS)
		TMP_SZ1->(DbSkip()())

		IF TMP_SZ1->(!EOF())
			cHistAux := Left(cHistAux, TamSX3("E2_HIST")[1]-10 )+ " +|Outros"
		ENDIF
	ENDIF
	TMP_SZ1->(DbCloseArea())
ENDIF

aadd(aRet,{"E2_XFORPGT",cForPgt,NIL})
aadd(aRet,{"E2_HIST",cHistAux,NIL})
aadd(aRet,{"E2_ITEMD","000000   ",NIL})   
aadd(aRet,{"E2_CLVLDB","000000000",NIL})   

// RestArea(aArea)

Return aRet
