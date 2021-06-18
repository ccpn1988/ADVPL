#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

user function REXCEL()
		
	
return

Static Function MntQry()

Local cQuery := ""
Local cAlias := GetNextAlias()

	cQuery := " SELECT "
	cQuery += " SB1.B1_COD AS CODIGO, " 
	cQuery += " SB1.B1_DESC AS DESCRICAO, "
	cQuery += " SB1.B1_TIPO AS TIPO, "
	cQuery += " SBM.BM_GRUPO GRUPO, "
	cQuery += " SBM.BM_DESC BM_DESCRICAO, "
	cQuery += " SBM.BM_PROORI BM_ORIGEM "
	cQuery += " FROM "
	cQuery += " "+RetSQLName ('SB1') + " SB1 "
	cQuery += " 	INNER JOIN "+RetSQLName ('SBM') + " SBM  ON ( "
	cQuery += " 		SBM.BM_FILIAL = '"+FWxFilial('SBM')+"' "
	cQuery += " 		AND SBM.BM_GRUPO = B1_GRUPO "
	cQuery += " 		AND SBM.D_E_L_E_T_ = ' ' "
	cQuery += " 		) "
	cQuery += " WHERE "
	cQuery += " 	SB1.B1_FILIAL = '"+FWxFilial('SB1')+"' "
	cQuery += " 	AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY "
	cQuery += " 	SB1.B1_COD "

	IF Select (cAlias) >0
		DbSelectArea(cAlias)
		DbCloseArea()
	EndIF
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.F.,.T.)
	
	

Return