#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER061N

DESCRICAO: RELATORIO DE NOVAS EDICOES E PRAZOS PARA TROCA

ALTERACOES:
16/10/2015 - Desenvolvimento do fonte

/*/

User Function GER061

Local oReport
Local cPerg := "GER061"

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
16/10/2015 - Helimar Tavares - Criacao do fonte
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

PutSx1(cPerg, cItPerg, "Dt Publ de:", "Dt Publ de:" ,"Dt Publ de:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
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

//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Fornecedor.    ")

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
16/10/2015 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2

//Declaracao do relatorio
oReport := TReport():New("GER061","GER061 - NOVAS EDIÇÕES E PRAZOS PARA TROCA",cPerg,{|oReport| PrintReport(oReport)},"GER061 - NOVAS EDIÇÕES E PRAZOS PARA TROCA")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Titulos","")
	
//Celulas da secao
TRCell():New(oSection1,"SELO"			,"SX5","Selo",,10)
TRCell():New(oSection1,"ISBN_ANTIGO"	,"SB1","EAN Antigo"+CRLF+"(Cód.Barras)",,27,,,"CENTER",,"CENTER")
TRCell():New(oSection1,"EDICAO_ANTIGA"	,"SB5","Nº Edição"+CRLF+"Antiga",,20,,,"CENTER",,"CENTER")
TRCell():New(oSection1,"TITULO"			,"SB1","Título",,30)
TRCell():New(oSection1,"AUTOR"   		,"SB5","Autor",,25)
TRCell():New(oSection1,"EDICAO"			,"SB5","Nº Edição"+CRLF+"Nova",,20,,,"CENTER",,"CENTER") 
TRCell():New(oSection1,"B1_ISBN"		,"SB1","EAN Novo"+CRLF+"(Cód.Barras)",,27,,,"CENTER",,"CENTER")
TRCell():New(oSection1,"CATEGORIA"		,"SX5","Categoria",,15)
TRCell():New(oSection1,"DA1_PRCVEN"		,"DA1","Preço"+CRLF+"Capa",,18)
TRCell():New(oSection1,"DATAPUBL"		,"SB5","Data"+CRLF+"Publicação",,20) 
TRCell():New(oSection1,"PRAZODEVOL"		,"SB5","Prazo"+CRLF+"Devolução",,20) 
                      
//Faz a impressao do totalizador em linha
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
_cParm2 := DTOS(DATE()-1)

_cQuery := "SELECT TRIM(XZ1.X5_DESCRI) SELO,
_cQuery += "       EA.ISBN_ANTIGO,
_cQuery += "       EA.EDICAO_ANTIGA,
_cQuery += "       TRIM(SB5.B5_CEME) TITULO,
_cQuery += "       EA.B5_XAUTOR,
_cQuery += "       SUBSTR(SB5.B5_XEDICAO, 1, INSTR(SB5.B5_XEDICAO,'|')-1) EDICAO,
_cQuery += "       SB1.B1_ISBN,
_cQuery += "       DA1.DA1_PRCVEN,
_cQuery += "       DECODE(SBM.BM_XCATEG, 'D', 'DID', 'P', 'PROF', 'I', 'INT.GER')||' - '|| DECODE(SB5.B5_XTIPINC, 1, 'ON', 2, 'NE') CATEGORIA,
_cQuery += "       SB5.B5_XDTPUBL,
_cQuery += "       CASE WHEN TO_DATE(SB5.B5_XDTPUBL, 'YYYYMMDD')+90 < SYSDATE
_cQuery += "            THEN 'VENCIDO'
_cQuery += "            ELSE TO_CHAR(TO_DATE(SB5.B5_XDTPUBL, 'YYYYMMDD')+90, 'YYYYMMDD')
_cQuery += "             END PRAZO_DEVOLUCAO
_cQuery += "  FROM " + RetSqlName("SB1") + " SB1
_cQuery += "  JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "    ON B1_COD = B5_COD
_cQuery += "   AND B5_XDTPUBL BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "  AND SUBSTR(B5_XEDICAO, 1, INSTR(B5_XEDICAO,'|')-1) <> '1'
_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  JOIN (SELECT SB1.B1_ISBN ISBN_ANTIGO
 _cQuery += "            , SB1.B1_PROC 
_cQuery += "             , SB5.B5_XEDICAO XEDICAO_ANTIGA
_cQuery += "             , SUBSTR(SB5.B5_XEDICAO, 1, INSTR(SB5.B5_XEDICAO,'|')-1) EDICAO_ANTIGA
_cQuery += "             , SB5.B5_XCODHIS
_cQuery += "             , SB5.B5_XAUTOR
_cQuery += "          FROM (SELECT B5_XCODHIS, MAX(EDICAO_ANTIGA) EDICAO_ANTIGA
_cQuery += "                  FROM (SELECT SB5.B5_XCODHIS
_cQuery += "                             , TO_NUMBER(TRIM(SUBSTR(SB5.B5_XEDICAO, 1, INSTR(SB5.B5_XEDICAO,'|')-1))) EDICAO_ANTIGA
_cQuery += "                             , TO_NUMBER(TRIM(EAA.EDICAO)) EDICAO_ATUAL
_cQuery += "                          FROM " + RetSqlName("SB5") + " SB5
_cQuery += "                          JOIN (SELECT MAX(TO_NUMBER(SUBSTR(B5_XEDICAO, 1, INSTR(B5_XEDICAO,'|')-1))) EDICAO ,B5_XCODHIS FROM  " + RetSqlName("SB5")+" WHERE D_E_L_E_T_ = ' ' AND B5_XDTPUBL                <> ' ' GROUP BY B5_XCODHIS) EAA
_cQuery += "                            ON TO_NUMBER(TRIM(SB5.B5_XCODHIS))  = TO_NUMBER(TRIM(EAA.B5_XCODHIS))
_cQuery += "                         WHERE SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += "                           AND SB5.D_E_L_E_T_  = ' ' AND SB5.B5_XDTPUBL <> ' ')
_cQuery += "                 WHERE EDICAO_ANTIGA <> EDICAO_ATUAL
_cQuery += "                 GROUP BY B5_XCODHIS) ED
_cQuery += "          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "            ON ED.B5_XCODHIS = SB5.B5_XCODHIS
_cQuery += "           AND ED.EDICAO_ANTIGA = TO_NUMBER(TRIM(SUBSTR(SB5.B5_XEDICAO, 1, INSTR(SB5.B5_XEDICAO,'|')-1)))
_cQuery += "          JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "            ON SB1.B1_COD = SB5.B5_COD
_cQuery += "         WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "           AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += "           AND SB5.D_E_L_E_T_ = ' ') EA
_cQuery += "    ON TO_NUMBER(TRIM(SB5.B5_XCODHIS)) = TO_NUMBER(TRIM(EA.B5_XCODHIS))           
_cQuery += "  JOIN " + RetSqlName("SX5") + " XZ1
_cQuery += "    ON SB5.B5_XSELO   = XZ1.X5_CHAVE
_cQuery += "   AND XZ1.X5_TABELA  = 'Z1'
_cQuery += "   AND XZ1.X5_FILIAL  = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ1.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SBM") + " SBM
_cQuery += "    ON SBM.BM_GRUPO   = SB1.B1_GRUPO
_cQuery += "   AND SBM.BM_FILIAL  = '" + xFilial("SBM") + "'"
_cQuery += "   AND SBM.D_E_L_E_T_ = ' '
_cQuery += "  JOIN " + RetSqlName("DA1") + " DA1
_cQuery += "    ON SB1.B1_COD = DA1.DA1_CODPRO
_cQuery += "   AND DA1.DA1_CODTAB = '"+GETMV("GEN_FAT064")+"'"
_cQuery += "   AND DA1_FILIAL = '" + xFilial("DA1") + "'"
_cQuery += "   AND DA1.D_E_L_E_T_ = ' '
_cQuery += "  JOIN " + RetSqlName("SA2") + " SA2
_cQuery += "    ON SB1.B1_PROC = A2_COD
_cQuery += "   AND SB1.B1_LOJPROC = A2_LOJA

If !Empty(MV_PAR03)
	_cQuery += "   AND A2_COD = '"+MV_PAR03+"'
EndIf
If !Empty(MV_PAR03)
	_cQuery += "   AND A2_LOJA = '"+MV_PAR04+"'
EndIf

_cQuery += "   AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
_cQuery += "   AND SA2.D_E_L_E_T_ = ' '
_cQuery += " WHERE SB1.B1_XIDTPPU    = '1'
_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "   AND ea.edicao_antiga < TO_NUMBER(substr(sb5.b5_xedicao,1,instr(sb5.b5_xedicao,'|') - 1))
_cQuery += " ORDER BY SB5.B5_XDTPUBL DESC

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oSection1:Init()  

    xDtPubl := STOD((_cAlias1)->B5_XDTPUBL)                                        
    If (_cAlias1)->PRAZO_DEVOLUCAO <> 'VENCIDO'
	    xPzDevl := STOD((_cAlias1)->PRAZO_DEVOLUCAO)
    Else
	    xPzDevl := (_cAlias1)->PRAZO_DEVOLUCAO
	EndIf
  	
	oSection1:Cell("SELO"):SetValue((_cAlias1)->SELO)
	oSection1:Cell("ISBN_ANTIGO"):SetValue((_cAlias1)->ISBN_ANTIGO)
	oSection1:Cell("EDICAO_ANTIGA"):SetValue((_cAlias1)->EDICAO_ANTIGA)
	oSection1:Cell("TITULO"):SetValue((_cAlias1)->TITULO)
	oSection1:Cell("AUTOR"):SetValue((_cAlias1)->B5_XAUTOR)
	oSection1:Cell("EDICAO"):SetValue((_cAlias1)->EDICAO)
	oSection1:Cell("B1_ISBN"):SetValue((_cAlias1)->B1_ISBN)
	oSection1:Cell("CATEGORIA"):SetValue((_cAlias1)->CATEGORIA)
	oSection1:Cell("DA1_PRCVEN"):SetValue((_cAlias1)->DA1_PRCVEN)
	oSection1:Cell("DATAPUBL"):SetValue(xDtPubl)
	oSection1:Cell("PRAZODEVOL"):SetValue(xPzDevl)
	
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())		
EndDo
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)