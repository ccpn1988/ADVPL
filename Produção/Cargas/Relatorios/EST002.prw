#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EST002    ºAutor  ³Helimar Tavares     º Data ³  04/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Obsolescencia                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Estoque/Custos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Alteraoes:

/*/

User Function EST002()
//User Function TST001()

Local oReport
Local cPerg := "EST002"

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
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

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
AADD(aHelpPor,"serão consideradas todas as   ")
AADD(aHelpPor,"opções.                       ")

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
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Fornecedor.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSX1(cPerg, cItPerg, "Estoque:", "Estoque:","Estoque:", cMVCH , "C", 1, 0, 1, "C","", "", "", "", cMVPAR, "Último Salvo", "Último Salvo", "Último Salvo", "", "Atual", "Atual", "Atual", "", "", "", "", "","", "", "", "", "", "", "", "" )

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio
*/

Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio

cAlias := GetNextAlias()
cQuery := "SELECT STOC(MAX(B9_DATA)) DATA
cQuery += "  FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
cQuery += " WHERE SB9.B9_COD = SB1.B1_COD
cQuery += "   AND SB9.B9_LOCAL = '01'
cQuery += "   AND SB9.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
cQuery += "   AND SB9.D_E_L_E_T_ = ' '

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
dbSelectArea(cAlias)
dbGoTop()
Do While !(cAlias)->(Eof())
	cData := (cAlias)->DATA
	(cAlias)->(dbSkip())
Enddo
fErase(cAlias)

If (MV_PAR05 == 2)
	cData := DTOC(DATE())
EndIf

oReport := TReport():New("EST002","EST002 - OBSOLESCÊNCIA DE ESTOQUE - "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02),cPerg,{|oReport| PrintReport(oReport)},"EST002 - OBSOLESCÊNCIA DE ESTOQUE",.T.)

oReport:NDEVICE := 4

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.
oReport:lDisableOrientation := .T.

//Secao do relatorio
oSection1 := TRSection():New(oReport,"EST002 - OBSOLESCÊNCIA DE ESTOQUE - "+DTOC(MV_PAR01)+" a "+DTOC(MV_PAR02),"SB2")

//Celulas da secao
TRCell():New(oSection1,"CODIGO"			,"   ","Código"						,			 ,10)
TRCell():New(oSection1,"ISBN"			,"   ","ISBN"						,			 ,15)
TRCell():New(oSection1,"DESCRICAO"		,"   ","Descrição"					,			 ,20)
TRCell():New(oSection1,"DATAPUBLICACAO"	,"   ","Data"+CRLF+"Lançamento"		,,15)
//TRCell():New(oSection1,"GRUPO"		    ,"SBM","Grupo"						,,25)
//TRCell():New(oSection1,"CENTROCUSTO"	,"CTT","Centro"+CRLF+"Custo"		,,25)
TRCell():New(oSection1,"SITUACAOOBRA"	,"   ","Sit."+CRLF+"Obra"			,,25)
TRCell():New(oSection1,"TIPOPUBLICACAO"	,"   ","Tipo"+CRLF+"Pub."			,,25)
TRCell():New(oSection1,"EMPRESA"		,"   ","Empresa"					,,10)
TRCell():New(oSection1,"AREA"			,"   ","Área"						,,15)
TRCell():New(oSection1,"CUSTO"			,"   ","Custo "+cData				,"@E 999,999.99",10)
TRCell():New(oSection1,"QTDE"			,"   ","Qtde "+cData				,"@E 999,999",8)
TRCell():New(oSection1,"CUSTOTOTAL"		,"   ","Custo"+CRLF+"Total"			,"@E 999,999,999.99",18)
TRCell():New(oSection1,"VENDA"			,"   ","Venda"			 			,"@E 999,999",8)
TRCell():New(oSection1,"PROJ_4ANOS"		,"SB5","Proj."+CRLF+"4 anos"		,"@E 999,999",8)
TRCell():New(oSection1,"QTDOBLTBOM"		,"   ","Qtde Obs"+CRLF+"Bom"		,"@E 999,999",10)
TRCell():New(oSection1,"QTDOBLTDEF"		,"   ","Qtde Obs"+CRLF+"Defeito"	,"@E 999,999",10)
TRCell():New(oSection1,"QTDOBLTTOT"		,"   ","Qtde Obs"+CRLF+"Total"		,"@E 999,999",10)
TRCell():New(oSection1,"VLROBLTBOM"		,"   ","Valor Obs"+CRLF+"Bom"		,"@E 999,999,999.99",18)
TRCell():New(oSection1,"VLROBLTDEF"		,"   ","Valor Obs"+CRLF+"Defeito"	,"@E 999,999,999.99",18)
TRCell():New(oSection1,"VLROBLTTOT"		,"   ","Valor Obs"+CRLF+"Total"		,"@E 999,999,999.99",18)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio
*/

