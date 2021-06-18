#INCLUDE "rwmake.ch"

User Function GENA019C             

Local oReport
Local cPerg := "GENA019A"

//Carrega grupo de perguntas
If !Pergunte(cPerg,.T.)
	Return
Endif

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
oReport := TReport():New("GENA019C","Prestação de Contas",cPerg,{|oReport| PrintReport(oReport)},"Prévia da Prestação de Contas")

//Ajuste nas definicoes
//oReport:nLineHeight := 50
//oReport:cFontBody 	:= "Courier New"
//oReport:nFontBody 	:= 9    		&& 10
//oReport:lHeaderVisible := .T.  

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SZA")

//Celulas da secao      
TRCell():New(oSection1,"PRES"		,"   ","Prestação"	,"@!"				,12)
TRCell():New(oSection1,"EMP"		,"   ","Empresa"	,"@!"				,12)
TRCell():New(oSection1,"PROD"		,"   ","Produto"	,"@!"				,20)
TRCell():New(oSection1,"DSCR"		,"   ","Descrição"	,"@!"				,30)
TRCell():New(oSection1,"ISBN"		,"   ","Isbn"		,"@!"				,20)
TRCell():New(oSection1,"PUBI"		,"   ","Publicação"	,"@!"				,20)
TRCell():New(oSection1,"VQTD"		,"   ","Quant Venda","@E 999,999,999.99",15)
TRCell():New(oSection1,"DQTD"		,"   ","Quant Devol","@E 999,999,999.99",15)
TRCell():New(oSection1,"CQTD"		,"   ","Quant Cance","@E 999,999,999.99",15)
TRCell():New(oSection1,"SALDO"		,"   ","Saldo"      ,"@E 999,999,999.99",15)
TRCell():New(oSection1,"PRECO"		,"   ","Preço"      ,"@E 999,999,999.99",15)
TRCell():New(oSection1,"TOTAL"		,"   ","Valor Total","@E 999,999,999.99",15)

//Totalizadores
TRFunction():New(oSection1:Cell("VQTD"),, "SUM",,,,,.T.,.F.,.F., oSection1) 
TRFunction():New(oSection1:Cell("DQTD"),, "SUM",,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("CQTD"),, "SUM",,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("SALDO"),, "SUM",,,,,.T.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell("TOTAL"),, "SUM",,,,,.T.,.F.,.F., oSection1)

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cAlias2	:= GetNextAlias()
Local _cMvTbPr 	:= GetMv("GEN_FAT006") //Contém a tabela de preço usado no pedido de vendas

_cRef := DTOS(MV_PAR01)
MV_PAR04 := Alltrim(Str(MV_PAR04)) 

//Cria query
_cSQL := " SELECT ZA_TIPO	  
_cSQL += " ,ZA_COD  
_cSQL += " ,ZA_DESC   
_cSQL += " ,B1_ISBN
_cSQL += " ,X5_DESCRI DESCRIX5    
_cSQL += " ,ZA_VALORI 
_cSQL += " ,ZA_VALDEV    
_cSQL += " ,ZA_VALCAN   
_cSQL += " ,ZA_SALDO       
_cSQL += " ,ZA_VALUNI
_cSQL += " ,ZA_VALTOT
_cSQL += " FROM "+RetSQLName("SZA")+" SZA
_cSQL += " INNER JOIN "+RetSQLName("SB1")+" SB1
_cSQL += " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"'
_cSQL += " AND SB1.B1_COD = SZA.ZA_COD
_cSQL += " AND SB1.D_E_L_E_T_ = ' '
_cSQL += " LEFT JOIN " + RetSqlName("SX5") + " SX5_1 
_cSQL += " ON SX5_1.X5_FILIAL = '"+xFilial("SX5")+"'
_cSQL += " AND SX5_1.X5_TABELA = 'Z4'
_cSQL += " AND SX5_1.X5_CHAVE = SB1.B1_XIDTPPU
_cSQL += " WHERE SZA.ZA_FILIAL  = '"+xFilial("SZA")+"' 
_cSQL += " AND SZA.ZA_REF = '"+_cRef+"'
_cSQL += " AND SZA.ZA_PROC = '"+MV_PAR02+"'
_cSQL += " AND SZA.ZA_LOJPROC = '"+MV_PAR03+"'
_cSQL += " AND SZA.ZA_TIPO = '"+MV_PAR04+"'
_cSQL += " AND SZA.D_E_L_E_T_ = ' '
_cSQL += " ORDER BY ZA_TIPO, ZA_REF, ZA_COD	  

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias2, .F., .T.)

If MV_PAR04 == "1"
	_cPrest := "Oferta"
Else            
	_cPrest := "Venda"
Endif  

If MV_PAR02 == "031811 "
	_cEmpProc := "AC"

ElseIf MV_PAR02 == "0380794"
	_cEmpProc := "FORENCE"

ElseIf MV_PAR02 == "0380795"
	_cEmpProc := "EGK"

ElseIf MV_PAR02 == "0380796"
	_cEmpProc := "LTC"
Endif

While (_cAlias2)->(!EOF())

oReport:IncMeter()

	oSection1:Init()  
	oSection1:Cell("PRES"):SetValue(_cPrest) 
	oSection1:Cell("EMP"):SetValue(_cEmpProc) 
	oSection1:Cell("PROD"):SetValue((_cAlias2)->ZA_COD) 
	oSection1:Cell("DSCR"):SetValue((_cAlias2)->ZA_DESC) 
	oSection1:Cell("ISBN"):SetValue((_cAlias2)->B1_ISBN) 
	oSection1:Cell("PUBI"):SetValue((_cAlias2)->DESCRIX5) 
	oSection1:Cell("VQTD"):SetValue((_cAlias2)->ZA_VALORI) 
	oSection1:Cell("DQTD"):SetValue((_cAlias2)->ZA_VALDEV) 
	oSection1:Cell("CQTD"):SetValue((_cAlias2)->ZA_VALCAN) 
	oSection1:Cell("SALDO"):SetValue((_cAlias2)->ZA_SALDO) 
	oSection1:Cell("PRECO"):SetValue((_cAlias2)->ZA_VALUNI) 
	oSection1:Cell("TOTAL"):SetValue((_cAlias2)->ZA_VALTOT) 
	
	oSection1:PrintLine()

	(_cAlias2)->(DbSkip())
EndDo

Return(.t.)