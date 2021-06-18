#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EST042    ºAutor  ³Érica Vieites       º Data ³  07/02/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio Movimentos Internos                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Estoque/Custos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Alteraoes:

/*/

User Function EST042()

Local oReport
Local cPerg := "EST042"

//Cria grupo de perguntas
//f001(cPerg)

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

U_xGPutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:", "Dt Emissão de:", cMVCH, "D", 8, 0, 0, "G", "", "", "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
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

U_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg	,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return()
/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio
*/

Static Function ReportDef(cPerg)

Local oReport


//Declaracao do relatorio

oReport := TReport():New("EST042","EST042 - Movimentos Internos",cPerg,{|oReport| PrintReport(oReport)},"EST042 - Movimentos Internos",.T.)

//oReport:NDEVICE := 4

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T.
oReport:lDisableOrientation := .T.

oReport:NDEVICE := 4

//Secao do relatorio
oSection1 := TRSection():New(oReport,"EST042 - Movimentos Internos","")

//Celulas da secao
TRCell():New(oSection1,"IDOBRA"				,"   ",CRLF+"IdObra"					,,15)
TRCell():New(oSection1,"FILIAL"				,"   ",CRLF+"Filial"	            	,,10)
TRCell():New(oSection1,"OBRA"				,"   ",CRLF+"Obra"			   		,,50)
TRCell():New(oSection1,"SITUACAOOBRA"		,"   ",CRLF+"Situação"+CRLF+"Obra"	,,15)
TRCell():New(oSection1,"TIPOPUBLICACAO"	,"   ","Tipo"+CRLF+"Publicação"		,,15)
TRCell():New(oSection1,"IDMAE"				,"   ","Obra"+CRLF+"Mãe"				,,10)
TRCell():New(oSection1,"IDHIS"				,"   ","Obra"+CRLF+"Histórico"		,,10)
TRCell():New(oSection1,"AREA"				,"   ",CRLF+"IdArea"   		 		,,10)
TRCell():New(oSection1,"DESC_AREA"			,"   ",CRLF+"Área"					,,20)
TRCell():New(oSection1,"DT_MOVIMENTO"		,"   ","Dt"+CRLF+"Mov."				,,10)
TRCell():New(oSection1,"TIPO_MOV"			,"   ","Tipo"+CRLF+"Movimento"   	,,18)
TRCell():New(oSection1,"DESCR_MOV"			,"   ",CRLF+"Movimento"     		,,20)
TRCell():New(oSection1,"B9_CM1"				,"   ","Último Custo"+CRLF+"Fechado "	,"@E 999,999",18,,,,,"RIGHT")
TRCell():New(oSection1,"QTDE"				,"   ",CRLF+"Quantidade "			,"@E 999,999",8,,,,,"RIGHT")
TRCell():New(oSection1,"VALOR"				,"   ",CRLF+"Valor"            		,"@E 999,999,999.99",18,,,,,"RIGHT")


