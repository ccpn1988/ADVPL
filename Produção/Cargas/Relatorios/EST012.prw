#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EST012    ºAutor  ³Cleuto Lima - Loop  º Data ³  03/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Entrada de graficas.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Faturamento                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EST012()             

Local oReport
Local cPerg := "EST012"

Private _cAlias1	:= ""

//Cria grupo de perguntas

//AjusteSX1(cPerg) 

//Carrega grupo de perguntas
If !Pergunte(cPerg,.T.)
	Return nil
EndIF

MV_PAR04	:= AllTrim(IIF( Left(MV_PAR04,2) == "00" , SubStr(MV_PAR04,3,Len(MV_PAR04)) , MV_PAR04 ))

_cAlias1	:= GetNextAlias()

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: AjusteSX1
Descricao: Cria grupo de perguntas
*/   

/*
Static Function AjusteSX1(cPerg)

Local cItPerg	:= "00"
Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}
Local cTitPer 	:= ""     


aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Data de digitação Mes/Ano (MM/AAAA).    ")
PutSx1(cPerg, "01", "Dt.Digitação Mes/Ano:", "Dt.Digitação Mes/ano:" ,"Dt.Digitação Mes/ano:",  "MV_CH1" , "C", 7, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Produto (Obra).    ")
PutSx1(cPerg, "02", "Produto (Obra):", "Produto (Obra):" ,"Produto (Obra):",  "MV_CH2" , "C", TamSX3("B1_ISBN")[1], 0, 0, "G","", "SB1", "", "", "MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Tipo de publicação.")
PutSx1(cPerg, "03", "Tipo de publicação:", "Tipo de publicação:" ,"Tipo de publicação:",  "MV_CH3" , "C", TamSX3("B1_XIDTPPU")[1], 0, 0, "G","", "Z4", "", "", "MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Empresa/Filial origem.")
PutSx1(cPerg, "04", "Empresa/Filial origem:", "Empresa/Filial origem:" ,"Empresa/Filial origem:",  "MV_CH4" , "C", Len(SX5->X5_FILIAL), 0, 0, "G","", "SM0EMP", "", "", "MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

*/
/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2 

Local aOrdem	:= {"Filial+Produto+Data de digitação","Produto+Filial+Data de digitação","Data de digitação+Filial+Produto"}

//Declaracao do relatorio
oReport := TReport():New("EST012","EST012 - Entradas de Gráfica",cPerg,{|oReport| PrintReport(oReport)},"EST012 - Entradas de Gráfica")
oReport:PrintHeader(.F.,.F.)
//Ajuste nas definicoes
oReport:nLineHeight := 55
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7		&& 10
oReport:lHeaderVisible := .F. 
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Compras",{_cAlias1,"NAOUSADO"},aOrdem)

//Celulas da secao
TRCell():New(oSection1,"D1_FILIAL"		,"  ","FILIAL"	  						,				 ,40)
TRCell():New(oSection1,"D1_EMISSAO"		,_cAlias1,TITSX3("D1_EMISSAO")[1]	  		,				 ,15)
TRCell():New(oSection1,"D1_DTDIGIT"   	,_cAlias1,TITSX3("D1_DTDIGIT")[1]			,				 ,15)
TRCell():New(oSection1,"D1_DOC"   		,_cAlias1,TITSX3("D1_DOC")[1]				,				 ,30)
TRCell():New(oSection1,"D1_SERIE"   	,_cAlias1,TITSX3("D1_SERIE")[1]			,				 ,15)
TRCell():New(oSection1,"D1_ITEM"   		,_cAlias1,TITSX3("D1_ITEM")[1]				,				 ,15)
TRCell():New(oSection1,"D1_COD"   		,_cAlias1,"Código do produto (id obra)"	,				,50)
TRCell():New(oSection1,"B1_ISBN"   		,_cAlias1,TITSX3("B1_ISBN")[1]				,				,50)
TRCell():New(oSection1,"B1_DESC"   		,_cAlias1,"Descrição (Título)"				,				,100)
TRCell():New(oSection1,"D1_TES"   		,_cAlias1,"TES"							,				,15)
TRCell():New(oSection1,"D1_CF"   		,_cAlias1,"CFOP"							,				,15)
TRCell():New(oSection1,"D1_QUANT"  		,_cAlias1,TITSX3("D1_QUANT")[1]			,				,50)
TRCell():New(oSection1,"D1_VUNIT"  		,_cAlias1,TITSX3("D1_VUNIT")[1]			,				,50)
TRCell():New(oSection1,"D1_TOTAL"  		,_cAlias1,TITSX3("D1_TOTAL")[1]			,				,60)
TRCell():New(oSection1,"D1_LOCAL"  		,_cAlias1,TITSX3("D1_LOCAL")[1]			,				,15)
TRCell():New(oSection1,"D1_FORNECE"  	,_cAlias1,TITSX3("D1_FORNECE")[1]			,				,20)
TRCell():New(oSection1,"D1_LOJA"  		,_cAlias1,TITSX3("D1_LOJA")[1]				,				,15)
TRCell():New(oSection1,"A2_NOME"  		,_cAlias1,TITSX3("A2_NOME")[1]				,				,80)
TRCell():New(oSection1,"D1_CLVL"  		,_cAlias1,"Classe de valor (id produção)"	,				,15)
TRCell():New(oSection1,"CTH_DESC01"  	,_cAlias1,"Descrição classe valor"			,				,50)

