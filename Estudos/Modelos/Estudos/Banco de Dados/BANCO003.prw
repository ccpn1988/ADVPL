#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TopConn.ch'

user function BANCO003()
	
	Local aArea := SB1->(GetArea())
	Local cQuery := ""
	Local aDados := {}
	
	cQuery := " SELECT " 
	cQuery += " SB1_COD AS CODIGO ,"
	cQuery += " B1_DESC AS DESCRICAO "
	cQuery += " FROM "
	cQuery += " "+ RetSQLName("SB1") + " SB1 "
	cQuery += " WHERE B1_MSBLQL != '1' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	
	// EXECUTANDO A CONSULTA ACIMA
	
	TCQuery cQuery New Alias "CCPN"
	
	While ! CCPN->(Eof())
		AADD(aDados, CCPN->CODIGO) //PREENCHE O ARRA
		AADD(aDados, CCPN->DESCRICAO)
	CCPN->(DBSkip()) //SAIR DA TABELA
		
	EndDo
	 
	Alert(Len(aDados))
	
	For nCount := 1 To Len (aDados)
		MsgInfo(aDados[nCount])
		Next nCount
		
	CCPN->(DBCloseArea)
	RestArea(aArea)
		
return