//Totalizadores
TRFunction():New(oSection1:Cell("QTDE")	   		,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("VALOR")		    ,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio
*/

Static Function PrintReport(oReport)

Local oSection1	:= oReport:Section(1)
Local cAlias1	:= GetNextAlias()
Local _cQuery	:= ""
Public _cData
cAlias := GetNextAlias()

cQuery := "SELECT MAX(B9_DATA) DATA
cQuery += "  FROM " + RetSqlName("SB9")
cQuery += " WHERE B9_LOCAL = '01'
cQuery += "   AND B9_FILIAL IN ('2022','3022','4022','6022','9022','1022')
cQuery += "   AND D_E_L_E_T_ = ' '
	
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
dbSelectArea(cAlias)
dbGoTop()

Do While !(cAlias)->(Eof())
	_cData := (cAlias)->DATA
	(cAlias)->(dbSkip())
Enddo
fErase(cAlias)

	
_cParm1 := DTOS(FIRSTDATE(MV_PAR01))
_cParm2 := DTOS(LASTDATE(MV_PAR01))

oReport:SetLandScape()

//Cria query

_cQuery := "SELECT SD3.D3_FILIAL FILIAL, TO_NUMBER(TRIM(SD3.D3_COD)) IDOBRA, SO.DESCRICAO SITUACAOOBRA, TP.DESCRICAO TIPOPUBLICACAO, O.IDOBRAMAE IDMAE, O.IDOBRAHISTORICO IDHIS,
_cQuery += "       SD3.D3_EMISSAO DT_MOVIMENTO, O.DESCRICAO OBRA, SD3.D3_QUANT QTDE, SD3.D3_CUSTO1 VALOR,  TO_NUMBER(9||SD3.D3_TM) TIPO_MOV,
_cQuery += "       SF5.F5_TEXTO DESCR_MOV,SZ7.Z7_AREA AREA, SZ7.Z7_DESC DESC_AREA, SB9.B9_CM1 B9_CM1
_cQuery += " FROM " + RetSqlName("SD3") + " SD3
_cQuery += "  JOIN TT_I10_FILIAL_GEN_TOTVS I10
_cQuery += "      ON I10.IDEMPRESATOTVS = D3_FILIAL
      
_cQuery += "   JOIN TT_EMPRESAOBRACUSTO EOC 
_cQuery += "      ON EOC.IDOBRA = TO_NUMBER(TRIM(SD3.D3_COD))
_cQuery += "     AND EOC.DATA   = LAST_DAY(TO_DATE(D3_EMISSAO,'YYYYMMDD'))
  
_cQuery += "   JOIN " + RetSqlName("DA1") + " DA1
_cQuery += "      ON DA1.DA1_CODPRO = SD3.D3_COD
_cQuery += "      AND DA1.DA1_CODTAB = EOC.TABPRECO
	  
_cQuery += "   JOIN " + RetSqlName("SF5") + " SF5
_cQuery += "      ON SF5.F5_CODIGO = SD3.D3_TM
_cQuery += "     AND SF5.D_E_L_E_T_ = ' '
_cQuery += "     AND SF5.F5_QTDZERO = '2'
  
_cQuery += "   JOIN OBRA O
_cQuery += "     ON O.IDOBRA = TO_NUMBER(TRIM(SD3.D3_COD))
  
_cQuery += "   JOIN SITUACAOOBRA SO
_cQuery += "     ON SO.IDSITUACAOOBRA = O.IDSITUACAOOBRA
   
_cQuery += "   JOIN TIPOPUBLICACAO TP
_cQuery += "     ON TP.IDTIPOPUBLICACAO = O.IDTIPOPUBLICACAO

_cQuery += "   LEFT JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "      ON SB5.B5_COD = SD3.D3_COD
_cQuery += "     AND SB5.D_E_L_E_T_ = ' '

_cQuery += "   LEFT JOIN " + RetSqlName("SZ7") + " SZ7
_cQuery += "      ON SB5.B5_XAREA = SZ7.Z7_AREA
_cQuery += "     AND SZ7.D_E_L_E_T_ = ' '

_cQuery += "  LEFT JOIN (SELECT SB9.B9_COD, SB9.B9_CM1, SUM(SB9.B9_QINI) QTDE
_cQuery += "               FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
_cQuery += "              WHERE SB9.B9_COD = SB1.B1_COD
_cQuery += "                AND SB9.B9_FILIAL = DECODE(SB1.B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','378803 ','1022')
_cQuery += "                AND SB9.B9_LOCAL = '01'
_cQuery += "                AND SB9.B9_DATA = '"+ _cData+"'"
_cQuery += "                AND SB9.D_E_L_E_T_ = ' '
_cQuery += "                AND SB1.D_E_L_E_T_ = ' '
_cQuery += "              GROUP BY SB9.B9_COD, SB9.B9_CM1) SB9
_cQuery += "    ON SB9.B9_COD = SB5.B5_COD
      
_cQuery += "  WHERE SD3.D_E_L_E_T_     = ' '
_cQuery += "  AND SD3.D3_TM NOT IN ('499','999')
_cQuery += "  AND SD3.D3_EMISSAO > '20170101'
If !Empty(MV_PAR02)
	_cQuery += " AND O.IDTIPOPUBLICACAO = '" + MV_PAR02 + "'
EndIF
_cQuery += "  AND SD3.D3_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += " UNION ALL
_cQuery += " SELECT SD3.D3_FILIAL FILIAL, TO_NUMBER(TRIM(SD3.D3_COD)) IDOBRA, SO.DESCRICAO SITUACAOOBRA, TP.DESCRICAO TIPOPUBLICACAO, O.IDOBRAMAE IDMAE, O.IDOBRAHISTORICO IDHIS,
_cQuery += "       SD3.D3_EMISSAO DT_MOVIMENTO, O.DESCRICAO OBRA, SD3.D3_QUANT QTDE, SD3.D3_CUSTO1 VALOR,  TO_NUMBER(9||SD3.D3_TM) TIPO_MOV,
_cQuery += "       DECODE(SD3.D3_TM,'499','ENTRADA INVENTÁRIO','SAÍDA INVENTÁRIO') DESCR_MOV,SZ7.Z7_AREA AREA, SZ7.Z7_DESC DESC_AREA, SB9.B9_CM1 B9_CM1
_cQuery += "  FROM " + RetSqlName("SD3") + " SD3
_cQuery += "  JOIN TT_I10_FILIAL_GEN_TOTVS I10
_cQuery += "      ON I10.IDEMPRESATOTVS = D3_FILIAL
      
_cQuery += "   JOIN TT_EMPRESAOBRACUSTO EOC 
_cQuery += "      ON EOC.IDOBRA = TO_NUMBER(TRIM(SD3.D3_COD))
_cQuery += "     AND EOC.DATA   = LAST_DAY(TO_DATE(D3_EMISSAO,'YYYYMMDD'))
  
_cQuery += "    JOIN " + RetSqlName("DA1") + " DA1
_cQuery += "      ON DA1.DA1_CODPRO = SD3.D3_COD
_cQuery += "      AND DA1.DA1_CODTAB = EOC.TABPRECO
    
_cQuery += "    JOIN OBRA O
_cQuery += "     ON O.IDOBRA = TO_NUMBER(TRIM(SD3.D3_COD))
    
_cQuery += "    JOIN SITUACAOOBRA SO
_cQuery += "     ON SO.IDSITUACAOOBRA = O.IDSITUACAOOBRA
   
_cQuery += "   JOIN TIPOPUBLICACAO TP
_cQuery += "     ON TP.IDTIPOPUBLICACAO = O.IDTIPOPUBLICACAO

_cQuery += "   LEFT JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "      ON SB5.B5_COD = SD3.D3_COD
_cQuery += "     AND SB5.D_E_L_E_T_ = ' '

_cQuery += "   LEFT JOIN " + RetSqlName("SZ7") + " SZ7
_cQuery += "      ON SB5.B5_XAREA = SZ7.Z7_AREA
_cQuery += "     AND SZ7.D_E_L_E_T_ = ' '

_cQuery += "  LEFT JOIN (SELECT SB9.B9_COD, SB9.B9_CM1, SUM(SB9.B9_QINI) QTDE
_cQuery += "               FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
_cQuery += "              WHERE SB9.B9_COD = SB1.B1_COD
_cQuery += "                AND SB9.B9_FILIAL = DECODE(SB1.B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','378803 ','1022')
_cQuery += "                AND SB9.B9_LOCAL = '01'
_cQuery += "                AND SB9.B9_DATA = '"+ _cData+"'"
_cQuery += "                AND SB9.D_E_L_E_T_ = ' '
_cQuery += "                AND SB1.D_E_L_E_T_ = ' '
_cQuery += "              GROUP BY SB9.B9_COD, SB9.B9_CM1) SB9
_cQuery += "    ON SB9.B9_COD = SB5.B5_COD
      
_cQuery += "  WHERE SD3.D_E_L_E_T_     = ' '
_cQuery += "  AND SD3.D3_TM IN ('499','999')
_cQuery += "  AND TRIM(SD3.D3_DOC) = 'INVENT'
_cQuery += "  AND SD3.D3_EMISSAO > '20170101'
If !Empty(MV_PAR02)
	_cQuery += " AND O.IDTIPOPUBLICACAO = '" + MV_PAR02 + "'
EndIF
_cQuery += "  AND SD3.D3_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
  
_cQuery += "  ORDER BY DT_MOVIMENTO, FILIAL, OBRA

If Select(cAlias1) > 0
	dbSelectArea(cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), cAlias1, .F., .T.)
