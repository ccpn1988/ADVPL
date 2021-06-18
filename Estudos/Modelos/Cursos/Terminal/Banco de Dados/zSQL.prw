#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.ch'

user function zSQL()
Local aArea := SB1->(GetArea())
Local cQuery := ""
Local aDados := {}

	cQuery := " SELECT B1_COD AS CODIGO, B1_DESC AS DESCRICAO " + CRLF
	cQuery += " FROM " + RetSqlName("SB1") + ' SB1 ' + CRLF//SB1010 - TOTVS.SB1000
	cQuery += " WHERE B1_MSBLQL = '2' "
	
	//EXECUTANDO A CONSULTA SQL
	TCQuery cQuery New Alias "TMP_C"
	//DbUseArea(.T., 'TOPCONN', TcQuery(,,cQuery),cQryAlias, .F., .T.)
	
	While ! TMP_C->(EOF())
		AADD(aDados, TMP_C->CODIGO)
		AADD(aDados, TMP_C->DESCRICAO)
		TMP_C->(DbSkip()) //PROXIMO REGISTRO
	ENDDO
	
		Alert(LEN(aDados))
		
		FOR nCount := 1 TO LEN(aDados)
			MsgInfo(aDados[nCount])
		Next nCount
		
	TMP_C->(dbCloseArea)//FECHA A TABELA TEMPORARIA	
	RestArea(aArea)
		
	
return

//--------------------------------------------------------------------------------------------------------------------------

User Function zSQL1()
	Local aArea := GetArea()
	Local cQuery := ""
	Local aDados := {}
	Private cQueryAlias := GetNextAlias()
	
	cQuery := " SELECT RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_VCTOEXP,RA_VCTEXP2" + CRLF
	cQuery += " FROM "+ RetSqlName("SRA")+ ' SRA ' + CRLF
	cQuery += " WHERE RA_FILIAL = '01' " + CRLF
	cQuery += " AND RA_ADMISSA BETWEEN '20150801' AND '20151130' " + CRLF
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), 'SRATMP', .F., .T.)
	SRATMP->(dbGoTop())
	
	WHILE ! SRATMP->( EOF())
		AADD(aDados,SRATMP->RA_FILIAL)
		AADD(aDados,SRATMP->RA_MAT)
		AADD(aDados,SRATMP->RA_NOME)
		AADD(aDados,SRATMP->RA_ADMISSA)
		AADD(aDados,SRATMP->RA_VCTOEXP)
		AADD(aDados,SRATMP->RA_VCTEXP2)
	SRATMP->(dbSkip())
	ENDDO
	
		MSGINFO(LEN(aDados)) //ARRAY TAMANHO 6
		
	FOR nCount := 1 TO LEN(aDados)
		MsgInfo(aDados[nCount])
	NEXT nCount
	
	(SRATMP)->(dbCloseArea)
	RestArea(aArea)
	
Return
		
//--------------------------------------------------------------------------------------------------------------------------

