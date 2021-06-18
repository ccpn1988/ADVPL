#include 'protheus.ch'
#include 'TopConn.ch'

#DEFINE STR_PULA CH(13) + CH(10)

user function zTCQuery()
	Local aArea := GetArea()
	Local cMsg 	:= ""
	Local cQuery := ""
	
	cQuery := " SELECT " 						+ STR_PULA
	cQuery += " B1_COD AS CODIGO "			 	+ STR_PULA
	cQuery += "	B1_DESC AS DECRICAO " 			+ STR_PULA
	cQuery += "	FROM " 							+ STR_PULA
	cQuery += " "+ RetSqlName("SB1") + ' SB1 '  + STR_PULA
	cQuery += " WHERE " 						+ STR_PULA
	cQuery += "	SB1.D_E_L_E_T_ = '' " 			+ STR_PULA
	cQuery += "	AND B1_MSBLQL = '2' " 			+ STR_PULA
	cQuery := ChangeQuery(cQuery)//CONVERSÃO DE ACORDO COM BANCO DE DADOS
	
	//EXECUTANDO A CONSULTA
	TCQuery cQuery New Alias "QRY_SB1"
	
	WHILE ! QRY_SB1->( EOF())
		cMsg += (QRY_SB1->B1_COD +"|"+ QRY_SB1->B1_DESC)
			MSGINFO(cMsg)
		QRY_SB1->(dbSkip())
	ENDDO
	
	QRY_SB1->(dbCloseArea())
	RestArea(aArea)
return