#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

User Function EXCFIN()

	Local cPerg := "EXCFIN"

AjustaSX1(cPerg)

IF !Pergunte(cPerg,.T.)
	Return Nil
EndIF

	Processa({||MntQry() },,"Processando...")		
	MsAguarde({||GerExcel()},,"Gerando Arquivo Excel")
	
	dbSelectArea('TMP')
	dbCloseArea()

Return Nil


Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= Sx1->(GetArea())
Local cItPerg 	:= "00"		//Ordem da Pergunta
Local cMVCH 	:= "MV_CH0" 
Local CMVPAR	:= "MV_PAR00"
Local aHelpPor	:= {}
Local aHelEng	:= {""}
Local aHelSpa	:= {""}
Local cTitPer	:= ""

//----------------------------------------------------------------------DEFINIÇÂO PERGUNTA 0 - MV_PAR01-------------------------------------------------------

cCpoPer	:= "E1_FILIAL"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1] //FILIAL TAMANHO
cTpoPer	:= "G" //G-get - C-combo
cOpc1	:= ""
cOpc2	:= ""

// CRIANDO TITULO E HELP DAS PERGUNTA
aHelpPor	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Informe o código da Filial")
AADD(aHelpPor,"De:")

//DEFININDO SEQUENCIAL DO CADASTRO DE PERGUNTA

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVCH,2))

//		   cGrupo cOrde    cDesPor	cDesSpa	cDesEng	 cVar	 cTipo   cTamanho cDecimal	nPreSel	cGSC	cValid  cF3 		cGrpSXG	cPyme	cVar01			cDef1Por cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por cDef3Spa	cDef3Eng	cDef4Por cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
u_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,	0,		0,       cTpoPer,""		,cF3Perg	,""		,""		,cMVPAR			,cOpc1	,""			,""			,""			,cOpc2			,""			,""			,""		,""			,""			,""		 ,""		,""			,""			,""			,""			,aHelpPor			,""			,""				 )


//----------------------------------------------------------------------DEFINIÇÂO PERGUNTA 02 - MV_PAR02-------------------------------------------------------

cCpoPer	:= "E1_FILIAL"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1] //FILIAL TAMANHO
cTpoPer	:= "G" //G-get - C-combo
cOpc1	:= ""
cOpc2	:= ""

// CRIANDO TITULO E HELP DAS PERGUNTA
aHelpPor	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Informe o código da Filial")
AADD(aHelpPor,"Até:")

//DEFININDO SEQUENCIAL DO CADASTRO DE PERGUNTA

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVCH,2))

//		   cGrupo cOrde    cDesPor	cDesSpa	cDesEng	 cVar	 cTipo   cTamanho cDecimal	nPreSel	cGSC	cValid  cF3 		cGrpSXG	cPyme	cVar01			cDef1Por cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por cDef3Spa	cDef3Eng	cDef4Por cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
u_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,	0,		0,       cTpoPer,""		,cF3Perg	,""		,""		,cMVPAR			,cOpc1	,""			,""			,""			,cOpc2			,""			,""			,""		,""			,""			,""		 ,""		,""			,""			,""			,""			,aHelpPor			,""		,""				 )


//----------------------------------------------------------------------DEFINIÇÂO PERGUNTA 03 - MV_PAR03-------------------------------------------------------

cCpoPer	:= "E1_VENCREA"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
nTamPer := TamSx3(cCpoPer)[1] //FILIAL TAMANHO
cTpoPer	:= "G" //G-get - C-combo
cOpc1	:= ""
cOpc2	:= ""

// CRIANDO TITULO E HELP DAS PERGUNTA
aHelpPor	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Informe data inicial")
AADD(aHelpPor,"do vencimento?:")

//DEFININDO SEQUENCIAL DO CADASTRO DE PERGUNTA

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVCH,2))

//		   cGrupo cOrde    cDesPor	cDesSpa	cDesEng	 cVar	 cTipo   cTamanho cDecimal	nPreSel	cGSC	cValid  cF3 		cGrpSXG	cPyme	cVar01			cDef1Por cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por cDef3Spa	cDef3Eng	cDef4Por cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
u_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,	0,		0,       cTpoPer,""		,""	,""		,""		,cMVPAR			,cOpc1	,""			,""			,""			,cOpc2			,""			,""			,""		,""			,""			,""		 ,""		,""			,""			,""			,""			,aHelpPor			,""			,""				 )

//----------------------------------------------------------------------DEFINIÇÂO PERGUNTA 04 - MV_PAR04-------------------------------------------------------

cCpoPer	:= "E1_VENCREA"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
nTamPer := TamSx3(cCpoPer)[1] //FILIAL TAMANHO
cTpoPer	:= "G" //G-get - C-combo
cOpc1	:= ""
cOpc2	:= ""

