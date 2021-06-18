#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GER039A   ºAutor  ³Helimar Tavares     º Data ³  09/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Vendas Canal/tipo colunado com as áreas - nao  º±±
±±º          ³utiliza filtro de filial, ou seja vem todas existentes.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Faturamento                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GER039A()             

Local oReport
Local cPerg := "GER039A"

//Cria grupo de perguntas
PutSx1(cPerg, "01", "Dt Emissão de:" , "Dt Emissão de:","Dt Emissão de:", "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Dt Emissão até:", "Dt Emissão até","Dt Emissão até", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSX1(cPerg, "03", "Relatório:"     , "Relatório:"    ,"Relatório:"    , "mv_ch3" , "C", 1, 0, 1, "C","", "", "", "", "MV_PAR03", "Sintético", "Sintético", "Sintético", "", "Analítico", "Analítico", "Analítico", "", "", "", "", "","", "", "", "", "", "", "", "" )

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

Private oSection1
Private oSection2
Private oSection3
Private _cTipoAnt  := NIL
Private _cTipo	   := NIL
Private _cCanalAnt := NIL
Private _cCanal	   := NIL

//Declaracao do relatorio
oReport := TReport():New("GER039","GER039 - Faturamento Líq. do Período por Canal de Vendas - Total GEN sem Fórum",cPerg,{|oReport| PrintReport(oReport)},"GER039 - Faturamento Líq. do Período por Canal de Vendas - Total GEN sem Fórum",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.          
oReport:oPage:SetPaperSize(9)
oReport:lDisableOrientation := .T.  
oReport:SetLandscape() 

//Secao do relatorio
oSection1 := TRSection():New(oReport,"","SD2")

//Celulas da secao
TRCell():New(oSection1,"TIPO"		,"",CRLF+"Tipo",,14)
TRCell():New(oSection1,"IDCANAL"	,"","",,0)
TRCell():New(oSection1,"A1_XCANALV"	,"SA1",CRLF+"Canal Venda",,18)
TRCell():New(oSection1,"A1_XTIPCLI"	,"SA1",CRLF+"Tipo Cliente",,18)
TRCell():New(oSection1,"LIQ_001"	,"","Saúde"+CRLF+"R$ Mil"		,'@E 999,999'	,8,,,,,"RIGHT") 
TRCell():New(oSection1,"PERC_001"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_002"	,"","Exatas"+CRLF+"R$ Mil"		,'@E 999,999'	,8,,,,,"RIGHT") 
TRCell():New(oSection1,"PERC_002"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_005"	,"","Concurso"+CRLF+"R$ Mil"	,'@E 999,999'	,8,,,,,"RIGHT") 
TRCell():New(oSection1,"PERC_005"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_006"	,"","Jurídico"+CRLF+"R$ Mil"	,'@E 999,999'	,8,,,,,"RIGHT") 
TRCell():New(oSection1,"PERC_006"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_007"	,"","Soc.Aplic."+CRLF+"R$ Mil"	,'@E 999,999'	,8,,,,,"RIGHT") 
TRCell():New(oSection1,"PERC_007"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
TRCell():New(oSection1,"LIQ_008"	,"","Humanas"+CRLF+"R$ Mil"		,'@E 999,999'	,8,,,,,"RIGHT") 
TRCell():New(oSection1,"PERC_008"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
TRCell():New(oSection1,"TOTAL"		,"","Total"+CRLF+"R$ Mil"		,'@E 999,999'	,8,,,,,"RIGHT",,,,,,.T.) 
TRCell():New(oSection1,"PERC_TOT"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT",,,,,,.T.) 
TRCell():New(oSection1,"META"		,"","Meta"+CRLF+"R$ Mil"  		,'@E 999,999'	,8,,,,,"RIGHT",,,,,,.T.) 
TRCell():New(oSection1,"PERC_META"	,"",CRLF+" % Meta"				,'@E 999,999.99',8,,,,,"RIGHT",,,,,,.T.) 

If (MV_PAR03 == 1)
	oBreak1 := TRBreak():New(oSection1,oSection1:Cell("A1_XCANALV"),"Subtotal Canal Venda",.F.)
	oBreak2 := TRBreak():New(oSection1,oSection1:Cell("TIPO"),"Subtotal Tipo",.F.)
	
	//Totalizadores
	TRFunction():New(oSection1:Cell("LIQ_001"  ),"TLIQ_001", "SUM",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_001" ),"TPERC_001" , "ONPRINT",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_002"  ),,"SUM",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_002" ),"TPERC_002" , "ONPRINT",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_005"  ),,"SUM",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_005" ),"TPERC_005" , "ONPRINT",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_006"  ),,"SUM",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_006" ),"TPERC_006" , "ONPRINT",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_007"  ),,"SUM",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_007" ),"TPERC_007" , "ONPRINT",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_008"  ),,"SUM",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_008" ),"TPERC_008" , "ONPRINT",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("TOTAL"    ),,"SUM",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_TOT" ),"TPERC_TOT" , "ONPRINT",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("META"     ),,"SUM",oBreak1,,,,.T.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_META"),"TPERC_META", "ONPRINT",oBreak1,,,,.T.,.F.,.F., oSection1)
	
	TRFunction():New(oSection1:Cell("LIQ_001"  ),,"SUM",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_001" ),"TpPERC_001" ,"ONPRINT",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_002"  ),,"SUM",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_002" ),"TpPERC_002" ,"ONPRINT",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_005"  ),,"SUM",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_005" ),"TpPERC_005" ,"ONPRINT",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_006"  ),,"SUM",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_006" ),"TpPERC_006" ,"ONPRINT",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_007"  ),,"SUM",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_007" ),"TpPERC_007" ,"ONPRINT",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("LIQ_008"  ),,"SUM",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_008" ),"TpPERC_008" ,"ONPRINT",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("TOTAL"    ),,"SUM",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_TOT" ),"TpPERC_TOT" ,"ONPRINT",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("META"     ),,"SUM",oBreak2,,,,.F.,.F.,.F., oSection1)
	TRFunction():New(oSection1:Cell("PERC_META"),"TpPERC_META","ONPRINT",oBreak2,,,,.F.,.F.,.F., oSection1)
	
	//oReport:GetFunction("TPERC_001"):SetFormula({||uReport := (oReport:GetFunction("TLIQ_001"):uLastValue / oReport:GetFunction("TLIQ_AA_001"):uLastValue) * 100})
	oReport:GetFunction("TPERC_001" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,_cCanalAnt,'000001')})
	oReport:GetFunction("TPERC_002" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,_cCanalAnt,'000002')})
	oReport:GetFunction("TPERC_005" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,_cCanalAnt,'000005')})
	oReport:GetFunction("TPERC_006" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,_cCanalAnt,'000006')})
	oReport:GetFunction("TPERC_007" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,_cCanalAnt,'000007')})
	oReport:GetFunction("TPERC_008" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,_cCanalAnt,'000008')})
	oReport:GetFunction("TPERC_TOT" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,_cCanalAnt,'TOTAL')})
	oReport:GetFunction("TPERC_META"):SetFormula({||uReport := CalcPerc(_cTipoAnt,_cCanalAnt,'META')})
	
	oReport:GetFunction("TpPERC_001" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,'TOTAL','000001')})
	oReport:GetFunction("TpPERC_002" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,'TOTAL','000002')})
	oReport:GetFunction("TpPERC_005" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,'TOTAL','000005')})
	oReport:GetFunction("TpPERC_006" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,'TOTAL','000006')})
	oReport:GetFunction("TpPERC_007" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,'TOTAL','000007')})
	oReport:GetFunction("TpPERC_008" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,'TOTAL','000008')})
	oReport:GetFunction("TpPERC_TOT" ):SetFormula({||uReport := CalcPerc(_cTipoAnt,'TOTAL','TOTAL')})
	oReport:GetFunction("TpPERC_META"):SetFormula({||uReport := CalcPerc(_cTipoAnt,'TOTAL','META')})

	//Faz a impressao do totalizador em linha
	oSection1:SetTotalInLine(.f.)
