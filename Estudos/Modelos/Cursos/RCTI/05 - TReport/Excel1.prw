#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

User Function REXCEL()

	Processa({||MntQry() },,"Processando...")		
	MsAguarde({||GerExcel()},,"Gerando Arquivo Excel")
	
	dbSelectArea('TMP')
	dbCloseArea()
Return Nil

//CRIANDO SCRIPT
Static Function MntQry()

Local cQuery := ""


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

	IF Select ('TMP') <>0
		DbSelectArea('TMP')
		DbCloseArea()
	EndIF
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),'TMP',.F.,.T.)
	
//GERANDO EXCEL	
//http://tdn.totvs.com/display/framework/FWMsExcelEx
Static Function GerExcel()

	Local oExcel := FWMSExcel():New()
	Local lOK := .F.
	Local cArq := ""
	Local cDirTMP := "I:\ADVPL\"
	
	dbSelectArea('TMP')
	TMP->(dbGoTop())
	
	oExcel:AddworkSheet("PRODUTOS")//FWMsExcelEx():AddWorkSheet(< cWorkSheet >)-> NIL
	oExcel:AddTable ("PRODUTOS","RCTI")//FWMsExcelEx():AddTable(< cWorkSheet >, < cTable >)-> NIL
	oExcel:AddColumn("PRODUTOS","RCTI","CODIGO",1,1) //FWMsExcelEx():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)-> NIL
	oExcel:AddColumn("PRODUTOS","RCTI","DESCRICAO",1,1) 
	oExcel:AddColumn("PRODUTOS","RCTI","TIPO",1,1) 
	oExcel:AddColumn("PRODUTOS","RCTI","GRUPO",1,1) 
	oExcel:AddColumn("PRODUTOS","RCTI","BM_DESCRICAO",1,1) 
	oExcel:AddColumn("PRODUTOS","RCTI","BM_ORIGEM",1,1) 
	
		While TMP->(!EOF())
		
		oExcel:AddRow("PRODUTOS","RCTI",{TMP->(CODIGO),;
										 TMP->(DESCRICAO),;
										 TMP->(TIPO),;
										 TMP->(GRUPO),;
										 TMP->(BM_DESCRICAO),;
										 TMP->(BM_ORIGEM)}) 
			lOK := .T.
			TMP->(dbSkip())
			
		EndDo 
	
			oExcel:Activate()
			//http://tdn.totvs.com/display/public/PROT/Criatrab-+Retorna+arquivo+de+trabalho
			cArq := CriaTrab(Nil,.F.) + ".xml"
			oExcel:GetXMLFile(cArq)
			
		//https://terminaldeinformacao.com/knowledgebase/__copyfile/	
		IF __CopyFile(cArq,cDirTMP + cArq)
			IF lOK 
				oExcelApp := MSExcel():New()
				oExcelApp:WorkBooks:Open(cDirTMP + cArq)
				oExcelApp:SetVisible(.T.)
				oExcelApp:Destroy()
					MsgInfo("O arquivo foi gerado no diretório: " + cDirTMP + cArq + ". ")
			ENDIF
		
		ELSE
			MsgAlert("O arquivo Excel não foi gerado")
		
		ENDIF
	
Return Nil