// CRIANDO TITULO E HELP DAS PERGUNTA
aHelpPor	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Informe data final")
AADD(aHelpPor,"do vencimento?:")

//DEFININDO SEQUENCIAL DO CADASTRO DE PERGUNTA

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVCH,2))

//		   cGrupo cOrde    cDesPor	cDesSpa	cDesEng	 cVar	 cTipo   cTamanho cDecimal	nPreSel	cGSC	cValid  cF3 		cGrpSXG	cPyme	cVar01			cDef1Por cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por cDef3Spa	cDef3Eng	cDef4Por cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
u_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,	0,		0,       cTpoPer,""		,""	,""		,""		,cMVPAR			,cOpc1	,""			,""			,""			,cOpc2			,""			,""			,""		,""			,""			,""		 ,""		,""			,""			,""			,""			,aHelpPor			,""			,""				 )




//CRIANDO SCRIPT
Static Function MntQry(cPerg)

Local cQuery := ""

_cParm2	:= DTOS(MV_PAR03)
_cParm3	:= DTOS(MV_PAR04)

cQuery := " SELECT " + CRLF
cQuery += " SE1.E1_FILIAL FILIAL, " + CRLF
cQuery += " SE1.E1_PREFIXO PREFIXO, " + CRLF
cQuery += " SE1.E1_NUM NF, " + CRLF
cQuery += " SE1.E1_PARCELA PARCELA," + CRLF
cQuery += " SE1.E1_TIPO TIPO, " + CRLF
cQuery += " SE1.E1_CLIENTE CLIENTE, " + CRLF
cQuery += " SE1.E1_LOJA LOJA, " + CRLF
cQuery += " SE1.E1_NOMCLI NOME_CLIENTE, " + CRLF
cQuery += " SE1.E1_EMISSAO EMISSAO, " + CRLF
cQuery += " SE1.E1_VENCREA VENCIMENTO_REAL," + CRLF
cQuery += " SE1.E1_VALOR VALOR " + CRLF
cQuery += " FROM " + RetSQLName("SE1")  + " SE1 " + CRLF
cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "'" + CRLF
cQuery += " AND SE1.E1_VENCREA BETWEEN '" + _cParm2 + "' AND '" + _cParm3 + "'" + CRLF
cQuery += " AND SE1.E1_TIPO IN ('NF','NCC') " + CRLF
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "

	IF Select ('TMP') <>0
		DbSelectArea('TMP')
		DbCloseArea()
	EndIF
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),'TMP',.F.,.T.)
	TMP->(dbGoTop())
	
	
//GERANDO EXCEL	
//http://tdn.totvs.com/display/framework/FWMsExcelEx
Static Function GerExcel(cPerg)

	Local oExcel := FWMSExcel():New()
	Local lOK := .F.
	Local cArq := ""
	Local cDirTMP := "I:\ADVPL\"
	
	dbSelectArea('TMP')
	TMP->(dbGoTop())
	
	oExcel:AddworkSheet("FINANCEIRO")//FWMsExcelEx():AddWorkSheet(< cWorkSheet >)-> NIL
	oExcel:AddTable ("FINANCEIRO","RCTI")//FWMsExcelEx():AddTable(< cWorkSheet >, < cTable >)-> NIL
	oExcel:AddColumn("FINANCEIRO","RCTI","FILIAL",1,1) //FWMsExcelEx():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)-> NIL
	oExcel:AddColumn("FINANCEIRO","RCTI","PREFIXO",1,1) 
	oExcel:AddColumn("FINANCEIRO","RCTI","NF",1,1) 
	oExcel:AddColumn("FINANCEIRO","RCTI","PARCELA",1,1) 
	oExcel:AddColumn("FINANCEIRO","RCTI","TIPO",1,1) 
	oExcel:AddColumn("FINANCEIRO","RCTI","CLIENTE",1,1) 
	oExcel:AddColumn("FINANCEIRO","RCTI","LOJA",1,1) 
	oExcel:AddColumn("FINANCEIRO","RCTI","NOME_CLIENTE",1,1) 
	oExcel:AddColumn("FINANCEIRO","RCTI","EMISSÃO",1,1) 
	oExcel:AddColumn("FINANCEIRO","RCTI","VENCIMENTO_REAL",1,1) 
	oExcel:AddColumn("FINANCEIRO","RCTI","VALOR",1,1) 
	
		While TMP->(!EOF())
		
		oExcel:AddRow("FINANCEIRO","RCTI",{TMP->(FILIAL),;
										 TMP->(PREFIXO),;
										 TMP->(NF),;
										 TMP->(PARCELA),;
										 TMP->(TIPO),;
										 TMP->(CLIENTE),; 
										 TMP->(LOJA),; 
										 TMP->(NOME_CLIENTE),; 
										 TMP->(EMISSAO),; 
										 TMP->(VENCIMENTO_REAL),; 
										 TMP->(VALOR)}) 
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
