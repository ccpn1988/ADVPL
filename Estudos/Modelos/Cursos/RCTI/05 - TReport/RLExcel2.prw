#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

User Function RLExcel2()

Local cPerg := "RLExcel2"

	AjustaSX1(cPerg)

IF !Pergunte(cPerg,.T.)
	Return Nil
EndIF

	MsgInfo("Este programa tem como objetivo imprimir relatórios em excel")

	Processa({||MntQry() },,"Processando...")		
	MsAguarde({||GerExcel()},,"Gerando Arquivo Excel")
	
	dbSelectArea('TR1')
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

	IF Select ('TR1') <>0
		DbSelectArea('TR1')
		DbCloseArea()
	EndIF
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),'TR1',.F.,.T.)
	TR1->(dbGoTop())
	
	
//GERANDO EXCEL	
//http://tdn.totvs.com/display/framework/FWMsExcelEx
Static Function GerExcel(cPerg)

	Local oExcel := FWMSExcel():New()
	Local lOK := .F.
	Local cArq := ""
	Local cDirTMP := "I:\ADVPL\"
	
	dbSelectArea('TR1')
	TR1->(dbGoTop())
	
	/*//ATRIBUINDO FONTES
	oExcel:SetFontSize(12)//TAMANHO FONTE
	oExcel:SetFont("Arial")//FONTE
	oExcel:SetTitleSizeFont(14)//FONTE DO TITULO
	oExcel:SetTitleBold(.T.)//TITULO EM NEGRITO
	oExcel:SetBgGeneralColor("#87CEEB")//COR DE FUNDO www.site112.com/tabela-cores-html
	oExcel:SetTitleFrColor("#C0C0C0")
	oExcel:SetLineFrColor("#F0F8FF")//Linha com uma cor
	oExcel:Set2LineFrColor("#FAF0E6")////linha com outra cor
*/	//ABA1
	oExcel:AddworkSheet("FINANCEIRO")
	oExcel:AddTable("FINANCEIRO","CADASTRO")
	oExcel:AddColumn("FINANCEIRO","CADASTRO","FILIAL",1,1) 
	oExcel:AddColumn("FINANCEIRO","CADASTRO","CLIENTE",1,1) 
	oExcel:AddColumn("FINANCEIRO","CADASTRO","LOJA",1,1) 
	oExcel:AddColumn("FINANCEIRO","CADASTRO","NOME_CLIENTE",1,1) 
	//ABA2
	oExcel:AddworkSheet("FIN")
	oExcel:AddTable("FIN","NOTAS")
	oExcel:AddColumn("FIN","NOTAS","PREFIXO",1,1) 
	oExcel:AddColumn("FIN","NOTAS","NF",1,1) 
	oExcel:AddColumn("FIN","NOTAS","PARCELA",1,1) 
	oExcel:AddColumn("FIN","NOTAS","TIPO",1,1) 
	oExcel:AddColumn("FIN","NOTAS","EMISSÃO",1,1) 
	oExcel:AddColumn("FIN","NOTAS","VENCIMENTO_REAL",1,1) 
	oExcel:AddColumn("FIN","NOTAS","VALOR",3,3) 
	
	
		While TR1->(!EOF())
		
		oExcel:AddRow("FINANCEIRO","CADASTRO",{TR1->(FILIAL),;
											  TR1->(CLIENTE),; 
											  TR1->(LOJA),; 
											  TR1->(NOME_CLIENTE)}) 								
											
		oExcel:AddRow("FIN","NOTAS",{TR1->(PREFIXO),;
									TR1->(NF),;
									TR1->(PARCELA),;
									TR1->(TIPO),;
									TR1->(STOD(EMISSAO)),; 
									TR1->(STOD(VENCIMENTO_REAL)),; 
									TR1->(VALOR)}) 										 
			
			lOK := .T.
			TR1->(dbSkip())
			
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