Static Function PrintReport(oReport)

Local oSection1   := oReport:Section(1)
Local cAlias1     := GetNextAlias()
Local _cQuery     := ""   					//Filtros variáveis da query
Local xQtdObltBom := 0
Local xQtdObltDef := 0
Local xQtdObltTot := 0
Local xVlrObltBom := 0
Local xVlrObltDef := 0
Local xVlrObltTot := 0

If oReport:NDEVICE <> 4
	MsgInfo("Este relatório somente poderá ser impresso em Excel.")
	Return(.t.)
Endif

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)

oReport:SetLandScape()

//Cria query
_cQuery := "SELECT TRIM(SB1.B1_COD) B1_COD, SB1.B1_ISBN,
_cQuery += "	   DECODE(SB5.B5_XDTPUBL, ' ', PVENDA.DATA, SB5.B5_XDTPUBL) DATAPUBLICACAO,
_cQuery += "	   TRIM(SB1.B1_DESC) B1_DESC,
//_cQuery += "	   TRIM(SB5.B5_XEDICAO) EDICAO,
//_cQuery += "	   TRIM(SBM.BM_DESC) CLASSEOBRA,
//_cQuery += "	   TRIM(CTT.CTT_DESC01) CENTROLUCRO,
_cQuery += "	   TRIM(SB1.B1_XSITOBR) B1_XSITOBR,
_cQuery += "	   TRIM(SZ4.Z4_DESC) SITUACAOOBRA,
_cQuery += "	   TRIM(SB1.B1_XIDTPPU) B1_XIDTPPU,
_cQuery += "	   TRIM(Z4.X5_DESCRI) TIPOPUBLICACAO,
_cQuery += "	   TRIM(SZ7.Z7_DESC) AREA,
_cQuery += "	   NVL(E.BOM, 0)+NVL(E.CONSIGNACAO, 0)+NVL(E.TRAPICHE1, 0)+NVL(E.TRANSITO, 0) QTDE,
_cQuery += "	   NVL(E.BOM, 0) QTD_BOM,
_cQuery += "	   NVL(E.DEFEITO, 0) QTD_DEFEITO,
_cQuery += "	   NVL(E.TRAPICHE1, 0) QTD_TRAPICHE1,
_cQuery += "	   NVL(E.TRANSITO, 0) QTD_TRANSITO,
_cQuery += "	   NVL(E.CONSIGNACAO, 0) QTD_CONSIGNACAO,
_cQuery += "	   NVL(E.CUSTO, 0) CUSTO,
_cQuery += "	   STOC(E.DATA) DATA_ESTOQUE,
_cQuery += "	   NVL(F.QTDVND, 0) VENDA,
_cQuery += "	   NVL(F.QTDVND*4, 0) PROJ_4ANOS,
_cQuery += "	   CASE WHEN SB5.B5_XDTPUBL >= '" + _cParm1 + "'"
_cQuery += "	        THEN 0
_cQuery += "	        WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','6','11','18')
_cQuery += "	        THEN 0
_cQuery += "	        WHEN TRIM(SB1.B1_XSITOBR) IN ('102','103','111')
_cQuery += "	        THEN NVL(E.BOM, 0)+NVL(E.CONSIGNACAO, 0)+NVL(E.TRANSITO, 0)+NVL(E.TRAPICHE1, 0)
_cQuery += "	        WHEN NVL(E.BOM, 0)+NVL(E.CONSIGNACAO, 0)+NVL(E.TRANSITO, 0)+NVL(E.TRAPICHE1, 0)-NVL(F.QTDVND*4, 0) < 0
_cQuery += "	        THEN 0
_cQuery += "	        WHEN NVL(F.QTDVND, 0) < 0
_cQuery += "            THEN NVL(E.BOM, 0)+NVL(E.CONSIGNACAO, 0)+NVL(E.TRANSITO, 0)+NVL(E.TRAPICHE1, 0)
_cQuery += "            ELSE NVL(E.BOM, 0)+NVL(E.CONSIGNACAO, 0)+NVL(E.TRANSITO, 0)+NVL(E.TRAPICHE1, 0)-NVL(F.QTDVND*4, 0)
_cQuery += "            END QTDOBLTBOM,
_cQuery += "	   TRIM(SB1.B1_PROC) B1_PROC,
_cQuery += "	   TRIM(SB1.B1_LOJPROC) B1_LOJPROC,
_cQuery += "	   DECODE(SB1.B1_PROC,'0380795','EGK','0380796','LTC','0380794','FORENSE','031811 ','ACF','378803 ','GEN','0378128','ATLAS') EMPRESA
_cQuery += "	   FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5,
//_cQuery += "            (SELECT * FROM " + RetSqlName("SBM") + " WHERE BM_FILIAL = '"+ xFilial("SBM") + "' AND D_E_L_E_T_ = ' ') SBM,
_cQuery += "            (SELECT X5_CHAVE, X5_DESCRI FROM " + RetSqlName("SX5") + " WHERE X5_TABELA = 'Z4' AND X5_FILIAL = '" + xFilial("SX5") + "' AND D_E_L_E_T_ = ' ') Z4,
//_cQuery += "            (SELECT * FROM " + RetSqlName("CTT") + " WHERE CTT_FILIAL = '" + xFilial("CTT") + "' AND D_E_L_E_T_ = ' ') CTT,
_cQuery += "            (SELECT Z4_COD, Z4_DESC FROM " + RetSqlName("SZ4") + " WHERE Z4_FILIAL = '" + xFilial("SZ4") + "' AND D_E_L_E_T_ = ' ') SZ4,
_cQuery += "            (SELECT Z7_AREA, Z7_DESC FROM " + RetSqlName("SZ7") + " WHERE Z7_FILIAL = '" + xFilial("SZ7") + "' AND D_E_L_E_T_ = ' ') SZ7,
_cQuery += "	   		(SELECT B1_COD, SUM(QTDE) QTDVND
_cQuery += "	   		   FROM (SELECT SB1.B1_COD B1_COD, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE
_cQuery += "					   FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1
_cQuery += "					  WHERE SD2.D2_COD = SB1.B1_COD
_cQuery += "						AND SD2.D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_  = ' ')
_cQuery += "						AND SD2.D2_FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "						AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "						AND SD2.D2_TIPO NOT IN ('D','B')
_cQuery += "						AND SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += "						AND SD2.D_E_L_E_T_  = ' '
_cQuery += "						AND SB1.D_E_L_E_T_  = ' '
_cQuery += "					  GROUP BY SB1.B1_COD
_cQuery += "					 UNION ALL
_cQuery += "					 SELECT SB1.B1_COD, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0)*(-1) QTDE
_cQuery += "	 				   FROM " + RetSqlName("SD1") + " SD1, " + RetSqlName("SB1") + " SB1
_cQuery += "					  WHERE SD1.D1_COD = SB1.B1_COD
_cQuery += "						AND SD1.D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_CF IN ('1201','1202','1922') AND F4_TIPO = 'E' AND D_E_L_E_T_  = ' ')
_cQuery += "						AND SD1.D1_FILIAL  = '" + xFilial("SD1") + "'"
_cQuery += "						AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
//_cQuery += "						AND SD1.D1_TIPO    = 'D'
_cQuery += "						AND SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += "						AND SD1.D_E_L_E_T_  = ' '
_cQuery += "						AND SB1.D_E_L_E_T_  = ' '
_cQuery += "				      GROUP BY SB1.B1_COD)
_cQuery += "			  GROUP BY B1_COD) F,
_cQuery += "		    (SELECT COD, MIN(DATA) DATA
_cQuery += "			   FROM (SELECT D2_COD COD, MIN(D2_EMISSAO) DATA
_cQuery += "					   FROM " + RetSqlName("SD2")
_cQuery += "					  WHERE D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_  = ' ')
_cQuery += "						AND D2_FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "						AND D2_TIPO NOT IN ('D','B')
_cQuery += "						AND D_E_L_E_T_  = ' '
_cQuery += "					  GROUP BY D2_COD
_cQuery += "					 UNION ALL
_cQuery += "					 SELECT LPAD(IDOBRAORIGEM, 8, '0'), MIN(TO_CHAR(DATA, 'yyyymmdd'))
_cQuery += "					   FROM GEN_VND002_VENDA
_cQuery += "					  GROUP BY LPAD(IDOBRAORIGEM, 8, '0'))
_cQuery += "			  GROUP BY COD) PVENDA,
If (MV_PAR05 == 2)
	_cQuery += "			(SELECT B2_COD CODIGO, TO_CHAR(SYSDATE, 'YYYYMMDD') DATA, SUM(BOM) BOM, SUM(DEFEITO) DEFEITO, SUM(TRAPICHE1) TRAPICHE1, SUM(TRANSITO) TRANSITO,
	_cQuery += "					SUM(CONSIGNACAO) CONSIGNACAO, SUM(CUSTO) CUSTO
	_cQuery += "			   FROM (SELECT B2_COD, B2_QATU BOM, 0 DEFEITO, 0 TRAPICHE1, 0 TRANSITO, 0 CONSIGNACAO, 0 CUSTO
	_cQuery += "					   FROM " + RetSqlName("SB2")
	_cQuery += "					  WHERE B2_FILIAL = '" + xFilial("SB2") + "'"
	_cQuery += "						AND B2_LOCAL = '01'
	_cQuery += "						AND D_E_L_E_T_  = ' '
	_cQuery += "					 UNION ALL
	_cQuery += "					 SELECT B2_COD, 0, B2_QATU, 0, 0, 0, 0
	_cQuery += "					   FROM " + RetSqlName("SB2")
	_cQuery += "					  WHERE B2_FILIAL = '" + xFilial("SB2") + "'"
	_cQuery += "						AND B2_LOCAL = '03'
	_cQuery += "						AND D_E_L_E_T_  = ' '
	_cQuery += "					 UNION ALL
	_cQuery += "					 SELECT B2_COD, 0, 0, B2_QATU, 0, 0, 0
	_cQuery += "					   FROM " + RetSqlName("SB2")
	_cQuery += "					  WHERE B2_FILIAL = '" + xFilial("SB2") + "'"
	_cQuery += "						AND B2_LOCAL = '04'
	_cQuery += "						AND D_E_L_E_T_  = ' '
	_cQuery += "					 UNION ALL
	_cQuery += "					 SELECT B2_COD, 0, 0, 0, B2_QATU, 0, 0
	_cQuery += "					   FROM " + RetSqlName("SB2")
	_cQuery += "					  WHERE B2_FILIAL = '" + xFilial("SB2") + "'"
	_cQuery += "						AND B2_LOCAL = '05'
	_cQuery += "						AND D_E_L_E_T_  = ' '
	_cQuery += "					 UNION ALL
	_cQuery += "					 SELECT B6_PRODUTO, 0, 0, 0, 0, SUM(B6_SALDO), 0
	_cQuery += "					   FROM " + RetSqlName("SB6")
	_cQuery += "					  WHERE B6_FILIAL = '" + xFilial("SB6") + "'"
	_cQuery += "						AND B6_LOCAL = '01'
	_cQuery += "						AND B6_TIPO = 'E'
	_cQuery += "						AND B6_CLIFOR <> '0005065'
	_cQuery += "						AND D_E_L_E_T_  = ' '
	_cQuery += "					  GROUP BY B6_PRODUTO
	_cQuery += "					 UNION ALL
	_cQuery += "					 SELECT SB9.B9_COD, 0, 0, 0, 0, 0, SB9.B9_CM1
	_cQuery += "					   FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
	_cQuery += "					  WHERE SB9.B9_COD = SB1.B1_COD 
	_cQuery += "						AND B9_LOCAL = '01'
	_cQuery += "						AND B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "						AND SB9.D_E_L_E_T_  = ' '
	_cQuery += "						AND SB9.B9_DATA = (SELECT MAX(B9_DATA)
	_cQuery += "						                     FROM " + RetSqlName("SB9") + ", " + RetSqlName("SB1")
	_cQuery += "						                    WHERE SB9000.B9_COD = SB1000.B1_COD
	_cQuery += "						                      AND SB9000.B9_LOCAL = '01'
	_cQuery += "						                      AND SB9000.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "						                      AND SB9000.D_E_L_E_T_ = ' '))
	_cQuery += "			  GROUP BY B2_COD, TO_CHAR(SYSDATE, 'YYYYMMDD')) E
