User Function TMP001

Local _cAlias2 := GetNextAlias()

If !MsgYesNo("Executa TMP001?")
	Return
Endif

_cSQL := " SELECT ' 'AS FILIAL
_cSQL += " ,PR.TIPO AS TIPO 
_cSQL += " ,'20160331' AS REF
_cSQL += " ,PR.PRODUTO AS COD
_cSQL += " ,B1_DESC AS B1_DESC
_cSQL += " ,B1_LOCPAD AS B1_LOCPAD
_cSQL += " ,B1_UM AS B1_UM
_cSQL += " ,B1_MSBLQL AS B1_MSBLQL
_cSQL += " ,B1_PROC AS B1_PROC
_cSQL += " ,B1_LOJPROC AS B1_LOJPROC
_cSQL += " ,PR.SALDO AS ORI
_cSQL += " ,0 AS DEV
_cSQL += " ,0 AS CAN
_cSQL += " ,PR.SALDO AS SALDO
_cSQL += " ,DA1_PRCVEN AS VALUNIT
_cSQL += " ,(DA1_PRCVEN*PR.SALDO*0.5) AS VALTOT
_cSQL += " FROM TOTVS_TST.PRESTACAO PR
_cSQL += " ,TOTVS.SB1000 SB1
_cSQL += " ,TOTVS.DA1000 DA1
_cSQL += " WHERE SB1.B1_COD = PR.PRODUTO
_cSQL += " AND SB1.D_E_L_E_T_ = ' '
_cSQL += " AND DA1.DA1_CODTAB = '160'
_cSQL += " AND DA1.DA1_CODPRO = PR.PRODUTO
_cSQL += " AND DA1.D_E_L_E_T_ = ' '

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias2, .F., .T.)       

Begin Transaction
	While (_cAlias2)->(!EOF())
		
		_nSaldo := (_cAlias2)->SALDO
		
		_nValUnit := NoRound((_cAlias2)->VALUNIT * 0.5,2)
		
		//Não existe preço menor que R$ 0,01
		If _nValUnit < 0.01 
		
			_nValUnit := 0.01
		Endif  
		
		_nValTot := NoRound(_nSaldo * _nValUnit,2)
		
		Reclock("SZA",.T.)
		SZA->ZA_FILIAL	:= ""  
		SZA->ZA_TIPO   	:= (_cAlias2)->TIPO
		SZA->ZA_REF    	:= STOD((_cAlias2)->REF)
		SZA->ZA_COD    	:= (_cAlias2)->COD
		SZA->ZA_DESC   	:= (_cAlias2)->B1_DESC
		SZA->ZA_LOCPAD 	:= (_cAlias2)->B1_LOCPAD
		SZA->ZA_UM     	:= (_cAlias2)->B1_UM
		SZA->ZA_MSBLQL 	:= (_cAlias2)->B1_MSBLQL
		SZA->ZA_PROC   	:= (_cAlias2)->B1_PROC
		SZA->ZA_LOJPROC	:= (_cAlias2)->B1_LOJPROC
		SZA->ZA_VALORI 	:= (_cAlias2)->ORI
		SZA->ZA_VALDEV 	:= (_cAlias2)->DEV
		SZA->ZA_VALCAN	:= (_cAlias2)->CAN 
		SZA->ZA_SALDO	:= _nSaldo
		SZA->ZA_VALUNI  := _nValUnit
		SZA->ZA_VALTOT  := _nValTot
		SZA->(MsUnlock()) 
		
		(_cAlias2)->(DbSkip())
	EndDo  
End Transaction

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
EndIf  

MsgInfo("Fim do processamento. Verifique a gravação dos dados.")

Return   