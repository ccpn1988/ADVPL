#include "protheus.ch"
#include "topconn.ch"
#Include "Report.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENR065  บ Autor ณ Cleuto Lima        บ Data ณ  10/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de listagem de nota fiscais para expedi็ใo       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENR065()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea	  		:= GetArea()
Local cPerg	  		:= "GENR065"
Private lQuebra		:= .T.
Private cQryAlias	:= GetNextAlias()

//AjustaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return nil
EndIF

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Restarea(aArea)

Return nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENR065  บ Autor ณ Cleuto Lima        บ Data ณ  10/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de listagem de nota fiscais para expedi็ใo       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef(cPerg)

Local cTitulo	:= "Lista de nota fiscais para expedi็ใo"
Local cAliTmp	:= GetNextalias()
Local oReport	:= Nil
Local oSection1	:= Nil

Local aOrdem	:= {}

//Declaracao do relatorio
oReport := TReport():New("GENR065",cTitulo	,cPerg		,{|oReport| PrintReport(oReport)}, cTitulo) 
oReport:PrintHeader(.F.,.F.)

//Secao do relatorio
oSection1 := TRSection():New(oReport, cTitulo,{cQryAlias, "NAOUSADO", "NAOUSADO"},aOrdem)

//Celulas da secao
TRCell():New(oSection1,"D04_NR_PEDIDO" 			, cQryAlias, "PEDIDO"		,"999999",6)
TRCell():New(oSection1,"D04_NR_NOTA_FISCAL"		, cQryAlias, "NOTA FISCAL"	,"999999999",9)
TRCell():New(oSection1,"D04_DT_NOTA_FISCAL"		, cQryAlias, "DATA"		  	,,)
TRCell():New(oSection1,"D04_TX_EMPRESA"			, cQryAlias, "EMPRESA"		,,)
TRCell():New(oSection1,"E04_TX_CLIENTE"			, cQryAlias, "CLIENTE"		,,)
TRCell():New(oSection1,"E04_TX_RUA"				, cQryAlias, "ENDERECO"		,,)
TRCell():New(oSection1,"E04_TX_BAIRRO"			, cQryAlias, "BAIRRO"		,,)
TRCell():New(oSection1,"E04_TX_CEP"				, cQryAlias, "CEP"			,,)
TRCell():New(oSection1,"E04_TX_UF" 				, cQryAlias, "UF"			,,)
TRCell():New(oSection1,"E04_TX_PAIS"			, cQryAlias, "PAIS"			,,)
TRCell():New(oSection1,"E04_VL_PESO_BRUTO"		, cQryAlias, "PESOBRUTO"	,,)
TRCell():New(oSection1,"IDNOTAFISCAL"  			, cQryAlias, "IDNOTAFISCAL"	,"999999999",10) 

//Faz a impressao do totalizador em linha
oSection1:SetHeaderPage(.F.)
//oSection1:SetLeftMargin(2)
//oSection1:lPrintHeader := .F.

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENR064  บ Autor ณ Renato Calabro'    บ Data ณ  06/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de listagem de pre-notas nao classificadas       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local nQtdReg	:= 0
Local cQuery	:= ""

cQuery := " SELECT " + CRLF
/*IDPEDIDO;NFFORMULARIO;DATA;EMPRESA;CLIENTE;ENDERECO;BAIRRO;CIDADE;CEP;UF;PAIS;PESOBRUTO*/
cQuery += " D04.D04_NR_PEDIDO AS PEDIDO, " + CRLF
cQuery += ' D04.D04_NR_NOTA_FISCAL AS "NOTA_FISCAL", ' + CRLF
cQuery += " D04.D04_DT_NOTA_FISCAL AS DATA, " + CRLF
cQuery += " D04.D04_TX_EMPRESA AS EMPRESA, " + CRLF
cQuery += " ENTRADA.E04_TX_CLIENTE AS CLIENTE, " + CRLF
cQuery += " ENTRADA.E04_TX_RUA AS ENDERECO, " + CRLF
cQuery += " ENTRADA.E04_TX_BAIRRO AS BAIRRO, " + CRLF
cQuery += " ENTRADA.E04_TX_CEP AS CEP, " + CRLF
cQuery += " ENTRADA.E04_TX_UF AS UF, " + CRLF
cQuery += " ENTRADA.E04_TX_PAIS AS PAIS, " + CRLF
cQuery += " ENTRADA.E04_VL_PESO_BRUTO AS PESOBRUTO, " + CRLF
cQuery += " SF2.R_E_C_N_O_ IDNOTAFISCAL " + CRLF
//ENTRADA.E04_TX_TRANSPORTADORA
cQuery += " FROM GUA_PEDIDOS.DPS_D04_ROMANEIO D04 " + CRLF
cQuery += " JOIN DPS_E04_SAIDA ENTRADA " + CRLF
cQuery += " ON ENTRADA.E04_ID_PEDIDO = D04.D04_ID_PEDIDO " + CRLF
cQuery += " JOIN TOTVS.SF2000 SF2 " + CRLF
cQuery += " ON F2_FILIAL = '1022' " + CRLF
cQuery += " AND F2_SERIE IN ('0','10') " + CRLF
cQuery += " AND TO_NUMBER(F2_DOC) = D04.D04_NR_NOTA_FISCAL " + CRLF
cQuery += " AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' " + CRLF
cQuery += " AND SF2.D_E_L_E_T_ <> '*' " + CRLF
//cQuery += " --AND SF2.F2_XCRASTR <> ' ' " + CRLF
cQuery += " WHERE D04.D04_NR_NOTA_FISCAL > 0 " + CRLF
cQuery += " AND TRIM(F2_XCRASTR) IS NULL " + CRLF 
cQuery += " AND ENTRADA.E04_TX_TRANSPORTADORA LIKE '%CORREIO%' " + CRLF 

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cQryAlias, .F., .T.)
(cQryAlias)->(dbGoTop())

