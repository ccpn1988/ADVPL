#Include 'Protheus.ch'

User Function TRep2()

Local oReport

	//Criando o grupo de pergunta
	//CriaPerg()
		
	
	//Chamando a Fun��o para criar a estrutura do relatorio	
	oReport := ReportDef()
  
  //Imprimindo o Relatorio
	oReport:PrintDialog()
      

Return( Nil )
//***********************************************************************************************************************************

Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oBreak

// Criando a o Objeto

/*oReport := TReport():New("ClinteXVendedor","Relatorio de Clientes X Vendedor",,{|oReport| PrintReport(oReport)},"Relatorio de visitas de vendedores nos clientes")
oReport:SetLandscape() 
oSection1 := TRSection():New(oReport,"Dados dos Clientes",{"SA1"},{"UF","A1_COD"} )

	TRCell():New(oSection,"A1_COD"    ," SA1","Cliente")
	TRCell():New(oSection,"A1_LOJA"   , "SA1")
	TRCell():New(oSection,"A1_NOME"   , "SA1")
	TRCell():New(oSection,"A1_END"    , "SA1")
	TRCell():New(oSection,"A1_CEP"    , "SA1")
	TRCell():New(oSection,"A1_CONTATO", "SA1")
	TRCell():New(oSection,"A1_TEL"    , "SA1")
	TRCell():New(oSection,"A1_EST"    , "SA1")

// Quebra por Vendedor
	oBreak := TRBreak():New(oSection,oSection:Cell("A1_EST"),"Sub Total UF")
*/

oReport := TReport():New("FornecedorXpedido","Relatorio de Fornecedor X Pedido",,{|oReport| PrintReport(oReport)},"Relat�rio Teste")
oReport:SetLandscape() 
oSection1 := TRSection():New(oReport,"Dados do Fornecedor",{"SZ2"},{"C�digo","Z2_COD"} )

	TRCell():New(oSection1,"Z2_COD"		,"SZ2")
	TRCell():New(oSection1,"Z2_CODFOR"	,"SZ2")
	TRCell():New(oSection1,"Z2_LOJAFOR"	,"SZ2")
	TRCell():New(oSection1,"Z2_NOMEFOR"	,"SZ2")
	TRCell():New(oSection1,"Z2_DATA"		,"SZ2")
	TRCell():New(oSection1,"Z2_PAG"		,"SZ2")
	TRCell():New(oSection1,"Z2_SOLICIT"	,"SZ2")

// Quebra por Vendedor
	oBreak := TRBreak():New(oSection1,oSection1:Cell("Z2_COD"),"Sub Total C�digo")
     
//Fazendo a contagem por codigo
	TRFunction():New(oSection:Cell("A1_COD"   ), NIL, "COUNT", oBreak)

Return ( oReport )

//*******************************************************************************************

Static Function PrintReport(oReport)
Local aOrder   := oReport:GetOrder()
Local oSection := oReport:Section(1)
Local cPart := ""



oSection:BeginQuery() //m�todo que imprime o resultado de uma Query

	cPart := "% AND A1_COD >= '" + MV_PAR01 + "' "
	cPart += "  AND A1_COD <= '" + MV_PAR02 + "' %"
	
BeginSql alias "QRYSA1"

	SELECT A1_COD, 
				 A1_LOJA, 
				 A1_NOME, 
				 A1_VEND, 
				 A1_END,
				 A1_CEP,
				 A1_TEL, 
				 A1_CONTATO, 
				 A1_EST 
	FROM   %TABLE:SA1% SA1 
	WHERE  A1_FILIAL = %XFILIAL:SA1% 
	AND    A1_MSBLQL <> '1' 
	AND    SA1.%NOTDEL%
	
	
	ORDER BY A1_EST, A1_COD, A1_LOJA
	
EndSql

aRetSql := GetLastQuery()

memowrite("C:\sql.txt",aRetSql[2])

oSection:EndQuery()

oSection:Print()

QRYSA1->(dbCloseArea())

Return( Nil )