#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: FAT004N

DESCRICAO: RELATORIO DE VENDAS DE PRODUTO POR CLIENTE

ALTERACOES:
11/02/2015 - Desenvolvimento do fonte

/*/

User Function FAT004

Local oReport
Local cPerg := "FAT004"

//Cria grupo de perguntas
f001(cPerg) 

//Carrega grupo de perguntas
If Pergunte(cPerg,.T.)

	oReport := ReportDef(cPerg)
	oReport:PrintDialog()
Endif

Return

/*
Funcao: f001

Descricao: Cria grupo de perguntas

Parametros:
- cPar1 - codigo do grupo de perguntas
------------------------------------------------------------------------------------------------
Alteracoes:
11/02/2015 - Rafael Leite - Criacao do fonte
*/
Static Function f001(cPerg)

PutSx1(cPerg, "01", "Dt Emissão de:"	,"Dt Emissão de:" 	,"Dt Emissão de:"	, "mv_ch1"	, "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Dt Emissão até:"	,"Dt Emissão até"	,"Dt Emissão até"	, "mv_ch2"	, "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Cliente:"	  		,"Cliente:"	  		,"Cliente:"			, "mv_ch3"	, "C",90, 0, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Produto:"			,"Produto:"	  		,"Produto:"			, "mv_ch4"	, "C",90, 0, 0, "G","", "", "", "", "MV_PAR04","","","","","","","","","","","","","","","","")

Return()
/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
29/01/2015 - Rafael Leite - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2
Local oSection3

//Declaracao do relatorio
oReport := TReport():New("GER010","GER010 - Faturamento de Produto por Cliente",cPerg,{|oReport| PrintReport(oReport)},"GER010 - Faturamento de Produto por Cliente",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Cliente","")
	
//Celulas da secao
TRCell():New(oSection1,"CLILOJA"		,"SD2") 
TRCell():New(oSection1,"D2_CLIENTE"		,"SD2") 
TRCell():New(oSection1,"D2_LOJA"		,"SD2") 
TRCell():New(oSection1,"A1_NOME"		,"SA1") 
TRCell():New(oSection1,"A3_NOME"		,"SA3","Vendedor")

//Secao do relatorio
oSection2 := TRSection():New(oSection1,"Produto","")

TRCell():New(oSection2,"SPACE1"			,"","",,2)
TRCell():New(oSection2,"B1_ISBN"		,"SB1",,,18)
TRCell():New(oSection2,"B1_DESC"		,"SB1",,,40)
TRCell():New(oSection2,"X5_DESCRI"	    ,"SX5","Selo",,8)
TRCell():New(oSection2,"B5_XDTPUBL"		,"SB1",,,15)
TRCell():New(oSection2,"X5_DESCENG"		,"SX5","Tipo Publ.",,20)
TRCell():New(oSection2,"X5_DESCSPA"		,"SX5","Sit.Vnd.",,15)
TRCell():New(oSection2,"A1_XCANALV"		," ","Canal Venda",,30)
TRCell():New(oSection2,"CATEGORIA"		,"SBM","Categoria",,15)
TRCell():New(oSection2,"Z7_DESC" 		,"SZ7","Area",,32)
TRCell():New(oSection2,"Z5_DESC"		,"SZ5","Curso",,28)
TRCell():New(oSection2,"Z6_DESC"		,"SZ6","Disciplina",,30)

//Secao do relatorio
oSection3 := TRSection():New(oSection2,"Faturamento","")

TRCell():New(oSection3,"SPACE1"			,"","",,10)
TRCell():New(oSection3,"D2_DOC"			,"SD2",,,10)
TRCell():New(oSection3,"D2_SERIE"		,"SD2",,,10)
TRCell():New(oSection3,"D2_EMISSAO"		,"SD2",,,10)
TRCell():New(oSection3,"D2_QUANT"		,"SD2","Qtde","@E 99,999",10)
TRCell():New(oSection3,"DA1_PRCVEN"		,"DA1","R$ Capa","@E 99,999.99",12)
TRCell():New(oSection3,"D2_DESC"		,"SD2","%Desc.","@E 999.99",7)
TRCell():New(oSection3,"D2_DESCON"		,"SD2","Vlr.Desc.","@E 99,999.99",12)
TRCell():New(oSection3,"D2_PRCVEN"		,"SD2","Vlr.Unit.","@E 99,999.99",12)
TRCell():New(oSection3,"D2_TOTAL"		,"SD2","Vlr.Total","@E 999,999,999.99",20)
TRCell():New(oSection3,"A1_PESSOA"		,"SA1")
TRCell():New(oSection3,"A1_EMAIL"		,"SA1")
  
//Quebras
//oBreak01 := TRBreak():New(oSection1,oSection1:Cell("D2_CLIENTE"),"Total do Faturamento",.F.)
//oBreak02 := TRBreak():New(oSection2,oSection2:Cell("B1_ISBN"),"Total do Produto",.F.)

//Totalizadores
TRFunction():New(oSection3:Cell("D2_QUANT")	,NIL,"SUM")//,oBreak01)  //,,,,.f.) 
TRFunction():New(oSection3:Cell("D2_TOTAL")	,NIL,"SUM")//,oBreak01)  //,,,,.f.) 

//Faz a impressao do totalizador em linha
oSection3:SetTotalInLine(.f.)
oSection2:SetTotalInLine(.f.)
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

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
Local oSection2 := oSection1:Section(1)
Local oSection3 := oSection2:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cQuery	:= ""
Local xCliente  := ""
Local xISBN     := ""

Local  _cCliente := MntStrPsq(MV_PAR03)
Local  _cProduto := MntStrPsq(MV_PAR04)    
 
_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02) 

_cQuery := "SELECT SD2.D2_CLIENTE||SD2.D2_LOJA CLILOJA, SD2.D2_CLIENTE, SD2.D2_LOJA, SA1.A1_NOME,SA3.A3_NOME,SA1.A1_PESSOA, SA1.A1_EMAIL,
_cQuery += "       SB1.B1_ISBN,SB1.B1_DESC, SB5.B5_XDTPUBL, Z4.X5_DESCENG X5_DESCENGZ4 , Z1.X5_DESCRI X5_DESCRIZ1, Z5.X5_DESCSPA X5_DESCSPAZ5, SZ7.Z7_DESC, Z2.X5_DESCRI X5_DESCRIZ2 , A1_XCANALV,
_cQuery += "       SZ5.Z5_DESC, SZ6.Z6_DESC, DECODE(SBM.BM_XCATEG,'D','DID','P','PROF','I','INT.GER')||' - '||DECODE(SB5.B5_XTIPINC,1,'ON',2,'NE') CATEGORIA,
_cQuery += "       SD2.D2_SERIE, SD2.D2_DOC, SD2.D2_EMISSAO, SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL, SD2.D2_DESC, SD2.D2_PRUNIT DA1_PRCVEN, SD2.D2_DESCON
_cQuery += "  FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SF4") + " SF4,
_cQuery += "       " + RetSqlName("SA1") + " SA1, " + RetSqlName("SB1") + " SB1,
_cQuery += "       " + RetSqlName("SB5") + " SB5, " + RetSqlName("SX5") + " Z1,
_cQuery += "       " + RetSqlName("SX5") + " Z4 , " + RetSqlName("SX5") + " Z5,
_cQuery += "       " + RetSqlName("SX5") + " Z2 , 
_cQuery += "       (SELECT * FROM " + RetSqlName("SA3") + " WHERE A3_FILIAL = '" + xFilial("SA3") + "' AND D_E_L_E_T_ = ' ') SA3,
_cQuery += "       (SELECT * FROM " + RetSqlName("SBM") + " WHERE BM_FILIAL = '" + xFilial("SBM") + "' AND D_E_L_E_T_ = ' ') SBM,
_cQuery += "       (SELECT * FROM " + RetSqlName("SZ5") + " WHERE Z5_FILIAL = '" + xFilial("SZ5") + "' AND D_E_L_E_T_ = ' ') SZ5,
_cQuery += "       (SELECT * FROM " + RetSqlName("SZ6") + " WHERE Z6_FILIAL = '" + xFilial("SZ6") + "' AND D_E_L_E_T_ = ' ') SZ6,
_cQuery += "       (SELECT * FROM " + RetSqlName("SZ7") + " WHERE Z7_FILIAL = '" + xFilial("SZ7") + "' AND D_E_L_E_T_ = ' ') SZ7
_cQuery += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += "   AND SD2.D2_EMISSAO BETWEEN '"+ _cParm1+"' AND '"+ _cParm2+"'"
_cQuery += "   AND SD2.D2_TIPO = 'N'
_cQuery += "   AND SD2.D_E_L_E_T_ = ' '
		  