TCSetFiEld(cAlias1,"DT_MOVIMENTO","D",8,0)

(cAlias1)->(dbGoTop())

Do While !(cAlias1)->(eof()) .And. !oReport:Cancel()

//DT_MOVIMENTO  := STOD((cAlias1)->DT_MOVIMENTO)


	oReport:IncMeter()
	
	oSection1:Init()
	
	oSection1:Cell("FILIAL"):SetValue((cAlias1)->FILIAL)
	oSection1:Cell("IDOBRA"):SetValue((cAlias1)->IDOBRA)
	oSection1:Cell("SITUACAOOBRA"):SetValue((cAlias1)->SITUACAOOBRA)
	oSection1:Cell("TIPOPUBLICACAO"):SetValue((cAlias1)->TIPOPUBLICACAO)
	oSection1:Cell("IDMAE"):SetValue((cAlias1)->IDMAE)
	oSection1:Cell("IDHIS"):SetValue((cAlias1)->IDHIS)
	oSection1:Cell("AREA"):SetValue((cAlias1)->AREA)
	oSection1:Cell("DESC_AREA"):SetValue((cAlias1)->DESC_AREA)
	//oSection1:Cell("DT_MOVIMENTO"):SetValue(DT_MOVIMENTO)
	oSection1:Cell("DT_MOVIMENTO"):SetValue((cAlias1)->DT_MOVIMENTO)
	oSection1:Cell("OBRA"):SetValue((cAlias1)->OBRA)
	oSection1:Cell("TIPO_MOV"):SetValue((cAlias1)->TIPO_MOV)
	oSection1:Cell("DESCR_MOV"):SetValue((cAlias1)->DESCR_MOV)	
	oSection1:Cell("B9_CM1"):SetValue((cAlias1)->B9_CM1)
	oSection1:Cell("QTDE"):SetValue((cAlias1)->QTDE)		
	oSection1:Cell("VALOR"):SetValue((cAlias1)->VALOR)

	oSection1:PrintLine()
	
	(cAlias1)->(dbSkip())
EndDo                    

DbSelectArea(cAlias1)
DbCloseArea()

Return(.t.)