//Totalizadores

oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->COD) } , {|| "Total Produto "+AllTrim((_cAlias1)->COD)+" -->" })

TRFunction():New(oSection1:Cell("D1_QUANT")	    ,"QTD"	,"SUM",oBreak)
TRFunction():New(oSection1:Cell("D1_TOTAL")		,"LIQ"	,"SUM",oBreak)                                

//Faz a impressao do totalizador em linha
oSection1:SetHeaderPage(.F.)
oSection1:SetLeftMargin(2)
oSection1:lPrintHeader := .F.

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local _cQuery   := ""
Local cQuebra	:= Chr(13)+Chr(10)
Local dDtAux	:= IIF( "/" $ MV_PAR01 , CtoD("01/"+Left(MV_PAR01,2)+"/"+SubStr(MV_PAR01,4,4)) , CtoD("01/"+Left(MV_PAR01,2)+"/"+SubStr(MV_PAR01,3,4)))
Local cCfops	:= AllTrim(SuperGetMv("GEN_EST001",.F.,"1102/5202/6202"))

cCfops := FormatIn(cCfops,"/")
  
_cQuery := " SELECT  "+cQuebra
_cQuery += " 'SD1' ORIG, "+cQuebra
_cQuery += " D1_FILIAL FILIAL, "+cQuebra
_cQuery += "  D1_EMISSAO EMISSAO, "+cQuebra
_cQuery += "  D1_DTDIGIT DIGITA, "+cQuebra
_cQuery += "  D1_DOC DOC, "+cQuebra
_cQuery += "  D1_SERIE SERIE, "+cQuebra
_cQuery += "  D1_ITEM ITEM, "+cQuebra
_cQuery += "  D1_COD COD, "+cQuebra
_cQuery += "  B1_ISBN ISBN, "+cQuebra
_cQuery += "  B1_DESC DESCRI, "+cQuebra
_cQuery += "  D1_TES TES, "+cQuebra
_cQuery += "  D1_CF CFOP, "+cQuebra
_cQuery += "  D1_QUANT QUANT, "+cQuebra
_cQuery += "  D1_VUNIT VUNIT, "+cQuebra
_cQuery += "  D1_TOTAL TOTAL, "+cQuebra
_cQuery += "  D1_LOCAL LOCAL, "+cQuebra
_cQuery += "  D1_FORNECE CLIFOR, "+cQuebra
_cQuery += "  D1_LOJA LOJA, "+cQuebra
_cQuery += "  A2_NOME NOME, "+cQuebra
_cQuery += "  D1_CLVL CLVL, "+cQuebra
_cQuery += "  CTH_DESC01 DESC01"+cQuebra
_cQuery += "FROM "+RetSqlName("SD1")+" SD1 "+cQuebra
_cQuery += "JOIN "+RetSqlName("SB1")+" SB1 "+cQuebra
_cQuery += "  ON B1_FILIAL = '"+xFilial("SB1")+"' "+cQuebra
_cQuery += "  AND B1_COD = D1_COD "+cQuebra
_cQuery += "  AND SB1.D_E_L_E_T_ <> '*' "+cQuebra
_cQuery += "JOIN "+RetSqlName("SA2")+" SA2 "+cQuebra
_cQuery += "  ON A2_FILIAL = '"+xFilial("SA2")+"' "+cQuebra
_cQuery += "  AND A2_COD = D1_FORNECE "+cQuebra
_cQuery += "  AND A2_LOJA = D1_LOJA "+cQuebra
_cQuery += "  AND SA2.D_E_L_E_T_ <> '*' "+cQuebra
_cQuery += "LEFT JOIN "+RetSqlName("CTH")+" CTH "+cQuebra
_cQuery += "  ON CTH_FILIAL = '"+xFilial("CTH")+"' "+cQuebra
_cQuery += "  AND CTH.CTH_CLVL = D1_CLVL "+cQuebra
_cQuery += "  AND CTH.D_E_L_E_T_ <> '*' "+cQuebra

