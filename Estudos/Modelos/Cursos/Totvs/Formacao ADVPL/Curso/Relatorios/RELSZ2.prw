#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function RELSZ2()
	Local oReport := nil 

	Pergunte("RELSZ2",.F.) //Adiciona a caixa de perguntas na hora de exibir o relatório
	
	oReport := RptDef() //RptDef - Alimenta o oreport (é o relatorio)
	
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
	oReport := TReport():New("RELSZ2","Cadastro SZ2","RELSZ2",{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	                       //cNome - Nome do relatorio
	                              //Titulo do relatorio
	                                                 //Tras a tela de parametros preenchida
	                                                                                     //Tras a descricao do relatorio
	// Relatorio em retrato 
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.) // SetTotalInLine - adiciona os totais em linhas, mas como no caso esta com .F. virá como coluna
	
	//Monstando a primeira seção

	oSection1:= TRSection():New(oReport, "Sucata SZ2", {"SZ2"}, NIL, .F., .T.)
	          //TRSection - cria uma seção, onde é exibidos os dados da tabela SB1
	TRCell():New(oSection1,"Z2_COD"	    ,"SZ2","Codigo"		     ,"@!",10)
	TRCell():New(oSection1,"Z2_CODFOR"  ,"SZ2","Cod. Fornecedor" ,"@!",20)
	TRCell():New(oSection1,"Z2_NOMEFOR"	,"SZ2","Nome Fornecedor" ,"@!",20)
	TRCell():New(oSection1,"Z2_DATA"	,"SZ2","Data"	         ,"@!",20)
	TRCell():New(oSection1,"Z2_PAG"	    ,"SZ2","Pagamento"		 ,"@!",20)
	TRCell():New(oSection1,"Z2_SOLICIT"	,"SZ2","Solicitante"	 ,"@!",20)
	
	//O parâmetro que indica qual célula o totalizador se refere ,
	//será utilizado para posicionamento de impressão do totalizador quando 
	//estiver definido que a impressão será por coluna e como conteúdo para a 
	//função definida caso não seja informada uma fórmula para o totalizador
//	TRFunction():New(oSection1:Cell("Z1_CODIGO"),NIL,"COUNT",,,,,.F.,.T.)// Adiciona os totais no rodapé
//	TRFunction():New(oSection1:Cell("Z1_VUNIT" ),NIL,"SUM"  ,,,,,.F.,.T.)
//	TRFunction():New(oSection1:Cell("Z1_TOTAL" ),NIL,"SUM"  ,,,,,.F.,.T.)
	
	
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	Local cAlias  := GetNextAlias()
	
	oSection1:BeginQuery() //Inicio da instrução do SQL na section
  
	BeginSql alias cAlias

        COLUMN Z2_DATA  AS Date          //COLUMN (Campo) as Date - trata o campo como data no padrão Brasileiro
//        COLUMN Z1_QUANT AS Numeric(10,2) //COLUMN (Campo) as Numeric(10,2) - trata o campo com a mascara numérica
//        COLUMN Z1_VUNIT AS Numeric(12,2) //COLUMN (Campo) as Numeric(12,2) - trata o campo com a mascara numérica
        
          	
		SELECT Z2_COD,Z2_CODFOR,Z2_NOMEFOR,Z2_DATA,Z2_PAG,Z2_SOLICIT
		FROM %table:SZ2% SZ2
		     
		WHERE Z2_FILIAL = %xfilial:SZ2%
	    AND Z2_COD >= %EXP:MV_PAR01%
	    AND Z2_COD <= %EXP:MV_PAR02%
		AND SZ2.%notDel%
		
		ORDER BY Z2_COD
	
	EndSql
	
	oSection1:EndQuery() //Fim da instrução do SQL na section		
	oSection1:Print() // Imprime o relatório	
Return