Else
	//Secao do relatorio
	oSection2 := TRSection():New(oSection1,"","")
	
	//Celulas da secao
	TRCell():New(oSection2,"CNPJ"		,"",CRLF+"CNPJ",,14)
	TRCell():New(oSection2,"NOME"		,"",CRLF+"Cliente",,18)
	TRCell():New(oSection2,"VENDEDOR"	,"",CRLF+"Vendedor",,18)
	TRCell():New(oSection2,"LIQ_001"	,"","Saúde"+CRLF+"R$ Mil"		,'@E 999,999'	,8,,,,,"RIGHT") 
	TRCell():New(oSection2,"PERC_001"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
	TRCell():New(oSection2,"LIQ_002"	,"","Exatas"+CRLF+"R$ Mil"		,'@E 999,999'	,8,,,,,"RIGHT") 
	TRCell():New(oSection2,"PERC_002"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
	TRCell():New(oSection2,"LIQ_005"	,"","Concurso"+CRLF+"R$ Mil"	,'@E 999,999'	,8,,,,,"RIGHT") 
	TRCell():New(oSection2,"PERC_005"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
	TRCell():New(oSection2,"LIQ_006"	,"","Jurídico"+CRLF+"R$ Mil"	,'@E 999,999'	,8,,,,,"RIGHT") 
	TRCell():New(oSection2,"PERC_006"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
	TRCell():New(oSection2,"LIQ_007"	,"","Soc.Aplic."+CRLF+"R$ Mil"	,'@E 999,999'	,8,,,,,"RIGHT") 
	TRCell():New(oSection2,"PERC_007"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
	TRCell():New(oSection2,"LIQ_008"	,"","Humanas"+CRLF+"R$ Mil"		,'@E 999,999'	,8,,,,,"RIGHT") 
	TRCell():New(oSection2,"PERC_008"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT") 
	TRCell():New(oSection2,"TOTAL"		,"","Total"+CRLF+"R$ Mil"		,'@E 999,999'	,8,,,,,"RIGHT",,,,,,.T.) 
	TRCell():New(oSection2,"PERC_TOT"	,"",CRLF+" % A.A."				,'@E 999,999.99',8,,,,,"RIGHT",,,,,,.T.) 
	TRCell():New(oSection2,"META"		,"","Meta"+CRLF+"R$ Mil"		,'@E 999,999'	,8,,,,,"RIGHT",,,,,,.T.) 
	TRCell():New(oSection2,"PERC_META"	,"",CRLF+" % Meta"				,'@E 999,999.99',8,,,,,"RIGHT",,,,,,.T.) 
	
	//Faz a impressao do totalizador em linha
	oSection2:SetTotalInLine(.f.)
EndIf

//Secao do relatorio
oSection3 := TRSection():New(oReport,"","")

//Celulas da secao
TRCell():New(oSection3,"TIPO"		,"","",,14)
TRCell():New(oSection3,"IDCANAL"	,"","",,0)
TRCell():New(oSection3,"A1_XCANALV"	,"SA1","",,18)
TRCell():New(oSection3,"A1_XTIPCLI"	,"SA1","",,18)
TRCell():New(oSection3,"LIQ_001"	,"","",'@E 999,999'   ,8) 
TRCell():New(oSection3,"PERC_001"	,"","",'@E 999,999.99',8) 
TRCell():New(oSection3,"LIQ_002"	,"","",'@E 999,999'   ,8) 
TRCell():New(oSection3,"PERC_002"	,"","",'@E 999,999.99',8) 
TRCell():New(oSection3,"LIQ_005"	,"","",'@E 999,999'   ,8) 
TRCell():New(oSection3,"PERC_005"	,"","",'@E 999,999.99',8) 
TRCell():New(oSection3,"LIQ_006"	,"","",'@E 999,999'   ,8) 
TRCell():New(oSection3,"PERC_006"	,"","",'@E 999,999.99',8) 
TRCell():New(oSection3,"LIQ_007"	,"","",'@E 999,999'   ,10) 
TRCell():New(oSection3,"PERC_007"	,"","",'@E 999,999.99',8) 
TRCell():New(oSection3,"LIQ_008"	,"","",'@E 999,999'   ,8) 
TRCell():New(oSection3,"PERC_008"	,"","",'@E 999,999.99',8) 
TRCell():New(oSection3,"TOTAL"		,"","",'@E 999,999'   ,8) 
TRCell():New(oSection3,"PERC_TOT"	,"","",'@E 999,999.99',8) 
TRCell():New(oSection3,"META"		,"","",,8) 
TRCell():New(oSection3,"PERC_META"	,"","",,8) 

oSection3:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)
Local oSection3 := oReport:Section(2)
Local _cQuery1	:= ""                      
Local _cAlias   := GetNextAlias()

Private _cQuery2 := ""                      
Private _cAlias1 := GetNextAlias()
Private _cAlias2 := GetNextAlias()
Private _cAlias3 := GetNextAlias()
Private _aPerc   := {}
Private _cParm1  := DTOS(MV_PAR01)
Private _cParm2  := DTOS(MV_PAR02)
Private _cParm3  := DTOS(YEARSUB(MV_PAR01,1))
Private _cParm4  := DTOS(YEARSUB(MV_PAR02,1))
Private _cParm5  := DTOS(LASTDATE(MV_PAR01))
Private _cParm6  := DTOS(LASTDATE(MV_PAR02))

_cQuery1 := " SELECT F.CANAL, F.AREA, F.TIPO, SUM(F.LIQUIDO) LIQUIDO, SUM(F.LIQUIDO_AA) LIQUIDO_AA, NVL(M.META,0) META
_cQuery1 += "   FROM (SELECT CANAL, AREA, TIPO, SUM(LIQUIDO) LIQUIDO, SUM(LIQUIDO_AA) LIQUIDO_AA
_cQuery1 += "           FROM (SELECT NVL(SB5.B5_XAREA, '      ') AREA, NVL(SA1.A1_XCANALV, '     ') CANAL, SB1.B1_TIPO TIPO, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO, 0 LIQUIDO_AA
_cQuery1 += "                   FROM GER_SD2 SD2 
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SD2.D2_CLIENTE = SA1.A1_COD
_cQuery1 += "                    AND SD2.D2_LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                    AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY NVL(SB5.B5_XAREA, '      '), NVL(SA1.A1_XCANALV, '     '), SB1.B1_TIPO
_cQuery1 += "                 UNION ALL
_cQuery1 += "                 SELECT NVL(SB5.B5_XAREA, '      '), NVL(SA1.A1_XCANALV, '     '), SB1.B1_TIPO, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1), 0
_cQuery1 += "                   FROM GER_SD1 SD1
_cQuery1 += "                  INNER JOIN SB1000 SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SD1.D1_FORNECE = SA1.A1_COD
_cQuery1 += "                    AND SD1.D1_LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "                  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "                    AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY NVL(SB5.B5_XAREA, '      '), NVL(SA1.A1_XCANALV, '     '), SB1.B1_TIPO
_cQuery1 += "                 UNION ALL 
_cQuery1 += "                 SELECT NVL(SB5.B5_XAREA, '      '), NVL(SA1.A1_XCANALV, '     '), SB1.B1_TIPO, 0, NVL(SUM(SD2.D2_VALBRUT), 0)
_cQuery1 += "                   FROM GER_SD2 SD2 
_cQuery1 += "                  INNER JOIN SB1000 SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SD2.D2_CLIENTE = SA1.A1_COD
_cQuery1 += "                    AND SD2.D2_LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                    AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY NVL(SB5.B5_XAREA, '      '), NVL(SA1.A1_XCANALV, '     '), SB1.B1_TIPO
_cQuery1 += "                 UNION ALL
_cQuery1 += "                 SELECT NVL(SB5.B5_XAREA, '      '), NVL(SA1.A1_XCANALV, '     '), SB1.B1_TIPO, 0, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery1 += "                   FROM GER_SD1 SD1
_cQuery1 += "                  INNER JOIN SB1000 SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SD1.D1_FORNECE = SA1.A1_COD
_cQuery1 += "                    AND SD1.D1_LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "                  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "                    AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY NVL(SB5.B5_XAREA, '      '), NVL(SA1.A1_XCANALV, '     '), SB1.B1_TIPO
_cQuery1 += "                 UNION ALL
_cQuery1 += "                 SELECT NVL(SB5.B5_XAREA,'      '), NVL(SA1.A1_XCANALV,'     '), MB.TIPO, NVL(SUM(MB.LIQUIDO),0), 0
_cQuery1 += "                   FROM GER_MB MB
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON MB.PRODUTO = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON MB.CLIENTE = SA1.A1_COD
_cQuery1 += "                    AND MB.LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "                  WHERE MB.EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery1 += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY NVL(SB5.B5_XAREA, '      '), NVL(SA1.A1_XCANALV, '     '), MB.TIPO
_cQuery1 += "                 UNION ALL 
_cQuery1 += "                 SELECT NVL(SB5.B5_XAREA,'      '), NVL(SA1.A1_XCANALV,'     '), MB.TIPO, 0, NVL(SUM(MB.LIQUIDO),0)
_cQuery1 += "                   FROM GER_MB MB
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON MB.PRODUTO = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON MB.CLIENTE = SA1.A1_COD
_cQuery1 += "                    AND MB.LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  WHERE MB.EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'"
_cQuery1 += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY NVL(SB5.B5_XAREA, '      '), NVL(SA1.A1_XCANALV, '     '), MB.TIPO)
_cQuery1 += "          GROUP BY CANAL, AREA, TIPO) F
_cQuery1 += "   LEFT JOIN (SELECT TC.IDCANAL, M.TIPOPRODUTO, NVL(SUM(M.VALOR),0) META
_cQuery1 += "                FROM GER_TB002_META_TIPOCLIENTE M
_cQuery1 += "                JOIN TIPOCLIENTE TC
_cQuery1 += "                  ON M.IDTIPOCLIENTE = TC.IDTIPOCLIENTE
_cQuery1 += "                WHERE TO_CHAR(M.DATA, 'YYYYMMDD') BETWEEN '" + _cParm5 + "' AND '" + _cParm6 + "'
_cQuery1 += "                GROUP BY TC.IDCANAL, M.TIPOPRODUTO) M             
_cQuery1 += "     ON TO_NUMBER(TRIM(F.CANAL)) = M.IDCANAL AND F.TIPO = M.TIPOPRODUTO
_cQuery1 += "  GROUP BY F.CANAL, F.AREA, F.TIPO, M.META
_cQuery1 += "  ORDER BY F.TIPO, F.CANAL, F.AREA
	
If Select(_cAlias) > 0
	dbSelectArea(_cAlias)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery1), _cAlias, .F., .T.)

_cTipo  := (_cAlias)->TIPO
_cCanal := (_cAlias)->CANAL
_nMeta  := (_cAlias)->META
_pMeta  := (_cAlias)->META
_tMeta  := (_cAlias)->META
_nLiq   := 0                   
_nLiqAA := 0          
_pLiq   := 0                   
_pLiqAA := 0          
_tLiq   := 0
_tLiqAA := 0

Do While !(_cAlias)->(eof()) 
	IF _cCanal <> (_cAlias)->CANAL
		If _nLiqAA <> 0
		     _nPerc := _nLiq / _nLiqAA * 100
		Else
			_nPerc := 0
		EndIf

		aAdd(_aPerc, {_cTipo,_cCanal,'TOTAL',_nLiq,_nLiqAA,_nPerc})	

		If _nMeta <> 0
		     _nPerc := _nLiq / _nMeta * 100
		Else
			_nPerc := 0
		EndIf

		aAdd(_aPerc, {_cTipo,_cCanal,'META',_nLiq,_nMeta,_nPerc})	

		_nLiq  := 0
		_nLiqAA:= 0               
		_cCanal:= (_cAlias)->CANAL
		_nMeta := (_cAlias)->META
		_pMeta := _pMeta + _nMeta
		_tMeta := _tMeta + _nMeta
	EndIF

	IF _cTipo <> (_cAlias)->TIPO
		If _pLiqAA <> 0
		     _nPerc := _pLiq / _pLiqAA * 100
		Else
			_nPerc := 0
		EndIf

		aAdd(_aPerc, {_cTipo,'TOTAL','TOTAL',_pLiq,_pLiqAA,_nPerc})	

		If _pMeta <> 0
		     _nPerc := _pLiq / _pMeta * 100
		Else
			_nPerc := 0
		EndIf

		aAdd(_aPerc, {_cTipo,'TOTAL','META',_pLiq,_pMeta,_nPerc})	

		_pLiq  := 0
		_pLiqAA:= 0
        _cTipo := (_cAlias)->TIPO   
        _pMeta := (_cAlias)->META
	EndIF

	_nLiq   := _nLiq   + (_cAlias)->LIQUIDO
	_nLiqAA := _nLiqAA + (_cAlias)->LIQUIDO_AA
	_pLiq   := _pLiq   + (_cAlias)->LIQUIDO
	_pLiqAA := _pLiqAA + (_cAlias)->LIQUIDO_AA
	_tLiq   := _tLiq   + (_cAlias)->LIQUIDO
	_tLiqAA := _tLiqAA + (_cAlias)->LIQUIDO_AA

	If (_cAlias)->AREA = ' '
		(_cAlias)->(dbSkip())
		Loop		
	EndIf
	
	If (_cAlias)->LIQUIDO_AA <> 0
		_nPerc := ((_cAlias)->LIQUIDO / (_cAlias)->LIQUIDO_AA) * 100
	Else
		_nPerc := 0
	EndIf

	aAdd(_aPerc, {(_cAlias)->TIPO,(_cAlias)->CANAL,(_cAlias)->AREA,(_cAlias)->LIQUIDO,(_cAlias)->LIQUIDO_AA,_nPerc})	

	_nPos := aScan(_aPerc,{|x| x[1]==(_cAlias)->TIPO .and. x[2]=="TOTAL" .and. x[3]==(_cAlias)->AREA})
	If _nPos <> 0
		_aPerc[_npos][4] := _aPerc[_npos][4] + (_cAlias)->LIQUIDO
		_aPerc[_npos][5] := _aPerc[_npos][5] + (_cAlias)->LIQUIDO_AA
		If _aPerc[_npos][5] <> 0
			_aPerc[_npos][6] := (_aPerc[_npos][4] / _aPerc[_npos][5] * 100)
		EndIf
	Else
		aAdd(_aPerc, {(_cAlias)->TIPO,"TOTAL",(_cAlias)->AREA,(_cAlias)->LIQUIDO,(_cAlias)->LIQUIDO_AA,_nPerc})	
	EndIf

	_nPos := aScan(_aPerc,{|x| x[1]=="TOTAL" .and. x[2]=="TOTAL" .and. x[3]==(_cAlias)->AREA})
	If _nPos <> 0
		_aPerc[_npos][4] := _aPerc[_npos][4] + (_cAlias)->LIQUIDO
		_aPerc[_npos][5] := _aPerc[_npos][5] + (_cAlias)->LIQUIDO_AA
		If _aPerc[_npos][5] <> 0
			_aPerc[_npos][6] := (_aPerc[_npos][4] / _aPerc[_npos][5] * 100)
		EndIf
	Else
		aAdd(_aPerc, {"TOTAL","TOTAL",(_cAlias)->AREA,(_cAlias)->LIQUIDO,(_cAlias)->LIQUIDO_AA,_nPerc})	
	EndIf

	(_cAlias)->(dbSkip())		         
EndDo	

If _nLiqAA <> 0
     _nPerc := _nLiq / _nLiqAA * 100
Else
	_nPerc := 0
EndIf

Aadd(_aPerc, {_cTipo,_cCanal,'TOTAL',_nLiq,_nLiqAA,_nPerc})	

If _nMeta <> 0
     _nPerc := _nLiq / _nMeta * 100
Else
	_nPerc := 0
EndIf

Aadd(_aPerc, {_cTipo,_cCanal,'META',_nLiq,_nMeta,_nPerc})	

If _pLiqAA <> 0
     _nPerc := _pLiq / _pLiqAA * 100
Else
	_nPerc := 0
EndIf

aAdd(_aPerc, {_cTipo,'TOTAL','TOTAL',_pLiq,_pLiqAA,_nPerc})	

If _pMeta <> 0
     _nPerc := _pLiq / _pMeta * 100
Else
	_nPerc := 0
EndIf

aAdd(_aPerc, {_cTipo,'TOTAL','META',_pLiq,_pMeta,_nPerc})	

If _tLiqAA <> 0
     _nPerc := _tLiq / _tLiqAA * 100
Else
	_nPerc := 0
EndIf

Aadd(_aPerc, {'TOTAL','TOTAL','TOTAL',_tLiq,_tLiqAA,_nPerc})	

If _tMeta <> 0
     _nPerc := _tLiq / _tMeta * 100
Else
	_nPerc := 0
EndIf

Aadd(_aPerc, {'TOTAL','TOTAL','META',_tLiq,_tMeta,_nPerc})	

_cQuery1 := ""
_cQuery1 := " SELECT FAT.TIPO, FAT.IDCANAL, FAT.IDTIPOCLIENTE,
_cQuery1 += "        TRIM(SX5Z2.X5_DESCRI) AS A1_XCANALV,
_cQuery1 += "        TRIM(SX5TP.X5_DESCRI) AS A1_XTIPCLI,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000001', FAT.LIQUIDO, 0)), 0) AS LIQ_001,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000002', FAT.LIQUIDO, 0)), 0) AS LIQ_002,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000005', FAT.LIQUIDO, 0)), 0) AS LIQ_005,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000006', FAT.LIQUIDO, 0)), 0) AS LIQ_006,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000007', FAT.LIQUIDO, 0)), 0) AS LIQ_007,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000008', FAT.LIQUIDO, 0)), 0) AS LIQ_008,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000001', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_001,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000002', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_002,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000005', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_005,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000006', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_006,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000007', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_007,
_cQuery1 += "        NVL(SUM(DECODE(FAT.AREA, '000008', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_008,
_cQuery1 += "        NVL(SUM(FAT.LIQUIDO), 0) LIQUIDO,
_cQuery1 += "        NVL(SUM(FAT.LIQUIDO_AA), 0) LIQUIDO_AA,
_cQuery1 += "        NVL(SUM(FAT.META), 0) META
_cQuery1 += "   FROM (SELECT AREA, NVL(IDCANAL,'4    ') IDCANAL, NVL(IDTIPOCLIENTE,'099   ') IDTIPOCLIENTE, TIPO, SUM(LIQUIDO) LIQUIDO, SUM(LIQUIDO_AA) LIQUIDO_AA, SUM(META) META
_cQuery1 += "           FROM (SELECT SB5.B5_XAREA AREA, SA1.A1_XCANALV IDCANAL, SA1.A1_XTIPCLI IDTIPOCLIENTE, SB1.B1_TIPO TIPO, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO, 0 LIQUIDO_AA, 0 META
_cQuery1 += "                   FROM GER_SD2 SD2
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SD2.D2_CLIENTE = SA1.A1_COD
_cQuery1 += "                    AND SD2.D2_LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, SB1.B1_TIPO
_cQuery1 += "                 UNION ALL
_cQuery1 += "                 SELECT SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, SB1.B1_TIPO, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1), 0, 0
_cQuery1 += "                   FROM GER_SD1 SD1
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SD1.D1_FORNECE = SA1.A1_COD
_cQuery1 += "                    AND SD1.D1_LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "                  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, SB1.B1_TIPO
_cQuery1 += "                 UNION ALL 
_cQuery1 += "                 SELECT SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, SB1.B1_TIPO, 0, NVL(SUM(SD2.D2_VALBRUT), 0), 0
_cQuery1 += "                   FROM GER_SD2 SD2
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SD2.D2_CLIENTE = SA1.A1_COD
_cQuery1 += "                    AND SD2.D2_LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, SB1.B1_TIPO
_cQuery1 += "                 UNION ALL
_cQuery1 += "                 SELECT SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, SB1.B1_TIPO, 0, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1), 0
_cQuery1 += "                   FROM GER_SD1 SD1
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SD1.D1_FORNECE = SA1.A1_COD
_cQuery1 += "                    AND SD1.D1_LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "                  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, SB1.B1_TIPO
_cQuery1 += "                 UNION ALL
_cQuery1 += "                 SELECT SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, MB.TIPO, NVL(SUM(MB.LIQUIDO), 0), 0, 0
_cQuery1 += "                   FROM GER_MB MB
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON MB.PRODUTO = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON MB.CLIENTE = SA1.A1_COD
_cQuery1 += "                    AND MB.LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "                  WHERE MB.EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery1 += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, MB.TIPO
_cQuery1 += "                 UNION ALL 
_cQuery1 += "                 SELECT SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, MB.TIPO, 0, NVL(SUM(MB.LIQUIDO), 0), 0
_cQuery1 += "                   FROM GER_MB MB
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON MB.PRODUTO = SB5.B5_COD
_cQuery1 += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1 ON MB.CLIENTE = SA1.A1_COD
_cQuery1 += "                    AND MB.LOJA = SA1.A1_LOJA
_cQuery1 += "                    AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery1 += "                    AND SA1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  WHERE MB.EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'"
_cQuery1 += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY SB5.B5_XAREA, SA1.A1_XCANALV, SA1.A1_XTIPCLI, MB.TIPO
_cQuery1 += "                 UNION ALL 
_cQuery1 += "                 SELECT LPAD(MTC.IDAREACRM,6,'0'), RPAD(TC.IDCANAL,5,' '), RPAD(LPAD(MTC.IDTIPOCLIENTE,3,0),6,' '), MTC.TIPOPRODUTO, 0, 0, SUM(MTC.VALOR) META
_cQuery1 += "                   FROM GER_TB002_META_TIPOCLIENTE MTC
_cQuery1 += "                  INNER JOIN TIPOCLIENTE TC ON MTC.IDTIPOCLIENTE = TC.IDTIPOCLIENTE
_cQuery1 += "                  WHERE TO_CHAR(MTC.DATA, 'YYYYMMDD') BETWEEN '" + _cParm5 + "' AND '" + _cParm6 + "'"
_cQuery1 += "                  GROUP BY MTC.IDAREACRM, TC.IDCANAL, MTC.IDTIPOCLIENTE, MTC.TIPOPRODUTO)
_cQuery1 += "          GROUP BY AREA, IDCANAL, IDTIPOCLIENTE, TIPO) FAT
_cQuery1 += "   LEFT JOIN " + RetSqlName("SX5") + " SX5Z2 ON TRIM(FAT.IDCANAL) = TRIM(SX5Z2.X5_CHAVE)
_cQuery1 += "    AND SX5Z2.X5_TABELA = 'Z2'
_cQuery1 += "    AND SX5Z2.X5_FILIAL = '" + xFilial("SX5") +  "'"
_cQuery1 += "    AND SX5Z2.D_E_L_E_T_ = ' '
_cQuery1 += "   LEFT JOIN " + RetSqlName("SX5") + " SX5TP ON TRIM(FAT.IDTIPOCLIENTE) = TRIM(SX5TP.X5_CHAVE)
_cQuery1 += "    AND SX5TP.X5_TABELA = 'TP'
_cQuery1 += "    AND SX5TP.X5_FILIAL = '" + xFilial("SX5") +  "'"
_cQuery1 += "    AND SX5TP.D_E_L_E_T_ = ' '
_cQuery1 += "  GROUP BY FAT.TIPO, FAT.IDCANAL, FAT.IDTIPOCLIENTE, SX5Z2.X5_DESCRI, SX5TP.X5_DESCRI
_cQuery1 += " HAVING NVL(SUM(FAT.LIQUIDO), 0) <> 0
_cQuery1 += "     OR DECODE(SUM(FAT.LIQUIDO_AA),0,0,ROUND(SUM(FAT.LIQUIDO)/SUM(FAT.LIQUIDO_AA)*100,2)) <> 0 
_cQuery1 += "     OR NVL(SUM(FAT.META), 0) <> 0
_cQuery1 += "  ORDER BY TIPO, IDCANAL, LIQUIDO_AA DESC, LIQUIDO DESC

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery1), _cAlias1, .F., .T.)
                                         
