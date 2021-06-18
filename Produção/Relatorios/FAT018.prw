#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FAT018    ºAutor  ³Bruno Parreira      º Data ³  08/06/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Comissao B2B                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Faturamento                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FAT018()

Local oReport
Local cPerg := "FAT018"

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
Private cParceiro := ""

//Declaracao do relatorio
oReport := TReport():New("FAT018","Relatório Comissão B2B",cPerg,{|oReport| PrintReport(oReport)},"Comissão B2B",.T.,,,,,.T.)

oReport:NDEVICE := 4

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.
oReport:lDisableOrientation := .T.

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Comissao B2B","",,,,,,,,.F.)
	
//Celulas da secao
TRCell():New(oSection1,"A2_COD"		,"SA2","Fornecedor") 
TRCell():New(oSection1,"A2_LOJA"	,"SA2","Loja") 
TRCell():New(oSection1,"A2_NOME"	,"SA2","Nome") 
TRCell():New(oSection1,"A2_CGC"		,"SA2","CNPJ") 
TRCell():New(oSection1,"DATA_DE"	,"","Data De",,10) 
TRCell():New(oSection1,"DATA_ATE"	,"","Data Ate",,10) 

//Secao do relatorio
oSection2 := TRSection():New(oSection1,"Parceiro","")//,,,,,,.T.,.T.,.T.)

TRCell():New(oSection2,"SPACE1"			,"","",,2)
TRCell():New(oSection2,"ZZG_PEDWEB"		,"ZZG",,,10)
TRCell():New(oSection2,"D2_DOC"			,"SD2",,,10)
TRCell():New(oSection2,"D2_SERIE"		,"SD2",,,10)
TRCell():New(oSection2,"D2_EMISSAO"		,"SD2",,,10)
TRCell():New(oSection2,"VLR_NOTA"		,"SD2","Vlr.Total","@E 999,999,999.99",20)
TRCell():New(oSection2,"TIPO_PARC"   	,""   ,"Tipo Parceria",,3)  // C=CUPOM / P=PARCERIA
TRCell():New(oSection2,"ZZG_COMIS"		,"ZZG","% Comissao","@E 99.99",10)
TRCell():New(oSection2,"VLR_COMIS"		,""   ,"Vlr.Comissao","@E 999,999,999.99",20)
TRCell():New(oSection2,"VEND_DEV"		,""   ,"Venda/Dev.",,3) // V=Venda / D=DEVOLUCAO

//Quebra de Total (SubTotal)
oBreak1 := TRBreak():New(oSection1,oSection1:Cell("A2_CGC"),"Parceiro",,,.T.)
oBreak2 := TRBreak():New(oSection2,oSection2:Cell("TIPO_PARC"),"Subtotal")

//Totalizadores
TRFunction():New(oSection2:Cell("VLR_NOTA")		,NIL,"SUM",oBreak2)
TRFunction():New(oSection2:Cell("VLR_COMIS")	,NIL,"SUM",oBreak2)

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)
oReport:SetTotalPageBreak(.F.)

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
Local oSection2 := oReport:Section(1):Section(1)
Local oBreak1 := oSection2:aBreak[1]
Local cQuery := ""
Local cTipo  := ""
Local cForn  := ""

oReport:SetLandScape()