nQtdReg	:= Contar(cQryAlias, "!EOF()")
oReport:SetMeter(nQtdReg)

(cQryAlias)->(dbGoTop())

While !(cQryAlias)->(Eof())

	If oReport:Cancel()
		Return nil
	EndIF
	
	oReport:IncMeter()
	oSection1:Init()  
	
	oSection1:Cell("D04_NR_PEDIDO"		):SetValue(	(cQryAlias)->PEDIDO			)
	oSection1:Cell("D04_NR_NOTA_FISCAL"	):SetValue(	(cQryAlias)->NOTA_FISCAL	)
	oSection1:Cell("D04_DT_NOTA_FISCAL"	):SetValue(	(cQryAlias)->DATA			)
	oSection1:Cell("D04_TX_EMPRESA"  	):SetValue(	(cQryAlias)->EMPRESA		)
	oSection1:Cell("E04_TX_CLIENTE"  	):SetValue(	(cQryAlias)->CLIENTE		)
	oSection1:Cell("E04_TX_RUA"    		):SetValue(	(cQryAlias)->ENDERECO		)
	oSection1:Cell("E04_TX_BAIRRO"  	):SetValue(	(cQryAlias)->BAIRRO			)
	oSection1:Cell("E04_TX_CEP"   		):SetValue(	(cQryAlias)->CEP			)
	oSection1:Cell("E04_TX_UF"    		):SetValue(	(cQryAlias)->UF				)
	oSection1:Cell("E04_TX_PAIS"  		):SetValue(	(cQryAlias)->PAIS			)
	oSection1:Cell("E04_VL_PESO_BRUTO"	):SetValue(	(cQryAlias)->PESOBRUTO		)
	oSection1:Cell("IDNOTAFISCAL"		):SetValue(	(cQryAlias)->IDNOTAFISCAL	)

	oSection1:PrintLine()

	(cQryAlias)->(dbSkip())
	
EndDo

(cQryAlias)->(DbCloseArea())

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENR064  บ Autor ณ Renato Calabro'    บ Data ณ  06/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de listagem de pre-notas nao classificadas       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aHelp		:= Array(3) 
Local cTamSX1	:= Len(SX1->X1_GRUPO)
Local cPesPerg	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define os tํtulos e Help das perguntas                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHelp[1] := {"Informe a data inicial de emissao das notas fiscais ",""           ,"Se nใo for preenchido, considera todos" }
aHelp[2] := {""}
aHelp[3] := {""}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava as perguntas no arquivo SX1                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//		cGrupo cOrde cDesPor			cDesSpa				  	cDesEng				     cVar	   cTipo cTamanho					cDecimal	nPreSel	cGSC	cValid                            cF3 		cGrpSXG	cPyme cVar01	cDef1Por	cDef1Spa	cDef1Eng cCnt01	cDef2Por	cDef2Spa	cDef2Eng		cDef3Por		cDef3Spa			cDef3Eng	cDef4Por			cDef4Spa			cDef4Eng			cDef5Por cDef5Spa cDef5Eng aHelpPor	aHelpEng 	aHelpSpa 	cHelp)
PutSx1(cPerg,"01","Dt. Emissใo De"		,"Dt. Emissใo De"      	,"Dt. Emissใo de"		,"mv_ch1" ,"D"	, 8        					,0  	    ,        ,"G"  ,""                                  ,""		,		,"","mv_par01", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

aHelp[1] := {"Informe a data final de emissใo das notas fiscais "      ,""           ,"Se nใo for preenchido, considera todos" }
PutSx1(cPerg,"02","Dt. Emissใo At้"		,"Dt. Emissใo Ate"		,"Dt. Emissใo Ate"		,"mv_ch2" ,"D"	, 8        					,0     	  	,        ,"G"  ,""                                  ,""	  	,	  	,"","mv_par02", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva as แreas originais                                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return( Nil )  

*/