_cCanal   := (_cAlias1)->IDCANAL
_cCanalAnt:= (_cAlias1)->IDCANAL
_cTipo    := (_cAlias1)->TIPO
_cTipoAnt := (_cAlias1)->TIPO

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()
                               
	If _cCanal <> (_cAlias1)->IDCANAL
		_cTipoAnt  := _cTipo
		_cCanalAnt := _cCanal                   
		_cTipo     := (_cAlias1)->TIPO
		_cCanal    := (_cAlias1)->IDCANAL		
	EndIf
	
	If _cCanal <> (_cAlias1)->IDCANAL
		_cTipoAnt  := _cTipo
		_cTipo     := (_cAlias1)->TIPO
	EndIf

	xLiq001 := (_cAlias1)->LIQ_001 / 1000
	If (_cAlias1)->LIQ_AA_001 <> 0
		xPerc001 := ((_cAlias1)->LIQ_001 / (_cAlias1)->LIQ_AA_001) * 100
	Else
		xPerc001 := 0
	EndIf
		
	xLiq002 := (_cAlias1)->LIQ_002 / 1000
	If (_cAlias1)->LIQ_AA_002 <> 0
		xPerc002 := ((_cAlias1)->LIQ_002 / (_cAlias1)->LIQ_AA_002) * 100
	Else
		xPerc002 := 0
	EndIf
		
	xLiq005 := (_cAlias1)->LIQ_005 / 1000
	If (_cAlias1)->LIQ_AA_005 <> 0
		xPerc005 := ((_cAlias1)->LIQ_005 / (_cAlias1)->LIQ_AA_005) * 100
	Else
		xPerc005 := 0
	EndIf
		
	xLiq006 := (_cAlias1)->LIQ_006 / 1000
	If (_cAlias1)->LIQ_AA_006 <> 0
		xPerc006 := ((_cAlias1)->LIQ_006 / (_cAlias1)->LIQ_AA_006) * 100
	Else
		xPerc006 := 0
	EndIf
		
	xLiq007 := (_cAlias1)->LIQ_007 / 1000
	If (_cAlias1)->LIQ_AA_007 <> 0
		xPerc007 := ((_cAlias1)->LIQ_007 / (_cAlias1)->LIQ_AA_007) * 100
	Else
		xPerc007 := 0
	EndIf
		
	xLiq008 := (_cAlias1)->LIQ_008 / 1000
	If (_cAlias1)->LIQ_AA_008 <> 0
		xPerc008 := ((_cAlias1)->LIQ_008 / (_cAlias1)->LIQ_AA_008) * 100
	Else
		xPerc008 := 0
	EndIf

	xTotal := Round((_cAlias1)->LIQUIDO / 1000,0)
	If (_cAlias1)->LIQUIDO_AA <> 0
		xPercTot := ((_cAlias1)->LIQUIDO / (_cAlias1)->LIQUIDO_AA) * 100
	Else
		xPercTot := 0
	EndIf

	xMeta := Round((_cAlias1)->META / 1000,0)
	If (_cAlias1)->META <> 0
		xPercMeta := ((_cAlias1)->LIQUIDO) / (_cAlias1)->META * 100
	Else
		xPercMeta := 0
	EndIf

	If (_cAlias1)->TIPO = 'PA'
		xTipo := 'PRODUTO'
	ElseIf (_cAlias1)->TIPO = 'SV'
		xTipo := 'SERVIÇO'
	ElseIf (_cAlias1)->TIPO = 'ZZ'
		xTipo := 'META'
	EndIf

	_cTipoCli:= (_cAlias1)->IDTIPOCLIENTE

	oSection1:Init()  
	oSection1:SetHeaderSection(.T.)

	oSection1:Cell("TIPO"):SetValue(xTipo)
	oSection1:Cell("IDCANAL"):SetValue((_cAlias1)->IDCANAL)
	oSection1:Cell("A1_XCANALV"):SetValue((_cAlias1)->A1_XCANALV)
	oSection1:Cell("A1_XTIPCLI"):SetValue((_cAlias1)->A1_XTIPCLI)
	oSection1:Cell("LIQ_001"):SetValue(xLiq001)
	oSection1:Cell("PERC_001"):SetValue(xPerc001)
	oSection1:Cell("LIQ_002"):SetValue(xLiq002)
	oSection1:Cell("PERC_002"):SetValue(xPerc002)
	oSection1:Cell("LIQ_005"):SetValue(xLiq005)
	oSection1:Cell("PERC_005"):SetValue(xPerc005)
	oSection1:Cell("LIQ_006"):SetValue(xLiq006)
	oSection1:Cell("PERC_006"):SetValue(xPerc006)
	oSection1:Cell("LIQ_007"):SetValue(xLiq007)
	oSection1:Cell("PERC_007"):SetValue(xPerc007)
	oSection1:Cell("LIQ_008"):SetValue(xLiq008)
	oSection1:Cell("PERC_008"):SetValue(xPerc008)
	oSection1:Cell("TOTAL"):SetValue(xTotal)
	oSection1:Cell("PERC_TOT"):SetValue(xPercTot)
	oSection1:Cell("META"):SetValue(xMeta)
	oSection1:Cell("PERC_META"):SetValue(xPercMeta)
                 
	oSection1:Cell("IDCANAL"):Hide()
   
	oSection1:PrintLine()

	If ((_cCanal == '1    ') .or. (_cCanal == '2    ')) .and. (MV_PAR03 == 2)
		_cQuery2 := " SELECT DECODE(FAT.GRUPO,'      ',SA1.A1_CGC,NULL) CNPJ
		_cQuery2 += " , DECODE(FAT.GRUPO,'      ',SA1.A1_NOME,'GRUPO '||ACY.ACY_DESCRI) NOME
		_cQuery2 += " , SA3.A3_NOME VENDEDOR
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000001', FAT.LIQUIDO, 0)), 0)    AS LIQ_001
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000002', FAT.LIQUIDO, 0)), 0)    AS LIQ_002
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000005', FAT.LIQUIDO, 0)), 0)    AS LIQ_005
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000006', FAT.LIQUIDO, 0)), 0)    AS LIQ_006
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000007', FAT.LIQUIDO, 0)), 0)    AS LIQ_007
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000008', FAT.LIQUIDO, 0)), 0)    AS LIQ_008
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000001', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_001
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000002', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_002
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000005', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_005
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000006', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_006
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000007', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_007
		_cQuery2 += " , NVL(SUM(DECODE(FAT.AREA, '000008', FAT.LIQUIDO_AA, 0)), 0) AS LIQ_AA_008
		_cQuery2 += " , SUM(FAT.LIQUIDO) LIQUIDO
		_cQuery2 += " , SUM(FAT.LIQUIDO_AA) LIQUIDO_AA
		_cQuery2 += " , 0 META
		_cQuery2 += " FROM
		_cQuery2 += "   (SELECT CASE WHEN GRUPO <> '      ' THEN FIRST_VALUE(CLIENTE) OVER (PARTITION BY GRUPO ORDER BY LIQUIDO DESC) ELSE CLIENTE END CLIENTE
		_cQuery2 += "    , CASE WHEN GRUPO <> '      ' THEN FIRST_VALUE(LOJA) OVER (PARTITION BY GRUPO ORDER BY LIQUIDO DESC) ELSE LOJA END LOJA
		_cQuery2 += "    , GRUPO, AREA, LIQUIDO, LIQUIDO_AA
		_cQuery2 += "    FROM
		_cQuery2 += "      (SELECT CLIENTE, LOJA, GRUPO, AREA
		_cQuery2 += "       , SUM(LIQUIDO) LIQUIDO
		_cQuery2 += "       , SUM(LIQUIDO_AA) LIQUIDO_AA
		_cQuery2 += "       FROM 
		_cQuery2 += "         (SELECT SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, SA1.A1_GRPVEN GRUPO, SB5.B5_XAREA AREA
		_cQuery2 += "          , NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
		_cQuery2 += "          , 0 LIQUIDO_AA
		_cQuery2 += "          FROM GER_SD2 SD2
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB1") + " SB1
		_cQuery2 += "          ON SD2.D2_COD = SB1.B1_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB5") + " SB5
		_cQuery2 += "          ON SB1.B1_COD = SB5.B5_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SA1") + " SA1
		_cQuery2 += "          ON SD2.D2_CLIENTE = SA1.A1_COD
		_cQuery2 += "          AND SD2.D2_LOJA = SA1.A1_LOJA
		_cQuery2 += "          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
		_cQuery2 += "          AND SB1.B1_XIDTPPU NOT IN (' ','15')
		_cQuery2 += "          AND SB1.B1_TIPO    = '" + _cTipo + "'
		_cQuery2 += "          AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
		_cQuery2 += "          AND SB1.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
		_cQuery2 += "          AND SB5.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SA1.A1_XCANALV = '" + _cCanal + "'
		_cQuery2 += "          AND SA1.A1_XTIPCLI = '" + _cTipoCli + "'
		_cQuery2 += "          AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'
		_cQuery2 += "          AND SA1.D_E_L_E_T_ = ' '
		_cQuery2 += "          GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          UNION ALL
		_cQuery2 += "          SELECT SD1.D1_FORNECE, SD1.D1_LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          , NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1), 0
		_cQuery2 += "          FROM GER_SD1 SD1
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB1") + " SB1
		_cQuery2 += "          ON SD1.D1_COD = SB1.B1_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB5") + " SB5
		_cQuery2 += "          ON SB1.B1_COD = SB5.B5_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SA1") + " SA1
		_cQuery2 += "          ON SD1.D1_FORNECE = SA1.A1_COD
		_cQuery2 += "          AND SD1.D1_LOJA = SA1.A1_LOJA
		_cQuery2 += "          WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
		_cQuery2 += "          AND SB1.B1_XIDTPPU NOT IN (' ','15')
		_cQuery2 += "          AND SB1.B1_TIPO    = '" + _cTipo + "'
		_cQuery2 += "          AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
		_cQuery2 += "          AND SB1.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
		_cQuery2 += "          AND SB5.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SA1.A1_XCANALV = '" + _cCanal + "'
		_cQuery2 += "          AND SA1.A1_XTIPCLI = '" + _cTipoCli + "'
		_cQuery2 += "          AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'
		_cQuery2 += "          AND SA1.D_E_L_E_T_ = ' '
		_cQuery2 += "          GROUP BY SD1.D1_FORNECE, SD1.D1_LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          UNION ALL
		_cQuery2 += "          SELECT SD2.D2_CLIENTE, SD2.D2_LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          , 0, NVL(SUM(SD2.D2_VALBRUT), 0)
		_cQuery2 += "          FROM GER_SD2 SD2
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB1") + " SB1
		_cQuery2 += "          ON SD2.D2_COD = SB1.B1_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB5") + " SB5
		_cQuery2 += "          ON SB1.B1_COD = SB5.B5_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SA1") + " SA1
		_cQuery2 += "          ON SD2.D2_CLIENTE = SA1.A1_COD
		_cQuery2 += "          AND SD2.D2_LOJA = SA1.A1_LOJA
		_cQuery2 += "          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'
		_cQuery2 += "          AND SB1.B1_XIDTPPU NOT IN (' ','15')
		_cQuery2 += "          AND SB1.B1_TIPO    = '" + _cTipo + "'
		_cQuery2 += "          AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
		_cQuery2 += "          AND SB1.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
		_cQuery2 += "          AND SB5.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SA1.A1_XCANALV = '" + _cCanal + "'
		_cQuery2 += "          AND SA1.A1_XTIPCLI = '" + _cTipoCli + "'
		_cQuery2 += "          AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'
		_cQuery2 += "          AND SA1.D_E_L_E_T_ = ' '
		_cQuery2 += "          GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          UNION ALL
		_cQuery2 += "          SELECT SD1.D1_FORNECE, SD1.D1_LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          , 0, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
		_cQuery2 += "          FROM GER_SD1 SD1
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB1") + " SB1
		_cQuery2 += "          ON SD1.D1_COD = SB1.B1_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB5") + " SB5
		_cQuery2 += "          ON SB1.B1_COD = SB5.B5_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SA1") + " SA1
		_cQuery2 += "          ON SD1.D1_FORNECE = SA1.A1_COD
		_cQuery2 += "          AND SD1.D1_LOJA = SA1.A1_LOJA
		_cQuery2 += "          WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'
		_cQuery2 += "          AND SB1.B1_XIDTPPU NOT IN (' ','15')
		_cQuery2 += "          AND SB1.B1_TIPO    = '" + _cTipo + "'
		_cQuery2 += "          AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
		_cQuery2 += "          AND SB1.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
		_cQuery2 += "          AND SB5.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SA1.A1_XCANALV = '" + _cCanal + "'
		_cQuery2 += "          AND SA1.A1_XTIPCLI = '" + _cTipoCli + "'
		_cQuery2 += "          AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'
		_cQuery2 += "          AND SA1.D_E_L_E_T_ = ' '
		_cQuery2 += "          GROUP BY SD1.D1_FORNECE, SD1.D1_LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          UNION ALL
		_cQuery2 += "          SELECT MB.CLIENTE, MB.LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          , NVL(SUM(LIQUIDO), 0), 0
		_cQuery2 += "          FROM GER_MB MB
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB5") + " SB5
		_cQuery2 += "          ON MB.PRODUTO = SB5.B5_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SA1") + " SA1
		_cQuery2 += "          ON MB.CLIENTE = SA1.A1_COD
		_cQuery2 += "          AND MB.LOJA = SA1.A1_LOJA
		_cQuery2 += "          WHERE MB.EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
		_cQuery2 += "          AND MB.TIPO        = '" + _cTipo + "'
		_cQuery2 += "          AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
		_cQuery2 += "          AND SB5.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SA1.A1_XCANALV = '" + _cCanal + "'
		_cQuery2 += "          AND SA1.A1_XTIPCLI = '" + _cTipoCli + "'
		_cQuery2 += "          AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'
		_cQuery2 += "          AND SA1.D_E_L_E_T_ = ' '
		_cQuery2 += "          GROUP BY MB.CLIENTE, MB.LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          UNION ALL
		_cQuery2 += "          SELECT MB.CLIENTE, MB.LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA
		_cQuery2 += "          , 0, NVL(SUM(LIQUIDO), 0) 
		_cQuery2 += "          FROM GER_MB MB
		_cQuery2 += "          INNER JOIN " + RetSqlName("SB5") + " SB5
		_cQuery2 += "          ON MB.PRODUTO = SB5.B5_COD
		_cQuery2 += "          INNER JOIN " + RetSqlName("SA1") + " SA1
		_cQuery2 += "          ON MB.CLIENTE = SA1.A1_COD
		_cQuery2 += "          AND MB.LOJA = SA1.A1_LOJA
		_cQuery2 += "          WHERE MB.EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'
		_cQuery2 += "          AND MB.TIPO        = '" + _cTipo + "'
		_cQuery2 += "          AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
		_cQuery2 += "          AND SB5.D_E_L_E_T_ = ' '
		_cQuery2 += "          AND SA1.A1_XCANALV = '" + _cCanal + "'
		_cQuery2 += "          AND SA1.A1_XTIPCLI = '" + _cTipoCli + "'
		_cQuery2 += "          AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'
		_cQuery2 += "          AND SA1.D_E_L_E_T_ = ' '
		_cQuery2 += "          GROUP BY MB.CLIENTE, MB.LOJA, SA1.A1_GRPVEN, SB5.B5_XAREA)
		_cQuery2 += "        GROUP BY CLIENTE, LOJA, GRUPO, AREA)
		_cQuery2 += "   ) FAT
		_cQuery2 += " LEFT JOIN " + RetSqlName("SA1") + " SA1
		_cQuery2 += " ON FAT.CLIENTE     = SA1.A1_COD
		_cQuery2 += " AND FAT.LOJA       = SA1.A1_LOJA
		_cQuery2 += " AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'
		_cQuery2 += " AND SA1.D_E_L_E_T_ = ' '
		_cQuery2 += " LEFT JOIN " + RetSqlName("ACY") + " ACY
		_cQuery2 += " ON SA1.A1_GRPVEN   = ACY.ACY_GRPVEN
		_cQuery2 += " AND ACY.ACY_FILIAL = '" + xFilial("ACY") + "'
		_cQuery2 += " AND ACY.D_E_L_E_T_ = ' '
		_cQuery2 += " LEFT JOIN " + RetSqlName("SA3") + " SA3
		_cQuery2 += " ON SA1.A1_VEND     = SA3.A3_COD
		_cQuery2 += " AND SA3.A3_FILIAL  = '" + xFilial("SA3") + "'
		_cQuery2 += " AND SA3.D_E_L_E_T_ = ' '
		_cQuery2 += " HAVING SUM(FAT.LIQUIDO) >= 500 OR SUM(FAT.LIQUIDO) <= -500
		_cQuery2 += " OR DECODE(SUM(FAT.LIQUIDO_AA),0,0,SUM(FAT.LIQUIDO)/SUM(FAT.LIQUIDO_AA)*100) <> 0
		_cQuery2 += " GROUP BY DECODE(FAT.GRUPO,'      ',SA1.A1_CGC,NULL)
		_cQuery2 += " , DECODE(FAT.GRUPO,'      ',SA1.A1_NOME,'GRUPO '||ACY.ACY_DESCRI), SA3.A3_NOME
		_cQuery2 += " ORDER BY LIQUIDO DESC, LIQUIDO_AA DESC

		If Select(_cAlias2) > 0
			dbSelectArea(_cAlias2)
			dbCloseArea()
		EndIf
		
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery2), _cAlias2, .F., .T.)
		                                         
		Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()
			oReport:IncMeter()
		                               
			xLiq001 := (_cAlias2)->LIQ_001 / 1000
			If (_cAlias2)->LIQ_AA_001 <> 0
				xPerc001 := ((_cAlias2)->LIQ_001 / (_cAlias2)->LIQ_AA_001) * 100
			Else
				xPerc001 := 0
			EndIf
				
			xLiq002 := (_cAlias2)->LIQ_002 / 1000
			If (_cAlias2)->LIQ_AA_002 <> 0
				xPerc002 := ((_cAlias2)->LIQ_002 / (_cAlias2)->LIQ_AA_002) * 100
			Else
				xPerc002 := 0
			EndIf
				
			xLiq005 := (_cAlias2)->LIQ_005 / 1000
			If (_cAlias2)->LIQ_AA_005 <> 0
				xPerc005 := ((_cAlias2)->LIQ_005 / (_cAlias2)->LIQ_AA_005) * 100
			Else
				xPerc005 := 0
			EndIf
				
			xLiq006 := (_cAlias2)->LIQ_006 / 1000
			If (_cAlias2)->LIQ_AA_006 <> 0
				xPerc006 := ((_cAlias2)->LIQ_006 / (_cAlias2)->LIQ_AA_006) * 100
			Else
				xPerc006 := 0
			EndIf
				
			xLiq007 := (_cAlias2)->LIQ_007 / 1000
			If (_cAlias2)->LIQ_AA_007 <> 0
				xPerc007 := ((_cAlias2)->LIQ_007 / (_cAlias2)->LIQ_AA_007) * 100
			Else
				xPerc007 := 0
			EndIf
				
			xLiq008 := (_cAlias2)->LIQ_008 / 1000
			If (_cAlias2)->LIQ_AA_008 <> 0
				xPerc008 := ((_cAlias2)->LIQ_008 / (_cAlias2)->LIQ_AA_008) * 100
			Else
				xPerc008 := 0
			EndIf
		
			xTotal := Round((_cAlias2)->LIQUIDO / 1000,0)
			If (_cAlias2)->LIQUIDO_AA <> 0
				xPercTot := ((_cAlias2)->LIQUIDO / (_cAlias2)->LIQUIDO_AA) * 100
			Else
				xPercTot := 0
			EndIf
		
			xMeta := Round((_cAlias2)->META / 1000,0)
			If (_cAlias2)->META <> 0
				xPercMeta := ((_cAlias2)->LIQUIDO) / (_cAlias2)->META * 100
			Else
				xPercMeta := 0
			EndIf
		
			oSection2:Init()  
			oSection2:SetHeaderSection(.T.)
		
			oSection2:Cell("CNPJ"):SetValue((_cAlias2)->CNPJ)
			oSection2:Cell("NOME"):SetValue((_cAlias2)->NOME)
			oSection2:Cell("VENDEDOR"):SetValue((_cAlias2)->VENDEDOR)
			oSection2:Cell("LIQ_001"):SetValue(xLiq001)
			oSection2:Cell("PERC_001"):SetValue(xPerc001)
			oSection2:Cell("LIQ_002"):SetValue(xLiq002)
			oSection2:Cell("PERC_002"):SetValue(xPerc002)
			oSection2:Cell("LIQ_005"):SetValue(xLiq005)
			oSection2:Cell("PERC_005"):SetValue(xPerc005)
			oSection2:Cell("LIQ_006"):SetValue(xLiq006)
			oSection2:Cell("PERC_006"):SetValue(xPerc006)
			oSection2:Cell("LIQ_007"):SetValue(xLiq007)
			oSection2:Cell("PERC_007"):SetValue(xPerc007)
			oSection2:Cell("LIQ_008"):SetValue(xLiq008)
			oSection2:Cell("PERC_008"):SetValue(xPerc008)
			oSection2:Cell("TOTAL"):SetValue(xTotal)
			oSection2:Cell("PERC_TOT"):SetValue(xPercTot)
			oSection2:Cell("META"):SetValue(xMeta)
			oSection2:Cell("PERC_META"):SetValue(xPercMeta)
		                
	   		oSection2:PrintLine()
	   		
			(_cAlias2)->(dbSkip())
		EndDo	   		
	 
	 	oSection2:Finish()
         
		DbSelectArea(_cAlias2)
		DbCloseArea()
	EndIf	
	
	(_cAlias1)->(dbSkip())		

	If (_cAlias1)->(eof())
		_cTipoAnt  := _cTipo
		_cCanalAnt := _cCanal
	EndIf

	If (MV_PAR03 == 2)
		oSection1:Finish()
	EndIf	