cQuery += "select  A2_COD,A2_LOJA,A2_NOME,A2_CGC, "+CRLF
cQuery += "		D2_DOC,D2_SERIE,D2_EMISSAO, "+CRLF
cQuery += "		ZZG_PEDWEB,ZZG_COMIS,ZZD_LIQBRU, "+CRLF
cQuery += "		SUM(D2_TOTAL) VALBRU, "+CRLF
cQuery += "		SUM(D2_TOTAL-D2_VALISS) VALLIQ, "+CRLF
cQuery += "		(SUM(D2_TOTAL)*(ZZG_COMIS/100)) COMIS_BRU, "+CRLF
cQuery += "		(SUM(D2_TOTAL-D2_VALISS)*(ZZG_COMIS/100)) COMIS_LIQ, "+CRLF
cQuery += "		DECODE(ZZG_COMIS,ZZD_COMCUP,'C',ZZD_COMPAR,'P',' ') TIPO_PARC, "+CRLF
cQuery += "     'V' VEND_DEV "+CRLF
cQuery += "from "+RetSqlName("SD2")+" SD2 "+CRLF
cQuery += "inner join "+RetSqlName("ZZG")+" ZZG "+CRLF
cQuery += "on ZZG_NOTA = D2_DOC "+CRLF
cQuery += "and ZZG_SERIE = D2_SERIE "+CRLF
cQuery += "and ZZG_FILIAL = D2_FILIAL "+CRLF
cQuery += "and ZZG_FORNEC between '"+MV_PAR03+"' and '"+MV_PAR04+"' "+CRLF
cQuery += "and ZZG.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "and ZZG_TIPO = 'V' "+CRLF
cQuery += "inner join "+RetSqlName("ZZD")+" ZZD "+CRLF
cQuery += "on ZZD_FORNEC = ZZG_FORNEC "+CRLF
cQuery += "and ZZD_LOJA = ZZG_LOJA "+CRLF
cQuery += "and ZZD.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "left join "+RetSqlName("SA2")+" SA2 "+CRLF
cQuery += "on A2_COD = ZZD_FORNEC "+CRLF
cQuery += "and A2_LOJA = ZZD_LOJA "+CRLF
cQuery += "and SA2.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "where D2_FILIAL IN ('1022','1001') "+CRLF
cQuery += "and D2_EMISSAO between '"+DtoS(MV_PAR01)+"' and '"+DtoS(MV_PAR02)+"' "+CRLF
cQuery += "and SD2.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "group by A2_COD,A2_LOJA,A2_NOME,A2_CGC,D2_DOC,D2_SERIE,D2_EMISSAO,ZZG_PEDWEB,ZZG_COMIS,ZZD_LIQBRU,ZZD_COMCUP,ZZD_COMPAR "+CRLF
cQuery += "UNION ALL "+CRLF
cQuery += "select  A2_COD,A2_LOJA,A2_NOME,A2_CGC, "+CRLF
cQuery += "		D1_DOC D2_DOC,D1_SERIE D2_SERIE,D1_EMISSAO D2_EMISSAO, "+CRLF
cQuery += "		ZZG_PEDWEB,ZZG_COMIS,ZZD_LIQBRU, "+CRLF
cQuery += "		SUM(D1_TOTAL)*-1 VALBRU, "+CRLF
cQuery += "		SUM(D1_TOTAL-D1_VALISS)*-1 VALLIQ, "+CRLF
cQuery += "		((SUM(D1_TOTAL)*(ZZG_COMIS/100)))*-1 COMIS_BRU, "+CRLF
cQuery += "		((SUM(D1_TOTAL-D1_VALISS)*(ZZG_COMIS/100)))*-1 COMIS_LIQ, "+CRLF
cQuery += "		DECODE(ZZG_COMIS,ZZD_COMCUP,'C',ZZD_COMPAR,'P',' ') TIPO_PARC, "+CRLF
cQuery += "     'D' VEND_DEV "+CRLF
cQuery += "from "+RetSqlName("SD1")+" SD1 "+CRLF
cQuery += "inner join "+RetSqlName("ZZG")+" ZZG "+CRLF
cQuery += "on ZZG_NOTA = D1_DOC "+CRLF
cQuery += "and ZZG_SERIE = D1_SERIE "+CRLF
cQuery += "and ZZG_FILIAL = D1_FILIAL "+CRLF
cQuery += "and ZZG_FORNEC between '"+MV_PAR03+"' and '"+MV_PAR04+"' "+CRLF
cQuery += "and ZZG.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "and ZZG_TIPO = 'D' "+CRLF
cQuery += "inner join "+RetSqlName("ZZD")+" ZZD "+CRLF
cQuery += "on ZZD_FORNEC = ZZG_FORNEC "+CRLF
cQuery += "and ZZD_LOJA = ZZG_LOJA "+CRLF
cQuery += "and ZZD.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "left join "+RetSqlName("SA2")+" SA2 "+CRLF
cQuery += "on A2_COD = ZZD_FORNEC "+CRLF
cQuery += "and A2_LOJA = ZZD_LOJA "+CRLF
cQuery += "and SA2.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "where D1_FILIAL IN ('1022','1001') "+CRLF
cQuery += "and D1_DTDIGIT between '"+DtoS(MV_PAR01)+"' and '"+DtoS(MV_PAR02)+"' "+CRLF
cQuery += "and SD1.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "group by A2_COD,A2_LOJA,A2_NOME,A2_CGC,D1_DOC,D1_SERIE,D1_EMISSAO,ZZG_PEDWEB,ZZG_COMIS,ZZD_LIQBRU,ZZD_COMCUP,ZZD_COMPAR "+CRLF
cQuery += "order by A2_COD,A2_LOJA,VEND_DEV DESC,TIPO_PARC "+CRLF

