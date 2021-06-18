#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: FEC030N

DESCRICAO: FEC030 - FECHAMENTO ANUAL -  VENDAS ANUAIS EM QUANTIDADES

ALTERACOES:
11/12/2015 - Desenvolvimento do fonte

/*/

User Function FEC030

Local oReport
Local cPerg := "FEC030"

//Cria grupo de perguntas
f001(cPerg) 

//Carrega grupo de perguntas
If Pergunte(cPerg,.T.)

	oReport := ReportDef(cPerg)
	oReport:PrintDialog()
Endif

Return

/*
Funcao: f001

Descricao: Cria grupo de perguntas

Parametros:
- cPar1 - codigo do grupo de perguntas
------------------------------------------------------------------------------------------------
Alteracoes:
11/12/2015 - Helimar Tavares - Criacao do fonte
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
cTpoCpo := "D"
cTitPer := "Data "                                               
nTamPer := 8                                                                              
cTpoPer := "G"

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH , cTpoCpo, nTamPer, 0, 0, cTpoPer,"", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
cCpoPer := "B1_PROC"                	
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
AADD(aHelpPor,"serão consideradas todas as   ")
AADD(aHelpPor,"opções.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo, nTamPer, 0, 0, cTpoPer, "vazio() .or. existcpo('SA2')", cF3Perg, "", "", cMVPAR, cOpc1,"","","", cOpc2,"","","","","","","","","","","", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Fornecedor.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH, "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return


/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
11/12/2015 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Public _cData

_cParm2 := MV_PAR02

cAlias := GetNextAlias()
If _cParm2 <> ' '
	cQuery := "SELECT MAX(B9_DATA) DATA
	cQuery += "  FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
	cQuery += " WHERE SB9.B9_COD = SB1.B1_COD
	cQuery += "   AND SB9.B9_LOCAL = '01'
	cQuery += "   AND SB9.B9_FILIAL = DECODE('"+ _cParm2+"','0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	cQuery += "   AND SB9.D_E_L_E_T_ = ' '
Else
	cQuery := "SELECT MAX(B9_DATA) DATA
	cQuery += "  FROM " + RetSqlName("SB9")
	cQuery += " WHERE B9_LOCAL = '01'
	cQuery += "   AND B9_FILIAL IN ('2022','3022','4022','6022','9022','1022')
	cQuery += "   AND D_E_L_E_T_ = ' '
EndIf
	
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
dbSelectArea(cAlias)
dbGoTop()

Do While !(cAlias)->(Eof())
	_cData := (cAlias)->DATA
	(cAlias)->(dbSkip())
Enddo
fErase(cAlias)

_cAno   := YEAR2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

//Declaracao do relatorio
oReport := TReport():New("FEC030","FEC030 - Fechamento Anual - Vendas Anuais em Quantidades",cPerg,{|oReport| PrintReport(oReport)},"FEC030 - Fechamento Anual - Vendas Anuais em Quantidades",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"FEC030 - Fechamento Anual - Vendas Anuais em Quantidades","")
	
//Celulas da secao
TRCell():New(oSection1,"VENDA"				,"","VENDA R$",,18,,,,,"RIGHT")
TRCell():New(oSection1,"PERCTOTAL"			,"","% s/TOT",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"PERCACUMULADO"		,"","% ACU",,,,,,,"RIGHT") 
TRCell():New(oSection1,"REIMP"				,""," ",,4) 
TRCell():New(oSection1,"ISBN"				,"","ISBN",,18)
TRCell():New(oSection1,"DESCRICAO"			,"","DESCRIÇÃO",,25)
TRCell():New(oSection1,"DATAPUBLICA"		,"","PUBLICAÇÃO")
TRCell():New(oSection1,"ACUANO"				,"","ACC "+_cAno,,12)
TRCell():New(oSection1,"ACUANOANT"			,"","TOTAL "+_cAnoAnt,,15)
TRCell():New(oSection1,"PERC"				,"","PERC",,13,,,,,"RIGHT")
TRCell():New(oSection1,"QTDE"				,"","SALDO EM "+_cData,,10,,,,,"RIGHT")
TRCell():New(oSection1,"QTDJAN"				,"","JAN",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDFEV"				,"","FEV",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDMAR"				,"","MAR",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDABR"				,"","ABR",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDMAI"				,"","MAI",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDJUN"				,"","JUN",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDJUL"				,"","JUL",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDAGO"				,"","AGO",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDSET"				,"","SET",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDOUT"				,"","OUT",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDNOV"				,"","NOV",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDDEZ"				,"","DEZ",,10,,,,,"RIGHT") 
TRCell():New(oSection1,"EDITORAORIGINAL"	,"","EDITORA ORIGINAL")
TRCell():New(oSection1,"ESTRANGEIRA"		,"","ESTRANGEIRA")
TRCell():New(oSection1,"TOTCUSTO"			,"","TOT CUSTO")
TRCell():New(oSection1,"DESCRICAOORIGINAL"	,"","DESCRIÇÃO ORIGINAL")
TRCell():New(oSection1,"AUTORPRINC"			,"","AUTOR PRINCIPAL")
TRCell():New(oSection1,"IDAUTOR"			,"","AUTOR")
TRCell():New(oSection1,"DESCAUTOR"			,"","DESCRIÇÃO AUTOR")
TRCell():New(oSection1,"CUSTO"				,"","CUSTO EM "+_cData)
TRCell():New(oSection1,"DIDATICA"			,"","D/P")
TRCell():New(oSection1,"PRECO"				,"","PREÇO")
TRCell():New(oSection1,"TIPOINCLUSAO"		,"","TIPO INCLUSÃO")
TRCell():New(oSection1,"TIPOPUBLICACAO"		,"","TIPO PUBLICAÇÃO")
TRCell():New(oSection1,"SITUACAOEBOOK"		,"","SITUAÇÃO E-BOOK")

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
11/12/2015 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cQuery	:= ""
Local lPlanilha := oReport:nDevice == 4
Local aResult   := {}
 
_cParm1 := DTOS(MV_PAR01)
_cAno   := YEAR2STR(MV_PAR01)
_cMes   := MONTH2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

If AnoMes(MV_PAR01) >= AnoMes(Date())
	MsgInfo('Esse relatório é mês fechado, informe uma data anterior ao mês corrente!')
Else	
	_cQuery := "SELECT SUM(VENDA) VENDA, ' ' PERCTOTAL, ' ' PERCACUMULADO, ' ' REIMP,
	_cQuery += "       ' ' ISBN, ' ' DESCRICAO, ' ' DATAPUBLICA, SUM(ACUANO) ACUANO, SUM(ACUANOANT) ACUANOANT, ' ' PERC, SUM(QTDE) QTDE,
	_cQuery += "       SUM(QTDJAN) QTDJAN, SUM(QTDFEV) QTDFEV, SUM(QTDMAR) QTDMAR, SUM(QTDABR) QTDABR, SUM(QTDMAI) QTDMAI, SUM(QTDJUN) QTDJUN,
	_cQuery += "       SUM(QTDJUL) QTDJUL, SUM(QTDAGO) QTDAGO, SUM(QTDSET) QTDSET, SUM(QTDOUT) QTDOUT, SUM(QTDNOV) QTDNOV, SUM(QTDDEZ) QTDDEZ,
	_cQuery += "       ' ' EDITORAORIGINAL, ' ' ESTRANGEIRA, ' ' TOTCUSTO, ' ' DESCRICAOORIGINAL, ' ' AUTORPRINC, ' ' IDAUTOR, ' ' DESCAUTOR,
	_cQuery += "       ' ' CUSTO, ' ' DIDATICA, ' ' PRECO, ' ' TIPOINCLUSAO, ' ' TIPOPUBLICACAO, ' ' SITUACAOEBOOK
	_cQuery += "  FROM (
	_cQuery += "SELECT SUM(DECODE(VMO.ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VMO.VLRJAN,
	_cQuery += "                                                              '02', VMO.VLRJAN+VMO.VLRFEV,
	_cQuery += "                                                              '03', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR,
	_cQuery += "                                                              '04', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR,
	_cQuery += "                                                              '05', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI,
	_cQuery += "                                                              '06', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN,
	_cQuery += "                                                              '07', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+
	_cQuery += "                                                                    VMO.VLRJUL,
	_cQuery += "                                                              '08', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+
	_cQuery += "                                                                    VMO.VLRJUL+VMO.VLRAGO,
	_cQuery += "                                                              '09', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+
	_cQuery += "                                                                    VMO.VLRJUL+VMO.VLRAGO+VMO.VLRSET,
	_cQuery += "                                                              '10', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+
	_cQuery += "                                                                    VMO.VLRJUL+VMO.VLRAGO+VMO.VLRSET+VMO.VLROUT,
	_cQuery += "                                                              '11', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+
	_cQuery += "                                                                    VMO.VLRJUL+VMO.VLRAGO+VMO.VLRSET+VMO.VLROUT+VMO.VLRNOV,
	_cQuery += "                                                              '12', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+
	_cQuery += "                                                                    VMO.VLRJUL+VMO.VLRAGO+VMO.VLRSET+VMO.VLROUT+VMO.VLRNOV+VMO.VLRDEZ, 0), 0)) VENDA,
	_cQuery += "       TRIM(XZ5.X5_DESCSPA) DESCREDUZIDA, TO_NUMBER(TRIM(B1_COD)) IDOBRA,
	_cQuery += "       SUM(DECODE(VMO.ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VMO.QTDJAN,
	_cQuery += "                                                              '02', VMO.QTDJAN+VMO.QTDFEV,
	_cQuery += "                                                              '03', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR,
	_cQuery += "                                                              '04', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR,
	_cQuery += "                                                              '05', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI,
	_cQuery += "                                                              '06', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN,
	_cQuery += "                                                              '07', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                    VMO.QTDJUL,
	_cQuery += "                                                              '08', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                    VMO.QTDJUL+VMO.QTDAGO,
	_cQuery += "                                                              '09', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                    VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET,
	_cQuery += "                                                              '10', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                    VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT,
	_cQuery += "                                                              '11', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                    VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV,
	_cQuery += "                                                              '12', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                    VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV+VMO.QTDDEZ, 0), 0)) ACUANO,
	_cQuery += "       SUM(DECODE(VMO.ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VMO.QTDJAN,
	_cQuery += "                                                                 '02', VMO.QTDJAN+VMO.QTDFEV,
	_cQuery += "                                                                 '03', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR,
	_cQuery += "                                                                 '04', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR,
	_cQuery += "                                                                 '05', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI,
	_cQuery += "                                                                 '06', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN,
	_cQuery += "                                                                 '07', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                       VMO.QTDJUL,
	_cQuery += "                                                                 '08', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                       VMO.QTDJUL+VMO.QTDAGO,
	_cQuery += "                                                                 '09', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                       VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET,
	_cQuery += "                                                                 '10', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                       VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT,
	_cQuery += "                                                                 '11', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                       VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV,
	_cQuery += "                                                                 '12', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                                                                       VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV+VMO.QTDDEZ, 0), 0)) ACUANOANT,
	_cQuery += "       SB9.QTDE,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', QTDJAN, 0)) QTDJAN,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 2 THEN QTDFEV ELSE 0 END, 0)) QTDFEV,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 3 THEN QTDMAR ELSE 0 END, 0)) QTDMAR,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 4 THEN QTDABR ELSE 0 END, 0)) QTDABR,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 5 THEN QTDMAI ELSE 0 END, 0)) QTDMAI,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 6 THEN QTDJUN ELSE 0 END, 0)) QTDJUN,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 7 THEN QTDJUL ELSE 0 END, 0)) QTDJUL,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 8 THEN QTDAGO ELSE 0 END, 0)) QTDAGO,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 9 THEN QTDSET ELSE 0 END, 0)) QTDSET,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 10 THEN QTDOUT ELSE 0 END, 0)) QTDOUT,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 11 THEN QTDNOV ELSE 0 END, 0)) QTDNOV,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 12 THEN QTDDEZ ELSE 0 END, 0)) QTDDEZ,
	_cQuery += "       TRIM(SB1.B1_DESC) DESCRICAO, TRIM(SB5.B5_XDESORI) DESCRICAOORIGINAL, DA.D41_ST_OBRA_ESTRANGEIRA ESTRANGEIRA,
	_cQuery += "       DA.V02_TX_AUTOR EDITORAORIGINAL,  TRIM(SB5.B5_XAUTOR) AUTORPRINC, SB9.B9_CM1 CUSTO, TRIM(SBM.BM_DESC) DESCCLASSEOBRA,
	_cQuery += "       SBM.BM_XCATEG DIDATICA, DA1.DA1_PRCVEN PRECO,
	_cQuery += "       DA.V04_ID_DETENTOR IDAUTOR, DA.V04_TX_NOME_COMPLETO DESCAUTOR, STOC(SB5.B5_XDTPUBL) DATAPUBLICA, 
	_cQuery += "       DA.D23_DT_EXPIRACAO DATAEXPIRACAODIREITO, SB1.B1_ISBN ISBN, DA.D41_TX_ISBN_ORIGINAL ISBNORIGEM,
	_cQuery += "       DA.D23_DT_ASSINATURA_CONTRATO DATACONTRATO, TRIM(SB5.B5_CEME) DESCRICAOCOMPLETA,
	_cQuery += "       DECODE(SB5.B5_XTIPINC, '1', 'OBRA NOVA', '2', 'NOVA EDIÇÃO') TIPOINCLUSAO, XZ4.X5_DESCRI TIPOPUBLICACAO, DA.D62_TX_OBSERVACAO SITUACAOEBOOK
	_cQuery += "  FROM " + RetSqlName("SB1") + " SB1
	_cQuery += "  JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "    ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "   AND B5_XFEC = '1'
	_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
	_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ5
	_cQuery += "    ON XZ5.X5_CHAVE = SB1.B1_XSITOBR
	_cQuery += "   AND XZ5.X5_TABELA = 'Z5'
	_cQuery += "   AND XZ5.X5_FILIAL = '" + xFilial("SX5") + "'"
	_cQuery += "   AND XZ5.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN DBA_EGK.VENDAMESOBRA VMO
	_cQuery += "    ON VMO.IDOBRAHISTORICO = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
	_cQuery += "   AND VMO.ANO >= '"+ _cAnoAnt+"'"
	_cQuery += "  LEFT JOIN (SELECT SB9.B9_COD, SB9.B9_CM1, SUM(SB9.B9_QINI) QTDE
	_cQuery += "               FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
	_cQuery += "              WHERE SB9.B9_COD = SB1.B1_COD
	_cQuery += "                AND SB9.B9_FILIAL = DECODE(SB1.B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','378803 ','1022')
	_cQuery += "                AND SB9.B9_LOCAL = '01'
	_cQuery += "                AND SB9.B9_DATA = '"+ _cData+"'"
	_cQuery += "                AND SB9.D_E_L_E_T_ = ' '
	_cQuery += "                AND SB1.D_E_L_E_T_ = ' '
	_cQuery += "              GROUP BY SB9.B9_COD, SB9.B9_CM1) SB9
	_cQuery += "    ON SB9.B9_COD = SB1.B1_COD
	_cQuery += "  LEFT JOIN " + RetSqlName("SBM") + " SBM
	_cQuery += "    ON SB1.B1_GRUPO = SBM.BM_GRUPO
	_cQuery += "   AND SBM.BM_FILIAL = '" + xFilial("SBM") + "'"
	_cQuery += "   AND SBM.D_E_L_E_T_ = ' '
	_cQuery += "  JOIN DBA_EGK.TT_PARAMETROS P
	_cQuery += "    ON P.VARIAVEL = 'GEN_FAT064'
	_cQuery += "  LEFT JOIN " + RetSqlName("DA1") + " DA1
	_cQuery += "    ON DA1.DA1_CODPRO = SB1.B1_COD
	_cQuery += "   AND DA1.DA1_CODTAB = P.CONTEUDO
	_cQuery += "   AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "'"
	_cQuery += "   AND DA1.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4                                                                                        
	_cQuery += "    ON XZ4.X5_CHAVE = SB1.B1_XIDTPPU
	_cQuery += "   AND XZ4.X5_TABELA = 'Z4'
	_cQuery += "   AND XZ4.X5_FILIAL = '" + xFilial("SX5") + "'"
	_cQuery += "   AND XZ4.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN (SELECT DISTINCT V02.V02_CD_OBRA, V02.V02_TX_AUTOR, D23.D23_DT_EXPIRACAO, D23.D23_DT_ASSINATURA_CONTRATO,
	_cQuery += "                    V04.V04_ID_DETENTOR, V04.V04_TX_NOME_COMPLETO, D41.D41_ST_OBRA_ESTRANGEIRA, D41.D41_TX_ISBN_ORIGINAL, D62.D62_TX_OBSERVACAO
	_cQuery += "               FROM GUA_DA.DAU_V02_OBRAS V02, 
	_cQuery += "                    (SELECT * FROM GUA_DA.DAU_D23_CONTRATOS WHERE D22_ID_STATUS_CONTRATO IN (1)) D23,
	_cQuery += "                    GUA_DA.DAU_D24_CONTRATO_TIPO_DETENTOR D24, 
	_cQuery += "                    (SELECT * FROM GUA_DA.DAU_D26_CONTRATO_DETENTORES WHERE D26_ST_AUTOR_PRINCIPAL = 'S') D26,
	_cQuery += "                    GUA_DA.DAU_V04_DETENTORES V04, GUA_DA.DAU_D41_OBRA D41,
	_cQuery += "                    (SELECT * FROM GUA_DA.DAU_D49_CONTRATO_PERMISSAO WHERE D27_ID_PERMISSAO = 3) D49,
	_cQuery += "                    GUA_DA.DAU_D62_PERMISSOES_OBSERVACOES D62
	_cQuery += "              WHERE V02.V02_CD_OBRA = D23.V02_CD_OBRA (+)
	_cQuery += "                AND D23.D23_ID_CONTRATO = D24.D23_ID_CONTRATO (+)
	_cQuery += "                AND D24.D24_ID_CONTRATO_TIPO_DETENTOR = D26.D24_ID_CONTRATO_TIPO_DETENTOR
	_cQuery += "                AND D26.V04_ID_DETENTOR = V04.V04_ID_DETENTOR (+)
	_cQuery += "                AND D23.V02_CD_OBRA = D41.V02_CD_OBRA (+)
	_cQuery += "                AND D23.D23_ID_CONTRATO = D49.D23_ID_CONTRATO (+)
	_cQuery += "                AND D49.D62_ID_PERMISSAO_OBSERVACAO = D62.D62_ID_PERMISSAO_OBSERVACAO (+)) DA
	_cQuery += "  ON TO_NUMBER(TRIM(B1_COD)) = DA.V02_CD_OBRA
	_cQuery += " WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
	If !Empty(MV_PAR02)
		_cQuery += "   AND SB1.B1_PROC = '"+MV_PAR02+"'
	Endif 
	If !Empty(MV_PAR03)
		_cQuery += "   AND SB1.B1_LOJPROC = '"+MV_PAR03+"'
	Endif
	_cQuery += "HAVING SUM(VMO.VLRJAN) <> 0 OR SUM(VMO.VLRFEV) <> 0 OR SUM(VMO.VLRMAR) <> 0 OR SUM(VMO.VLRABR) <> 0 OR SUM(VMO.VLRMAI) <> 0 OR SUM(VMO.VLRJUN) <> 0 OR
	_cQuery += "       SUM(VMO.VLRJUL) <> 0 OR SUM(VMO.VLRAGO) <> 0 OR SUM(VMO.VLRSET) <> 0 OR SUM(VMO.VLROUT) <> 0 OR SUM(VMO.VLRNOV) <> 0 OR SUM(VMO.VLRDEZ) <> 0
	_cQuery += " GROUP BY XZ5.X5_DESCSPA, TO_NUMBER(TRIM(B1_COD)), SB9.QTDE,
	_cQuery += "         TRIM(SB1.B1_DESC), TRIM(SB5.B5_XDESORI), DA.D41_ST_OBRA_ESTRANGEIRA,
	_cQuery += "         DA.V02_TX_AUTOR,  TRIM(SB5.B5_XAUTOR), SB9.B9_CM1, TRIM(SBM.BM_DESC),
	_cQuery += "         SBM.BM_XCATEG, DA1.DA1_PRCVEN,
	_cQuery += "         DA.V04_ID_DETENTOR, DA.V04_TX_NOME_COMPLETO, STOC(SB5.B5_XDTPUBL), 
	_cQuery += "         DA.D23_DT_EXPIRACAO, SB1.B1_ISBN, DA.D41_TX_ISBN_ORIGINAL,
	_cQuery += "         DA.D23_DT_ASSINATURA_CONTRATO, TRIM(SB5.B5_CEME),
	_cQuery += "         DECODE(SB5.B5_XTIPINC, '1', 'OBRA NOVA', '2', 'NOVA EDIÇÃO'), XZ4.X5_DESCRI, DA.D62_TX_OBSERVACAO
	_cQuery += "       )
	
	If Select(_cAlias1) > 0
		dbSelectArea(_cAlias1)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)
	
	Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
		oReport:IncMeter()
	
		oSection1:Init()  
	                         
		oSection1:Cell("VENDA"):SetValue("R$ " + Transform((_cAlias1)->VENDA, "@E 999,999,999.99"))
		oSection1:Cell("PERCTOTAL"):SetValue((_cAlias1)->PERCTOTAL)
		oSection1:Cell("PERCACUMULADO"):SetValue((_cAlias1)->PERCACUMULADO)
		oSection1:Cell("REIMP"):SetValue((_cAlias1)->REIMP) 
		oSection1:Cell("ISBN"):SetValue((_cAlias1)->ISBN)
		oSection1:Cell("DESCRICAO"):SetValue((_cAlias1)->DESCRICAO)
		oSection1:Cell("DATAPUBLICA"):SetValue((_cAlias1)->DATAPUBLICA)
		oSection1:Cell("ACUANO"):SetValue(Transform((_cAlias1)->ACUANO,"@E 9,999,999"))
		oSection1:Cell("ACUANOANT"):SetValue(Transform((_cAlias1)->ACUANOANT,"@E 9,999,999"))
		oSection1:Cell("PERC"):SetValue((_cAlias1)->PERC)
		oSection1:Cell("QTDE"):SetValue(Transform((_cAlias1)->QTDE,"@E 9,999,999"))
		oSection1:Cell("QTDJAN"):SetValue(Transform((_cAlias1)->QTDJAN,"@E 9,999,999"))
		oSection1:Cell("QTDFEV"):SetValue(Transform((_cAlias1)->QTDFEV,"@E 9,999,999"))
		oSection1:Cell("QTDMAR"):SetValue(Transform((_cAlias1)->QTDMAR,"@E 9,999,999"))
		oSection1:Cell("QTDABR"):SetValue(Transform((_cAlias1)->QTDABR,"@E 9,999,999"))
		oSection1:Cell("QTDMAI"):SetValue(Transform((_cAlias1)->QTDMAI,"@E 9,999,999"))
		oSection1:Cell("QTDJUN"):SetValue(Transform((_cAlias1)->QTDJUN,"@E 9,999,999"))
		oSection1:Cell("QTDJUL"):SetValue(Transform((_cAlias1)->QTDJUL,"@E 9,999,999"))
		oSection1:Cell("QTDAGO"):SetValue(Transform((_cAlias1)->QTDAGO,"@E 9,999,999"))
		oSection1:Cell("QTDSET"):SetValue(Transform((_cAlias1)->QTDSET,"@E 9,999,999"))
		oSection1:Cell("QTDOUT"):SetValue(Transform((_cAlias1)->QTDOUT,"@E 9,999,999"))
		oSection1:Cell("QTDNOV"):SetValue(Transform((_cAlias1)->QTDNOV,"@E 9,999,999"))
		oSection1:Cell("QTDDEZ"):SetValue(Transform((_cAlias1)->QTDDEZ,"@E 9,999,999"))
		oSection1:Cell("EDITORAORIGINAL"):SetValue((_cAlias1)->EDITORAORIGINAL)
		oSection1:Cell("ESTRANGEIRA"):SetValue((_cAlias1)->ESTRANGEIRA)
		oSection1:Cell("TOTCUSTO"):SetValue((_cAlias1)->TOTCUSTO)
		oSection1:Cell("DESCRICAOORIGINAL"):SetValue((_cAlias1)->DESCRICAOORIGINAL)
		oSection1:Cell("AUTORPRINC"):SetValue((_cAlias1)->AUTORPRINC)
		oSection1:Cell("IDAUTOR"):SetValue((_cAlias1)->IDAUTOR)
		oSection1:Cell("DESCAUTOR"):SetValue((_cAlias1)->DESCAUTOR)
		oSection1:Cell("CUSTO"):SetValue((_cAlias1)->CUSTO)
		oSection1:Cell("DIDATICA"):SetValue((_cAlias1)->DIDATICA)
		oSection1:Cell("PRECO"):SetValue((_cAlias1)->PRECO)
		oSection1:Cell("TIPOINCLUSAO"):SetValue((_cAlias1)->TIPOINCLUSAO)
		oSection1:Cell("TIPOPUBLICACAO"):SetValue((_cAlias1)->TIPOPUBLICACAO)
		oSection1:Cell("SITUACAOEBOOK"):SetValue((_cAlias1)->SITUACAOEBOOK)
	                                                                 
		If !lPlanilha
	    	oSection1:Cell("PERCACUMULADO"):Disable()
			oSection1:Cell("DATAPUBLICA"):Disable()
			oSection1:Cell("EDITORAORIGINAL"):Disable()
			oSection1:Cell("ESTRANGEIRA"):Disable()
			oSection1:Cell("TOTCUSTO"):Disable()
			oSection1:Cell("DESCRICAOORIGINAL"):Disable()
			oSection1:Cell("AUTORPRINC"):Disable()
			oSection1:Cell("IDAUTOR"):Disable()
			oSection1:Cell("DESCAUTOR"):Disable()
			oSection1:Cell("CUSTO"):Disable()
			oSection1:Cell("DIDATICA"):Disable()
			oSection1:Cell("PRECO"):Disable()
			oSection1:Cell("TIPOINCLUSAO"):Disable()
			oSection1:Cell("TIPOPUBLICACAO"):Disable()
			oSection1:Cell("SITUACAOEBOOK"):Disable()
		End If
	
		oSection1:PrintLine()
	
		(_cAlias1)->(dbSkip())		
	EndDo
	         
	oReport:SkipLine()
	
	_cQuery	:= ""
	
	_cQuery := "SELECT VENDA, SUM(VENDA) OVER() TOTALVENDA, SUM(VENDA) OVER(ORDER BY DESCRICAO) TOTALACUMULADO,
	_cQuery += "       DESCREDUZIDA, ISBN, DESCRICAO, DATAPUBLICA, ACUANO, ACUANOANT, PERC, QTDE,
	_cQuery += "       QTDJAN, QTDFEV, QTDMAR, QTDABR, QTDMAI, QTDJUN, QTDJUL, QTDAGO, QTDSET, QTDOUT, QTDNOV, QTDDEZ,
	_cQuery += "       EDITORAORIGINAL, ESTRANGEIRA, QTDE*CUSTO TOTCUSTO, DESCRICAOORIGINAL, AUTORPRINC, IDAUTOR, DESCAUTOR,
	_cQuery += "       CUSTO, DIDATICA, PRECO, TIPOINCLUSAO, TIPOPUBLICACAO, SITUACAOEBOOK
	_cQuery += "  FROM (
	_cQuery += "SELECT SUM(DECODE(VMO.ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VMO.VLRJAN,
	_cQuery += "           '02', VMO.VLRJAN+VMO.VLRFEV,
	_cQuery += "           '03', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR,
	_cQuery += "           '04', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR,
	_cQuery += "           '05', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI,
	_cQuery += "           '06', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN,
	_cQuery += "           '07', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+VMO.VLRJUL,
	_cQuery += "           '08', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+VMO.VLRJUL+VMO.VLRAGO,
	_cQuery += "           '09', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+VMO.VLRJUL+VMO.VLRAGO+VMO.VLRSET,
	_cQuery += "           '10', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+VMO.VLRJUL+VMO.VLRAGO+VMO.VLRSET+VMO.VLROUT,
	_cQuery += "           '11', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+VMO.VLRJUL+VMO.VLRAGO+VMO.VLRSET+VMO.VLROUT+VMO.VLRNOV,
	_cQuery += "           '12', VMO.VLRJAN+VMO.VLRFEV+VMO.VLRMAR+VMO.VLRABR+VMO.VLRMAI+VMO.VLRJUN+VMO.VLRJUL+VMO.VLRAGO+VMO.VLRSET+VMO.VLROUT+VMO.VLRNOV+VMO.VLRDEZ, 0), 0)) VENDA,
	_cQuery += "       TRIM(XZ5.X5_DESCSPA) DESCREDUZIDA, TO_NUMBER(TRIM(B1_COD)) IDOBRA,
	_cQuery += "       SUM(DECODE(VMO.ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VMO.QTDJAN,
	_cQuery += "           '02', VMO.QTDJAN+VMO.QTDFEV,
	_cQuery += "           '03', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR,
	_cQuery += "           '04', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR,
	_cQuery += "           '05', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI,
	_cQuery += "           '06', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN,
	_cQuery += "           '07', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL,
	_cQuery += "           '08', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO,
	_cQuery += "           '09', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET,
	_cQuery += "           '10', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT,
	_cQuery += "           '11', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV,
	_cQuery += "           '12', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV+VMO.QTDDEZ, 0), 0)) ACUANO,
	_cQuery += "       SUM(DECODE(VMO.ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VMO.QTDJAN,
	_cQuery += "           '02', VMO.QTDJAN+VMO.QTDFEV,
	_cQuery += "           '03', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR,
	_cQuery += "           '04', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR,
	_cQuery += "           '05', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI,
	_cQuery += "           '06', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN,
	_cQuery += "           '07', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL,
	_cQuery += "           '08', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO,
	_cQuery += "           '09', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET,
	_cQuery += "           '10', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT,
	_cQuery += "           '11', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV,
	_cQuery += "           '12', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV+VMO.QTDDEZ, 0), 0)) ACUANOANT,
	_cQuery += "       ROUND(SUM(DECODE(VMO.ANO, '"+ _cAno+"', (VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+
	_cQuery += "                 VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV+VMO.QTDDEZ), 0)) /
	_cQuery += "             DECODE(SUM(DECODE(VMO.ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VMO.QTDJAN,
	_cQuery += "             '02', VMO.QTDJAN+VMO.QTDFEV,
	_cQuery += "             '03', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR,
	_cQuery += "             '04', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR,
	_cQuery += "             '05', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI,
	_cQuery += "             '06', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN,
	_cQuery += "             '07', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL,
	_cQuery += "             '08', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO,
	_cQuery += "             '09', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET,
	_cQuery += "             '10', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT,
	_cQuery += "             '11', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV,
	_cQuery += "             '12', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV+VMO.QTDDEZ), 0)), 0, NULL,
	_cQuery += "             SUM(DECODE(VMO.ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VMO.QTDJAN,
	_cQuery += "                 '02', VMO.QTDJan+VMO.QTDFev,
	_cQuery += "                 '03', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR,
	_cQuery += "                 '04', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR,
	_cQuery += "                 '05', VMO.QTDJan+VMO.QTDFev+VMO.QTDMar+VMO.QTDAbr+VMO.QTDMai,
	_cQuery += "                 '06', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN,
	_cQuery += "                 '07', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL,
	_cQuery += "                 '08', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO,
	_cQuery += "                 '09', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET,
	_cQuery += "                 '10', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT,
	_cQuery += "                 '11', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV,
	_cQuery += "                 '12', VMO.QTDJAN+VMO.QTDFEV+VMO.QTDMAR+VMO.QTDABR+VMO.QTDMAI+VMO.QTDJUN+VMO.QTDJUL+VMO.QTDAGO+VMO.QTDSET+VMO.QTDOUT+VMO.QTDNOV+VMO.QTDDEZ), NULL))) * 100, 4) PERC,
	_cQuery += "       SB9.QTDE,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', QTDJAN, 0)) QTDJAN,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 2 THEN QTDFEV ELSE 0 END, 0)) QTDFEV,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 3 THEN QTDMAR ELSE 0 END, 0)) QTDMAR,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 4 THEN QTDABR ELSE 0 END, 0)) QTDABR,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 5 THEN QTDMAI ELSE 0 END, 0)) QTDMAI,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 6 THEN QTDJUN ELSE 0 END, 0)) QTDJUN,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 7 THEN QTDJUL ELSE 0 END, 0)) QTDJUL,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 8 THEN QTDAGO ELSE 0 END, 0)) QTDAGO,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 9 THEN QTDSET ELSE 0 END, 0)) QTDSET,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 10 THEN QTDOUT ELSE 0 END, 0)) QTDOUT,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 11 THEN QTDNOV ELSE 0 END, 0)) QTDNOV,
	_cQuery += "       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 12 THEN QTDDEZ ELSE 0 END, 0)) QTDDEZ,
	_cQuery += "       TRIM(SB1.B1_DESC) DESCRICAO, TRIM(SB5.B5_XDESORI) DESCRICAOORIGINAL, DA.D41_ST_OBRA_ESTRANGEIRA ESTRANGEIRA,
	_cQuery += "       DA.V02_TX_AUTOR EDITORAORIGINAL,  TRIM(SB5.B5_XAUTOR) AUTORPRINC, SB9.B9_CM1 CUSTO, TRIM(SBM.BM_DESC) DESCCLASSEOBRA,
	_cQuery += "       SBM.BM_XCATEG DIDATICA, DA1.DA1_PRCVEN PRECO,
	_cQuery += "       DA.V04_ID_DETENTOR IDAUTOR, DA.V04_TX_NOME_COMPLETO DESCAUTOR, STOC(SB5.B5_XDTPUBL) DATAPUBLICA, 
	_cQuery += "       DA.D23_DT_EXPIRACAO DATAEXPIRACAODIREITO, SB1.B1_ISBN ISBN, DA.D41_TX_ISBN_ORIGINAL ISBNORIGEM,
	_cQuery += "       DA.D23_DT_ASSINATURA_CONTRATO DATACONTRATO, TRIM(SB5.B5_CEME) DESCRICAOCOMPLETA,
	_cQuery += "       DECODE(SB5.B5_XTIPINC, '1', 'OBRA NOVA', '2', 'NOVA EDIÇÃO') TIPOINCLUSAO, XZ4.X5_DESCRI TIPOPUBLICACAO, DA.D62_TX_OBSERVACAO SITUACAOEBOOK
	_cQuery += "  FROM " + RetSqlName("SB1") + " SB1
	_cQuery += "  JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "    ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "   AND B5_XFEC = '1'
	_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
	_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ5
	_cQuery += "    ON XZ5.X5_CHAVE = SB1.B1_XSITOBR
	_cQuery += "   AND XZ5.X5_TABELA = 'Z5'
	_cQuery += "   AND XZ5.X5_FILIAL = '" + xFilial("SX5") + "'"
	_cQuery += "   AND XZ5.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN DBA_EGK.VENDAMESOBRA VMO
	_cQuery += "    ON VMO.IDOBRAHISTORICO = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
	_cQuery += "   AND VMO.ANO >= '"+ _cAnoAnt+"'"
	_cQuery += "  LEFT JOIN (SELECT SB9.B9_COD, SB9.B9_CM1, SUM(SB9.B9_QINI) QTDE
	_cQuery += "               FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
	_cQuery += "              WHERE SB9.B9_COD = SB1.B1_COD
	_cQuery += "                AND SB9.B9_FILIAL = DECODE(SB1.B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','378803 ','1022')
	_cQuery += "                AND SB9.B9_LOCAL = '01'
	_cQuery += "                AND SB9.B9_DATA = '"+ _cData+"'"
	_cQuery += "                AND SB9.D_E_L_E_T_ = ' '
	_cQuery += "                AND SB1.D_E_L_E_T_ = ' '
	_cQuery += "              GROUP BY SB9.B9_COD, SB9.B9_CM1) SB9
	_cQuery += "    ON SB9.B9_COD = SB1.B1_COD
	_cQuery += "  LEFT JOIN " + RetSqlName("SBM") + " SBM
	_cQuery += "    ON SB1.B1_GRUPO = SBM.BM_GRUPO
	_cQuery += "   AND SBM.BM_FILIAL = '" + xFilial("SBM") + "'"
	_cQuery += "   AND SBM.D_E_L_E_T_ = ' '
	_cQuery += "  JOIN DBA_EGK.TT_PARAMETROS P
	_cQuery += "    ON P.VARIAVEL = 'GEN_FAT064'
	_cQuery += "  LEFT JOIN " + RetSqlName("DA1") + " DA1
	_cQuery += "    ON DA1.DA1_CODPRO = SB1.B1_COD
	_cQuery += "   AND DA1.DA1_CODTAB = P.CONTEUDO
	_cQuery += "   AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "'"
	_cQuery += "   AND DA1.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4                                                                                        
	_cQuery += "    ON XZ4.X5_CHAVE = SB1.B1_XIDTPPU
	_cQuery += "   AND XZ4.X5_TABELA = 'Z4'
	_cQuery += "   AND XZ4.X5_FILIAL = '" + xFilial("SX5") + "'"
	_cQuery += "   AND XZ4.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN (SELECT DISTINCT V02.V02_CD_OBRA, V02.V02_TX_AUTOR, D23.D23_DT_EXPIRACAO, D23.D23_DT_ASSINATURA_CONTRATO,
	_cQuery += "                    V04.V04_ID_DETENTOR, V04.V04_TX_NOME_COMPLETO, D41.D41_ST_OBRA_ESTRANGEIRA, D41.D41_TX_ISBN_ORIGINAL, D62.D62_TX_OBSERVACAO
	_cQuery += "               FROM GUA_DA.DAU_V02_OBRAS V02, 
	_cQuery += "                    (SELECT * FROM GUA_DA.DAU_D23_CONTRATOS WHERE D22_ID_STATUS_CONTRATO IN (1)) D23,
	_cQuery += "                    GUA_DA.DAU_D24_CONTRATO_TIPO_DETENTOR D24, 
	_cQuery += "                    (SELECT * FROM GUA_DA.DAU_D26_CONTRATO_DETENTORES WHERE D26_ST_AUTOR_PRINCIPAL = 'S') D26,
	_cQuery += "                    GUA_DA.DAU_V04_DETENTORES V04, GUA_DA.DAU_D41_OBRA D41,
	_cQuery += "                    (SELECT * FROM GUA_DA.DAU_D49_CONTRATO_PERMISSAO WHERE D27_ID_PERMISSAO = 3) D49,
	_cQuery += "                    GUA_DA.DAU_D62_PERMISSOES_OBSERVACOES D62
	_cQuery += "              WHERE V02.V02_CD_OBRA = D23.V02_CD_OBRA (+)
	_cQuery += "                AND D23.D23_ID_CONTRATO = D24.D23_ID_CONTRATO (+)
	_cQuery += "                AND D24.D24_ID_CONTRATO_TIPO_DETENTOR = D26.D24_ID_CONTRATO_TIPO_DETENTOR
	_cQuery += "                AND D26.V04_ID_DETENTOR = V04.V04_ID_DETENTOR (+)
	_cQuery += "                AND D23.V02_CD_OBRA = D41.V02_CD_OBRA (+)
	_cQuery += "                AND D23.D23_ID_CONTRATO = D49.D23_ID_CONTRATO (+)
	_cQuery += "                AND D49.D62_ID_PERMISSAO_OBSERVACAO = D62.D62_ID_PERMISSAO_OBSERVACAO (+)) DA
	_cQuery += "  ON TO_NUMBER(TRIM(B1_COD)) = DA.V02_CD_OBRA
	_cQuery += " WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
	If !Empty(MV_PAR02)
		_cQuery += "   AND SB1.B1_PROC = '"+MV_PAR02+"'
	Endif 
	If !Empty(MV_PAR03)
		_cQuery += "   AND SB1.B1_LOJPROC = '"+MV_PAR03+"'
	Endif
	_cQuery += "HAVING SUM(VMO.VLRJAN) <> 0 OR SUM(VMO.VLRFEV) <> 0 OR SUM(VMO.VLRMAR) <> 0 OR SUM(VMO.VLRABR) <> 0 OR SUM(VMO.VLRMAI) <> 0 OR SUM(VMO.VLRJUN) <> 0 OR
	_cQuery += "       SUM(VMO.VLRJUL) <> 0 OR SUM(VMO.VLRAGO) <> 0 OR SUM(VMO.VLRSET) <> 0 OR SUM(VMO.VLROUT) <> 0 OR SUM(VMO.VLRNOV) <> 0 OR SUM(VMO.VLRDEZ) <> 0
	_cQuery += " GROUP BY XZ5.X5_DESCSPA, TO_NUMBER(TRIM(B1_COD)), SB9.QTDE,
	_cQuery += "         TRIM(SB1.B1_DESC), TRIM(SB5.B5_XDESORI), DA.D41_ST_OBRA_ESTRANGEIRA,
	_cQuery += "         DA.V02_TX_AUTOR,  TRIM(SB5.B5_XAUTOR), SB9.B9_CM1, TRIM(SBM.BM_DESC),
	_cQuery += "         SBM.BM_XCATEG, DA1.DA1_PRCVEN,
	_cQuery += "         DA.V04_ID_DETENTOR, DA.V04_TX_NOME_COMPLETO, STOC(SB5.B5_XDTPUBL), 
	_cQuery += "         DA.D23_DT_EXPIRACAO, SB1.B1_ISBN, DA.D41_TX_ISBN_ORIGINAL,
	_cQuery += "         DA.D23_DT_ASSINATURA_CONTRATO, TRIM(SB5.B5_CEME),
	_cQuery += "         DECODE(SB5.B5_XTIPINC, '1', 'OBRA NOVA', '2', 'NOVA EDIÇÃO'), XZ4.X5_DESCRI, DA.D62_TX_OBSERVACAO
	_cQuery += "       )
	
	If Select(_cAlias2) > 0
		dbSelectArea(_cAlias2)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias2, .F., .T.)
	
	Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()
		oReport:IncMeter()
	
		xPercTotal := (_cAlias2)->VENDA / (_cAlias2)->TOTALVENDA * 100
		xPercAcum  := (_cAlias2)->TOTALACUMULADO / (_cAlias2)->TOTALVENDA * 100
	
		If (_cAlias2)->ACUANO > (_cAlias2)->QTDE .or. (_cAlias2)->ACUANOANT > (_cAlias2)->QTDE
			xReimp := "*"+(_cAlias2)->DESCREDUZIDA
		Else
			xReimp := " "+(_cAlias2)->DESCREDUZIDA
		End If
	
		oSection1:Cell("VENDA"):SetValue("R$ " + Transform((_cAlias2)->VENDA, "@E 999,999,999.99"))
		oSection1:Cell("PERCTOTAL"):SetValue(Transform(xPercTotal,"@E 9,999.99") + " %")
		oSection1:Cell("PERCACUMULADO"):SetValue(Transform(xPercAcum,"@E 9,999.99") + " %")
		oSection1:Cell("REIMP"):SetValue(xReimp) 
		oSection1:Cell("ISBN"):SetValue((_cAlias2)->ISBN)
		oSection1:Cell("DESCRICAO"):SetValue((_cAlias2)->DESCRICAO)
		oSection1:Cell("DATAPUBLICA"):SetValue((_cAlias2)->DATAPUBLICA)
		oSection1:Cell("ACUANO"):SetValue(Transform((_cAlias2)->ACUANO,"@E 9,999,999"))
		oSection1:Cell("ACUANOANT"):SetValue(Transform((_cAlias2)->ACUANOANT,"@E 9,999,999"))
		oSection1:Cell("PERC"):SetValue(Transform((_cAlias2)->PERC,"@E 9,999.99") + " %")
		oSection1:Cell("QTDE"):SetValue(Transform((_cAlias2)->QTDE,"@E 9,999,999"))
		oSection1:Cell("QTDJAN"):SetValue(Transform((_cAlias2)->QTDJAN,"@E 9,999,999"))
		oSection1:Cell("QTDFEV"):SetValue(Transform((_cAlias2)->QTDFEV,"@E 9,999,999"))
		oSection1:Cell("QTDMAR"):SetValue(Transform((_cAlias2)->QTDMAR,"@E 9,999,999"))
		oSection1:Cell("QTDABR"):SetValue(Transform((_cAlias2)->QTDABR,"@E 9,999,999"))
		oSection1:Cell("QTDMAI"):SetValue(Transform((_cAlias2)->QTDMAI,"@E 9,999,999"))
		oSection1:Cell("QTDJUN"):SetValue(Transform((_cAlias2)->QTDJUN,"@E 9,999,999"))
		oSection1:Cell("QTDJUL"):SetValue(Transform((_cAlias2)->QTDJUL,"@E 9,999,999"))
		oSection1:Cell("QTDAGO"):SetValue(Transform((_cAlias2)->QTDAGO,"@E 9,999,999"))
		oSection1:Cell("QTDSET"):SetValue(Transform((_cAlias2)->QTDSET,"@E 9,999,999"))
		oSection1:Cell("QTDOUT"):SetValue(Transform((_cAlias2)->QTDOUT,"@E 9,999,999"))
		oSection1:Cell("QTDNOV"):SetValue(Transform((_cAlias2)->QTDNOV,"@E 9,999,999"))
		oSection1:Cell("QTDDEZ"):SetValue(Transform((_cAlias2)->QTDDEZ,"@E 9,999,999"))
		oSection1:Cell("EDITORAORIGINAL"):SetValue((_cAlias2)->EDITORAORIGINAL)
		oSection1:Cell("ESTRANGEIRA"):SetValue((_cAlias2)->ESTRANGEIRA)
		oSection1:Cell("TOTCUSTO"):SetValue("R$ " + Transform((_cAlias2)->TOTCUSTO, "@E 999,999,999.99"))
		oSection1:Cell("DESCRICAOORIGINAL"):SetValue((_cAlias2)->DESCRICAOORIGINAL)
		oSection1:Cell("AUTORPRINC"):SetValue((_cAlias2)->AUTORPRINC)
		oSection1:Cell("IDAUTOR"):SetValue((_cAlias2)->IDAUTOR)
		oSection1:Cell("DESCAUTOR"):SetValue((_cAlias2)->DESCAUTOR)
		oSection1:Cell("CUSTO"):SetValue("R$ " + Transform((_cAlias2)->CUSTO, "@E 9,999.99"))
		oSection1:Cell("DIDATICA"):SetValue((_cAlias2)->DIDATICA)
		oSection1:Cell("PRECO"):SetValue("R$ " + Transform((_cAlias2)->PRECO, "@E 9,999.99"))
		oSection1:Cell("TIPOINCLUSAO"):SetValue((_cAlias2)->TIPOINCLUSAO)
		oSection1:Cell("TIPOPUBLICACAO"):SetValue((_cAlias2)->TIPOPUBLICACAO)
		oSection1:Cell("SITUACAOEBOOK"):SetValue((_cAlias2)->SITUACAOEBOOK)
	 
		If !lPlanilha
	    	oSection1:Cell("PERCACUMULADO"):Disable()
			oSection1:Cell("DATAPUBLICA"):Disable()
			oSection1:Cell("EDITORAORIGINAL"):Disable()
			oSection1:Cell("ESTRANGEIRA"):Disable()
			oSection1:Cell("TOTCUSTO"):Disable()
			oSection1:Cell("DESCRICAOORIGINAL"):Disable()
			oSection1:Cell("AUTORPRINC"):Disable()
			oSection1:Cell("IDAUTOR"):Disable()
			oSection1:Cell("DESCAUTOR"):Disable()
			oSection1:Cell("CUSTO"):Disable()
			oSection1:Cell("DIDATICA"):Disable()
			oSection1:Cell("PRECO"):Disable()
			oSection1:Cell("TIPOINCLUSAO"):Disable()
			oSection1:Cell("TIPOPUBLICACAO"):Disable()
			oSection1:Cell("SITUACAOEBOOK"):Disable()
		End If
	
		oSection1:PrintLine()
	
		(_cAlias2)->(dbSkip())		
	EndDo
	oSection1:Finish()
	         
	DbSelectArea(_cAlias2)
	DbSelectArea(_cAlias1)
	DbCloseArea()
Endif
	
Return(.t.)
