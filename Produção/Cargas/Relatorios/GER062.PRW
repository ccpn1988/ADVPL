#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER062N

DESCRICAO: GER062 - FATURAMENTO ANUAL - AUTOR X TITULO

ALTERACOES:
02/05/2016 - Desenvolvimento do fonte

/*/

User Function GER062

Local oReport
Local cPerg := "GER062"

Private cAutor
Private xAno1
Private xAno2
Private xAno3
Private xAno4
Private xAno5

//Cria grupo de perguntas
f001(cPerg) 
aAutor := Tela001()

cAutor	 := aAutor[1]
cAutNome := aAutor[2]

//Carrega grupo de perguntas
If Pergunte(cPerg,.T.)

	oReport:= ReportDef(cPerg)
	oReport:= ReportDef("")
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
02/05/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function f001(cPerg)

Local cItPerg	:= "00"
Local cMVCH 	:= "MV_CH0"
Local cMVPAR 	:= 'MV_PAR00"
Local aHelpPor 	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local cTitPer 	:= ""     

//---------------------------------------MV_PAR01--------------------------------------------------  
cTitPer:= "Imprime Dados Detentor"

aAdd(aHelpPor,"Com dados do detentor podem   ")
aAdd(aHelpPor,"replicar registros da obra.   ")

PutSX1(cPerg,"01",cTitPer,cTitPer,cTitPer,"mv_ch1","C",1,0,1,"C","","","","","MV_PAR01","Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
02/05/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2

xAno1  := YEAR2STR(DATE())
xAno2  := YEAR2STR(YEARSUB(DATE(),1))
xAno3  := YEAR2STR(YEARSUB(DATE(),2))
xAno4  := YEAR2STR(YEARSUB(DATE(),3))
xAno5  := YEAR2STR(YEARSUB(DATE(),4))
								
//Declaracao do relatorio
oReport := TReport():New("GER062","GER062 - Faturamento Anual - Autor x Título",cPerg,{|oReport| PrintReport(oReport)},"GER062 - Faturamento Anual - Autor x Título",.T.)

oReport:NDEVICE := 4

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7  && 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()
cData := DTOC(DATE())

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Detentor","")
	
//Celulas da secao
TRCell():New(oSection1,"DETENTOR","","",,100)

//Secao do relatorio
oSection2 := TRSection():New(oReport,"Produtos","")

//Celulas da secao
TRCell():New(oSection2,"TIPOPUBLICACAO"		,"","Tipo"+CRLF+"Publicação",,15)
TRCell():New(oSection2,"ANOLANC"			,"","1º Lanç",,4)
TRCell():New(oSection2,"B1_COD"				,"","Código",,8)
TRCell():New(oSection2,"ISBN"				,"","ISBN",,15)
TRCell():New(oSection2,"DESCRICAO"			,"","Descrição",,25)
TRCell():New(oSection2,"EDICAO"				,"","Ed | Ano",,8)
TRCell():New(oSection2,"DATAPUBLICACAO"		,"","Dt. Publ.",,13)
TRCell():New(oSection2,"DATAEXPIRACAO"		,"","Dt. Exp.",,13)
TRCell():New(oSection2,"SITUACAOOBRA"		,"","Sit.Venda",,12)
TRCell():New(oSection2,"ANO5"				,"","Qtd "+xAno5,"@E 9,999,999",6,,,,,"RIGHT") 
TRCell():New(oSection2,"ANO4"				,"","Qtd "+xAno4,"@E 9,999,999",6,,,,,"RIGHT") 
TRCell():New(oSection2,"ANO3"				,"","Qtd "+xAno3,"@E 9,999,999",6,,,,,"RIGHT") 
TRCell():New(oSection2,"ANO2"				,"","Qtd "+xAno2,"@E 9,999,999",6,,,,,"RIGHT") 
TRCell():New(oSection2,"ANO1"				,"","Qtd "+xAno1+" YTD","@E 9,999,999",6,,,,,"RIGHT") 
TRCell():New(oSection2,"LIQ5"				,"","Vl.Líq (R$) "+xAno5,"@E 999,999,999.99",12,,,,,"RIGHT")
TRCell():New(oSection2,"LIQ4"				,"","Vl.Líq (R$) "+xAno4,"@E 999,999,999.99",12,,,,,"RIGHT")
TRCell():New(oSection2,"LIQ3"				,"","Vl.Líq (R$) "+xAno3,"@E 999,999,999.99",12,,,,,"RIGHT")
TRCell():New(oSection2,"LIQ2"				,"","Vl.Líq (R$) "+xAno2,"@E 999,999,999.99",12,,,,,"RIGHT")
TRCell():New(oSection2,"LIQ1"				,"","Vl.Líq (R$) "+xAno1+" YTD","@E 999,999,999.99",15,,,,,"RIGHT")
TRCell():New(oSection2,"BRUTO5"				,"","Vl.Bruto (R$) "+xAno5,"@E 999,999,999.99",12,,,,,"RIGHT")
TRCell():New(oSection2,"BRUTO4"				,"","Vl.Bruto (R$) "+xAno4,"@E 999,999,999.99",12,,,,,"RIGHT")
TRCell():New(oSection2,"BRUTO3"				,"","Vl.Bruto (R$) "+xAno3,"@E 999,999,999.99",12,,,,,"RIGHT")
TRCell():New(oSection2,"BRUTO2"				,"","Vl.Bruto (R$) "+xAno2,"@E 999,999,999.99",12,,,,,"RIGHT")
TRCell():New(oSection2,"BRUTO1"				,"","Vl.Bruto (R$) "+xAno1+" YTD","@E 999,999,999.99",15,,,,,"RIGHT")
TRCell():New(oSection2,"SALDOESTOQUE"		,"","Sld.Estoque em "+cData,"@E 9,999,999",15,,,,,"RIGHT") 
TRCell():New(oSection2,"TIPOENTRADA"		,"","Tipo Entrada",,12)
TRCell():New(oSection2,"CODHISTORICO"		,"","IdHistórico",,8)
TRCell():New(oSection2,"DESCRICAOHISTORICO"	,"","Descrição Histórico",,25)
TRCell():New(oSection2,"CODMAE"				,"","IdObraMãe",,8)
TRCell():New(oSection2,"DESCRICAOMAE"		,"","Descrição Obra Mãe",,25)
TRCell():New(oSection2,"EMPRESA"			,"","Empresa",,25)
TRCell():New(oSection2,"AREA"				,"","Área",,15)
TRCell():New(oSection2,"SELO"				,"","Selo",,8)
TRCell():New(oSection2,"ESTRANGEIRA"		,"","Estrangeira",,10)
TRCell():New(oSection2,"ASSINATURACONTRATO"	,"","Dt. Ass. Contrato",,15)
TRCell():New(oSection2,"STATUSCONTRATO"		,"","Status Contrato",,15)
TRCell():New(oSection2,"TIPOCONTRATO"		,"","Tipo Contrato",,15)
TRCell():New(oSection2,"AUTOR"				,"","Autor DA",,20)
TRCell():New(oSection2,"TITULOCONTRATADO"	,"","Título Contratado",,25)
TRCell():New(oSection2,"ISBNORIGINAL"		,"","ISBN Original",,15)
TRCell():New(oSection2,"PRECO"				,"","Preço (R$)","@E 999,999.99",12,,,,,"RIGHT")
If (MV_PAR01) == 1
	TRCell():New(oSection2,"CODDETENTOR"		,"","Id Detentor",,8)
	TRCell():New(oSection2,"NOMEDETENTOR"		,"","Nome Detentor",,25)
	TRCell():New(oSection2,"GRUPODETENTOR"		,"","Grupo Detentor",,25)
	TRCell():New(oSection2,"TIPODETENTOR"		,"","Tipo Detentor",,25)
	TRCell():New(oSection2,"AUTORPRINCIPAL"		,"","Autor Principal",,15)
	TRCell():New(oSection2,"PERCDA"				,"","% DA","@E 999.99999",12,,,,,"RIGHT")
	TRCell():New(oSection2,"PERCDADET"			,"","% DA Det.","@E 999.99999",12,,,,,"RIGHT")
	TRCell():New(oSection2,"PERCDETENTOR"		,"","% Detentor","@E 999.99999",12,,,,,"RIGHT")
EndIf

oBreak := TRBreak():New(oSection2,oSection2:Cell("TIPOPUBLICACAO"),"Subtotal",.f.)

//Totalizadores
TRFunction():New(oSection2:Cell("ANO5")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("ANO4")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("ANO3")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("ANO2")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("ANO1")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("LIQ5")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("LIQ4")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("LIQ3")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("LIQ2")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("LIQ1")		,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("BRUTO5")	,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("BRUTO4")	,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("BRUTO3")	,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("BRUTO2")	,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell("BRUTO1")	,NIL,"SUM",oBreak,,,,.F.,.F.,.F., oSection2)


//Faz a impressao do totalizador em linha
oSection2:SetTotalInLine(.f.)
//oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
02/05/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local _cAlias1	:= GetNextAlias()
Local _cQuery	:= ""                             

_cTab   := GETMV("GEN_FAT064")

If oReport:NDEVICE <> 4
	MsgInfo("Este relatório somente poderá ser impresso em Excel.")
	Return(.t.)
Endif

_cQuery := "SELECT DISTINCT SB1.B1_XIDTPPU, TRIM(XZ4.X5_DESCRI) TIPOPUBLICACAO, F.ANOLANC, SB1.B1_COD, TRIM(SB1.B1_ISBN) ISBN
_cQuery += "     , TRIM(SB1.B1_DESC) DESCRICAO, TRIM(SB5.B5_XEDICAO) EDICAO, SB5.B5_XDTPUBL, DA.D23_DT_EXPIRACAO, TRIM(XZ5.X5_DESCRI) SITUACAOOBRA
_cQuery += "     , F.ANO5, F.ANO4, F.ANO3, F.ANO2, F.ANO1, F.LIQ5, F.LIQ4, F.LIQ3, F.LIQ2, F.LIQ1, F.BRUTO5, F.BRUTO4, F.BRUTO3, F.BRUTO2, F.BRUTO1, F.TOTAL
_cQuery += "     , SB2.B2_QATU SALDOESTOQUE, DA.TIPOENTRADA, SB5.B5_XCODHIS CODHISTORICO, SB1_H.B1_DESC DESCRICAOHISTORICO, SB1.B1_XIDMAE CODMAE, SB1_M.B1_DESC DESCRICAOMAE
_cQuery += "     , SA2.A2_NOME EMPRESA, SZ7.Z7_DESC AREA, XZ1.X5_DESCRI SELO, DA.ESTRANGEIRA, DA.D23_DT_ASSINATURA_CONTRATO ASSINATURACONTRATO, DA.STATUSCONTRATO
_cQuery += "     , DA.D23_TX_TIPO_CONTRATO TIPOCONTRATO, DA.D41_TX_AUTOR AUTOR, DA1.DA1_PRCVEN PRECO, DA.D41_TX_TITULO_CONTRATADO TITULOCONTRATADO, DA.D41_TX_ISBN_ORIGINAL ISBNORIGINAL
If (MV_PAR01) == 1
	_cQuery += "     , F.V04_ID_DETENTOR CODDETENTOR, F.V04_TX_NOME_COMPLETO NOMEDETENTOR, F.D26_ST_AUTOR_PRINCIPAL AUTORPRINCIPAL, F.GRUPODETENTOR, F.TIPODETENTOR
	_cQuery += "     , F.PERCENTUAL PERCDA, F.PERCENTUALDETENTOR PERCDADET, ROUND(F.PERCENTUAL*F.PERCENTUALDETENTOR/100,5) PERCDETENTOR
EndIf
_cQuery += "  FROM (SELECT DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, FAT.IDOBRAHISTORICO, SFEC.B5_COD), FEC.B5_COD) B1_COD, AL.ANOLANC,
_cQuery += "               FAT.ANO5, FAT.ANO4, FAT.ANO3, FAT.ANO2, FAT.ANO1, FAT.LIQ5, FAT.LIQ4, FAT.LIQ3, FAT.LIQ2, FAT.LIQ1,
_cQuery += "               FAT.BRUTO5, FAT.BRUTO4, FAT.BRUTO3, FAT.BRUTO2, FAT.BRUTO1, (FAT.LIQ5+FAT.LIQ4+FAT.LIQ3+FAT.LIQ2+FAT.LIQ1) TOTAL,
_cQuery += "               HDA.V04_ID_DETENTOR, HDA.V04_TX_NOME_COMPLETO, HDA.D26_ST_AUTOR_PRINCIPAL, HDA.GRUPODETENTOR, HDA.TIPODETENTOR,
_cQuery += "               HDA.D25_VL_PERCENTUAL PERCENTUAL, HDA.D26_VL_PERCENTUAL_DETENTOR PERCENTUALDETENTOR
_cQuery += "          FROM (SELECT IDOBRAHISTORICO, NVL("+'"2015"'+", 0) ANO5, NVL("+'"2016"'+", 0) ANO4, NVL("+'"2017"'+", 0) ANO3, NVL("+'"2018"'+", 0) ANO2, NVL("+'"2019"'+", 0) ANO1,
_cQuery += "                       NVL("+'"8015"'+", 0) LIQ5, NVL("+'"8016"'+", 0) LIQ4, NVL("+'"8017"'+", 0) LIQ3, NVL("+'"8018"'+", 0) LIQ2, NVL("+'"8019"'+", 0) LIQ1,
_cQuery += "                       NVL("+'"9015"'+", 0) BRUTO5, NVL("+'"9016"'+", 0) BRUTO4, NVL("+'"9017"'+", 0) BRUTO3, NVL("+'"9018"'+", 0) BRUTO2, NVL("+'"9019"'+", 0) BRUTO1
_cQuery += "                  FROM (SELECT *
_cQuery += "                          FROM (SELECT IDOBRAHISTORICO, ANO, QTDE
_cQuery += "                                  FROM TT_VENDAANO
_cQuery += "                                 WHERE ANO BETWEEN '"+xAno5+"' AND '"+xAno1+"'"
_cQuery += "                                UNION ALL
_cQuery += "                                SELECT IDOBRAHISTORICO, TO_CHAR(ANO+6000), LIQUIDO
_cQuery += "                                  FROM TT_VENDAANO
_cQuery += "                                 WHERE ANO BETWEEN '"+xAno5+"' AND '"+xAno1+"'"
_cQuery += "                                UNION ALL
_cQuery += "                                SELECT IDOBRAHISTORICO, TO_CHAR(ANO+7000), BRUTO
_cQuery += "                                  FROM TT_VENDAANO
_cQuery += "                                 WHERE ANO BETWEEN '"+xAno5+"' AND '"+xAno1+"')"
_cQuery += "                         PIVOT (SUM(QTDE) FOR ANO IN (2015,2016,2017,2018,2019,8015,8016,8017,8018,8019,9015,9016,9017,9018,9019)))) FAT
_cQuery += "         INNER
_cQuery += "          JOIN (SELECT DISTINCT V02.V02_ID_OBRA_HISTORICA, V04.V04_ID_DETENTOR, V04.V04_TX_NOME_COMPLETO, D26.D26_ST_AUTOR_PRINCIPAL, D2404.D04_TX_DESCRICAO GRUPODETENTOR,
_cQuery += "                       D2604.D04_TX_DESCRICAO TIPODETENTOR, D25.D25_VL_PERCENTUAL, D26.D26_VL_PERCENTUAL_DETENTOR
_cQuery += "                  FROM GUA_DA.DAU_V02_OBRAS V02
_cQuery += "                 INNER JOIN GUA_DA.DAU_D23_CONTRATOS D23
_cQuery += "                    ON V02.V02_CD_OBRA = D23.V02_CD_OBRA	
_cQuery += "                   AND D23.D22_ID_STATUS_CONTRATO = 1	
_cQuery += "                 INNER JOIN GUA_DA.DAU_D24_CONTRATO_TIPO_DETENTOR D24
_cQuery += "                    ON D24.D23_ID_CONTRATO = D23.D23_ID_CONTRATO	
_cQuery += "                 INNER JOIN (SELECT D24_ID_CONTRATO_TIPO_DETENTOR, MAX(D25_VL_PERCENTUAL) D25_VL_PERCENTUAL
_cQuery += "                               FROM GUA_DA.DAU_D25_TIPO_DETENTOR_FAIXAS
_cQuery += "                              GROUP BY D24_ID_CONTRATO_TIPO_DETENTOR) D25
_cQuery += "                    ON D24.D24_ID_CONTRATO_TIPO_DETENTOR = D25.D24_ID_CONTRATO_TIPO_DETENTOR
_cQuery += "                 INNER JOIN GUA_DA.DAU_D26_CONTRATO_DETENTORES D26	
_cQuery += "                    ON D26.D24_ID_CONTRATO_TIPO_DETENTOR = D24.D24_ID_CONTRATO_TIPO_DETENTOR
_cQuery += "                   AND D26.V04_ID_DETENTOR = " + cAutor
_cQuery += "                 INNER JOIN GUA_DA.DAU_V04_DETENTORES V04
_cQuery += "                    ON D26.V04_ID_DETENTOR = V04.V04_ID_DETENTOR
_cQuery += "                 INNER JOIN GUA_DA.DAU_D04_TIPOS_DETENTOR D2404
_cQuery += "                    ON D24.D04_ID_TIPO_DETENTOR = D2404.D04_ID_TIPO_DETENTOR
_cQuery += "                 INNER JOIN GUA_DA.DAU_D04_TIPOS_DETENTOR D2604
_cQuery += "                    ON D26.D04_ID_TIPO_DETENTOR_ORIGINAL = D2604.D04_ID_TIPO_DETENTOR) HDA
_cQuery += "            ON FAT.IDOBRAHISTORICO = HDA.V02_ID_OBRA_HISTORICA  
_cQuery += "          LEFT JOIN (SELECT TO_NUMBER(TRIM(B5_COD)) B5_COD, TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS
_cQuery += "                       FROM " + RetSqlName("SB5")
_cQuery += "                      WHERE B5_XFEC = '1'
_cQuery += "                        AND IS_NUMBER(B5_COD) = 1
_cQuery += "                        AND D_E_L_E_T_ = ' ') FEC
_cQuery += "            ON FAT.IDOBRAHISTORICO = FEC.B5_XCODHIS
_cQuery += "          LEFT JOIN (SELECT TO_NUMBER(TRIM(SB5.B5_COD)) B5_COD, TO_NUMBER(TRIM(SB5.B5_XCODHIS)) B5_XCODHIS
_cQuery += "                       FROM " + RetSqlName("SB5") + " SB5, 
_cQuery += "                            (SELECT TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, MAX(B5_XDTPUBL) B5_XDTPUBL
_cQuery += "                               FROM " + RetSqlName("SB5") + " SB5
_cQuery += "                              WHERE D_E_L_E_T_ = ' '
_cQuery += "                              GROUP BY TO_NUMBER(TRIM(B5_XCODHIS))) M
_cQuery += "                      WHERE TO_NUMBER(TRIM(SB5.B5_XCODHIS)) = M.B5_XCODHIS
_cQuery += "                        AND SB5.B5_XDTPUBL = M.B5_XDTPUBL
_cQuery += "                        AND TRIM(SB5.B5_XFEC) <> '1'
_cQuery += "                        AND SB5.D_E_L_E_T_ = ' ') SFEC
_cQuery += "            ON FAT.IDOBRAHISTORICO = SFEC.B5_XCODHIS
_cQuery += "          LEFT JOIN (SELECT TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, SUBSTR(MIN(B5_XDTPUBL),1,4) ANOLANC
_cQuery += "                       FROM " + RetSqlName("SB5")
_cQuery += "                      WHERE B5_XDTPUBL <> ' '
_cQuery += "                      GROUP BY B5_XCODHIS) AL
_cQuery += "            ON FAT.IDOBRAHISTORICO = AL.B5_XCODHIS) F
_cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON LPAD(F.B1_COD,8,'0') = TRIM(SB1.B1_COD)
_cQuery += " INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery += " INNER JOIN " + RetSqlName("SB2") + " SB2 ON SB1.B1_COD = SB2.B2_COD
_cQuery += "  LEFT JOIN " + RetSqlName("SB1") + " SB1_H ON TO_NUMBER(TRIM(SB5.B5_XCODHIS)) = TO_NUMBER(TRIM(SB1_H.B1_COD)) AND IS_NUMBER(SB1_H.B1_COD) = 1 AND SB1_H.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1_H.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SB1") + " SB1_M ON TO_NUMBER(TRIM(SB1.B1_XIDMAE)) = TO_NUMBER(TRIM(SB1_M.B1_COD)) AND IS_NUMBER(SB1_M.B1_COD) = 1 AND SB1_M.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1_M.D_E_L_E_T_ = ' '
_cQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON SB1.B1_PROC = SA2.A2_COD AND SB1.B1_LOJPROC = SA2.A2_LOJA AND SA2.A2_FILIAL = '" + xFilial("SA2") + "' AND SA2.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ7") + " SZ7 ON SB5.B5_XAREA = SZ7.Z7_AREA AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN (SELECT V02.V02_CD_OBRA, V02.V02_TX_TIPO_INCLUSAO_OBRA TIPOENTRADA, D23.D23_DT_ASSINATURA_CONTRATO, D23.D23_DT_EXPIRACAO, D22.D22_TX_DESCRICAO STATUSCONTRATO,
_cQuery += "                    D23.D23_TX_TIPO_CONTRATO, D41.D41_ST_OBRA_ESTRANGEIRA ESTRANGEIRA, D41.D41_TX_AUTOR, D41.D41_TX_TITULO_CONTRATADO, D41.D41_TX_ISBN_ORIGINAL
_cQuery += "               FROM GUA_DA.DAU_V02_OBRAS V02
_cQuery += "               LEFT JOIN GUA_DA.DAU_D23_CONTRATOS D23 ON V02.V02_CD_OBRA = D23.V02_CD_OBRA
_cQuery += "               LEFT JOIN GUA_DA.DAU_D41_OBRA D41 ON V02.V02_CD_OBRA = D41.V02_CD_OBRA
_cQuery += "               LEFT JOIN GUA_DA.DAU_D22_STATUS_CONTRATO D22 ON D23.D22_ID_STATUS_CONTRATO = D22.D22_ID_STATUS_CONTRATO
_cQuery += "              WHERE D23.D22_ID_STATUS_CONTRATO IN (1)) DA ON F.B1_COD = DA.V02_CD_OBRA
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ1 ON TRIM(SB5.B5_XSELO) = TRIM(XZ1.X5_CHAVE) AND XZ1.X5_TABELA = 'Z1' AND XZ1.X5_FILIAL = '" + xFilial("SX5") + "' AND XZ1.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4 ON TRIM(SB1.B1_XIDTPPU) = TRIM(XZ4.X5_CHAVE) AND XZ4.X5_TABELA = 'Z4' AND XZ4.X5_FILIAL = '" + xFilial("SX5") + "' AND XZ4.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ5 ON TRIM(SB1.B1_XSITOBR) = TRIM(XZ5.X5_CHAVE) AND XZ5.X5_TABELA = 'Z5' AND XZ5.X5_FILIAL = '" + xFilial("SX5") + "' AND XZ5.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("DA1") + " DA1 ON SB1.B1_COD = DA1.DA1_CODPRO AND DA1.DA1_CODTAB = '" + _cTab + "' AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "' AND DA1.D_E_L_E_T_ = ' '
_cQuery += " WHERE F.PERCENTUAL > 0
_cQuery += "   AND F.PERCENTUALDETENTOR > 0
_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery += "   AND SB2.B2_FILIAL = '1022'
_cQuery += "   AND SB2.B2_LOCAL = '01'
_cQuery += "   AND SB2.D_E_L_E_T_ = ' '
_cQuery += "   AND SA2.A2_FILIAL = '" + xFilial("SA2") + "'"
_cQuery += "   AND SA2.D_E_L_E_T_ = ' '
_cQuery += " ORDER BY SB1.B1_XIDTPPU, F.TOTAL DESC

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

cParmAut := "Detentor: " + cAutor + " - " + cAutNome

oSection1:Init()

oSection1:Cell("DETENTOR"):SetValue(cParmAut)
	                                                      
oSection1:PrintLine()

oSection1:Finish()

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	xProduto := (_cAlias1)->B1_COD

	oReport:IncMeter()

	oSection2:Init()  

	oSection2:Cell("TIPOPUBLICACAO"):SetValue((_cAlias1)->TIPOPUBLICACAO)
	oSection2:Cell("ANOLANC"):SetValue((_cAlias1)->ANOLANC)
	oSection2:Cell("B1_COD"):SetValue((_cAlias1)->B1_COD)
	oSection2:Cell("ISBN"):SetValue((_cAlias1)->ISBN)
	oSection2:Cell("DESCRICAO"):SetValue((_cAlias1)->DESCRICAO)
	oSection2:Cell("EDICAO"):SetValue((_cAlias1)->EDICAO)
	oSection2:Cell("DATAPUBLICACAO"):SetValue(STOD((_cAlias1)->B5_XDTPUBL))
	oSection2:Cell("DATAEXPIRACAO"):SetValue((_cAlias1)->D23_DT_EXPIRACAO)
	oSection2:Cell("SITUACAOOBRA"):SetValue((_cAlias1)->SITUACAOOBRA)
	oSection2:Cell("ANO5"):SetValue((_cAlias1)->ANO5)
	oSection2:Cell("ANO4"):SetValue((_cAlias1)->ANO4)
	oSection2:Cell("ANO3"):SetValue((_cAlias1)->ANO3)
	oSection2:Cell("ANO2"):SetValue((_cAlias1)->ANO2)
	oSection2:Cell("ANO1"):SetValue((_cAlias1)->ANO1)
	oSection2:Cell("LIQ5"):SetValue((_cAlias1)->LIQ5)
	oSection2:Cell("LIQ4"):SetValue((_cAlias1)->LIQ4)
	oSection2:Cell("LIQ3"):SetValue((_cAlias1)->LIQ3)
	oSection2:Cell("LIQ2"):SetValue((_cAlias1)->LIQ2)
	oSection2:Cell("LIQ1"):SetValue((_cAlias1)->LIQ1)
	oSection2:Cell("BRUTO5"):SetValue((_cAlias1)->BRUTO5)
	oSection2:Cell("BRUTO4"):SetValue((_cAlias1)->BRUTO4)
	oSection2:Cell("BRUTO3"):SetValue((_cAlias1)->BRUTO3)
	oSection2:Cell("BRUTO2"):SetValue((_cAlias1)->BRUTO2)
	oSection2:Cell("BRUTO1"):SetValue((_cAlias1)->BRUTO1)
	oSection2:Cell("SALDOESTOQUE"):SetValue((_cAlias1)->SALDOESTOQUE)
	oSection2:Cell("TIPOENTRADA"):SetValue((_cAlias1)->TIPOENTRADA)
	oSection2:Cell("CODHISTORICO"):SetValue((_cAlias1)->CODHISTORICO)
	oSection2:Cell("DESCRICAOHISTORICO"):SetValue((_cAlias1)->DESCRICAOHISTORICO)
	oSection2:Cell("CODMAE"):SetValue((_cAlias1)->CODMAE)
	oSection2:Cell("DESCRICAOMAE"):SetValue((_cAlias1)->DESCRICAOMAE)
	oSection2:Cell("EMPRESA"):SetValue((_cAlias1)->EMPRESA)
	oSection2:Cell("AREA"):SetValue((_cAlias1)->AREA)
	oSection2:Cell("SELO"):SetValue((_cAlias1)->SELO)
	oSection2:Cell("ESTRANGEIRA"):SetValue((_cAlias1)->ESTRANGEIRA)
	oSection2:Cell("ASSINATURACONTRATO"):SetValue((_cAlias1)->ASSINATURACONTRATO)
	oSection2:Cell("STATUSCONTRATO"):SetValue((_cAlias1)->STATUSCONTRATO)
	oSection2:Cell("TIPOCONTRATO"):SetValue((_cAlias1)->TIPOCONTRATO)
	oSection2:Cell("AUTOR"):SetValue((_cAlias1)->AUTOR)
	oSection2:Cell("TITULOCONTRATADO"):SetValue((_cAlias1)->TITULOCONTRATADO)
	oSection2:Cell("ISBNORIGINAL"):SetValue((_cAlias1)->ISBNORIGINAL)
	oSection2:Cell("PRECO"):SetValue((_cAlias1)->PRECO)
	If (MV_PAR01) == 1
		oSection2:Cell("CODDETENTOR"):SetValue((_cAlias1)->CODDETENTOR)
		oSection2:Cell("NOMEDETENTOR"):SetValue((_cAlias1)->NOMEDETENTOR)
		oSection2:Cell("GRUPODETENTOR"):SetValue((_cAlias1)->GRUPODETENTOR)
		oSection2:Cell("TIPODETENTOR"):SetValue((_cAlias1)->TIPODETENTOR)
		oSection2:Cell("AUTORPRINCIPAL"):SetValue((_cAlias1)->AUTORPRINCIPAL)
		oSection2:Cell("PERCDA"):SetValue((_cAlias1)->PERCDA)
		oSection2:Cell("PERCDADET"):SetValue((_cAlias1)->PERCDADET)
		oSection2:Cell("PERCDETENTOR"):SetValue((_cAlias1)->PERCDETENTOR)
	EndIf

	oSection2:PrintLine()

	(_cAlias1)->(dbSkip())
EndDo
oSection2:Finish()
         
DbSelectArea(_cAlias1)
DbCloseArea()
	
Return(.t.)

/*
Funcao: Tela001()

Descricao: Tela de pesquisa de autores

------------------------------------------------------------------------------------------------
Alteracoes:
13/05/2016 - Rafael Leite - Criacao do fonte
*/
                               
