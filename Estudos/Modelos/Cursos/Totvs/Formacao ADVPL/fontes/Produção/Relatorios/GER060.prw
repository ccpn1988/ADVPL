#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER060    บAutor  ณErica Vieites       บ Data ณ  28/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Vendas Site Por มrea                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GER060()             

Local oReport
Local cPerg := "GER060"


//Cria grupo de perguntas
PutSx1(cPerg, "01", "Data de:", "Data de:" ,"Data de:",  "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Data at้:", "Data at้:","Data at้:", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSX1(cPerg, "03", "Relat๓rio:"     , "Relat๓rio:"     ,"Relat๓rio:"    , "mv_ch3" , "C", 1, 0, 1, "C","", "", "", "", "MV_PAR03", "Sint้tico", "Sint้tico", "Sint้tico", "", "Analํtico", "Analํtico", "Analํtico", "", "", "", "", "","", "", "", "", "", "", "", "" )

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
oReport := TReport():New("GER060","VENDA SITE POR มREA",cPerg,{|oReport| PrintReport(oReport)},"VENDA SITE POR มREA")

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
TRCell():New(oSection1,"Z7_DESC"   		,"SZ7","มrea",,20)
    
if (MV_PAR03 == 2)
TRCell():New(oSection1,"B1_ISBN"   		,"SB1",,,18) 
TRCell():New(oSection1,"B1_DESC"   		,"SB1",,,30)  
TRCell():New(oSection1,"X5_DESCRI" 		,"SX5","Selo",,10)  
TRCell():New(oSection1,"TP_DESCRI" 		," ","Tipo Publica็ใo",,20) 
endif   

TRCell():New(oSection1,"QTDE_AA"		,""		,"Qtde Anterior"	,'@E 9,999,999'		,10,,,,,"RIGHT")
TRCell():New(oSection1,"D2_VALBRUT"		,"SD2"	,"Valor Anterior"   ,'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection1,"QTDE"	     	,""		,"Qtde Atual"   	,'@E 9,999,999'		,10,,,,,"RIGHT") 
TRCell():New(oSection1,"D2_VALDESC"	 	,"SD2"	,"Valor Atual"      ,'@E 999,999,999.99',15,,,,,"RIGHT") 

//Totalizadores
TRFunction():New(oSection1:Cell("QTDE_AA")   	,NIL,"SUM")
TRFunction():New(oSection1:Cell("D2_VALBRUT")  ,NIL,"SUM")
TRFunction():New(oSection1:Cell("QTDE")     	,NIL,"SUM")
TRFunction():New(oSection1:Cell("D2_VALDESC")	,NIL,"SUM")                             

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


If (MV_PAR03 == 1)
	//Cria query
	Begin Report Query oSection1
		BeginSQL Alias cAlias1  
			SELECT SZ7.Z7_AREA, SZ7.Z7_DESC,
			       SUM(QTDE_AA) QTDE_AA, 
			       SUM(VALOR_AA) D2_VALBRUT, 
			       SUM(QTDE) QTDE, 
			       SUM(VALOR) D2_VALDESC
			  FROM (SELECT B1_COD, SUM(QTDE_AA) QTDE_AA, SUM(VALOR_AA) VALOR_AA, SUM(QTDE) QTDE, SUM(VALOR) VALOR
			          FROM (SELECT TRIM(SB1.B1_COD) B1_COD, 0 QTDE_AA, 0 VALOR_AA,
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
			                 GROUP BY SB1.B1_COD                       
                       UNION ALL
                       SELECT TRIM(SB1.B1_COD), 
                             NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0), 
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
			                 GROUP BY SB1.B1_COD
			                UNION ALL
			                SELECT LPAD(IDOBRAORIGEM, 8, '0'),
			                       SUM(CASE WHEN IDTIPOPUBLICACAO IN (11,15) THEN 0 ELSE QTDE END),
			                       SUM(LIQUIDO), 0, 0
			                  FROM GEN_FAT001_FATURAMENTO
			                 WHERE TT_DATA BETWEEN %Exp:_cParm3% AND %Exp:_cParm4%
			                   AND INTERCOMPANY  = 0
			                   AND VENDAWEB = 1
			                  GROUP BY LPAD(IDOBRAORIGEM, 8, '0'))
			         GROUP BY B1_COD) F
			  LEFT JOIN %table:SB5% SB5
			    ON F.B1_COD = TRIM(SB5.B5_COD)
			   AND SB5.B5_FILIAL  = %xFilial:SB5% 
			   AND SB5.%notDel%
			  LEFT JOIN %table:SZ7% SZ7
			    ON SB5.B5_XAREA = SZ7.Z7_AREA
			   AND SZ7.Z7_FILIAL  = %xFilial:SZ7%
			   AND SZ7.%notDel%
			 GROUP BY SZ7.Z7_AREA, SZ7.Z7_DESC
			 ORDER BY TO_NUMBER(TRIM(SZ7.Z7_AREA))
		EndSql			
	End Report Query oSection1    
else
	//Cria query
	Begin Report Query oSection1
		BeginSQL Alias cAlias1  
		SELECT SZ7.Z7_AREA, SZ7.Z7_DESC,
			       F.B1_ISBN B1_ISBN, 
			       F.B1_DESC B1_DESC, 
			       TRIM(SX5.X5_DESCRI) X5_DESCRI,
			       F.QTDE_AA, 
			       F.VALOR_AA D2_VALBRUT, 
			       F.QTDE, 
			       F.VALOR D2_VALDESC,
			       TRIM(TP.X5_DESCRI) TP_DESCRI
			  FROM (SELECT B1_DESC, B1_COD, B1_ISBN, SUM(QTDE_AA) QTDE_AA, SUM(VALOR_AA) VALOR_AA, SUM(QTDE) QTDE, SUM(VALOR) VALOR, TIPOPUBLICACAO
			          FROM (SELECT TRIM(SB1.B1_DESC) B1_DESC, 
			                       TRIM(SB1.B1_COD) B1_COD, SB1.B1_ISBN, 0 QTDE_AA, 0 VALOR_AA,
			                       NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE,
			                       NVL(SUM(SD2.D2_VALBRUT), 0) VALOR, TO_NUMBER(TRIM(SB1.B1_XIDTPPU)) TIPOPUBLICACAO
			                  FROM %table:SD2% SD2, %table:SB1% SB1
			                 WHERE SD2.D2_COD = SB1.B1_COD
			                   AND SD2.D2_TES IN ('503','506','564')
			                   AND SD2.D2_FILIAL  = %xFilial:SD2%
			                   AND SB1.B1_FILIAL  = %xFilial:SB1%
			                   AND SD2.D2_TIPO NOT IN ('D','B')
			                   AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
			                   AND SD2.%notDel%
			                   AND SB1.%notDel%
			                 GROUP BY B1_DESC,SB1.B1_COD, SB1.B1_ISBN, TO_NUMBER(TRIM(SB1.B1_XIDTPPU))
                      UNION ALL
                      SELECT TRIM(SB1.B1_DESC), 
			                 TRIM(SB1.B1_COD) B1_COD, SB1.B1_ISBN, 
                             NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0), 
                             NVL(SUM(SD2.D2_VALBRUT), 0), 0, 0, TO_NUMBER(TRIM(SB1.B1_XIDTPPU)) 
			                  FROM %table:SD2% SD2, %table:SB1% SB1
			                 WHERE SD2.D2_COD = SB1.B1_COD
			                   AND SD2.D2_TES IN ('503','506','564')
			                   AND SD2.D2_FILIAL  = %xFilial:SD2%
			                   AND SB1.B1_FILIAL  = %xFilial:SB1%
			                   AND SD2.D2_TIPO NOT IN ('D','B')
			                   AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm3%  AND %Exp:_cParm4%
			                   AND SD2.%notDel%
			                   AND SB1.%notDel% 			                   
			                 GROUP BY B1_DESC,SB1.B1_COD, SB1.B1_ISBN, TO_NUMBER(TRIM(SB1.B1_XIDTPPU))
			                UNION ALL
			                SELECT TXOBRA,
			                       LPAD(IDOBRAORIGEM, 8, '0'),           
			                       ISBN,
			                       SUM(CASE WHEN IDTIPOPUBLICACAO IN (11,15) THEN 0 ELSE QTDE END),
			                       SUM(LIQUIDO), 0, 0, IDTIPOPUBLICACAO
			                  FROM GEN_FAT001_FATURAMENTO
			                 WHERE TT_DATA BETWEEN %Exp:_cParm3% AND %Exp:_cParm4%
			                   AND INTERCOMPANY  = 0
			                   AND VENDAWEB = 1
			                  GROUP BY TXOBRA,LPAD(IDOBRAORIGEM, 8, '0'), ISBN, IDTIPOPUBLICACAO)
			         GROUP BY B1_DESC, B1_COD, B1_ISBN,TIPOPUBLICACAO) F
			  LEFT JOIN %table:SB5% SB5
			    ON F.B1_COD = TRIM(SB5.B5_COD)
			   AND SB5.B5_FILIAL  = %xFilial:SB5%
			   AND SB5.%notDel%
			  LEFT JOIN %table:SZ7% SZ7
			    ON SB5.B5_XAREA = SZ7.Z7_AREA
			   AND SZ7.Z7_FILIAL  = %xFilial:SZ7%
			   AND SZ7.%notDel%
              LEFT JOIN %table:SX5% SX5
	            ON SB5.B5_XSELO = SX5.X5_CHAVE
		       AND SX5.X5_TABELA = 'Z1'
			   AND SX5.X5_FILIAL  = %xFilial:SX5%
		       AND SX5.%notDel% 
		       LEFT JOIN TOTVS.SX5000 TP
          		ON F.TIPOPUBLICACAO = TO_NUMBER(TRIM(TP.X5_CHAVE))
         	   AND TP.X5_TABELA  = 'Z4'               
               AND TP.X5_FILIAL  = %xFilial:SX5%  
               AND TP.%notDel%
			 ORDER BY TO_NUMBER(TRIM(SZ7.Z7_AREA)), D2_VALDESC DESC
		EndSql			
	End Report Query oSection1  
Endif

//Efetua impressใo
oSection1:Print()

Return(.t.)