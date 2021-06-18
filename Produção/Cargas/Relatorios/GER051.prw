#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER051N

DESCRICAO: RELATORIO DE DESCONTO POR OBRA NO CLIENTE

ALTERACOES:
10/08/2015 - Desenvolvimento do fonte

/*/

User Function GER051            

Local oReport
Local cPerg := "GER051"

//Cria grupo de perguntas
f001(cPerg) 

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: f001

Descricao: Cria grupo de perguntas

Parametros:
- cPar1 - codigo do grupo de perguntas
------------------------------------------------------------------------------------------------
Alteracoes:
10/08/2015 - Helimar Tavares - Criacao do fonte
*/
Static Function f001(cPerg)

Local cItPerg	:= "00"
Local cMVCH 	:= "MV_CH0"
Local cMVPAR 	:= 'MV_PAR00"
Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}
Local cTitPer 	:= ""  


//---------------------------------------MV_PAR01--------------------------------------------------
cCpoPer := "A1_COD"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SA1"  //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"existcpo('SA1')",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Cliente.       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
10/08/2015 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2

//Declaracao do relatorio
oReport := TReport():New("GER051","GER051 - DESCONTO POR OBRA NO CLIENTE",cPerg,{|oReport| PrintReport(oReport)},"GER051 - DESCONTO POR OBRA NO CLIENTE")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Cliente","")
	
TRCell():New(oSection1,"A1_NOME","SA1","Tabela de preço com o percentual de desconto praticado no cliente")


//Secao do relatorio
oSection2 := TRSection():New(oSection1,"Produtos","")     

//Celulas da secao
TRCell():New(oSection2,"B1_ISBN"	,"SB1",,,15)
TRCell():New(oSection2,"B1_DESC"	,"SB1",,,40)
TRCell():New(oSection2,"Z1_SELO"	,"SX5","Selo",,10) 
TRCell():New(oSection2,"B5_DTPUBL"	,"SB5","Dt.Publicação",,10) 
TRCell():New(oSection2,"BM_DESC"	,"SBM",,,25) 
TRCell():New(oSection2,"Z5_SITOBRA"	,"SX5","Sit.Obra",,15)
TRCell():New(oSection2,"Z7_DESC"	,"SZ7","DESC_AREA",,15) 
TRCell():New(oSection2,"Z5_DESC"	,"SZ5","DESC_CURSOS",,15)
TRCell():New(oSection2,"Z6_DESC"	,"SZ6","DISCIPLINA",,15)
TRCell():New(oSection2,"DA1_PRCVEN"	,"DA1",,,10)
TRCell():New(oSection2,"Z2_PERCDES"	,"SZ2",,,10)
                      
//Faz a impressao do totalizador em linha
oSection2:SetTotalInLine(.f.)
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
10/08/2015 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local _cQuery   := ""
Local _cAlias1	:= GetNextAlias()            
Local xCliente  := ""

_cQuery := "SELECT A1_NOME, B1_ISBN, B1_DESC, XZ1.X5_DESCRI Z1_SELO, STOC(B5_XDTPUBL) B5_DTPUBL, BM_DESC, XZ5.X5_DESCRI Z5_SITOBRA,SZ7.Z7_DESC DESC_AREA,SZ5.Z5_DESC DESC_CURSOS,SZ6.Z6_DESC DISCIPLINA,NVL(DA1_PRCVEN,0) DA1_PRCVEN, Z2_PERCDES
_cQuery += "  FROM " + RetSqlName("SB1") + " SB1
_cQuery += "  JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "   	ON B5_COD = B1_COD 
_cQuery += "  LEFT JOIN " + RetSqlName("SZ7") + " SZ7
_cQuery += "   	ON Z7_AREA = B5_XAREA 
_cQuery += "   AND Z7_FILIAL = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ5") + " SZ5
_cQuery += "   	ON Z5_CURSO = B5_XCURSO 
_cQuery += "   AND Z5_FILIAL = ' '   
_cQuery += "  LEFT JOIN " + RetSqlName("SZ6") + " SZ6
_cQuery += "   	ON Z6_DISCIPL = B5_XDISCIP 
_cQuery += "   AND Z6_FILIAL = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ1
_cQuery += "   	ON XZ1.X5_CHAVE = B5_XSELO
_cQuery += "   AND XZ1.X5_TABELA = 'Z1'
_cQuery += "  LEFT JOIN " + RetSqlName("SBM") + " SBM
_cQuery += "   	ON BM_GRUPO = B1_GRUPO
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ5
_cQuery += "   	ON XZ5.X5_CHAVE = B1_XSITOBR
_cQuery += "   AND XZ5.X5_TABELA = 'Z5'
_cQuery += "  LEFT JOIN " + RetSqlName("DA1") + " DA1
_cQuery += "   	ON DA1_CODPRO = B1_COD
_cQuery += "  AND DA1_CODTAB ='"+GETMV("GEN_FAT064")+"'"
_cQuery += "  LEFT JOIN " + RetSqlName("SZ2") + " SZ2
_cQuery += "   	ON Z2_CLASSE = B1_GRUPO
_cQuery += "  JOIN " + RetSqlName("SA1") + " SA1
_cQuery += "   	ON A1_XTPDES = Z2_TIPO
_cQuery += "   AND A1_COD = '"+MV_PAR01+"'
_cQuery += "   AND A1_LOJA = '"+MV_PAR02+"'
_cQuery += " WHERE B1_XIDTPPU = '1'
_cQuery += "   AND B1_TIPO = 'PA'
_cQuery += "   AND B1_XSITOBR IN ('101','102','105')
_cQuery += " ORDER BY B1_PROC, XZ1.X5_DESCRI, B1_DESC


If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	xCliente := (_cAlias1)->A1_NOME

	oSection1:Init()  

	oSection1:Cell("A1_NOME"):SetValue((_cAlias1)->A1_NOME)
	
	oSection1:PrintLine()

	Do While !(_cAlias1)->(eof()) .And. (_cAlias1)->A1_NOME = xCliente .And. !oReport:Cancel()
 		oReport:IncMeter()
	
		oSection2:Init()

		oSection2:Cell("B1_ISBN"):SetValue((_cAlias1)->B1_ISBN)
		oSection2:Cell("B1_DESC"):SetValue((_cAlias1)->B1_DESC)
		oSection2:Cell("Z1_SELO"):SetValue((_cAlias1)->Z1_SELO)
		oSection2:Cell("B5_DTPUBL"):SetValue((_cAlias1)->B5_DTPUBL)
		oSection2:Cell("BM_DESC"):SetValue((_cAlias1)->BM_DESC)
		oSection2:Cell("Z5_SITOBRA"):SetValue((_cAlias1)->Z5_SITOBRA)
		oSection2:Cell("DA1_PRCVEN"):SetValue((_cAlias1)->DA1_PRCVEN)
		oSection2:Cell("Z2_PERCDES"):SetValue((_cAlias1)->Z2_PERCDES)   
		oSection2:Cell("Z7_DESC"):SetValue((_cAlias1)->DESC_AREA)
		oSection2:Cell("Z5_DESC"):SetValue((_cAlias1)->DESC_CURSOS)
		oSection2:Cell("Z6_DESC"):SetValue((_cAlias1)->DISCIPLINA)

		oSection2:PrintLine()

		(_cAlias1)->(dbSkip())		
	
	EndDo             
	oSection2:Finish()
EndDo
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()


Return(.t.)