If !Empty(MV_PAR04)
	_cQuery += " WHERE D1_FILIAL = '"+MV_PAR04+"' "+cQuebra
	_cQuery += "  AND D1_DTDIGIT BETWEEN '"+DtoS(FirstDate(dDtAux))+"' AND '"+DtoS(LastDate(dDtAux))+"' "+cQuebra	
Else
	_cQuery += " WHERE D1_DTDIGIT BETWEEN '"+DtoS(FirstDate(dDtAux))+"' AND '"+DtoS(LastDate(dDtAux))+"' "+cQuebra	
EndIF

If !Empty(MV_PAR02)
	_cQuery += "  AND D1_COD = '"+MV_PAR02+"' "
EndIf
If !Empty(MV_PAR03)
	_cQuery += "  AND B1_XIDTPPU = '"+MV_PAR03+"' "
EndIf

_cQuery += "  AND B1_ISBN <> ' ' "+cQuebra
_cQuery += "  AND B1_ISBN IS NOT NULL "+cQuebra
_cQuery += "  AND D1_CF IN "+cCfops+" "+cQuebra
_cQuery += "  AND SD1.D_E_L_E_T_ <> '*' "+cQuebra

_cQuery += " UNION ALL  "+cQuebra

_cQuery += " SELECT  "+cQuebra
_cQuery += " 'SD2' ORIG, "+cQuebra
_cQuery += " D2_FILIAL, "+cQuebra
_cQuery += "  D2_EMISSAO, "+cQuebra
_cQuery += "  D2_EMISSAO, "+cQuebra
_cQuery += "  D2_DOC, "+cQuebra
_cQuery += "  D2_SERIE, "+cQuebra
_cQuery += "  D2_ITEM, "+cQuebra
_cQuery += "  D2_COD, "+cQuebra
_cQuery += "  B1_ISBN, "+cQuebra
_cQuery += "  B1_DESC, "+cQuebra
_cQuery += "  D2_TES, "+cQuebra
_cQuery += "  D2_CF, "+cQuebra
_cQuery += "  D2_QUANT*(-1), "+cQuebra
_cQuery += "  D2_PRCVEN, "+cQuebra
_cQuery += "  D2_TOTAL*(-1), "+cQuebra
_cQuery += "  D2_LOCAL, "+cQuebra
_cQuery += "  D2_CLIENTE, "+cQuebra
_cQuery += "  D2_LOJA, "+cQuebra
_cQuery += "  A2_NOME, "+cQuebra
_cQuery += "  D2_CLVL, "+cQuebra
_cQuery += "  CTH_DESC01  "+cQuebra
_cQuery += "FROM "+RetSqlName("SD2")+" SD2 "+cQuebra
_cQuery += "JOIN "+RetSqlName("SB1")+" SB1 "+cQuebra
_cQuery += "  ON B1_FILIAL = '"+xFilial("SB1")+"' "+cQuebra
_cQuery += "  AND B1_COD = D2_COD "+cQuebra
_cQuery += "  AND SB1.D_E_L_E_T_ <> '*' "+cQuebra
_cQuery += "JOIN "+RetSqlName("SA2")+" SA2 "+cQuebra
_cQuery += "  ON A2_FILIAL = '"+xFilial("SA2")+"' "+cQuebra
_cQuery += "  AND A2_COD = D2_CLIENTE "+cQuebra
_cQuery += "  AND A2_LOJA = D2_LOJA "+cQuebra
_cQuery += "  AND SA2.D_E_L_E_T_ <> '*' "+cQuebra
_cQuery += "LEFT JOIN "+RetSqlName("CTH")+" CTH "+cQuebra
_cQuery += "  ON CTH_FILIAL = '"+xFilial("CTH")+"' "+cQuebra
_cQuery += "  AND CTH.CTH_CLVL = D2_CLVL "+cQuebra
_cQuery += "  AND CTH.D_E_L_E_T_ <> '*' "+cQuebra

