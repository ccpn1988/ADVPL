#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA032  ºAutor  ³Microsiga           º Data ³  01/18/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ realiza movimentação de saida.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Gen.                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA032()

If Type("cFilAnt") == "U"
	RpcSetType(3)
	RpcSetEnv("00","1022")
EndIf

If MsgYesNo("GENA032.?")
	LJMsgRun("Realizando ajustes...","Aguarde...",{|| ProcEstorno() })
Endif

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA032  ºAutor  ³Microsiga           º Data ³  01/18/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Gen.                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcEstorno()

Local cAliasQry	:= GetNextAlias()
Local ExpA1		:= {}
Local ExpN2		:= 3

BeginSql Alias cAliasQry

/*
SELECT *
FROM SD3000 SD3 
JOIN SB2000 SB2
ON B2_COD = D3_COD
AND B2_LOCAL = D3_LOCAL
AND SB2.B2_QATU > D3_QUANT
AND SB2.D_E_L_E_T_ <> '*'
WHERE D3_FILIAL = '1022'
AND SUBSTR(D3_COD,1,3) = '042'
AND D3_QUANT = 1500
AND D3_ESTORNO = ' '
AND D3_TM = '100'
AND SD3.D_E_L_E_T_ = ' '  
AND SD3.D3_EMISSAO = '20150901'
*/

SELECT SD3.*
FROM SD3000 SD3
JOIN SB2000 SB2
ON B2_COD = D3_COD
AND B2_LOCAL = D3_LOCAL
AND B2_QATU >= D3_QUANT
AND SB2.D_E_L_E_T_ <> '*'
WHERE D3_FILIAL = '1022'
AND SUBSTR(D3_COD,1,3) = '042'
AND D3_QUANT = 1500
AND D3_ESTORNO = ' '
AND D3_TM = '100'
AND SD3.D_E_L_E_T_ = ' '  
AND SD3.D3_EMISSAO = '20150901'
AND NOT EXISTS (SELECT 1 
FROM SD3000 A
WHERE A.D_E_L_E_T_ = ' '
AND A.D3_COD = SD3.D3_COD
AND A.D3_FILIAL = SD3.D3_FILIAL
AND A.D3_TM = '505'
AND A.D3_EMISSAO = '20151231')

EndSql



SB1->(DbSetORder(1))

(cAliasQry)->(DbGoTop())


While (cAliasQry)->(!EOF())
	Begin Transaction
		
		SB1->(DbSeek(xFilial("SB1")+(cAliasQry)->D3_COD))
			
		lMsErroAuto := .F.          
		
		ExpA1 := {}
		
		aadd(ExpA1,{"D3_TM"			, "505"								,	})
		aadd(ExpA1,{"D3_COD"		, (cAliasQry)->D3_COD				,	})
		aadd(ExpA1,{"D3_UM"			, (cAliasQry)->D3_UM				,	})		
		aadd(ExpA1,{"D3_LOCAL"		, (cAliasQry)->D3_LOCAL				,	})
		aadd(ExpA1,{"D3_QUANT"		, (cAliasQry)->D3_QUANT				,	})
		aadd(ExpA1,{"D3_GRUPO"		, (cAliasQry)->D3_GRUPO				,	})		
//		aadd(ExpA1,{"D3_CUSTO1"		, (cAliasQry)->D3_CUSTO1			,	})
		aadd(ExpA1,{"D3_EMISSAO"	, DDataBase	,	})	        
	
		MSExecAuto({|x,y| mata240(x,y)},ExpA1,ExpN2)		
		
		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			MsgStop("Processo cancelado!")
			(cAliasQry)->(DbCloseArea())	
		EndIF
	End Transaction	
	//Retirado retorno dentro do Begin Fernando Lavor
	If lMsErroAuto
		Return .F.   
	EndIf	
	(cAliasQry)->(DbSkip())
EndDo

(cAliasQry)->(DbCloseArea())
MsgStop("Processo finalizado!")

Return nil