EndDo

If (MV_PAR03 == 2)
	oSection2:Finish()
EndIf	
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

_cQuery1 := " SELECT 'ZZ' AS TIPO, '99   ' AS IDCANAL, ' ' IDTIPOCLIENTE, ' ' AS A1_XCANALV, ' ' AS A1_XTIPCLI,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000001',M.META,0)),0) AS LIQ_001,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000002',M.META,0)),0) AS LIQ_002,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000005',M.META,0)),0) AS LIQ_005,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000006',M.META,0)),0) AS LIQ_006,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000007',M.META,0)),0) AS LIQ_007,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000008',M.META,0)),0) AS LIQ_008,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000001',F.LIQUIDO,0)),0) AS LIQ_AA_001,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000002',F.LIQUIDO,0)),0) AS LIQ_AA_002,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000005',F.LIQUIDO,0)),0) AS LIQ_AA_005,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000006',F.LIQUIDO,0)),0) AS LIQ_AA_006,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000007',F.LIQUIDO,0)),0) AS LIQ_AA_007,
_cQuery1 += "        NVL(SUM(DECODE(F.AREA,'000008',F.LIQUIDO,0)),0) AS LIQ_AA_008,
_cQuery1 += "        NVL(SUM(M.META),0) LIQUIDO, NVL(SUM(F.LIQUIDO),0) LIQUIDO_AA, NULL META, NULL PERC_META
_cQuery1 += "   FROM (SELECT AREA, SUM(LIQUIDO) LIQUIDO
_cQuery1 += "           FROM (SELECT NVL(SB5.B5_XAREA, '      ') AREA, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery1 += "                   FROM GER_SD2 SD2 
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                  WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'" 
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' ' 
_cQuery1 += "                    AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'" 
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY NVL(SB5.B5_XAREA, '      ')
_cQuery1 += "                  UNION ALL
_cQuery1 += "                 SELECT NVL(SB5.B5_XAREA, '      '), NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery1 += "                   FROM GER_SD1 SD1
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery1 += "                  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery1 += "                    AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery1 += "                    AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'" 
_cQuery1 += "                    AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "                    AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'" 
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY NVL(SB5.B5_XAREA, '      ')
_cQuery1 += "                  UNION ALL
_cQuery1 += "                 SELECT NVL(SB5.B5_XAREA, '      '), NVL(SUM(MB.LIQUIDO), 0)
_cQuery1 += "                   FROM GER_MB MB
_cQuery1 += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON MB.PRODUTO = SB5.B5_COD
_cQuery1 += "                  WHERE MB.EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery1 += "                    AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'" 
_cQuery1 += "                    AND SB5.D_E_L_E_T_ = ' ' 
_cQuery1 += "                  GROUP BY NVL(SB5.B5_XAREA, '      '))
_cQuery1 += "          GROUP BY AREA) F
_cQuery1 += "   LEFT JOIN (SELECT M.IDAREACRM AREA, NVL(SUM(M.VALOR), 0) META
_cQuery1 += "   FROM GER_TB002_META_TIPOCLIENTE M
_cQuery1 += "  WHERE TO_CHAR(M.DATA, 'YYYYMMDD') BETWEEN '" + _cParm5 + "' AND '" + _cParm6 + "'"
_cQuery1 += "  GROUP BY M.IDAREACRM) M
_cQuery1 += "     ON TO_NUMBER(TRIM(F.AREA)) = M.AREA

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery1), _cAlias3, .F., .T.)

