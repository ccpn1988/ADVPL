#include "protheus.ch"
#include "topconn.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥EST001    ∫Autor  ≥Rafael Leite        ∫ Data ≥  29/01/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Relatorio de Posicao de Estoque                             ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥GEN - Estoque/Custos                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function EST001()

Local oReport
Local cPerg := "EST001"

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
29/01/2015 - Rafael Leite - Criacao do fonte
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
cCpoPer := "B1_XEMPRES"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer ,0,0,cTpoPer,"",cF3Perg	,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
cCpoPer := "B5_XSELO"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
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


Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer ,0,0,cTpoPer,"",cF3Perg	,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
//---------------------------------------MV_PAR03--------------------------------------------------
cCpoPer := "B1_XIDTPPU"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg	,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------
cCpoPer := "B1_LOCPAD"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer ,0,0,cTpoPer,"",cF3Perg	,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------
cCpoPer := ""
cTpoCpo := "C"
cTitPer := "Produto zerado?"
cF3Perg := ""
nTamPer := 1
cTpoPer := "C"	//G-get;C-combo
cOpc1	:= "Sim"
cOpc2	:= "Nao"

aHelpPor 	:= {}
AADD(aHelpPor,"Informe se produtos com saldo ")
AADD(aHelpPor,"zerado serao impressos no     ")
AADD(aHelpPor,"relatorio.                    ")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer ,0,0,cTpoPer,"",cF3Perg	,"","",cMVPAR,cOpc1,cOpc1,cOpc1,"",cOpc2,cOpc2,cOpc2,"","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR06--------------------------------------------------
cCpoPer := "B5_XAREA"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,"Informe a Area dos produtos que ")
AADD(aHelpPor,"serao impressos no relatorio    ")
AADD(aHelpPor,"                                ")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer ,0,0,cTpoPer,"",cF3Perg	,"","",cMVPAR,cOpc1,cOpc1,cOpc1,"",cOpc2,cOpc2,cOpc2,"","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)    


//---------------------------------------MV_PAR07--------------------------------------------------    MARCOS SILVA
cCpoPer := "B1_XSITOBR"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg	,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
Return()

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
29/01/2015 - Rafael Leite - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
oReport := TReport():New("EST001","Posicao de Estoque (GEN)",cPerg,{|oReport| PrintReport(oReport)},"Posicao de Estoque (GEN)",.T.)

oReport:NDEVICE := 4

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.
oReport:lDisableOrientation := .T.

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Estoque","SB2")

//Celulas da secao    
TRCell():New(oSection1,"B1_XIDMAE"		,"SB1",,,15) //MARCOS SILVA
TRCell():New(oSection1,"B1_COD"			,"SB1",,,15)
TRCell():New(oSection1,"B5_XCODHIS"		,"SB5",,,15)
TRCell():New(oSection1,"B1_ISBN"		,"SB1","ISBN",,25)
TRCell():New(oSection1,"B1_DESC"		,"SB1",,,30)
TRCell():New(oSection1,"B5_XFEC"		,"SB5","FEC",,10)
TRCell():New(oSection1,"B5_XSELO"		,"SB5","Selo",,10)
TRCell():New(oSection1,"B5_XDTPUBL"		,"SB5","Data Publ.",,18)
TRCell():New(oSection1,"B1_XIDTPPU"		,"SB1","Tp.Publ.",,15)
TRCell():New(oSection1,"B1_XSITOBR"		,"SB1","Sit.Obra",,15)
TRCell():New(oSection1,"CATEGORIA"		,"SBM","Categoria",,15)
TRCell():New(oSection1,"B5_XOFERT"		,"SB5","Ofertar",,5)
TRCell():New(oSection1,"BM_DESC"		,"SBM","Grupo",,15)
TRCell():New(oSection1,"DA1_PRCVEN"		,"SB1","PreÁo","@E 9,999.99")
TRCell():New(oSection1,"B1_XPSITEG"		,"SB1","Site Gen",,5)
TRCell():New(oSection1,"B5_XTABPRC"		,"SB5","Tab.PreÁo",,5)
TRCell():New(oSection1,"Z7_DESC"		,"SZ7","Area",,15)
TRCell():New(oSection1,"Z5_DESC"		,"SZ5","Curso",,15)
TRCell():New(oSection1,"Z6_DESC"		,"SZ6","Disciplina",,15)
TRCell():New(oSection1,"B2_LOCAL"		,"SB2")
TRCell():New(oSection1,"B2_QATU"		,"SB2",,"@E 999,999,999,999")
TRCell():New(oSection1,"B2_RESERVA"		,"SB2",,"@E 999,999,999")
TRCell():New(oSection1,"B2_QTNP"		,"SB2",,"@E 999,999")
TRCell():New(oSection1,"B2_QNPT"		,"SB2",,"@E 999,999,999")
TRCell():New(oSection1,"B2_QTER"		,"SB2",,"@E 999,999,999")
TRCell():New(oSection1,"B1_PESO"		,"SB1","Peso","@E 9.999")