_cQuery += "   AND SB5.B5_XSELO = Z1.X5_CHAVE
_cQuery += "   AND Z1.X5_TABELA = 'Z1'
	      
_cQuery += "   AND SA1.A1_XCANALV = Z2.X5_CHAVE
_cQuery += "   AND Z2.X5_TABELA = 'Z2'

_cQuery += "   AND SB1.B1_XIDTPPU = Z4.X5_CHAVE
_cQuery += "   AND Z4.X5_TABELA = 'Z4'
	      
_cQuery += "   AND SB1.B1_XSITOBR = Z5.X5_CHAVE
_cQuery += "   AND Z5.X5_TABELA = 'Z5'
	    
_cQuery += "   AND SF4.F4_FILIAL  = '" + xFilial("SF4") + "'"
_cQuery += "   AND SD2.D2_TES = SF4.F4_CODIGO
_cQuery += "   AND SF4.F4_DUPLIC = 'S'
_cQuery += "   AND SF4.D_E_L_E_T_ = ' '
		    
_cQuery += "   AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery += "   AND SD2.D2_CLIENTE = SA1.A1_COD
_cQuery += "   AND SD2.D2_LOJA = SA1.A1_LOJA
_cQuery += "   AND SA1.D_E_L_E_T_ = ' '
		    