Static Function Tela001()

Local aArea			:= GetArea()
Local cTitulo		:= "Detentores"

Local oListBox
Local aHList     	:= {}
Local oOk        	:= LoadBitMap(GetResources(),"LBOK")
Local oNo        	:= LoadBitMap(GetResources(),"LBNO")
Local lMarcaItem 	:= .F.
Local bRetSel		:= {|| nPosSel := aScan(aCat,{|x| x[1]==.T. }) }
Local bSelc			:= {|| aCat[oListBox:nAt,1] := !aCat[oListBox:nAt,1] }  
Local cPesq			:= Space(100)
Local oTFont	 	:= TFont():New('Arial',,-20,.T.)
Local aBkup			:= {}
Local cSql 			:= ""                     
Local cAlias		:= GetNextAlias()

Private _lPesq	:= .F.     
Private cCodAut	:= ""     
Private cNomAut	:= ""     
Private nPosSel	:= 0  
Private aCat	:= {} 
Private oDlgTmp

cSql := "SELECT V04_ID_DETENTOR, V04_TX_NOME_COMPLETO "
cSql += "FROM GUA_DA.DAU_V04_DETENTORES "
cSql += "ORDER BY V04_TX_NOME_COMPLETO "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cSql),cAlias, .T., .T.)

While .NOT. Eof()
	Aadd(aCat, { .F.,(cAlias)->V04_ID_DETENTOR,(cAlias)->V04_TX_NOME_COMPLETO} )	
    DbSkip()
