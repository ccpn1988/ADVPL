#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER059    บAutor  ณErica Vieites       บ Data ณ  28/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Vendas Site Por Dia                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GER059()             

Local oReport
Local cPerg := "GER059"


//Cria grupo de perguntas
PutSx1(cPerg, "01", "Data de:", "Data de:" ,"Data de:",  "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Data at้:", "Data at้:","Data at้:", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")


//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

    

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
oReport := TReport():New("GER059","VENDA SITE POR DIA",cPerg,{|oReport| PrintReport(oReport)},"VENDA SITE POR DIA")

//Ajuste nas definicoes             
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao
TRCell():New(oSection1,"D2_EMISSAO"		,"","Data",,15)
TRCell():New(oSection1,"QTDE_AA"		,"","Qtde Anterior",'@E 9,999,999',10,,,,,"RIGHT")
TRCell():New(oSection1,"D2_VALBRUT"		,"SD2","Valor Anterior",,15,,,,,"RIGHT")
TRCell():New(oSection1,"QTDE"	  	    ,"","Qtde Atual",'@E 9,999,999',10,,,,,"RIGHT") 
TRCell():New(oSection1,"D1_VALDESC"	 	,"SD2","Valor Atual",,15,,,,,"RIGHT") 

//Totalizadores
TRFunction():New(oSection1:Cell("QTDE_AA")   	,NIL,"SUM")
TRFunction():New(oSection1:Cell("D2_VALBRUT")  ,NIL,"SUM")
TRFunction():New(oSection1:Cell("QTDE")	        ,NIL,"SUM")
TRFunction():New(oSection1:Cell("D1_VALDESC")	,NIL,"SUM")                             

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.F.)
oReport:SetTotalInLine(.F.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
_cParm3 := DTOS(YEARSUB(MV_PAR01, 1))
_cParm4 := DTOS(YEARSUB(MV_PAR02, 1))
  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
 
  	
SELECT D2_EMISSAO AS D2_EMISSAO,
       SUM(QTDE_AA) AS QTDE_AA, 
       SUM(VALOR_AA) AS D2_VALBRUT, 
       SUM(QTDE) AS QTDE, 
       SUM(VALOR) AS D1_VALDESC
FROM (SELECT SD2.D2_EMISSAO D2_EMISSAO,  
       TRIM(SB1.B1_COD) B1_COD, 0 QTDE_AA, 0 VALOR_AA,
       NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE,
       NVL(SUM(SD2.D2_VALBRUT), 0) VALOR
         FROM %table:SD2% SD2, %table:SB1% SB1
      WHERE SD2.D2_COD = SB1.B1_COD
        AND SD2.D2_TES IN ('503','506','564')
        AND SD2.D2_FILIAL  = %xFilial:SD2%
        AND SB1.B1_FILIAL  = %xFilial:SB1%
        AND SD2.D2_TIPO NOT IN ('D','B')
        AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
        AND SD2.%notDel%
        AND SB1.%notDel%
      GROUP BY D2_EMISSAO, SB1.B1_COD   
      UNION ALL
      SELECT TO_CHAR(ADD_MONTHS(TO_DATE(SD2.D2_EMISSAO,'YYYYMMDD'),12),'YYYYMMDD'),  
             TRIM(SB1.B1_COD), NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0), 
             NVL(SUM(SD2.D2_VALBRUT), 0), 0, 0       
         FROM %table:SD2% SD2, %table:SB1% SB1
      WHERE SD2.D2_COD = SB1.B1_COD
        AND SD2.D2_TES IN ('503','506','564')
        AND SD2.D2_FILIAL  = %xFilial:SD2%
        AND SB1.B1_FILIAL  = %xFilial:SB1%
        AND SD2.D2_TIPO NOT IN ('D','B')
        AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm3%  AND %Exp:_cParm4%
        AND SD2.%notDel%
        AND SB1.%notDel%
      GROUP BY TO_CHAR(ADD_MONTHS(TO_DATE(SD2.D2_EMISSAO,'YYYYMMDD'),12),'YYYYMMDD'), SB1.B1_COD
      UNION ALL
      SELECT TO_CHAR(ADD_MONTHS(DATA,12),'YYYYMMDD'),
             LPAD(IDOBRAORIGEM, 8, '0'),
             SUM(CASE WHEN IDTIPOPUBLICACAO IN (11,15) THEN 0 ELSE QTDE END),
             SUM(LIQUIDO), 0, 0
       FROM GEN_FAT001_FATURAMENTO
      WHERE TT_DATA BETWEEN %Exp:_cParm3% AND %Exp:_cParm4%
        AND INTERCOMPANY  = 0
        AND VENDAWEB = 1
      GROUP BY DATA, LPAD(IDOBRAORIGEM, 8, '0'))
GROUP BY D2_EMISSAO
ORDER BY D2_EMISSAO



	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)