Else	
	_cQuery += "			(SELECT B9_COD CODIGO, MAX(DATA) DATA, SUM(BOM) BOM, SUM(DEFEITO) DEFEITO, SUM(TRAPICHE1) TRAPICHE1, SUM(TRANSITO) TRANSITO,
	_cQuery += "	    				0 CONSIGNACAO, SUM(CUSTO) CUSTO
	_cQuery += "         FROM (SELECT SB9.B9_COD, SB9.B9_DATA DATA, SB9.B9_QINI BOM, 0 DEFEITO, 0 TRAPICHE1, 0 TRANSITO, SB9.B9_CM1 CUSTO
	_cQuery += "    					   FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
	_cQuery += "    					  WHERE SB9.B9_COD = SB1.B1_COD 
	_cQuery += "      						AND SB9.B9_LOCAL = '01'
	_cQuery += "      						AND SB9.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "						      AND SB9.D_E_L_E_T_  = ' '
	_cQuery += "      						AND SB9.B9_DATA = (SELECT MAX(B9_DATA)
	_cQuery += "			      			                     FROM " + RetSqlName("SB9") + ", " + RetSqlName("SB1")
	_cQuery += "      						                    WHERE SB9000.B9_COD = SB1000.B1_COD
	_cQuery += "      						                      AND SB9000.B9_LOCAL = '01'
	_cQuery += "      						                      AND SB9000.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "      						                      AND SB9000.D_E_L_E_T_ = ' ')
	_cQuery += "			    		 UNION ALL
	_cQuery += "               SELECT SB9.B9_COD, SB9.B9_DATA DATA, 0 BOM, SB9.B9_QINI DEFEITO, 0 TRAPICHE1, 0 TRANSITO, 0 CUSTO
	_cQuery += "    					   FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
	_cQuery += "    					  WHERE SB9.B9_COD = SB1.B1_COD 
	_cQuery += "      						AND SB9.B9_LOCAL = '03'
	_cQuery += "      						AND SB9.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "						      AND SB9.D_E_L_E_T_  = ' '
	_cQuery += "      						AND SB9.B9_DATA = (SELECT MAX(B9_DATA)
	_cQuery += "			      			                     FROM " + RetSqlName("SB9") + ", " + RetSqlName("SB1")
	_cQuery += "      						                    WHERE SB9000.B9_COD = SB1000.B1_COD
	_cQuery += "      						                      AND SB9000.B9_LOCAL = '03'
	_cQuery += "      						                      AND SB9000.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "      						                      AND SB9000.D_E_L_E_T_ = ' ')
	_cQuery += "    					 UNION ALL
	_cQuery += "               SELECT SB9.B9_COD, SB9.B9_DATA DATA, 0 BOM, 0 DEFEITO, SB9.B9_QINI TRAPICHE1, 0 TRANSITO, 0 CUSTO
	_cQuery += "    					   FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
	_cQuery += "    					  WHERE SB9.B9_COD = SB1.B1_COD 
	_cQuery += "      						AND SB9.B9_LOCAL = '04'
	_cQuery += "      						AND SB9.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "						      AND SB9.D_E_L_E_T_  = ' '
	_cQuery += "      						AND SB9.B9_DATA = (SELECT MAX(B9_DATA)
	_cQuery += "			      			                     FROM " + RetSqlName("SB9") + ", " + RetSqlName("SB1")
	_cQuery += "      						                    WHERE SB9000.B9_COD = SB1000.B1_COD
	_cQuery += "      						                      AND SB9000.B9_LOCAL = '04'
	_cQuery += "      						                      AND SB9000.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "      						                      AND SB9000.D_E_L_E_T_ = ' ')
	_cQuery += "    					 UNION ALL
	_cQuery += "               SELECT SB9.B9_COD, SB9.B9_DATA DATA, 0 BOM, 0 DEFEITO, 0 TRAPICHE1, SB9.B9_QINI TRANSITO, 0 CUSTO
	_cQuery += "    					   FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
	_cQuery += "    					  WHERE SB9.B9_COD = SB1.B1_COD 
	_cQuery += "      						AND SB9.B9_LOCAL = '05'
	_cQuery += "      						AND SB9.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "						      AND SB9.D_E_L_E_T_  = ' '
	_cQuery += "      						AND SB9.B9_DATA = (SELECT MAX(B9_DATA)
	_cQuery += "			      			                     FROM " + RetSqlName("SB9") + ", " + RetSqlName("SB1")
	_cQuery += "      						                    WHERE SB9000.B9_COD = SB1000.B1_COD
	_cQuery += "      						                      AND SB9000.B9_LOCAL = '05'
	_cQuery += "      						                      AND SB9000.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022', '0378128', '9022', '378803 ', '1022')
	_cQuery += "      						                      AND SB9000.D_E_L_E_T_ = ' '))
	_cQuery += "			  GROUP BY B9_COD) E