EndDo

DbCloseArea()    

aBkup	:= aClone(aCat)

DEFINE MSDIALOG oDlgTmp TITLE cTitulo From 9,0 To 35,100 Style 128

AAdd( aHList, ' ')
AAdd( aHList, 'Código' )
AAdd( aHList, 'Detentor' )

oListBox := TWBrowse():New(005,005,335,145,,aHList,,oDlgTmp,,,,,,,,,,,,, "ARRAY", .T. )
oListBox:SetArray( aCat )
oListBox:bLine := {|| {	If(aCat[oListBox:nAT,1], oOk, oNo),;
						aCat[oListBox:nAT,2],;
						aCat[oListBox:nAT,3]}}

oListBox:bLDblClick := {|| eVal(bRetSel), Iif( nPosSel <> 0 .And. nPosSel <> oListBox:nAT,MsgAlert("Apenas um detentor deve ser selecionado!"),eVal(bSelc) ) , oListBox:Refresh()}

oGtPesq	:= TGet():New(160,005,{|u| if( Pcount()>0, cPesq:= u,cPesq ) },oDlgTmp,250,010,,,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cPesq",,,,,,,"Pesquisar",1,oTFont,CLR_BLUE )

DEFINE SBUTTON FROM 170,270 TYPE 17 ACTION (Pesquisa(@oListBox,@aBkup,@aCat,@cPesq))   ENABLE OF oDlgTmp

DEFINE SBUTTON FROM 04,350 TYPE 01 ACTION (Valida01()) ENABLE OF oDlgTmp

ACTIVATE MSDIALOG oDlgTmp CENTERED

Return ({alltrim(str(cCodAut)),alltrim(cNomAut)})

/*
Funcao: Pesquisa()

Descricao: Retorna o autor selecionado

------------------------------------------------------------------------------------------------
Alteracoes:
16/05/2016 - Rafael Leite - Criacao do fonte
*/
Static Function Pesquisa(oListBox,aBkup,aCat,cPesq)

If _lPesq   
	
	For _nx:=oListBox:NAT+1 To Len(aCat)
	
		If upper(Alltrim(cPesq)) $ Upper(Alltrim(aCat[_nx,3])) .or. Val(AllTrim(cPesq)) = aCat[_nx,2]
	  		oListBox:NAT := _nx
			Exit
		Endif
	Next _nx
Else
	_lPesq := .T.
	For _nx:=1 To Len(aCat)
	
		If upper(Alltrim(cPesq)) $ Upper(Alltrim(aCat[_nx,3])) .or. Val(AllTrim(cPesq)) = aCat[_nx,2]
	  		oListBox:NAT := _nx
			Exit
		Endif
	Next _nx
Endif

Return

Static Function Valida01()

nPosSel	:= aScan(aCat,{|x| x[1]==.T. })

If nPosSel <> 0

	&(ReadVar())	:= aCat[nPosSel,2]
	cCodAut			:= aCat[nPosSel,2]	
	cNomAut			:= aCat[nPosSel,3]	
EndIF

If Empty(cCodAut)
	Alert("Selecione um Detentor")
Else
	oDlgTmp:End()
Endif

Return