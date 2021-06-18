#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function RELSZ3()
	Local oReport := nil 

	Pergunte("RELSZ2",.F.) //Adiciona a caixa de perguntas na hora de exibir o relat�rio
	
	oReport := RptDef() //RptDef - Alimenta o oreport (� o relatorio)
	
	oReport:PrintDialog() 
Return() 
//------------------------------------------------------------------------------------------------

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oBreak
	Local oFunction
	//Default cNome := "RELSZ1" //Default - define a propriedade
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New("RELSZ2","Cadastro SZ2 E SZ3","RELSZ2",{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	                       //cNome - Nome do relatorio
	                              //Titulo do relatorio
	                                                 //Tras a tela de parametros preenchida
	                                                                                     //Tras a descricao do relatorio
	// Relatorio em retrato 
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.) // SetTotalInLine - adiciona os totais em linhas, mas como no caso esta com .F. vir� como coluna
	
	//Monstando a primeira se��o

	oSection1:= TRSection():New(oReport, "Pai (SZ2)", /*{"SZ2"}*/, NIL, .F., .T.)
	          //TRSection - cria uma se��o, onde � exibidos os dados da tabela SB1
	TRCell():New(oSection1,"Z2_COD"	    ,"SZ2","Codigo"		     ,"@!",10)
	TRCell():New(oSection1,"Z2_CODFOR"  ,"SZ2","Cod. Fornecedor" ,"@!",20)
	TRCell():New(oSection1,"Z2_NOMEFOR"	,"SZ2","Nome Fornecedor" ,"@!",20)
	TRCell():New(oSection1,"Z2_DATA"	,"SZ2","Data"	         ,"@!",20)
	TRCell():New(oSection1,"Z2_PAG"	    ,"SZ2","Pagamento"		 ,"@!",20)
	TRCell():New(oSection1,"Z2_SOLICIT"	,"SZ2","Solicitante"	 ,"@!",20)
	
	oSection1:SetWidth(3) // Espa�o entre as se��es
	
	oSection2:= TRSection():New(oSection1, "Filho (SZ3)", /*{"SZ2"}*/, NIL, .F., .T.)
	
	oSection2:SetWidth(3) //Espa�o entre se��es
	Osection2:nLeftmargin := 5 //Margem a esquerda
	
	TRCell():New(oSection2,"Z3_COD"	     ,"SZ3")
	TRCell():New(oSection2,"Z3_CODPRO"   ,"SZ3")
	TRCell():New(oSection2,"Z3_NDESCCOD" ,"SZ3")
	TRCell():New(oSection2,"Z3_ITEM"	 ,"SZ3")
	TRCell():New(oSection2,"Z3_QTD"	     ,"SZ3")
	TRCell():New(oSection2,"Z3_VALOR"	 ,"SZ3")
	TRCell():New(oSection2,"Z3_TOTAL"	 ,"SZ3")
	
	//O par�metro que indica qual c�lula o totalizador se refere ,
	//ser� utilizado para posicionamento de impress�o do totalizador quando 
	//estiver definido que a impress�o ser� por coluna e como conte�do para a 
	//fun��o definida caso n�o seja informada uma f�rmula para o totalizador
//	TRFunction():New(oSection1:Cell("Z1_CODIGO"),NIL,"COUNT",,,,,.F.,.T.)// Adiciona os totais no rodap�
//	TRFunction():New(oSection1:Cell("Z1_VUNIT" ),NIL,"SUM"  ,,,,,.F.,.T.)
//	TRFunction():New(oSection1:Cell("Z1_TOTAL" ),NIL,"SUM"  ,,,,,.F.,.T.)
	
	
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)//Puxa a se��o 2 que esta dentro da se��o 1
	Local lPrim 	:= .T.
	Local cAlias  := GetNextAlias()
	
	oSection1:BeginQuery() //Inicio da instru��o do SQL na section
  
	BeginSql alias cAlias

        COLUMN Z2_DATA  AS Date          //COLUMN (Campo) as Date - trata o campo como data no padr�o Brasileiro
        COLUMN Z3_QTD   as Numeric(10,2) //COLUMN (Campo) as Numeric(10,2) - trata o campo com a mascara num�rica
 		COLUMN Z3_VALOR as Numeric(12,2) //COLUMN (Campo) as Numeric(12,2) - trata o campo com a mascara num�rica
 		COLUMN Z3_TOTAL as Numeric(12,2) //COLUMN (Campo) as Numeric(12,2) - trata o campo com a mascara num�rica

		SELECT *
		FROM %table:SZ2% SZ2,
		     %table:SZ3% SZ3
		WHERE Z2_FILIAL = %xfilial:SZ2%
	    AND SZ2.%notDel%
	    AND Z3_FILIAL = %xfilial:SZ3%
	    AND Z2_COD = Z3_COD
	    AND SZ3.%notDel%
		
	EndSql
	
	oSection1:EndQuery() //Fim da instru��o do SQL na section
	oSection2:SetParentQuery() //Se��o 2 vai ser impressa sempre ap�s cada linha da se��o 1
	oSection2:SetParentFilter({| Z3_COD | (cAlias)->Z2_COD == Z3_COD },{|| (cAlias)->Z2_COD })
	
			
	oSection1:Print() // Imprime o relat�rio	
	
Return






