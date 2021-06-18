#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT001    บAutor  ณEricaVieites        บ Data ณ  05/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Vendas Canal/tipo                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FAT001()             

Local oReport
Local cPerg := "FAT001"


//Cria grupo de perguntas
PutSx1(cPerg, "01", "Dt Emissใo de:", "Dt Emissใo de:" ,"Dt Emissใo de:", "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Dt Emissใo at้:", "Dt Emissใo at้","Dt Emissใo at้", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSX1(cPerg, "03", "Relat๓rio:"     , "Relat๓rio:"     ,"Relat๓rio:"   , "mv_ch3" , "C", 1, 0, 1, "C","", "", "", "", "MV_PAR03", "Vlr. Lํq.", "Vlr. Lํq.", "Vlr. Lํq.", "", "Qtde", "Qtde", "Qtde", "", "", "", "", "","", "", "", "", "", "", "", "" )


//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

     

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------

*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
If (MV_PAR03 == 1)
oReport := TReport():New("GER039","GER039 - PERFORMANCE DE CANAL DE VENDAS (VLR. LIQ.)",cPerg,{|oReport| PrintReport(oReport)},"GER039 - PERFORMANCE DE CANAL DE VENDAS (VLR. LIQ.)")
Else
oReport := TReport():New("GER039","GER039 - PERFORMANCE DE CANAL DE VENDAS (QTDE)",cPerg,{|oReport| PrintReport(oReport)},"GER039 - PERFORMANCE DE CANAL DE VENDAS (QTDE)")
End If

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao
TRCell():New(oSection1,"A1_XCANALV"		,"SA1",,,20)
TRCell():New(oSection1,"A1_XTIPCLI"		,"SA1",,,20)

If (MV_PAR03 == 1)
TRCell():New(oSection1,"LIQ_EGK"	,"","EGK"		,'@E 999,999,999.99',20,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_LTC"	,"","LTC"		,'@E 999,999,999.99',20,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_FOR"	,"","Forense"	,'@E 999,999,999.99',20,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_ACF"	,"","ACF"		,'@E 999,999,999.99',20,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_ATL"	,"","Atlas"		,'@E 999,999,999.99',20,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_GEN"	,"","GEN"		,'@E 999,999,999.99',20,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQUIDO"	,"","Total"		,'@E 999,999,999.99',20,,,,,"RIGHT") 
Else
TRCell():New(oSection1,"QTD_EGK"   	,"","EGK"		,'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection1,"QTD_LTC"   	,"","LTC"		,'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection1,"QTD_FOR"   	,"","Forense"	,'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection1,"QTD_ACF"   	,"","ACF"		,'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection1,"QTD_ATL"   	,"","Atlas"		,'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection1,"QTD_GEN"   	,"","GEN"		,'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection1,"QTDE"   	,"","Total"		,'@E 9,999,999',20,,,,,"RIGHT")
End If

oBreak := TRBreak():New(oSection1,oSection1:Cell("A1_XCANALV"),"Subtotal",.f.)

//Totalizadores
If (MV_PAR03 == 1)
TRFunction():New(oSection1:Cell("LIQ_EGK"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("LIQ_LTC"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("LIQ_FOR"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("LIQ_ACF"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("LIQ_ATL"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("LIQ_GEN"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("LIQUIDO"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
Else
TRFunction():New(oSection1:Cell("QTD_EGK"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("QTD_LTC"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("QTD_FOR"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("QTD_ACF"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("QTD_ATL"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("QTD_GEN"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("QTDE"),, "SUM",oBreak,,,,.T.,.F.,.F., oSection1) 
End If


//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
	
	SELECT SX5Z2.X5_DESCRI AS A1_XCANALV, 
           SX5TP.X5_DESCRI AS A1_XTIPCLI, 
           NVL(SUM(DECODE(B1_PROC, '0380795', QTDE, 0)), 0) AS QTD_EGK, 
           NVL(SUM(DECODE(B1_PROC, '0380795', LIQUIDO, 0)), 0) AS LIQ_EGK,
           NVL(SUM(DECODE(B1_PROC, '0380796', QTDE, 0)), 0) AS QTD_LTC, 
           NVL(SUM(DECODE(B1_PROC, '0380796', LIQUIDO, 0)), 0) AS LIQ_LTC,
           NVL(SUM(DECODE(B1_PROC, '0380794', QTDE, 0)), 0) AS QTD_FOR, 
           NVL(SUM(DECODE(B1_PROC, '0380794', LIQUIDO, 0)), 0) AS LIQ_FOR,
           NVL(SUM(DECODE(B1_PROC, '031811 ', QTDE, 0)), 0) AS QTD_ACF, 
           NVL(SUM(DECODE(B1_PROC, '031811 ', LIQUIDO, 0)), 0) AS LIQ_ACF,
           NVL(SUM(DECODE(B1_PROC, '0378128', QTDE, 0)), 0) AS QTD_ATL, 
           NVL(SUM(DECODE(B1_PROC, '0378128', LIQUIDO, 0)), 0) AS LIQ_ATL,
           NVL(SUM(DECODE(B1_PROC, '378803 ', QTDE, 0)), 0) AS QTD_GEN, 
           NVL(SUM(DECODE(B1_PROC, '378803 ', LIQUIDO, 0)), 0) AS LIQ_GEN,
           NVL(SUM(QTDE), 0) QTDE,
           NVL(SUM(LIQUIDO), 0) LIQUIDO
      FROM %table:SX5% SX5Z2, 
           %table:SX5% SX5TP,
           (SELECT B1_PROC, IDCANAL, IDTIPOCLIENTE, SUM(QTDE) QTDE, SUM(LIQUIDO) LIQUIDO
              FROM (SELECT SB1.B1_PROC, SA1.A1_XCANALV IDCANAL, SA1.A1_XTIPCLI IDTIPOCLIENTE, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
                      FROM %table:SD2% SD2, %table:SB1% SB1, %table:SA1% SA1
                     WHERE SD2.D2_COD = SB1.B1_COD
                       AND SD2.D2_CLIENTE = SA1.A1_COD
                       AND SD2.D2_LOJA = SA1.A1_LOJA
                       AND SD2.D2_TES IN (SELECT F4_CODIGO FROM %table:SF4% WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ')
                       AND SD2.D2_FILIAL  = %xFilial:SD2%
                       AND SB1.B1_FILIAL  = %xFilial:SB1%
                       AND SA1.A1_FILIAL  = %xFilial:SA1%
                       AND SD2.D2_TIPO NOT IN ('D','B')
                       AND SB1.B1_XIDTPPU <> ' '
                       AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
                       AND SD2.%notDel% 
                       AND SB1.%notDel% 
                       AND SA1.%notDel% 
                     GROUP BY SB1.B1_PROC, SA1.A1_XCANALV, SA1.A1_XTIPCLI
                    UNION ALL
                    SELECT SB1.B1_PROC, SA1.A1_XCANALV, SA1.A1_XTIPCLI, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0)*(-1), NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
                      FROM %table:SD1% SD1, %table:SB1% SB1, %table:SA1% SA1
                     WHERE SD1.D1_COD = SB1.B1_COD
                       AND SD1.D1_FORNECE = SA1.A1_COD
                       AND SD1.D1_LOJA = SA1.A1_LOJA
                       AND SD1.D1_TES IN (SELECT F4_CODIGO FROM %table:SF4% WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND %notDel%)
                       AND SD1.D1_FILIAL  = %xFilial:SD1%
                       AND SB1.B1_FILIAL  = %xFilial:SB1%
                       AND SA1.A1_FILIAL  = %xFilial:SA1%
                       AND SD1.D1_TIPO = 'D'
                       AND SB1.B1_XIDTPPU <> ' '
                       AND SD1.D1_DTDIGIT BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
                       AND SD1.%notDel%
                       AND SB1.%notDel%
                       AND SA1.%notDel%
                     GROUP BY SB1.B1_PROC, SA1.A1_XCANALV, SA1.A1_XTIPCLI)
             GROUP BY B1_PROC, IDCANAL, IDTIPOCLIENTE) FAT
   	 WHERE FAT.IDCANAL = SX5Z2.X5_CHAVE (+)
       AND FAT.IDTIPOCLIENTE = SX5TP.X5_CHAVE (+)
       AND SX5Z2.X5_TABELA = 'Z2'
	   AND SX5TP.X5_TABELA = 'TP'
	   AND SX5Z2.%notDel%
	   AND SX5TP.%notDel%
     GROUP BY SX5Z2.X5_DESCRI, SX5TP.X5_DESCRI
     ORDER BY A1_XCANALV, LIQUIDO DESC	  
	
	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)