Endif	
_cQuery += "	  WHERE SB1.B1_COD     = SB5.B5_COD
//_cQuery += "		AND SB1.B1_GRUPO   = SBM.BM_GRUPO (+)
_cQuery += "		AND SB1.B1_XIDTPPU = Z4.X5_CHAVE (+)
//_cQuery += "		AND SB1.B1_CC      = CTT.CTT_CUSTO (+)
_cQuery += "		AND SB1.B1_XSITOBR = SZ4.Z4_COD (+)
_cQuery += "		AND SB5.B5_XAREA   = SZ7.Z7_AREA (+)
_cQuery += "		AND SB1.B1_COD     = F.B1_COD (+)
_cQuery += "		AND SB1.B1_COD     = PVENDA.COD (+)
_cQuery += "		AND SB1.B1_COD     = E.CODIGO (+)
_cQuery += "		AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "		AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "		AND SB1.D_E_L_E_T_  = ' '
_cQuery += "		AND SB5.D_E_L_E_T_  = ' '
_cQuery += "	    AND (NVL(E.BOM, 0)+NVL(E.CONSIGNACAO, 0)+NVL(E.TRAPICHE1, 0)+NVL(E.TRANSITO, 0) <> 0
_cQuery += "	     OR  NVL(E.DEFEITO, 0) <> 0)