oSection3:Init()

Do While !(_cAlias3)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	xLiq001 := (_cAlias3)->LIQ_001 / 1000
	If (_cAlias3)->LIQ_001 <> 0
		xPerc001 := ((_cAlias3)->LIQ_AA_001 / (_cAlias3)->LIQ_001) * 100
	Else
		xPerc001 := 0
	EndIf
		
	xLiq002 := (_cAlias3)->LIQ_002 / 1000
	If (_cAlias3)->LIQ_002 <> 0
		xPerc002 := ((_cAlias3)->LIQ_AA_002 / (_cAlias3)->LIQ_002) * 100
	Else
		xPerc002 := 0
	EndIf
		
	xLiq005 := (_cAlias3)->LIQ_005 / 1000
	If (_cAlias3)->LIQ_005 <> 0
		xPerc005 := ((_cAlias3)->LIQ_AA_005 / (_cAlias3)->LIQ_005) * 100
	Else
		xPerc005 := 0
	EndIf
		
	xLiq006 := (_cAlias3)->LIQ_006 / 1000
	If (_cAlias3)->LIQ_006 <> 0
		xPerc006 := ((_cAlias3)->LIQ_AA_006 / (_cAlias3)->LIQ_006) * 100
	Else
		xPerc006 := 0
	EndIf
		
	xLiq007 := (_cAlias3)->LIQ_007 / 1000
	If (_cAlias3)->LIQ_007 <> 0
		xPerc007 := ((_cAlias3)->LIQ_AA_007 / (_cAlias3)->LIQ_007) * 100
	Else
		xPerc007 := 0
	EndIf
		
	xLiq008 := (_cAlias3)->LIQ_008 / 1000
	If (_cAlias3)->LIQ_008 <> 0
		xPerc008 := ((_cAlias3)->LIQ_AA_008 / (_cAlias3)->LIQ_008) * 100
	Else
		xPerc008 := 0
	EndIf

	xTotal := Round((_cAlias3)->LIQUIDO / 1000,0)
	If (_cAlias3)->LIQUIDO <> 0
		xPercTot := ((_cAlias3)->LIQUIDO_AA / (_cAlias3)->LIQUIDO) * 100
	Else
		xPercTot := 0
	EndIf

	xTipo := 'META'

	oSection3:Init()  
	oSection3:SetHeaderSection(.T.)

	oSection3:Cell("TIPO"):SetValue(xTipo)
	oSection3:Cell("IDCANAL"):SetValue((_cAlias3)->IDCANAL)
	oSection3:Cell("A1_XCANALV"):SetValue((_cAlias3)->A1_XCANALV)
	oSection3:Cell("A1_XTIPCLI"):SetValue((_cAlias3)->A1_XTIPCLI)
	oSection3:Cell("LIQ_001"):SetValue(xLiq001)
	oSection3:Cell("PERC_001"):SetValue(xPerc001)
	oSection3:Cell("LIQ_002"):SetValue(xLiq002)
	oSection3:Cell("PERC_002"):SetValue(xPerc002)
	oSection3:Cell("LIQ_005"):SetValue(xLiq005)
	oSection3:Cell("PERC_005"):SetValue(xPerc005)
	oSection3:Cell("LIQ_006"):SetValue(xLiq006)
	oSection3:Cell("PERC_006"):SetValue(xPerc006)
	oSection3:Cell("LIQ_007"):SetValue(xLiq007)
	oSection3:Cell("PERC_007"):SetValue(xPerc007)
	oSection3:Cell("LIQ_008"):SetValue(xLiq008)
	oSection3:Cell("PERC_008"):SetValue(xPerc008)
	oSection3:Cell("TOTAL"):SetValue(xTotal)
	oSection3:Cell("PERC_TOT"):SetValue(xPercTot)
	oSection3:Cell("META"):SetValue((_cAlias3)->META)
	oSection3:Cell("PERC_META"):SetValue((_cAlias3)->PERC_META)
                 
	oSection3:Cell("IDCANAL"):Hide()
   
	oSection3:PrintLine()

	(_cAlias3)->(dbSkip())		
EndDo
         
DbSelectArea(_cAlias3)
DbCloseArea()

Return(.t.)

/**********************************************************************************************************************/
Static Function CalcPerc(_xTipo,_xCanal,_xArea)
/**********************************************************************************************************************/
_nPos := ascan(_aPerc,{|x| x[1]==_xTipo .and. x[2]==_xCanal .and. x[3]==_xArea})

If _nPos <> 0
	xPerc := _aPerc[_nPos,6]	
Else
	xPerc := 0
Endif

If _cTipoAnt <> _cTipo .and. (_cAlias1)->(eof()) .and. _xArea = 'META'
	_cTipoAnt := 'TOTAL'
EndIf

If _cTipoAnt == _cTipo .and. _cCanalAnt == _cCanal .and. (_cAlias1)->(eof()) .and. _xArea = 'META'
	_cTipo := _cCanalAnt := _cCanal := 'TOTAL'
Endif

Return xPerc
