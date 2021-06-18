#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER017A   บAutor  ณErica Vieites       บ Data ณ  31/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Alerta de Reimpressใo Produtos Digitais        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Gerencial                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GER017A()             

Local oReport
Local cPerg := "GER017A"


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

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Fornecedor.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------  
cCpoPer := "Z7_AREA"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "มrea ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
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

//---------------------------------------MV_PAR04--------------------------------------------------
cCpoPer := "B1_XIDTPPU"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Tipo Publica็ใo ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "Z4"	//Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dias de Estocagem:", "Dias de Estocagem:" ,"Dias de Estocagem:",  cMVCH , "N", 4, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//-----------------------------------------------------------------------------------------

Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
oReport := TReport():New("GER017A","GER017A - ALERTA DE PRODUTOS DIGITAIS",cPerg,{|oReport| PrintReport(oReport)},"GER017A - ALERTA DE PRODUTOS DIGITAIS",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.   

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Estoque","SB1")

//Celulas da secao
TRCell():New(oSection1,"B1_COD"		,"SB1","ID OBRA"								,				,10)
TRCell():New(oSection1,"B1_ISBN"	,"SB1","ISBN"									,				,20)
TRCell():New(oSection1,"B1_DESC"	,"SB1","Descri็ใo (conceito FEC)"				,				,35)
TRCell():New(oSection1,"X5_DESCRI"	,"SX5","Selo"									,				, 8)
TRCell():New(oSection1,"TPPUBLIC"	,"   ","Tipo"+CRLF+"Publica็ใo"					,				,18,,,,,"LEFT")  
TRCell():New(oSection1,"Z4_DESC"	,"SZ4","Situa็ใo"+CRLF+"Obra"					,				,18,,,,,"LEFT")
TRCell():New(oSection1,"DTPUBL"		,"   ","Data"+CRLF+"Publica็ใo"					,				,15,,,,,"LEFT")
TRCell():New(oSection1,"Z7_DESC"	,"SZ7","มrea"									,				,15)
TRCell():New(oSection1,"BOM"	    ,"   ","Bom"									,'@E 999,999'	, 9,,,,,"RIGHT")
TRCell():New(oSection1,"RESERVA"	,"   ","Reserva"								,'@E 999,999'	, 9,,,,,"RIGHT")
TRCell():New(oSection1,"CONSIGNADO"	,"SB2","Consignado"								,'@E 999,999'	,12,,,,,"RIGHT")
TRCell():New(oSection1,"QTDE"	    ,"   ","Venda no"+CRLF+"Qtde"+CRLF+"Total"		,'@E 999,999'	,12,,,,,"RIGHT") 
TRCell():New(oSection1,"MEDIA"	    ,"   ","Perํodo"+CRLF+"Media"+CRLF+"Mensal"		,				, 8,,,,,"RIGHT") 
TRCell():New(oSection1,"DIAEST"	    ,"   ","Dias"+CRLF+"ฺteis de"+CRLF+"Estocagem"	,'@E 9,999,999'	,15,,,,,"RIGHT") 

//Totalizadores
/*
TRFunction():New(oSection1:Cell("BOM")      	,NIL,"SUM") 
TRFunction():New(oSection1:Cell("RESERVA")  	,NIL,"SUM")
TRFunction():New(oSection1:Cell("CONSIGNADO")	,NIL,"SUM")
TRFunction():New(oSection1:Cell("QTDE")      	,NIL,"SUM")  
*/

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()
Local _cSQL		:= ""   

oReport:SetLandScape()

_cParm1 := DTOS(YEARSUB(Date(), 1))
_cParm2 := DTOS(Date())
_cParm3 := YEARSUB(Date(), 1)
_cParm4 := Date()
_cParm5 := MV_PAR05
 
If !Empty(MV_PAR01)
	_cSQL += " AND SB1.B1_PROC = '"+MV_PAR01+"'
Endif 

If !Empty(MV_PAR02)
	_cSQL += " AND SB1.B1_LOJPROC = '"+MV_PAR02+"'
Endif 
 
If !Empty(MV_PAR03)
	_cSQL += " AND SB5.B5_XAREA = '"+MV_PAR03+"'
Endif 

If !Empty(MV_PAR04)
	_cSQL += " AND SB1.B1_XIDTPPU = '"+MV_PAR04+"'
Endif 

_cSQL := "%" + _cSQL + "%" 
  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
    
SELECT * FROM
    (SELECT B1_COD 
	      , B1_ISBN 
	      , B1_DESC 
	      , Z1.X5_DESCRI 
	      , Z4.X5_DESCRI AS TPPUBLIC  
	      , SZ4.Z4_DESC 
	      , TO_CHAR(TO_DATE(TRIM(SB5.B5_XDTPUBL), 'YYYYMMDD'), 'DD/MM/YYYY') AS DTPUBL
	      , SZ7.Z7_DESC
	      , SB2.B2_QATU BOM
	      , nvl(RSV.B2_QATU,0) RESERVA
	      , SB2.B2_QNPT CONSIGNADO
	      , NVL(SUM(F.QTDE), 0) QTDE 
	      , NVL(SUM(F.LIQUIDO),0) LIQUIDO
           , CASE WHEN NVL(ROUND((SUM(F.QTDE)/(ROUND(MONTHS_BETWEEN(%Exp:_cParm4%, %Exp:_cParm3%),0))),0),0) < 0
               THEN NVL(ROUND((SUM(F.QTDE)/(ROUND(MONTHS_BETWEEN(%Exp:_cParm4%, %Exp:_cParm3%),0))),0),0) * -1
               ELSE NVL(ROUND((SUM(F.QTDE)/(ROUND(MONTHS_BETWEEN(%Exp:_cParm4%, %Exp:_cParm3%),0))),0),0)
                END MEDIA 
          , CASE WHEN NVL(SB2.B2_QATU+NVL(RSV.B2_QATU, 0),0) = 0 OR ROUND(NVL(ROUND((ROUND((SUM(F.QTDE)/(ROUND(MONTHS_BETWEEN(%Exp:_cParm4%, %Exp:_cParm3%),0))),2)),2),0)/22, 2) = 0
               THEN NVL(SB2.B2_QATU+NVL(RSV.B2_QATU, 0),0)
               ELSE CEIL(NVL(SB2.B2_QATU+NVL(RSV.B2_QATU, 0),0) / (ROUND(NVL(ROUND((ROUND((SUM(F.QTDE)/(ROUND(MONTHS_BETWEEN(%Exp:_cParm4%, %Exp:_cParm3%),0))),2)),2),0)/22, 2)))
                END DIAEST 
     FROM %table:SB2% SB2
        , %table:SB1% SB1
        , %table:SB5% SB5
        , %table:SX5% Z1
        , %table:SX5% Z4
        , %table:SZ4% SZ4
        ,(SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) CODHIS, NVL(SUM(SD2.D2_QUANT), 0) QTDE, NVL(SUM(SD2.D2_VALBRUT),0) LIQUIDO
            FROM %table:SD2% SD2, %table:SB5% SB5
          WHERE SD2.D2_COD = SB5.B5_COD
            AND SD2.D2_TES IN (SELECT F4_CODIGO FROM %table:SF4% WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND F4_CODIGO < '800' AND %notDel%)
            AND SD2.D2_FILIAL    = %xFilial:SD2%
            AND SB5.B5_FILIAL    = %xFilial:SB5%
            AND SD2.D2_TIPO NOT IN ('D','B')
            AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
            AND SD2.%notDel%
            AND SB5.%notDel%
          GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS))
          UNION ALL
          SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) CODHIS, NVL(SUM(SD1.D1_QUANT),0)*(-1) QTDE, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC),0)*(-1) LIQUIDO
            FROM %table:SD1% SD1, %table:SB5% SB5
          WHERE SD1.D1_COD = SB5.B5_COD
            AND SD1.D1_TES IN (SELECT F4_CODIGO FROM %table:SF4% WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND F4_CODIGO < '400' AND %notDel%)
            AND SD1.D1_FILIAL  = %xFilial:SD1%
            AND SB5.B5_FILIAL  = %xFilial:SB5%
            AND SD1.D1_TIPO    = 'D'
            AND SD1.D1_DTDIGIT BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
            AND SD1.%notDel%
            AND SB5.%notDel%
          GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS))
          UNION ALL
          SELECT IDOBRAHISTORICO CODHIS, SUM(QTDE) QTDE, SUM(LIQUIDO) LIQUIDO
            FROM DBA_EGK.GEN_FAT001_FATURAMENTO
          WHERE TT_DATA BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
            AND INTERCOMPANY  = 0
          GROUP BY IDOBRAHISTORICO) F
        , (SELECT B2_COD, B2_QATU FROM %table:SB2% WHERE B2_LOCAL = '04') RSV
		, (SELECT * FROM %table:SZ7% WHERE %notDel% ) SZ7     
     WHERE SB2.B2_FILIAL    = %xFilial:SB2%
          AND SB1.B1_FILIAL = %xFilial:SB1%
          AND Z1.X5_FILIAL  = %xFilial:SX5%
          AND Z4.X5_FILIAL  = %xFilial:SX5%
          AND SB5.B5_FILIAL = %xFilial:SB5%
          AND SB2.B2_COD = SB1.B1_COD  
          AND SB1.B1_COD = SB5.B5_COD
          AND SB5.B5_XSELO = Z1.X5_CHAVE
          AND SB1.B1_XIDTPPU = Z4.X5_CHAVE
          AND SB1.B1_XSITOBR = SZ4.Z4_COD
          AND TO_NUMBER(TRIM(SB5.B5_XCODHIS)) = F.CODHIS (+)
          AND SB1.B1_COD = RSV.B2_COD (+)
          AND SB5.B5_XAREA = SZ7.Z7_AREA (+)
          AND SB5.B5_XFEC  = '1'
          AND SB2.B2_LOCAL = '01'          
          AND Z1.X5_TABELA = 'Z1'
          AND Z4.X5_TABELA = 'Z4'
          AND SB1.B1_XSITOBR IN ('101','105')
          AND SB1.B1_XIDTPPU IN ('9','14','15','16','17','24','25')
          AND SB2.%notDel%
          AND SB1.%notDel%
       	  AND SZ4.%notDel%
          AND Z1.%notDel%
          AND Z4.%notDel%   
          
	     %exp:_cSQL%  
	  
	 GROUP BY B1_COD
    	    , B1_ISBN
        	, B1_DESC
	        , Z1.X5_DESCRI
    	    , Z4.X5_DESCRI
        	, SZ4.Z4_DESC
	        , TO_CHAR(TO_DATE(TRIM(SB5.B5_XDTPUBL), 'YYYYMMDD'), 'DD/MM/YYYY')
	        , SZ7.Z7_DESC
    	    , SB2.B2_QATU
        	, NVL(RSV.B2_QATU,0)
	        , SB2.B2_QNPT
          	
	 ORDER BY LIQUIDO DESC, DIAEST)
 WHERE DIAEST <= %Exp:_cParm5%

	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)