//Totalizadores
TRFunction():New(oSection1:Cell("B2_QATU")		,NIL,"SUM")
TRFunction():New(oSection1:Cell("B2_RESERVA")	,NIL,"SUM")
TRFunction():New(oSection1:Cell("B2_QTNP")		,NIL,"SUM")
TRFunction():New(oSection1:Cell("B2_QNPT")		,NIL,"SUM")
TRFunction():New(oSection1:Cell("B2_QTER")		,NIL,"SUM")

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
29/01/2015 - Rafael Leite - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()
Local _cSQL		:= ""   					//Filtros vari·veis da query

If oReport:NDEVICE <> 4
	MsgInfo("Este relatÛrio somente poder· ser impresso em Excel.")
	Return(.t.)
Endif
oReport:SetLandScape()

_cTab   := GETMV("GEN_FAT064")

//Monta filtros da query
//mv_par01 - B1_XEMPRES
If !Empty(MV_PAR01)
	_cSQL += " AND SB1.B1_XEMPRES = '"+MV_PAR01+"'
Endif

//mv_par02 - B5_XSELO
If !Empty(MV_PAR02)
	_cSQL += " AND SB5.B5_XSELO = '"+MV_PAR02+"'
Endif

//mv_par03 - B1_XIDTPPU
If !Empty(MV_PAR03)
	_cSQL += " AND SB1.B1_XIDTPPU = '"+MV_PAR03+"'
Endif

//mv_par04 - B2_LOCAL
If !Empty(MV_PAR04)
	_cSQL += " AND SB2.B2_LOCAL = '"+MV_PAR04+"'
Endif

//mv_par05 - zerado (sim/nao)
If MV_PAR05 == 2
	_cSQL += " AND SB2.B2_QATU <> 0
Endif

//mv_par06 - B5_XAREA
If !Empty(MV_PAR06)
	_cSQL += " AND SB5.B5_XAREA = '"+MV_PAR06+"'
Endif       

//mv_par07 - B1_SITOBR     MARCOS SILVA
If !Empty(MV_PAR07)
	_cSQL += " AND SB1.B1_XSITOBR = '"+MV_PAR07+"' 
Endif
_cSQL := "%" + _cSQL + "%"

//Cria query
Begin Report Query oSection1