If !Empty(MV_PAR03)
	_cQuery += "   AND SB1.B1_PROC = '"+MV_PAR03+"'
Endif 

If !Empty(MV_PAR04)
	_cQuery += "   AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
Endif

_cQuery += "	ORDER BY EMPRESA, SB1.B1_COD
	
If Select(cAlias1) > 0
	dbSelectArea(cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), cAlias1, .F., .T.)

(cAlias1)->(dbGoTop())

Do While !(cAlias1)->(eof()) .And. !oReport:Cancel()
	xQtdObltTot := (cAlias1)->QTDOBLTBOM + (cAlias1)->QTD_DEFEITO
	xCustoTot   := (cAlias1)->QTDE * (cAlias1)->CUSTO
    xVlrObltBom := (cAlias1)->QTDOBLTBOM * (cAlias1)->CUSTO
    xVlrObltDef := (cAlias1)->QTD_DEFEITO * (cAlias1)->CUSTO
    xVlrObltTot := xQtdObltTot * (cAlias1)->CUSTO

	xDtPubl     := STOD((cAlias1)->DATAPUBLICACAO)
	
	oReport:IncMeter()
	
	oSection1:Init()
	
	oSection1:Cell("CODIGO"):SetValue((cAlias1)->B1_COD)
	oSection1:Cell("ISBN"):SetValue((cAlias1)->B1_ISBN)
	oSection1:Cell("DESCRICAO"):SetValue((cAlias1)->B1_DESC)
	oSection1:Cell("DATAPUBLICACAO"):SetValue(xDtPubl)
