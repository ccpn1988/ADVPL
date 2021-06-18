#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER006N

DESCRICAO: GER006a - FATURAMENTO COMPARATIVO POR OBRA

ALTERACOES:
05/04/2016 - Desenvolvimento do fonte

/*/

User Function GER006A

Local oReport
Local cPerg := "GER06A"

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
05/04/2016 - Helimar Tavares - Criacao do fonte
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

//---------------------------------------MV_PAR04--------------------------------------------------  
cCpoPer := "Z7_AREA"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Área ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SZ7"	//Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"vazio() .or. existcpo('SZ7')",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------  
cCpoPer := "X5_CHAVE"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Tp Publicação ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SX5Z4"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
05/04/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local _cSigla := '' 

_cParm2 := MV_PAR02           
_cParm4 := MV_PAR04

_cMes   := MONTH2STR(MV_PAR01)
_cAno   := YEAR2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

If MV_PAR02 = '0380795'
	_cSigla := ' - EGK'
ElseIf MV_PAR02 = '0380796'
	_cSigla := ' - LTC'
ElseIf MV_PAR02 = '0380794'
	_cSigla := ' - FOR'
ElseIf MV_PAR02 = '031811 '
	_cSigla := ' - ACF'
ElseIf MV_PAR02 = '0378128'
	_cSigla := ' - ATL'
EndIf

If MV_PAR04 = '000001'
	_cSigla := _cSigla + ' - Saúde'
ElseIf MV_PAR04 = '000002'
	_cSigla := _cSigla + ' - Exatas'	
ElseIf MV_PAR04 = '000005'
	_cSigla := _cSigla + ' - Concursos'	
ElseIf MV_PAR04 = '000006'
	_cSigla := _cSigla + ' - Jurídico'	
ElseIf MV_PAR04 = '000007'
	_cSigla := _cSigla + ' - Sociais Aplicadas'	
ElseIf MV_PAR04 = '000008'
	_cSigla := _cSigla + ' - Humanas'
EndIf
	           
If _cSigla = ''
	_cSigla := ' - '
EndIf

//Declaracao do relatorio
oReport := TReport():New("GER006A","GER006A - Faturamento Líq. Mensal por Produto - Total GEN sem Fórum",cPerg,{|oReport| PrintReport(oReport)},"GER006A - Faturamento Líq. Mensal por Produto - Total GEN sem Fórum",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

oReport:NDEVICE := 4

//Secao do relatorio
oSection1 := TRSection():New(oReport,"GER006A - Fat. Líq. Mensal por Produto - Total GEN sem Fórum","")
	
//Celulas da secao
TRCell():New(oSection1,"B1_COD" 			,"","Código")
TRCell():New(oSection1,"ISBN"				,"","ISBN")
TRCell():New(oSection1,"DESCRICAO"			,"","Descrição")
TRCell():New(oSection1,"ESTOQUE"			,"","Estoque","@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"ESTOQUECSG"			,"","Estoque Consig","@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"ESTOQUEDISP"		,"","Estoque Disponível","@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"VALOR"				,"",_cAno+" YTD R$","@E 999,999,999.99",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"VALOR_AA"			,"",_cAnoAnt+" YTD R$","@E 999,999,999.99",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"PERC_VLR"			,"","% "+_cAno+" X "+_cAnoAnt+" R$","@E 9,999.99",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDE"				,"",_cAno+" YTD","@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDE_AA"			,"",_cAnoAnt+" YTD","@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"PERC_QTD"			,"","% "+_cAno+" X "+_cAnoAnt,"@E 9,999.99",6,,,"RIGHT",,"RIGHT")
If _cMes >= '12'
	TRCell():New(oSection1,"QTDDEZ"				,"","Dez"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '11'
	TRCell():New(oSection1,"QTDNOV"				,"","Nov"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '10'
	TRCell():New(oSection1,"QTDOUT"				,"","Out"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '09'
	TRCell():New(oSection1,"QTDSET"				,"","Set"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '08'
	TRCell():New(oSection1,"QTDAGO"				,"","Ago"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '07'
	TRCell():New(oSection1,"QTDJUL"				,"","Jul"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '06'
	TRCell():New(oSection1,"QTDJUN"				,"","Jun"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '05'
	TRCell():New(oSection1,"QTDMAI"				,"","Mai"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '04'
	TRCell():New(oSection1,"QTDABR"				,"","Abr"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '03'
	TRCell():New(oSection1,"QTDMAR"				,"","Mar"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
If _cMes >= '02'
	TRCell():New(oSection1,"QTDFEV"				,"","Fev"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
EndIf
TRCell():New(oSection1,"QTDJAN"				,"","Jan"+_cAno,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDDEZ_AA"			,"","Dez"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDNOV_AA"			,"","Nov"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDOUT_AA"			,"","Out"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDSET_AA"			,"","Set"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDAGO_AA"			,"","Ago"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDJUL_AA"			,"","Jul"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDJUN_AA"			,"","Jun"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDMAI_AA"			,"","Mai"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDABR_AA"			,"","Abr"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDMAR_AA"			,"","Mar"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDFEV_AA"			,"","Fev"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"QTDJAN_AA"			,"","Jan"+_cAnoAnt,"@E 9,999,999",6,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"AREA"				,"","Área")
TRCell():New(oSection1,"SELO"				,"","Selo")
TRCell():New(oSection1,"DATAPUBLICACAO"		,"","Data Publicação")
TRCell():New(oSection1,"TIPOPUBLICACAO"		,"","Tipo Publicação")
TRCell():New(oSection1,"SITUACAOOBRA"		,"","Situação Obra")

//Totalizadores
//TRFunction():New(oSection3:Cell("D2_QUANT")	,NIL,"SUM")//,oBreak01)  //,,,,.f.) 
//TRFunction():New(oSection3:Cell("D2_TOTAL")	,NIL,"SUM")//,oBreak01)  //,,,,.f.) 

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
05/04/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cQuery	:= ""
 
_cParm1 := DTOS(LASTDATE(MV_PAR01))
_cAno   := YEAR2STR(MV_PAR01)
_cMes   := MONTH2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

xCodigo     := ' '
xISBN       := ' '
xDescricao  := 'TOTAL'
xArea       := ' '
xSelo       := ' '
xDataPub    := ' '
xTipoPub    := ' '
xSituacao   := ' '
xEstoque    := 0
xEstoqueCsg := 0
xEstoqueDisp:= 0
xValor      := 0
xValor_AA   := 0
xQtde       := 0
xQtde_AA    := 0
xQtdJan_AA  := 0
xQtdFev_AA  := 0
xQtdMar_AA  := 0
xQtdAbr_AA  := 0
xQtdMai_AA  := 0
xQtdJun_AA  := 0
xQtdJul_AA  := 0
xQtdAgo_AA  := 0
xQtdSet_AA  := 0
xQtdOut_AA  := 0
xQtdNov_AA  := 0
xQtdDez_AA  := 0
xQtdJan     := 0
xQtdFev     := 0
xQtdMar     := 0
xQtdAbr     := 0
xQtdMai     := 0
xQtdJun     := 0
xQtdJul     := 0
xQtdAgo     := 0
xQtdSet     := 0
xQtdOut     := 0
xQtdNov     := 0
xQtdDez     := 0

If AnoMes(MV_PAR01) >= AnoMes(Date())
	MsgInfo('Esse relatório é mês fechado, informe uma data anterior ao mês corrente!')
Else	
	_cQuery	:= ""
	_cQuery += "SELECT B1_COD, ISBN, DESCRICAO, B1_PROC, B1_LOJPROC, B5_XAREA, AREA, SELO, DATAPUBLICACAO, B1_XIDTPPU, TIPOPUBLICACAO, SITUACAOOBRA,
	_cQuery += "       ESTOQUE, ESTOQUECSG, ESTOQUEDISP, VALOR, VALOR_AA, QTDE, QTDE_AA,
	_cQuery += "       QTDJAN_AA, QTDFEV_AA, QTDMAR_AA, QTDABR_AA, QTDMAI_AA, QTDJUN_AA, QTDJUL_AA, QTDAGO_AA, QTDSET_AA, QTDOUT_AA, QTDNOV_AA, QTDDEZ_AA,
	_cQuery += "       QTDJAN, QTDFEV, QTDMAR, QTDABR, QTDMAI, QTDJUN, QTDJUL, QTDAGO, QTDSET, QTDOUT, QTDNOV, QTDDEZ,
	_cQuery += "       SUM(ESTOQUE) OVER() TESTOQUE, SUM(ESTOQUECSG) OVER() TESTOQUECSG, SUM(ESTOQUEDISP) OVER() TESTOQUEDISP,
	_cQuery += "       SUM(VALOR) OVER() TVALOR, SUM(VALOR_AA) OVER() TVALOR_AA, SUM(QTDE) OVER() TQTDE, SUM(QTDE_AA) OVER() TQTDE_AA,
	_cQuery += "       SUM(QTDJAN_AA) OVER() TQTDJAN_AA, SUM(QTDFEV_AA) OVER() TQTDFEV_AA, SUM(QTDMAR_AA) OVER() TQTDMAR_AA,
	_cQuery += "       SUM(QTDABR_AA) OVER() TQTDABR_AA, SUM(QTDMAI_AA) OVER() TQTDMAI_AA, SUM(QTDJUN_AA) OVER() TQTDJUN_AA,
	_cQuery += "       SUM(QTDJUL_AA) OVER() TQTDJUL_AA, SUM(QTDAGO_AA) OVER() TQTDAGO_AA, SUM(QTDSET_AA) OVER() TQTDSET_AA,
	_cQuery += "       SUM(QTDOUT_AA) OVER() TQTDOUT_AA, SUM(QTDNOV_AA) OVER() TQTDNOV_AA, SUM(QTDDEZ_AA) OVER() TQTDDEZ_AA,
	_cQuery += "       SUM(QTDJAN) OVER() TQTDJAN, SUM(QTDFEV) OVER() TQTDFEV, SUM(QTDMAR) OVER() TQTDMAR,
	_cQuery += "       SUM(QTDABR) OVER() TQTDABR, SUM(QTDMAI) OVER() TQTDMAI, SUM(QTDJUN) OVER() TQTDJUN,
	_cQuery += "       SUM(QTDJUL) OVER() TQTDJUL, SUM(QTDAGO) OVER() TQTDAGO, SUM(QTDSET) OVER() TQTDSET,
	_cQuery += "       SUM(QTDOUT) OVER() TQTDOUT, SUM(QTDNOV) OVER() TQTDNOV, SUM(QTDDEZ) OVER() TQTDDEZ
	_cQuery += "  FROM (
	_cQuery += "SELECT F.B1_COD, SB1.B1_ISBN ISBN, TRIM(DECODE(F.B1_COD,'APARAS','FATURAMENTO PRODUTOS OBSOLETOS',SB1.B1_DESC)) DESCRICAO, SB1.B1_PROC, SB1.B1_LOJPROC, SB5.B5_XAREA,
	_cQuery += "       TRIM(SZ7.Z7_DESC) AREA, TRIM(XZ1.X5_DESCRI) SELO, TRIM(SB5.B5_XDTPUBL) DATAPUBLICACAO, SB1.B1_XIDTPPU, TRIM(XZ4.X5_DESCRI) TIPOPUBLICACAO, TRIM(XZ5.X5_DESCRI) SITUACAOOBRA,
	_cQuery += "       CASE WHEN TRIM(B1_XIDTPPU) IN ('8','9','11','14','15','16','17','19','24','25','27') THEN 0 ELSE EST.QTDE END ESTOQUE,
	_cQuery += "       CASE WHEN TRIM(B1_XIDTPPU) IN ('8','9','11','14','15','16','17','19','24','25','27') THEN 0 ELSE EST.QTDECONSIG END ESTOQUECSG,
	_cQuery += "       CASE WHEN TRIM(B1_XIDTPPU) IN ('8','9','11','14','15','16','17','19','24','25','27') THEN 0 ELSE EST.QTDETOTAL END ESTOQUEDISP,
	_cQuery += "       F.VALOR, F.VALOR_AA,
	_cQuery += "       F.QTDE, F.QTDE_AA,
	_cQuery += "       F.QTDJAN_AA, F.QTDFEV_AA, F.QTDMAR_AA, F.QTDABR_AA, F.QTDMAI_AA, F.QTDJUN_AA,
	_cQuery += "       F.QTDJUL_AA, F.QTDAGO_AA, F.QTDSET_AA, F.QTDOUT_AA, F.QTDNOV_AA, F.QTDDEZ_AA,
	_cQuery += "       F.QTDJAN, F.QTDFEV, F.QTDMAR, F.QTDABR, F.QTDMAI, F.QTDJUN,
	_cQuery += "       F.QTDJUL, F.QTDAGO, F.QTDSET, F.QTDOUT, F.QTDNOV, F.QTDDEZ,
	_cQuery += "       CST.B9_CM1 CUSTO
	_cQuery += "  FROM (SELECT DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, FAT.B5_XCODHIS, SFEC.B5_COD), FEC.B5_COD) B1_COD,
	_cQuery += "               VALOR, VALOR_AA, QTDE, QTDE_AA,
	_cQuery += "               QTDJAN_AA, QTDFEV_AA, QTDMAR_AA, QTDABR_AA, QTDMAI_AA, QTDJUN_AA, QTDJUL_AA, QTDAGO_AA, QTDSET_AA, QTDOUT_AA, QTDNOV_AA, QTDDEZ_AA,
	_cQuery += "               QTDJAN, QTDFEV, QTDMAR, QTDABR, QTDMAI, QTDJUN, QTDJUL, QTDAGO, QTDSET, QTDOUT, QTDNOV, QTDDEZ
	_cQuery += "          FROM (SELECT B5_XCODHIS,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                                            '02', VLRJAN+VLRFEV,
	_cQuery += "                                                            '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                            '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                            '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                            '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                            '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                            '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                            '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                            '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                            '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                            '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) VALOR,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                                            '02', VLRJAN+VLRFEV,
	_cQuery += "                                                            '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                            '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                            '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                            '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                            '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                            '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                            '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                            '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                            '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                            '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) VALOR_AA,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', QTDJAN,
	_cQuery += "                                                            '02', QTDJAN+QTDFEV,
	_cQuery += "                                                            '03', QTDJAN+QTDFEV+QTDMAR,
	_cQuery += "                                                            '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
	_cQuery += "                                                            '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
	_cQuery += "                                                            '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
	_cQuery += "                                                            '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
	_cQuery += "                                                            '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
	_cQuery += "                                                            '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
	_cQuery += "                                                            '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
	_cQuery += "                                                            '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
	_cQuery += "                                                            '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) QTDE,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', QTDJAN,
	_cQuery += "                                                            '02', QTDJAN+QTDFEV,
	_cQuery += "                                                            '03', QTDJAN+QTDFEV+QTDMAR,
	_cQuery += "                                                            '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
	_cQuery += "                                                            '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
	_cQuery += "                                                            '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
	_cQuery += "                                                            '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
	_cQuery += "                                                            '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
	_cQuery += "                                                            '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
	_cQuery += "                                                            '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
	_cQuery += "                                                            '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
	_cQuery += "                                                            '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) QTDE_AA,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDJAN, 0)) QTDJAN_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDFEV, 0)) QTDFEV_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDMAR, 0)) QTDMAR_AA,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDABR, 0)) QTDABR_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDMAI, 0)) QTDMAI_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDJUN, 0)) QTDJUN_AA,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDJUL, 0)) QTDJUL_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDAGO, 0)) QTDAGO_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDSET, 0)) QTDSET_AA,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDOUT, 0)) QTDOUT_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDNOV, 0)) QTDNOV_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', QTDDEZ, 0)) QTDDEZ_AA,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', QTDJAN, 0)) QTDJAN, 
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 2 THEN QTDFEV ELSE 0 END, 0)) QTDFEV,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 3 THEN QTDMAR ELSE 0 END, 0)) QTDMAR,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 4 THEN QTDABR ELSE 0 END, 0)) QTDABR,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 5 THEN QTDMAI ELSE 0 END, 0)) QTDMAI,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 6 THEN QTDJUN ELSE 0 END, 0)) QTDJUN,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 7 THEN QTDJUL ELSE 0 END, 0)) QTDJUL,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 8 THEN QTDAGO ELSE 0 END, 0)) QTDAGO,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 9 THEN QTDSET ELSE 0 END, 0)) QTDSET,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 10 THEN QTDOUT ELSE 0 END, 0)) QTDOUT,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 11 THEN QTDNOV ELSE 0 END, 0)) QTDNOV,
	_cQuery += "                       SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 12 THEN QTDDEZ ELSE 0 END, 0)) QTDDEZ
	_cQuery += "                  FROM GER_VENDAMESOBRA
	_cQuery += "                 GROUP BY B5_XCODHIS) FAT
	_cQuery += "          LEFT JOIN (SELECT SB5.B5_COD, SB5.B5_XCODHIS
	_cQuery += "                       FROM " + RetSqlName("SB5") + " SB5, 
	_cQuery += "                            (SELECT B5_XCODHIS, MAX(R_E_C_N_O_) R_E_C_N_O_
	_cQuery += "                               FROM " + RetSqlName("SB5")
	_cQuery += "                              WHERE TRIM(B5_XFEC) = '1'
	_cQuery += "                                AND D_E_L_E_T_ = ' '
	_cQuery += "                              GROUP BY B5_XCODHIS) M
	_cQuery += "                      WHERE SB5.B5_XCODHIS = M.B5_XCODHIS
	_cQuery += "                        AND SB5.R_E_C_N_O_ = M.R_E_C_N_O_
	_cQuery += "                        AND TRIM(SB5.B5_XFEC) = '1'
	_cQuery += "                        AND SB5.D_E_L_E_T_ = ' ') FEC
	_cQuery += "            ON FAT.B5_XCODHIS = FEC.B5_XCODHIS
	_cQuery += "          LEFT JOIN (SELECT SB5.B5_COD, SB5.B5_XCODHIS
	_cQuery += "                       FROM " + RetSqlName("SB5") + " SB5, 
	_cQuery += "                            (SELECT B5_XCODHIS, MAX(R_E_C_N_O_) R_E_C_N_O_
	_cQuery += "                               FROM " + RetSqlName("SB5")
	_cQuery += "                              WHERE D_E_L_E_T_ = ' '
	_cQuery += "                              GROUP BY B5_XCODHIS) M
	_cQuery += "                      WHERE SB5.B5_XCODHIS = M.B5_XCODHIS
	_cQuery += "                        AND SB5.R_E_C_N_O_ = M.R_E_C_N_O_
	_cQuery += "                        AND TRIM(SB5.B5_XFEC) <> '1'
	_cQuery += "                        AND SB5.D_E_L_E_T_ = ' ') SFEC
	_cQuery += "            ON FAT.B5_XCODHIS = SFEC.B5_XCODHIS) F
	_cQuery += "  LEFT JOIN " + RetSqlName("SB1") + " SB1
	_cQuery += "    ON F.B1_COD = SB1.B1_COD
    _cQuery += "   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
	_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "    ON SB1.B1_COD = SB5.B5_COD
    _cQuery += "   AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
	_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ1
	_cQuery += "    ON TRIM(SB5.B5_XSELO) = TRIM(XZ1.X5_CHAVE)
	_cQuery += "   AND XZ1.X5_TABELA = 'Z1'
    _cQuery += "   AND XZ1.X5_FILIAL  = '" + xFilial("SX5") + "'"
	_cQuery += "   AND XZ1.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4
	_cQuery += "    ON TRIM(SB1.B1_XIDTPPU) = TRIM(XZ4.X5_CHAVE)
	_cQuery += "   AND XZ4.X5_TABELA = 'Z4'
    _cQuery += "   AND XZ4.X5_FILIAL  = '" + xFilial("SX5") + "'"
	_cQuery += "   AND XZ4.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ5
	_cQuery += "    ON TRIM(SB1.B1_XSITOBR) = TRIM(XZ5.X5_CHAVE)
	_cQuery += "   AND XZ5.X5_TABELA = 'Z5'
    _cQuery += "   AND XZ5.X5_FILIAL  = '" + xFilial("SX5") + "'"
	_cQuery += "   AND XZ5.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SZ7") + " SZ7
	_cQuery += "    ON SB5.B5_XAREA = SZ7.Z7_AREA
    _cQuery += "   AND SZ7.Z7_FILIAL  = '" + xFilial("SZ7") + "'"
	_cQuery += "   AND SZ7.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN (SELECT B2_COD, SUM(QTDE) QTDE, SUM(QTDECONSIG) QTDECONSIG, SUM(QTDE+QTDECONSIG) QTDETOTAL
	_cQuery += "          FROM (SELECT B2_COD, B2_QATU QTDE, 0 QTDECONSIG
	_cQuery += "                  FROM " + RetSqlName("SB2")
	_cQuery += "                 WHERE B2_FILIAL = '1022'
	_cQuery += "                   AND B2_LOCAL = '01'
	_cQuery += "                   AND D_E_L_E_T_ = ' '
	_cQuery += "                UNION ALL
	_cQuery += "                SELECT B6_PRODUTO, 0, SUM(B6_SALDO)
	_cQuery += "                  FROM " + RetSqlName("SB6")
	_cQuery += "                 WHERE B6_FILIAL = '1022'
	_cQuery += "                   AND B6_LOCAL = '01'
	_cQuery += "                   AND B6_TIPO = 'E'
	_cQuery += "                   AND D_E_L_E_T_  = ' '
	_cQuery += "                 GROUP BY B6_PRODUTO)
	_cQuery += "         GROUP BY B2_COD) EST
	_cQuery += "    ON SB1.B1_COD = EST.B2_COD
	_cQuery += "  LEFT JOIN (SELECT SB9.B9_COD, SB9.B9_CM1
	_cQuery += "               FROM " + RetSqlName("SB9") + " SB9
	_cQuery += "               JOIN " + RetSqlName("SB1") + " SB1
	_cQuery += "                 ON SB9.B9_COD = SB1.B1_COD 
    _cQuery += "                AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
	_cQuery += "                AND SB1.D_E_L_E_T_  = ' '
	_cQuery += "              WHERE SB9.B9_LOCAL = '01'
	_cQuery += "                AND SB9.B9_FILIAL = DECODE(SB1.B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "                AND SB9.D_E_L_E_T_  = ' '
	_cQuery += "                AND SB9.B9_DATA = (SELECT MAX(B9_DATA)
	_cQuery += "                                     FROM " + RetSqlName("SB9")
	_cQuery += "                                    WHERE B9_LOCAL = '01'
	_cQuery += "                                      AND B9_FILIAL = DECODE(SB1.B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "                                      AND D_E_L_E_T_ = ' ')) CST
	_cQuery += "    ON SB1.B1_COD = CST.B9_COD
	_cQuery += " WHERE (F.VALOR_AA <> 0 OR F.VALOR <> 0)
	If _cMes = '01'
		_cQuery += "    OR (QTDJAN <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '02'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '03'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '04'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0 OR QTDABR <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '05'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0 OR QTDABR <>  0 OR QTDMAI <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '06'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0 OR QTDABR <>  0 OR QTDMAI <>  0 OR QTDJUN <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '07'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0 OR QTDABR <>  0 OR QTDMAI <>  0 OR QTDJUN <>  0 OR QTDJUL <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '08'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0 OR QTDABR <>  0 OR QTDMAI <>  0 OR QTDJUN <>  0 OR QTDJUL <>  0 OR QTDAGO <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '09'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0 OR QTDABR <>  0 OR QTDMAI <>  0 OR QTDJUN <>  0 OR QTDJUL <>  0 OR QTDAGO <>  0 OR QTDSET <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '10'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0 OR QTDABR <>  0 OR QTDMAI <>  0 OR QTDJUN <>  0 OR QTDJUL <>  0 OR QTDAGO <>  0 OR QTDSET <>  0 OR QTDOUT <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '11'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0 OR QTDABR <>  0 OR QTDMAI <>  0 OR QTDJUN <>  0 OR QTDJUL <>  0 OR QTDAGO <>  0 OR QTDSET <>  0 OR QTDOUT <>  0 OR QTDNOV <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	If _cMes = '12'
		_cQuery += "    OR (QTDJAN <>  0 OR QTDFEV <>  0 OR QTDMAR <>  0 OR QTDABR <>  0 OR QTDMAI <>  0 OR QTDJUN <>  0 OR QTDJUL <>  0 OR QTDAGO <>  0 OR QTDSET <>  0 OR QTDOUT <>  0 OR QTDNOV <>  0 OR QTDDEZ <>  0
		_cQuery += "    OR  QTDJAN_AA <>  0 OR QTDFEV_AA <>  0 OR QTDMAR_AA <>  0 OR QTDABR_AA <>  0 OR QTDMAI_AA <>  0 OR QTDJUN_AA <>  0 OR QTDJUL_AA <>  0 OR QTDAGO_AA <>  0 OR QTDSET_AA <>  0 OR QTDOUT_AA <>  0 OR QTDNOV_AA <>  0 OR QTDDEZ_AA <>  0)
    EndIf
	_cQuery += " ORDER BY F.VALOR DESC, F.VALOR_AA DESC)
	_cQuery += " WHERE ROWNUM > 0
	If !Empty(MV_PAR02)
		_cQuery += "   AND B1_PROC = '"+MV_PAR02+"'
	Endif 
	If !Empty(MV_PAR03)
		_cQuery += "   AND B1_LOJPROC = '"+MV_PAR03+"'
	Endif
	If !Empty(MV_PAR05)
		_cQuery += "   AND B1_XIDTPPU = '"+MV_PAR05+"'
	Endif
	If !Empty(MV_PAR04)
		_cQuery += "   AND B5_XAREA = '"+MV_PAR04+"'
	Endif

	
	If Select(_cAlias1) > 0
		dbSelectArea(_cAlias1)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)
	
	oReport:IncMeter()

	oSection1:Init()  

	If (_cAlias1)->TVALOR_AA <> 0
		xPercVlr := (_cAlias1)->TVALOR / (_cAlias1)->TVALOR_AA * 100
	Else
		xPercVlr := 0
	EndIf

	If (_cAlias1)->TQTDE_AA <> 0
		xPercQtd := (_cAlias1)->TQTDE / (_cAlias1)->TQTDE_AA * 100
	Else
		xPercQtd := 0
	EndIf
                         
	oSection1:Cell("B1_COD"			):SetValue(xCodigo) 
	oSection1:Cell("ISBN"			):SetValue(xISBN)
	oSection1:Cell("DESCRICAO"		):SetValue(xDescricao)
	oSection1:Cell("AREA"			):SetValue(xArea)
	oSection1:Cell("SELO"			):SetValue(xSelo)
	oSection1:Cell("DATAPUBLICACAO"	):SetValue(xDataPub)
	oSection1:Cell("TIPOPUBLICACAO"	):SetValue(xTipoPub)
	oSection1:Cell("SITUACAOOBRA"	):SetValue(xSituacao)
	oSection1:Cell("ESTOQUE"		):SetValue((_cAlias1)->TESTOQUE)
	oSection1:Cell("ESTOQUECSG"		):SetValue((_cAlias1)->TESTOQUECSG)
	oSection1:Cell("ESTOQUEDISP"	):SetValue((_cAlias1)->TESTOQUEDISP)
	oSection1:Cell("VALOR"			):SetValue((_cAlias1)->TVALOR)
	oSection1:Cell("VALOR_AA"		):SetValue((_cAlias1)->TVALOR_AA)
	oSection1:Cell("PERC_VLR"		):SetValue(xPercVlr)
	oSection1:Cell("QTDE"			):SetValue((_cAlias1)->TQTDE)
	oSection1:Cell("QTDE_AA"		):SetValue((_cAlias1)->TQTDE_AA)
	oSection1:Cell("PERC_QTD"		):SetValue(xPercQtd)
	oSection1:Cell("QTDJAN_AA"		):SetValue((_cAlias1)->TQTDJAN_AA)
	oSection1:Cell("QTDFEV_AA"		):SetValue((_cAlias1)->TQTDFEV_AA)
	oSection1:Cell("QTDMAR_AA"		):SetValue((_cAlias1)->TQTDMAR_AA)
	oSection1:Cell("QTDABR_AA"		):SetValue((_cAlias1)->TQTDABR_AA)
	oSection1:Cell("QTDMAI_AA"		):SetValue((_cAlias1)->TQTDMAI_AA)
	oSection1:Cell("QTDJUN_AA"		):SetValue((_cAlias1)->TQTDJUN_AA)
	oSection1:Cell("QTDJUL_AA"		):SetValue((_cAlias1)->TQTDJUL_AA)
	oSection1:Cell("QTDAGO_AA"		):SetValue((_cAlias1)->TQTDAGO_AA)
	oSection1:Cell("QTDSET_AA"		):SetValue((_cAlias1)->TQTDSET_AA)
	oSection1:Cell("QTDOUT_AA"		):SetValue((_cAlias1)->TQTDOUT_AA)
	oSection1:Cell("QTDNOV_AA"		):SetValue((_cAlias1)->TQTDNOV_AA)
	oSection1:Cell("QTDDEZ_AA"		):SetValue((_cAlias1)->TQTDDEZ_AA)
	oSection1:Cell("QTDJAN"			):SetValue((_cAlias1)->TQTDJAN)
	If _cMes >= '02'
		oSection1:Cell("QTDFEV"		):SetValue((_cAlias1)->TQTDFEV)
	EndIf
	If _cMes >= '03'
		oSection1:Cell("QTDMAR"		):SetValue((_cAlias1)->TQTDMAR)
	EndIf
	If _cMes >= '04'
		oSection1:Cell("QTDABR"		):SetValue((_cAlias1)->TQTDABR)
	EndIf
	If _cMes >= '05'
		oSection1:Cell("QTDMAI"		):SetValue((_cAlias1)->TQTDMAI)
	EndIf
	If _cMes >= '06'
		oSection1:Cell("QTDJUN"		):SetValue((_cAlias1)->TQTDJUN)
	EndIf
	If _cMes >= '07'
		oSection1:Cell("QTDJUL"		):SetValue((_cAlias1)->TQTDJUL)
	EndIf
	If _cMes >= '08'
		oSection1:Cell("QTDAGO"		):SetValue((_cAlias1)->TQTDAGO)
	EndIf
	If _cMes >= '09'
		oSection1:Cell("QTDSET"		):SetValue((_cAlias1)->TQTDSET)
	EndIf
	If _cMes >= '10'
		oSection1:Cell("QTDOUT"		):SetValue((_cAlias1)->TQTDOUT)
	EndIf
	If _cMes >= '11'
		oSection1:Cell("QTDNOV"		):SetValue((_cAlias1)->TQTDNOV)
	EndIf
	If _cMes >= '12'
		oSection1:Cell("QTDDEZ"		):SetValue((_cAlias1)->TQTDDEZ)
	EndIf

	oSection1:PrintLine()

	oReport:SkipLine()

	Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
		oReport:IncMeter()

		If (_cAlias1)->VALOR_AA <> 0
			xPercVlr := (_cAlias1)->VALOR / (_cAlias1)->VALOR_AA * 100
		Else
			xPercVlr := 0
		EndIf
	
		If (_cAlias1)->QTDE_AA <> 0
			xPercQtd := (_cAlias1)->QTDE / (_cAlias1)->QTDE_AA * 100
		Else
			xPercQtd := 0
		EndIf
	                         
        xDataPub := DTOC(STOD((_cAlias1)->DATAPUBLICACAO))
        
		oSection1:Cell("B1_COD"			):SetValue((_cAlias1)->B1_COD) 
		oSection1:Cell("ISBN"  			):SetValue((_cAlias1)->ISBN)
		oSection1:Cell("DESCRICAO"		):SetValue((_cAlias1)->DESCRICAO)
		oSection1:Cell("AREA"			):SetValue((_cAlias1)->AREA)
		oSection1:Cell("SELO"			):SetValue((_cAlias1)->SELO)
		oSection1:Cell("DATAPUBLICACAO"	):SetValue(xDataPub)
		oSection1:Cell("TIPOPUBLICACAO"	):SetValue((_cAlias1)->TIPOPUBLICACAO)
		oSection1:Cell("SITUACAOOBRA"	):SetValue((_cAlias1)->SITUACAOOBRA)
		oSection1:Cell("ESTOQUE"		):SetValue((_cAlias1)->ESTOQUE)
		oSection1:Cell("ESTOQUECSG"		):SetValue((_cAlias1)->ESTOQUECSG)
		oSection1:Cell("ESTOQUEDISP"	):SetValue((_cAlias1)->ESTOQUEDISP)
		oSection1:Cell("VALOR"			):SetValue((_cAlias1)->VALOR)
		oSection1:Cell("VALOR_AA"		):SetValue((_cAlias1)->VALOR_AA)
		oSection1:Cell("PERC_VLR"		):SetValue(xPercVlr)
		oSection1:Cell("QTDE"			):SetValue((_cAlias1)->QTDE)
		oSection1:Cell("QTDE_AA"		):SetValue((_cAlias1)->QTDE_AA)
		oSection1:Cell("PERC_QTD"		):SetValue(xPercQtd)
		oSection1:Cell("QTDJAN_AA"		):SetValue((_cAlias1)->QTDJAN_AA)
		oSection1:Cell("QTDFEV_AA"		):SetValue((_cAlias1)->QTDFEV_AA)
		oSection1:Cell("QTDMAR_AA"		):SetValue((_cAlias1)->QTDMAR_AA)
		oSection1:Cell("QTDABR_AA"		):SetValue((_cAlias1)->QTDABR_AA)
		oSection1:Cell("QTDMAI_AA"		):SetValue((_cAlias1)->QTDMAI_AA)
		oSection1:Cell("QTDJUN_AA"		):SetValue((_cAlias1)->QTDJUN_AA)
		oSection1:Cell("QTDJUL_AA"		):SetValue((_cAlias1)->QTDJUL_AA)
		oSection1:Cell("QTDAGO_AA"		):SetValue((_cAlias1)->QTDAGO_AA)
		oSection1:Cell("QTDSET_AA"		):SetValue((_cAlias1)->QTDSET_AA)
		oSection1:Cell("QTDOUT_AA"		):SetValue((_cAlias1)->QTDOUT_AA)
		oSection1:Cell("QTDNOV_AA"		):SetValue((_cAlias1)->QTDNOV_AA)
		oSection1:Cell("QTDDEZ_AA"		):SetValue((_cAlias1)->QTDDEZ_AA)
		oSection1:Cell("QTDJAN"			):SetValue((_cAlias1)->QTDJAN)
		If _cMes >= '02'
			oSection1:Cell("QTDFEV"		):SetValue((_cAlias1)->QTDFEV)
		EndIf
		If _cMes >= '03'
			oSection1:Cell("QTDMAR"		):SetValue((_cAlias1)->QTDMAR)
		EndIf
		If _cMes >= '04'
			oSection1:Cell("QTDABR"		):SetValue((_cAlias1)->QTDABR)
		EndIf
		If _cMes >= '05'
			oSection1:Cell("QTDMAI"		):SetValue((_cAlias1)->QTDMAI)
		EndIf
		If _cMes >= '06'
			oSection1:Cell("QTDJUN"		):SetValue((_cAlias1)->QTDJUN)
		EndIf
		If _cMes >= '07'
			oSection1:Cell("QTDJUL"		):SetValue((_cAlias1)->QTDJUL)
		EndIf
		If _cMes >= '08'
			oSection1:Cell("QTDAGO"		):SetValue((_cAlias1)->QTDAGO)
		EndIf
		If _cMes >= '09'
			oSection1:Cell("QTDSET"		):SetValue((_cAlias1)->QTDSET)
		EndIf
		If _cMes >= '10'
			oSection1:Cell("QTDOUT"		):SetValue((_cAlias1)->QTDOUT)
		EndIf
		If _cMes >= '11'
			oSection1:Cell("QTDNOV"		):SetValue((_cAlias1)->QTDNOV)
		EndIf
		If _cMes >= '12'
			oSection1:Cell("QTDDEZ"		):SetValue((_cAlias1)->QTDDEZ)
		EndIf
	
		oSection1:PrintLine()

		(_cAlias1)->(dbSkip())		
	EndDo
	oSection1:Finish()
	         
	DbSelectArea(_cAlias1)
	DbCloseArea()
Endif
	
Return(.t.)
