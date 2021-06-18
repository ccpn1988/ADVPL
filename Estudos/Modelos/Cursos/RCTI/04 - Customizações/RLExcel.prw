#Include 'Protheus.ch'


/*/{Protheus.doc} rlexcel
Exemplo para gerar arquivo excel utilizando advpl
@type function
@author Curso Desenvolvendo relatórios com ADVPL - RCTI Treinamentos
@since 2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see www.rctitreinamentos.com.br
/*/
User Function RLExcel()

	Processa({||MntQry() },,"Processando...")
	MsAguarde({|| GeraExcel()},,"O arquivo Excel está sendo gerado...")
	
	dbSelectArea("TR1")
	dbCloseArea()

Return Nil

// Monstando a query SQL
Static Function MntQry()

	Local cQuery := ""
	
	//pegar os dados da base de dados
	
	cQuery := " SELECT "													
	cQuery += " 	SB1.B1_COD AS CODIGO, "											
	cQuery += " 	SB1.B1_DESC AS DESCRICAO, "										
	cQuery += " 	SB1.B1_TIPO AS TIPO, "										
	cQuery += " 	SBM.BM_GRUPO GRUPO, "										
	cQuery += " 	SBM.BM_DESC BM_DESCRICAO, "										
	cQuery += " 	SBM.BM_PROORI BM_ORIGEM"										
	cQuery += " FROM "													
	cQuery += " 	"+RetSQLName('SB1')+" SB1 "							
	cQuery += " 	INNER JOIN "+RetSQLName('SBM')+" SBM ON ( "		
	cQuery += " 		SBM.BM_FILIAL = '"+FWxFilial('SBM')+"' "		
	cQuery += " 		AND SBM.BM_GRUPO = B1_GRUPO "					
	cQuery += " 		AND SBM.D_E_L_E_T_='' "							
	cQuery += " 	) "														
	cQuery += " WHERE "													
	cQuery += " 	SB1.B1_FILIAL = '"+FWxFilial('SBM')+"' "			
	cQuery += " 	AND SB1.D_E_L_E_T_ = '' "							
	cQuery += " ORDER BY "												
	cQuery += " 	SB1.B1_COD "
	
		If Select("TR1") <> 0
			DbSelectArea("TR1")
			DbCloseArea()
		EndIf	
		
		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TR1',.F.,.T.)
		
Return Nil

/*** Função que gera o arquivo Excel: FWMSExcel()  ***/

Static Function GeraExcel()

	Local oExcel := FWMSEXCEL():New()
	Local lOK := .F.
	Local cArq := ""
	Local cDirTmp := "C:\SPOOL\"
	
	dbSelectArea("TR1")
	TR1->(dbGoTop())
	
	oExcel:AddWorkSheet("PRODUTOS")
	oExcel:AddTable("PRODUTOS","TESTE")
	oExcel:AddColumn("PRODUTOS","TESTE","CODIGO",1,1)
	oExcel:AddColumn("PRODUTOS","TESTE","DESCRICAO",1,1)
	oExcel:AddColumn("PRODUTOS","TESTE","TIPO",1,1)
	oExcel:AddColumn("PRODUTOS","TESTE","GRUPO",1,1)
	oExcel:AddColumn("PRODUTOS","TESTE","BM_DESCRICAO",1,1)
	oExcel:AddColumn("PRODUTOS","TESTE","BM_ORIGEM",1,1)
	
		While TR1->(!EOF())
		
			oExcel:AddRow("PRODUTOS","TESTE",{TR1->(CODIGO),;
													  TR1->(DESCRICAO),;
													  TR1->(TIPO),;
													  TR1->(GRUPO),;
													  TR1->(BM_DESCRICAO),;
													  TR1->(BM_ORIGEM)})
			lOK := .T.
			TR1->(dbSkip())
		
		EndDo
	oExcel:Activate()
	
		cArq := CriaTrab(NIL, .F.) + ".xml"
		oExcel:GetXMLFile(cArq)
		
			If __CopyFile(cArq,cDirTmp + cArq)
				If lOK
					oExcelApp := MSExcel():New()
					oExcelApp:WorkBooks:Open(cDirTmp + cArq)
					oExcelApp:SetVisible(.T.)
					oExcelApp:Destroy()
					
				MsgInfo("O arquivo Excel foi gerado no dirtério: " + cDirTmp + cArq + ". ")
					
				EndIf
				Else
						MsgAlert("Erro ao cpiar o arquivo Excel!!")
				EndIf
		

Return Nil