//	oSection1:Cell("GRUPO"):SetValue((cAlias1)->CLASSEOBRA)
//	oSection1:Cell("CENTROCUSTO"):SetValue((cAlias1)->CENTROLUCRO)
	oSection1:Cell("SITUACAOOBRA"):SetValue((cAlias1)->SITUACAOOBRA)
	oSection1:Cell("TIPOPUBLICACAO"):SetValue((cAlias1)->TIPOPUBLICACAO)
	oSection1:Cell("EMPRESA"):SetValue((cAlias1)->EMPRESA)
	oSection1:Cell("AREA"):SetValue((cAlias1)->AREA)
	oSection1:Cell("CUSTO"):SetValue((cAlias1)->CUSTO)
	oSection1:Cell("QTDE"):SetValue((cAlias1)->QTDE)
	oSection1:Cell("CUSTOTOTAL"):SetValue(xCustoTot)
	oSection1:Cell("VENDA"):SetValue((cAlias1)->VENDA)
	oSection1:Cell("PROJ_4ANOS"):SetValue((cAlias1)->PROJ_4ANOS)
	oSection1:Cell("QTDOBLTBOM"):SetValue((cAlias1)->QTDOBLTBOM)
	oSection1:Cell("QTDOBLTDEF"):SetValue((cAlias1)->QTD_DEFEITO)
	oSection1:Cell("QTDOBLTTOT"):SetValue(xQtdObltTot)
	oSection1:Cell("VLROBLTBOM"):SetValue(xVlrObltBom)
	oSection1:Cell("VLROBLTDEF"):SetValue(xVlrObltDef)
	oSection1:Cell("VLROBLTTOT"):SetValue(xVlrObltTot)


	oSection1:PrintLine()
	
	(cAlias1)->(dbSkip())
	
EndDo                    

DbSelectArea(cAlias1)
DbCloseArea()

Return(.t.)
