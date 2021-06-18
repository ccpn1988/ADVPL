#Include 'Protheus.ch'

User Function Rel2Section()

Local oReport
	
	//Chando a Função para criar a estrutura do relatorio	
	oReport := ReportDef()
  
  //Imprimindo o Relatorio
	oReport:PrintDialog()
      

Return( Nil )
//***********************************************************************************************************************************

Static Function ReportDef()

Local oReport
Local oSection
Local oBreak

// Criando a o Objeto

oReport := TReport():New("Rel2Section","Relatorio de Clientes X Vendedor","",{|oReport| PrintReport(oReport)},"Relatorio de visitas de vendedores nos clientes")
oReport:SetLandscape()
 
oSection := TRSection():New(oReport,"Dados da Fornecedor")
	TRCell():New(oSection,"Z2_COD"     ,"SZ2")
	TRCell():New(oSection,"Z2_CODFOR"  ,"SZ2")
	TRCell():New(oSection,"Z2_LOJAFOR" ,"SZ2")
	TRCell():New(oSection,"Z2_NOMEFOR" ,"SZ2")
	TRCell():New(oSection,"Z2_DATA"    ,"SZ2")
	
oSection2 := TRSection():New(oSection,"Dados do Produto")
	TRCell():New(oSection2,'Z3_ITEM'   ,"SZ3")
	TRCell():New(oSection2,'Z3_CODPRO' ,"SZ3")
	TRCell():New(oSection2,'Z3_DESCCOD',"SZ3")
	TRCell():New(oSection2,'Z3_QTD'    ,"SZ3")
	TRCell():New(oSection2,'Z3_VALOR'  ,"SZ3")
	TRCell():New(oSection2,'Z3_TOTAL'  ,"SZ3")   
	
TRFunction():New(oSection2:Cell("Z3_QTD")  , NIL, "SUM")
TRFunction():New(oSection2:Cell("Z3_VALOR"), NIL, "SUM")
TRFunction():New(oSection2:Cell("Z3_TOTAL"), NIL, "SUM")
Return ( oReport )

//*******************************************************************************************

Static Function PrintReport(oReport)
Local aOrder   := oReport:GetOrder()
Local oSection := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cAlias   := GetNextAlias()


oSection:BeginQuery()
	
BeginSql alias cAlias

	SELECT *
	FROM   %TABLE:SZ2% SZ2 , %TABLE:SZ3% SZ3 
	WHERE  Z2_FILIAL = %XFILIAL:SZ2%
	AND    Z2_COD = Z3_COD 
	AND    SZ2.%NOTDEL%
	AND    Z3_FILIAL = %XFILIAL:SZ3%
	AND    SZ3.%NOTDEL%
	
EndSql


//aRetSql := GetLastQuery()
//memowrite("C:\sql.txt",aRetSql[2])
oSection:EndQuery()
oSection2:SetParentQuery()
oSection2:SetParentFilter({|cParam| (cAlias)->Z2_COD == cParam},{|| (cAlias)->Z2_COD })
oSection:Print()

(cAlias)->(dbCloseArea())

Return( Nil )



