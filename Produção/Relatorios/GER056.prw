#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER056N

DESCRICAO: RELATORIO DE NOVIDADES NAO RECEBIDAS

ALTERACOES:
17/09/2015 - Desenvolvimento do fonte

/*/

User Function GER056

Local oReport
Local cPerg := "GER056"

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
17/09/2015 - Helimar Tavares - Criacao do fonte
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
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))


PutSx1(cPerg, cItPerg, "Dt Emissão até:", "Dt Emissão até:","Dt Emissão até:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03-------------------------------------------------- 
cCpoPer := "D1_FORNECE"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Fornecedor ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SA2_B"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"vazio() .or. existcpo('SA2')",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Fornecedor.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------
cCpoPer := "A1_COD"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := "Cliente ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
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

//---------------------------------------MV_PAR06--------------------------------------------------
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
17/09/2015 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2

//Declaracao do relatorio
oReport := TReport():New("GER056","GER056 - NOVIDADES NÃO RECEBIDAS",cPerg,{|oReport| PrintReport(oReport)},"GER056 - NOVIDADES NÃO RECEBIDAS")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Cliente","")
	
TRCell():New(oSection1,"A1_NOME"		,"SA1",,,40)
TRCell():New(oSection1,"A1_CGC"			,"SA1",,,15)
TRCell():New(oSection1,"A1_EST"			,"SA1",,,5)
TRCell():New(oSection1,"TIPOCLIENTE"	,"SX5","Tipo",,20)
TRCell():New(oSection1,"A3_NOME"  		,"SA3","Vendedor",,20)


//Secao do relatorio
oSection2 := TRSection():New(oSection1,"Produtos","")     

//Celulas da secao
TRCell():New(oSection2,"B1_ISBN"		,"SB1",,,20)
TRCell():New(oSection2,"B1_DESC"		,"SB1",,,30)
TRCell():New(oSection2,"SELO"			,"SX5","Selo",,10) 
TRCell():New(oSection2,"DATAPUBL"		,"SB5","Data Publicação",,20) 
TRCell():New(oSection2,"TIPOPUBLICACAO"	,"SX5","Tipo Publicação",,20) 
TRCell():New(oSection2,"CATEGORIA"		,"SX5","Categoria",,15)
TRCell():New(oSection2,"AREA"			,"SX5","Área",,20)
TRCell():New(oSection2,"CURSO"	  		,"SX5","Curso",,25)
TRCell():New(oSection2,"DISCIPLINA"		,"SX5","Disciplina",,25)
TRCell():New(oSection2,"DA1_PRCVEN"	,"DA1",,,18)
TRCell():New(oSection2,"Z2_PERCDES"	,"SZ2",,,15)
                      
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
17/09/2015 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local _cQuery   := ""
Local _cAlias1	:= GetNextAlias()            
Local xCliente  := ""

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)

_cQuery := "SELECT A1_COD, A1_LOJA, A1_CGC, A1_NOME, A1_EST, XTP.X5_DESCRI TIPOCLIENTE, SA3.A3_NOME,
_cQuery += "       B1_ISBN, B1_DESC, TRIM(XZ1.X5_DESCRI) SELO, B5_XDTPUBL, TRIM(XZ4.X5_DESCRI) TIPOPUBLICACAO,
_cQuery += "       DECODE(BM_XCATEG, 'D', 'DID', 'P', 'PROF', 'I', 'INT.GER') ||' - '|| DECODE(B5_XTIPINC, 1, 'ON', 2, 'NE') CATEGORIA,
_cQuery += "       TRIM(Z7_DESC) AREA, TRIM(Z5_DESC) CURSO, TRIM(Z6_DESC) DISCIPLINA, DA1.DA1_PRCVEN, Z2_PERCDES
_cQuery += "  FROM (SELECT B1_COD
_cQuery += "          FROM " + RetSqlName("SB1") + " SB1
_cQuery += "          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "   		    ON SB1.B1_COD = SB5.B5_COD
_cQuery += "           AND B5_XDTPUBL BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "   		   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += "   		   AND SB5.D_E_L_E_T_ = ' '
_cQuery += "          JOIN " + RetSqlName("SA2") + " SA2
_cQuery += "            ON B1_PROC = A2_COD
_cQuery += "           AND B1_LOJPROC = A2_LOJA
If !Empty(MV_PAR03)
	_cQuery += "           AND A2_COD = '"+MV_PAR03+"'
EndIf
If !Empty(MV_PAR03)
	_cQuery += "           AND A2_LOJA = '"+MV_PAR04+"'
EndIf
_cQuery += "   		   AND SA2.A2_FILIAL = '" + xFilial("SA2") + "'"
_cQuery += "   		   AND SA2.D_E_L_E_T_ = ' '
_cQuery += "         WHERE B1_XSITOBR IN ('101','105')
_cQuery += "           AND B1_XIDTPPU NOT IN ('2','11','18','3','4','9','14','15','16','17','19','20','21','22','23','24','25','27')
_cQuery += "        MINUS   
_cQuery += "        SELECT DISTINCT D2_COD IDOBRA
_cQuery += "          FROM " + RetSqlName("SD2")
_cQuery += "         WHERE D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "           AND D2_CLIENTE = '"+MV_PAR05+"'
_cQuery += "           AND D2_LOJA = '"+MV_PAR06+"'
_cQuery += "           AND D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE (F4_DUPLIC = 'S' OR F4_PODER3 = 'R') AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ' )
_cQuery += "           AND D_E_L_E_T_ = ' ') O
_cQuery += "  JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "    ON O.B1_COD = SB1.B1_COD
_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery += "  JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "    ON SB1.B1_COD = SB5.B5_COD
_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ1
_cQuery += "    ON TRIM(XZ1.X5_CHAVE) = TRIM(B5_XSELO)
_cQuery += "   AND XZ1.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ1.X5_TABELA = 'Z1'
_cQuery += "   AND XZ1.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4
_cQuery += "    ON TRIM(XZ4.X5_CHAVE) = TRIM(B1_XIDTPPU)
_cQuery += "   AND XZ4.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ4.X5_TABELA = 'Z4'
_cQuery += "   AND XZ4.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SBM") + " SBM
_cQuery += "    ON BM_GRUPO = B1_GRUPO
_cQuery += "   AND BM_FILIAL = '" + xFilial("SBM") + "'"
_cQuery += "   AND SBM.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ7") + " SZ7
_cQuery += "    ON Z7_AREA = B5_XAREA
_cQuery += "   AND Z7_FILIAL = '" + xFilial("SZ7") + "'"
_cQuery += "   AND SZ7.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ5") + " SZ5
_cQuery += "    ON Z5_CURSO = B5_XCURSO
_cQuery += "   AND Z5_FILIAL = '" + xFilial("SZ5") + "'"
_cQuery += "   AND SZ5.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ6") + " SZ6
_cQuery += "    ON Z6_DISCIPL = B5_XDISCIP
_cQuery += "   AND Z6_FILIAL = '" + xFilial("SZ6") + "'"
_cQuery += "   AND SZ6.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("DA1") + " DA1
_cQuery += "    ON DA1_CODPRO = SB1.B1_COD
_cQuery += "   AND DA1_CODTAB = '"+GETMV("GEN_FAT064")+"'"
_cQuery += "   AND DA1_FILIAL = '" + xFilial("DA1") + "'"
_cQuery += "   AND DA1.D_E_L_E_T_ = ' '
_cQuery += "  JOIN " + RetSqlName("SA1") + " SA1
_cQuery += "    ON A1_COD = '"+MV_PAR05+"'
_cQuery += "   AND A1_LOJA = '"+MV_PAR06+"'
_cQuery += "  LEFT JOIN " + RetSqlName("SZ2") + " SZ2
_cQuery += "    ON Z2_CLASSE = SB1.B1_GRUPO
_cQuery += "   AND Z2_TIPO = A1_XTPDES
_cQuery += "   AND Z2_FILIAL = '" + xFilial("SZ2") + "'"
_cQuery += "   AND SZ2.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XTP
_cQuery += "    ON TRIM(SA1.A1_XTIPCLI) = TRIM(XTP.X5_CHAVE)
_cQuery += "   AND XTP.X5_TABELA = 'TP'
_cQuery += "   AND XTP.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XTP.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " SA3
_cQuery += "    ON A1_VEND = A3_COD
_cQuery += "   AND A3_FILIAL = '" + xFilial("SA3") + "'"
_cQuery += "   AND SA3.D_E_L_E_T_ = ' '
_cQuery += "ORDER BY B1_DESC

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	xCliente := (_cAlias1)->A1_NOME

	oSection1:Init()  

	oSection1:Cell("A1_NOME"):SetValue((_cAlias1)->A1_NOME)
	oSection1:Cell("A1_CGC"):SetValue((_cAlias1)->A1_CGC)
	oSection1:Cell("A1_EST"):SetValue((_cAlias1)->A1_EST)
	oSection1:Cell("TIPOCLIENTE"):SetValue((_cAlias1)->TIPOCLIENTE)
	oSection1:Cell("A3_NOME"):SetValue((_cAlias1)->A3_NOME)
	
	oSection1:PrintLine()

	Do While !(_cAlias1)->(eof()) .And. (_cAlias1)->A1_NOME = xCliente .And. !oReport:Cancel()
 		oReport:IncMeter()
	
		oSection2:Init()

	    xDtPubl := STOD((_cAlias1)->B5_XDTPUBL)

		oSection2:Cell("B1_ISBN"):SetValue((_cAlias1)->B1_ISBN)
		oSection2:Cell("B1_DESC"):SetValue((_cAlias1)->B1_DESC)
		oSection2:Cell("SELO"):SetValue((_cAlias1)->SELO)
		oSection2:Cell("DATAPUBL"):SetValue(xDtPubl)
		oSection2:Cell("TIPOPUBLICACAO"):SetValue((_cAlias1)->TIPOPUBLICACAO)
		oSection2:Cell("CATEGORIA"):SetValue((_cAlias1)->CATEGORIA)
		oSection2:Cell("AREA"):SetValue((_cAlias1)->AREA)
		oSection2:Cell("CURSO"):SetValue((_cAlias1)->CURSO)
		oSection2:Cell("DISCIPLINA"):SetValue((_cAlias1)->DISCIPLINA)
		oSection2:Cell("DA1_PRCVEN"):SetValue((_cAlias1)->DA1_PRCVEN)
		oSection2:Cell("Z2_PERCDES"):SetValue((_cAlias1)->Z2_PERCDES)

		oSection2:PrintLine()

		(_cAlias1)->(dbSkip())		
	
	EndDo             
	oSection2:Finish()
EndDo
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)