If !Empty(MV_PAR04)
	_cQuery += " WHERE D2_FILIAL = '"+MV_PAR04+"' "+cQuebra
	_cQuery += "  AND D2_EMISSAO BETWEEN '"+DtoS(FirstDate(dDtAux))+"' AND '"+DtoS(LastDate(dDtAux))+"' "+cQuebra	
Else
	_cQuery += " WHERE D2_EMISSAO BETWEEN '"+DtoS(FirstDate(dDtAux))+"' AND '"+DtoS(LastDate(dDtAux))+"' "+cQuebra	
EndIF

If !Empty(MV_PAR02)
	_cQuery += "  AND D2_COD = '"+MV_PAR02+"' "
EndIf
If !Empty(MV_PAR03)
	_cQuery += "  AND B1_XIDTPPU = '"+MV_PAR03+"' "
EndIf

_cQuery += "  AND B1_ISBN <> ' ' "+cQuebra
_cQuery += "  AND B1_ISBN IS NOT NULL "+cQuebra
_cQuery += "  AND D2_CF IN "+cCfops+" "+cQuebra
_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "+cQuebra

_cQuery += "  ORDER BY "+cQuebra		

Do Case 
	Case oSection1:nOrder == 1
		_cQuery += "  FILIAL,COD,DIGITA "+cQuebra	
	Case oSection1:nOrder == 2
		_cQuery += "  COD,FILIAL,DIGITA "+cQuebra	
	Case oSection1:nOrder == 3
		_cQuery += "  DIGITA,FILIAL,COD "+cQuebra	
	OtherWise
		_cQuery += "  FILIAL,COD,DIGITA "+cQuebra		
End Case
  
If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)
TCSetFiEld(_cAlias1,"EMISSAO","D",8,0)
TCSetFiEld(_cAlias1,"DIGITA","D",8,0)

(_cAlias1)->(dbGoTop())

While !(_cAlias1)->(Eof())
	
	If oReport:Cancel()
		Return nil
	EndIF
	
	oReport:IncMeter()
	oSection1:Init()  
	
	oSection1:Cell("D1_FILIAL"):SetValue(	(_cAlias1)->FILIAL	)     
	oSection1:Cell("D1_EMISSAO"):SetValue(	(_cAlias1)->EMISSAO	)     
	oSection1:Cell("D1_DTDIGIT"):SetValue(	(_cAlias1)->DIGITA	)
	oSection1:Cell("D1_DOC"):SetValue(		(_cAlias1)->DOC		)
	oSection1:Cell("D1_SERIE"):SetValue(	(_cAlias1)->SERIE	)
	oSection1:Cell("D1_ITEM"):SetValue(		(_cAlias1)->ITEM	)
	oSection1:Cell("D1_COD"):SetValue(		(_cAlias1)->COD		)
	oSection1:Cell("B1_ISBN"):SetValue(		(_cAlias1)->ISBN	)
	oSection1:Cell("B1_DESC"):SetValue(		(_cAlias1)->DESCRI	)
	oSection1:Cell("D1_TES"):SetValue(		(_cAlias1)->TES		)
	oSection1:Cell("D1_CF"):SetValue(		(_cAlias1)->CFOP	)     
	oSection1:Cell("D1_QUANT"):SetValue(	(_cAlias1)->QUANT	)     
	oSection1:Cell("D1_VUNIT"):SetValue(	(_cAlias1)->VUNIT	)
	oSection1:Cell("D1_TOTAL"):SetValue(	(_cAlias1)->TOTAL	)
	oSection1:Cell("D1_LOCAL"):SetValue(	(_cAlias1)->LOCAL	)
	oSection1:Cell("D1_FORNECE"):SetValue(	(_cAlias1)->CLIFOR	)
	oSection1:Cell("D1_LOJA"):SetValue(		(_cAlias1)->LOJA	)
	oSection1:Cell("A2_NOME"):SetValue(		(_cAlias1)->NOME	)
	oSection1:Cell("D1_CLVL"):SetValue(		(_cAlias1)->CLVL	)
	oSection1:Cell("CTH_DESC01"):SetValue(	(_cAlias1)->DESC01	)
			
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())
	
EndDo

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)