Memowrite("FAT018.sql",cQuery)

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),"TRB", .F., .T.)

If TRB->(!EOF())
	While TRB->(!EOF()) .And. !oReport:Cancel()
		cTipo := TRB->TIPO_PARC
		cForn := TRB->A2_COD+TRB->A2_LOJA
		cParceiro := TRB->A2_NOME

		oReport:IncMeter()
	    oSection1:Init(.T.)

		oSection1:Cell("A2_COD"):SetValue(TRB->A2_COD)
		oSection1:Cell("A2_LOJA"):SetValue(TRB->A2_LOJA)
		oSection1:Cell("A2_NOME"):SetValue(TRB->A2_NOME)
		oSection1:Cell("A2_CGC"):SetValue(TRB->A2_CGC)
		oSection1:Cell("DATA_DE"):SetValue(DtoC(MV_PAR01))
		oSection1:Cell("DATA_ATE"):SetValue(DtoC(MV_PAR02))
		
		oSection1:PrintLine()
		
	    While !TRB->(EOF()) .And. cForn = TRB->A2_COD+TRB->A2_LOJA .And. !oReport:Cancel() 
		
			oSection2:Init()
			oSection2:SetHeaderSection(.T.)

			oSection2:Cell("ZZG_PEDWEB"):SetValue(TRB->ZZG_PEDWEB)
			oSection2:Cell("D2_DOC"):SetValue(TRB->D2_DOC)
			oSection2:Cell("D2_SERIE"):SetValue(TRB->D2_SERIE)
			oSection2:Cell("D2_EMISSAO"):SetValue(DtoC(StoD(TRB->D2_EMISSAO)))
			oSection2:Cell("TIPO_PARC"):SetValue(If(TRB->TIPO_PARC="C","LINK","PARCERIA"))
			oSection2:Cell("ZZG_COMIS"):SetValue(TRB->ZZG_COMIS)
			oSection2:Cell("VEND_DEV"):SetValue(TRB->VEND_DEV)
			
			If TRB->ZZD_LIQBRU == "B"
				oSection2:Cell("VLR_NOTA"):SetValue(TRB->VALBRU)
				oSection2:Cell("VLR_COMIS"):SetValue(TRB->COMIS_BRU)
			Else
				oSection2:Cell("VLR_NOTA"):SetValue(TRB->VALLIQ)
				oSection2:Cell("VLR_COMIS"):SetValue(TRB->COMIS_LIQ)
			EndIf

			oSection2:PrintLine()

			If TRB->VEND_DEV == "D"
				oBreak1:SetTitle("Subtotal Devoluções")
			Else
				If TRB->TIPO_PARC == "C"
					oBreak1:SetTitle("Subtotal Vendas CUPOM")
				Else
					oBreak1:SetTitle("Subtotal Vendas Parceria")
				EndIf
			EndIf
		
			TRB->(DbSkip())		
		EndDo 
		
		oSection2:Finish()
	EndDo
	oSection1:Finish()

	DbSelectArea("TRB")
EndIf

TRB->(DbCloseArea())

Return(.T.)