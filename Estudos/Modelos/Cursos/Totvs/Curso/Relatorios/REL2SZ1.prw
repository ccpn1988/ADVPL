#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function REL2SZ1()
	Local oReport := nil 

	Pergunte("RELSZ1",.F.) //Adiciona a caixa de perguntas na hora de exibir o relat�rio
	
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
	oReport := TReport():New("RELSZ1","Cadastro SZ1","RELSZ1",{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	                       //cNome - Nome do relatorio
	                              //Titulo do relatorio
	                                                 //Tras a tela de parametros preenchida
	                                                                                     //Tras a descricao do relatorio
	// Relatorio em retrato 
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.) // SetTotalInLine - adiciona os totais em linhas, mas como no caso esta com .F. vir� como coluna
	
	//Monstando a primeira se��o

	oSection1:= TRSection():New(oReport, "Sucata", /*{"SZ1"}*/, NIL, .F., .T.)
	          //TRSection - cria uma se��o, onde � exibidos os dados da tabela SB1
	TRCell():New(oSection1,"Z1_CODIGO"	,"SZ1","C�digo"		    ,"@!",10)
	TRCell():New(oSection1,"Z1_NOME"  	,"SZ1","Usu�rio"	    ,"@!",20)
	TRCell():New(oSection1,"Z1_DATA"	,"SZ1","Data"	        ,"@!",20)
	TRCell():New(oSection1,"Z1_PRODUTO"	,"SZ1","Codigo Produto"	,"@!",20)
	TRCell():New(oSection1,"B1_DESC"	,"SB1","Descricao"   	,"@!",20)
	TRCell():New(oSection1,"Z1_QUANT"	,"SZ1","Quantidade"		,"@!",20)
	TRCell():New(oSection1,"Z1_VUNIT"	,"SZ1","Valor Unitario"	,"@!",20)
	TRCell():New(oSection1,"Z1_TOTAL"	,"SZ1","Total"	        ,"@!",20)
//	TRCell():New(oSection1,"Z1_OBS"  	,"SZ1","Observa��o"		,"@!",20)

	//O par�metro que indica qual c�lula o totalizador se refere ,
	//ser� utilizado para posicionamento de impress�o do totalizador quando 
	//estiver definido que a impress�o ser� por coluna e como conte�do para a 
	//fun��o definida caso n�o seja informada uma f�rmula para o totalizador
	TRFunction():New(oSection1:Cell("Z1_CODIGO"),NIL,"COUNT",,,,,.F.,.T.)// Adiciona os totais no rodap�
	TRFunction():New(oSection1:Cell("Z1_VUNIT" ),NIL,"SUM"  ,,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("Z1_TOTAL" ),NIL,"SUM"  ,,,,,.F.,.T.)
	
	
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	Local cAlias  := GetNextAlias()
	
	oSection1:BeginQuery() //Inicio da instru��o do SQL na section
  
	BeginSql alias cAlias

        COLUMN Z1_DATA  AS Date          //COLUMN (Campo) as Date - trata o campo como data no padr�o Brasileiro
        COLUMN Z1_QUANT AS Numeric(10,2) //COLUMN (Campo) as Numeric(10,2) - trata o campo com a mascara num�rica
        COLUMN Z1_VUNIT AS Numeric(12,2) //COLUMN (Campo) as Numeric(10,2) - trata o campo com a mascara num�rica
          	
		SELECT Z1_CODIGO, Z1_NOME, Z1_DATA, Z1_PRODUTO, Z1_QUANT, Z1_VUNIT, Z1_OBS, Z1_VUNIT *Z1_QUANT AS Z1_TOTAL
		FROM %table:SZ1% SZ1,
		     %table:SB1% SB1
		     
		WHERE Z1_FILIAL = %xfilial:SZ1%
	    AND Z1_CODIGO >= %EXP:MV_PAR01%
	    AND Z1_CODIGO <= %EXP:MV_PAR02%
		AND SZ1.%notDel%
		
	    AND B1_FILIAL = %xfilial:SB1%
	    AND Z1_PRODUTO = B1_COD
	    AND SB1.%notDel%
	
		ORDER BY Z1_CODIGO
	
	EndSql
	
	oSection1:EndQuery() //Fim da instru��o do SQL na section		
	oSection1:Print() // Imprime o relat�rio	
Return