BeginSQL Alias cAlias1
	
	SELECT TRIM(B1_COD) B1_COD
	,TRIM(B1_XIDMAE) B1_XIDMAE
	,B5_XCODHIS
	,B1_ISBN
	,TRIM(Z3.X5_DESCRI) AS B1_XEMPRES
	,TRIM(Z4.X5_DESCRI) AS B1_XIDTPPU
	,TRIM(Z1.X5_DESCRI) AS B5_XSELO
	,B1_XEMPRES
	,B1_DESC
	,B5_XDTPUBL
	,DECODE(BM_XCATEG,'D','DID','P','PROF','I','INT.GER')||' - '||DECODE(B5_XTIPINC,1,'ON',2,'NE') CATEGORIA
	,DECODE(TRIM(B5_XOFERT),'1','SIM','0','N√O') B5_XOFERT
	,SZ4.Z4_DESC B1_XSITOBR
	,SBM.BM_DESC
	,DA1_PRCVEN
	,DECODE(B1_XPSITEG,'1','SIM','0','N√O') B1_XPSITEG
	,DECODE(B5_XTABPRC,'1','SIM','0','N√O') B5_XTABPRC
	,Z7_DESC
	,Z5_DESC
	,Z6_DESC
	,B2_LOCAL
	,B2_QATU
	,B2_RESERVA
	,B2_QNPT
	,B2_QTER
	,B1_PESO
	,DECODE(B5_XFEC,'1','SIM','0','N√O') B5_XFEC 
	FROM %table:SB1% SB1
	JOIN %table:SB2% SB2
	ON SB2.B2_COD = SB1.B1_COD
	AND SB2.B2_FILIAL = %xFilial:SB2%
	AND SB2.%notDel%
	JOIN	%table:SB5% SB5
	ON SB1.B1_COD = SB5.B5_COD
	AND SB5.B5_FILIAL = %xFilial:SB5%
	AND SB5.%notDel%
	JOIN	%table:SBM% SBM
	ON SB1.B1_GRUPO = SBM.BM_GRUPO
	AND SBM.BM_FILIAL = %xFilial:SBM%
	AND SBM.%notDel%
	JOIN	%table:SX5% Z1
	ON SB5.B5_XSELO = Z1.X5_CHAVE
	AND Z1.X5_FILIAL = %xFilial:SX5%
	AND Z1.X5_TABELA = 'Z1'
	AND Z1.%notDel%
	JOIN	%table:SX5% Z3
	ON SB1.B1_XEMPRES = Z3.X5_CHAVE
	AND Z3.X5_FILIAL = %xFilial:SX5%
	AND Z3.X5_TABELA = 'Z3'
	AND Z3.%notDel%
	JOIN	%table:SX5% Z4
	ON SB1.B1_XIDTPPU = Z4.X5_CHAVE
	AND Z4.X5_FILIAL = %xFilial:SX5%
	AND Z4.X5_TABELA = 'Z4'
	AND Z4.%notDel%
	JOIN	%table:SZ4% SZ4
	ON SB1.B1_XSITOBR = SZ4.Z4_COD
	AND SZ4.Z4_FILIAL = %xFilial:SZ4%
	AND SZ4.%notDel%
	LEFT JOIN %table:DA1% DA1
	ON SB1.B1_COD = DA1.DA1_CODPRO
	AND DA1.DA1_CODTAB = %Exp:_cTab%
	AND DA1.DA1_FILIAL = %xFilial:DA1%
	AND DA1.%notDel%
	LEFT JOIN	 %table:SZ7% SZ7
	ON SB5.B5_XAREA = SZ7.Z7_AREA
	AND SZ7.Z7_FILIAL = %xFilial:SZ7%
	AND SZ7.%notDel%
	LEFT JOIN	 %table:SZ5% SZ5
	ON SB5.B5_XCURSO = SZ5.Z5_CURSO
	AND SZ5.Z5_FILIAL = %xFilial:SZ5%
	AND SZ5.%notDel%
    LEFT JOIN	 %table:SZ6% SZ6
	ON SB5.B5_XDISCIP = SZ6.Z6_DISCIPL
	AND SZ6.Z6_FILIAL = %xFilial:SZ6%
	AND SZ6.%notDel%
	
	WHERE SB1.B1_FILIAL = %xFilial:SB1%
	AND SB1.%notDel%
	AND SB1.B1_TIPO = 'PA'
	
	%exp:_cSQL%
	
	order by SB1.B1_XEMPRES,SB5.B5_XSELO,SB1.B1_ISBN,SB2.B2_LOCAL
	
EndSql

End Report Query oSection1

//Efetua impress„o
oSection1:Print()

Return(.T.)
