#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TopConn.ch'

//http://tdn.totvs.com/display/framework/Desenvolvendo+queries+no+Protheus


//PESQUISAR REGISTRO UNICO
user function zSql()
	Local aArea := GetArea()
	Local cMsg := ""
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	
	//FILTRA O INDICE DEFINIDO
	
	/*IF SB1->(dbSeek(FWxFilial("SB1")+'0000001')) 
		Alert(SB1->B1_DESC)
	ENDIF*/
	
	cMsg:= Posicione("SB1",1,FWxFilial("SB1")+'0000001','SB1->B1_DESC')
	
	Alert("Descrição Produto: " + cMsg,"AVISO")
	
	RestArea(aArea)
return

//UTILIZANDO QUERY

User Function zSqlII()
Local aArea := SB1->(GetArea())
Local cQuery := ""
Local aDados := {}


	cQuery := " SELECT " 
	cQuery += " SB1.B1_COD, SB1.B1_DESC " 
	cQuery += " FROM "  
	cQuery += " " + RetSQLName("SB1")+ ' SB1 ' 
	cQuery += " WHERE " 
	cQuery += " SB1.B1_MSBLQL != '1' " 
	cQuery += ChangeQuery(cQuery)
	
	TcQuery cQuery New Alias "TMP_SB1"
	
	//DbUseArea(.T., "TOPCONN", TCGenQry(NIL,NIL,cQuery), ("TMP_SB1") , .F., .T. )
	
	DbSelectArea("TMP_SB1")
	
	While ! TMP_SB1->(EOF())
		AADD(aDados,TMP_SB1->B1_COD)
		AADD(aDados,TMP_SB1->B1_DESC)
			TMP_SB1->(DbSkip())
	EndDo
	
	Alert(Len(aDados))
	
		For nCount := 1 To Len(aDados)
			MsgInfo(aDados[nCount])
		Next nCount
		
	TMP_SB1->(DbCloseArea())	
	RestArea(aArea)
	

Return


User Function zSQLRA()
Local aArea 	:= GetArea()
Local aDados	:= {}
Local cAliasSRA := GetNextAlias()
Local cMsg 		:= ""
Local cQuery 	:= ""
Local cMat		:= '005929'
Local cNome		:= 'CAIO CESAR PEREIRA NEVES'

	BeginSql alias cAliasSRA
		SELECT 
			SRA.RA_FILIAL,
			SRA.RA_NOME, 
			SRA.RA_MAT 
		FROM 
			%Table:SRA% SRA
		WHERE 
			SRA.RA_FILIAL = %xFilial:SRA% AND
			SRA.RA_MAT = %Exp:cMat% AND
			SRA.RA_NOME = %Exp:cNome% AND
			SRA.%notDel%
	EndSql

	
	While ! (cAliasSRA)->(EOF())
		AADD(aDados,(cAliasSRA)->RA_NOME)
		AADD(aDados,(cAliasSRA)->RA_MAT)
			(cAliasSRA)->(DbSkip())
	EndDo
	
		
		For nCount := 1 To Len(aDados)
			MsgInfo(aDados[nCount])
		Next nCount
		
	(cAliasSRA)->(DbCloseArea())	
	RestArea(aArea)

		
Return