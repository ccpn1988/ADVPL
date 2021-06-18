#include "PROTHEUS.ch"

User Function tReport_SQL()

Local oReport

/*	//Criando o grupo de pergunta
	CriaPerg()*/
		
	
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

oReport := TReport():New("ClinteXVendedor","Relatorio de Clientes X Vendedor",,{|oReport| PrintReport(oReport)},"Relatorio de visitas de vendedores nos clientes")
oReport:SetLandscape() 
oSection := TRSection():New(oReport,"Dados dos Clientes",{"SA1"},{"UF","A1_COD"} )

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
//Fazendo a contagem por codigo
 TRFunction():New(oSection:Cell("A1_COD"), NIL, "COUNT", oBreak)

Return ( oReport )

//*******************************************************************************************

Static Function PrintReport(oReport)
Local aOrder   := oReport:GetOrder()
Local oSection := oReport:Section(1)
Local cPart := ""

oSection:BeginQuery()

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