_cQuery += "   AND SA1.A1_VEND = SA3.A3_COD (+)
		
_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB1.B1_COD = SD2.D2_COD
_cQuery += "   AND SB1.B1_COD = SB5.B5_COD
_cQuery += "   AND SB1.B1_XIDTPPU <> ' '
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
	      
_cQuery += "   AND SB1.B1_GRUPO = SBM.BM_GRUPO (+)
		      
_cQuery += "   AND SB5.B5_XCURSO = SZ5.Z5_CURSO (+)
		      
_cQuery += "   AND SB5.B5_XDISCIP = SZ6.Z6_DISCIPL (+)
		      
_cQuery += "   AND SB5.B5_XAREA = SZ7.Z7_AREA (+)

If !Empty(MV_PAR03)
	_cQuery += " AND SD2.D2_CLIENTE||SD2.D2_LOJA IN ("+_cCliente+")"
Endif

If !Empty(MV_PAR04)
	_cQuery += " AND SB1.B1_ISBN IN ("+_cProduto+")"
Endif
		      
_cQuery += " ORDER BY A1_COD,A1_LOJA,B1_ISBN,D2_EMISSAO,D2_SERIE,D2_DOC
		  	
If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	xCliente := (_cAlias1)->D2_CLIENTE+(_cAlias1)->D2_LOJA

	oReport:IncMeter()

	oSection1:Init()  

	oSection1:Cell("CLILOJA"):SetValue((_cAlias1)->CLILOJA)
	oSection1:Cell("D2_CLIENTE"):SetValue((_cAlias1)->D2_CLIENTE)
	oSection1:Cell("D2_LOJA"):SetValue((_cAlias1)->D2_LOJA)
	oSection1:Cell("A1_NOME"):SetValue((_cAlias1)->A1_NOME)
	oSection1:Cell("A3_NOME"):SetValue((_cAlias1)->A3_NOME)
                                                                 
    oSection1:Cell("CLILOJA"):Disable()
 	
	oSection1:PrintLine()

	Do While !(_cAlias1)->(eof()) .And. (_cAlias1)->D2_CLIENTE+(_cAlias1)->D2_LOJA = xCliente .And. !oReport:Cancel()        
		xISBN := (_cAlias1)->B1_ISBN

		oSection2:Init()
		oSection2:SetHeaderSection(.T.)

		oSection2:Cell("B1_ISBN"):SetValue((_cAlias1)->B1_ISBN)
		oSection2:Cell("B1_DESC"):SetValue((_cAlias1)->B1_DESC)
		oSection2:Cell("X5_DESCRI"):SetValue((_cAlias1)->X5_DESCRIZ1)
		oSection2:Cell("B5_XDTPUBL"):SetValue((_cAlias1)->B5_XDTPUBL)
		oSection2:Cell("X5_DESCENG"):SetValue((_cAlias1)->X5_DESCENGZ4)
		oSection2:Cell("X5_DESCSPA"):SetValue((_cAlias1)->X5_DESCSPAZ5)  
		oSection2:Cell("A1_XCANALV"):SetValue((_cAlias1)->A1_XCANALV) 
		oSection2:Cell("CATEGORIA"):SetValue((_cAlias1)->CATEGORIA)
		oSection2:Cell("Z7_DESC"):SetValue((_cAlias1)->Z7_DESC)
		oSection2:Cell("Z5_DESC"):SetValue((_cAlias1)->Z5_DESC)
		oSection2:Cell("Z6_DESC"):SetValue((_cAlias1)->Z6_DESC)

		oSection2:PrintLine()

		Do While !(_cAlias1)->(eof()) .And. (_cAlias1)->D2_CLIENTE+(_cAlias1)->D2_LOJA = xCliente .And. (_cAlias1)->B1_ISBN = xISBN .And. !oReport:Cancel()
			oSection3:Init()

			oSection3:Cell("D2_DOC"):SetValue((_cAlias1)->D2_DOC)
			oSection3:Cell("D2_SERIE"):SetValue((_cAlias1)->D2_SERIE)
			oSection3:Cell("D2_EMISSAO"):SetValue((_cAlias1)->D2_EMISSAO)
			oSection3:Cell("D2_QUANT"):SetValue((_cAlias1)->D2_QUANT)
			oSection3:Cell("DA1_PRCVEN"):SetValue((_cAlias1)->DA1_PRCVEN)
			oSection3:Cell("D2_DESC"):SetValue((_cAlias1)->D2_DESC)
			oSection3:Cell("D2_DESCON"):SetValue((_cAlias1)->D2_DESCON)
			oSection3:Cell("D2_PRCVEN"):SetValue((_cAlias1)->D2_PRCVEN)
			oSection3:Cell("D2_TOTAL"):SetValue((_cAlias1)->D2_TOTAL)
			oSection3:Cell("A1_PESSOA"):SetValue((_cAlias1)->A1_PESSOA)
			oSection3:Cell("A1_EMAIL"):SetValue((_cAlias1)->A1_EMAIL)
	
			oSection3:PrintLine()

			(_cAlias1)->(dbSkip())		
		EndDo
		oSection3:Finish()
		oSection2:Finish()
	EndDo
	oSection3:Finish()
	oSection2:Finish()
	oSection1:Finish()
EndDo
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()
         
DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)

/**********************************************************************************************************************/
Static Function MntStrPsq(_cParametros)
/**********************************************************************************************************************/

Local _cTipos := ""
Local _aTipos := {}
Local _nLen   := 0

_aTipos := Separa(_cParametros,";")
_nLen   := Len(_aTipos)

If _nLen > 500
	_nLen := 500 
End

For nX := 1 To _nLen
	If nX == 1
		_cTipos := "'" + ALLTRIM(_aTipos[nX]) + "'"
	Else
		_cTipos := _cTipos + ",'" + ALLTRIM(_aTipos[nX]) + "'"
	EndIf
Next

Return _cTipos
