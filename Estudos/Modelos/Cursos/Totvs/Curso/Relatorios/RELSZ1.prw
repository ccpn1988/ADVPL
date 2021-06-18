#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function RELSZ1()
	Local oReport := nil 

	Pergunte("RELSZ1",.F.) //Adiciona a caixa de perguntas na hora de exibir o relat�rio
	
	oReport := RptDef() //RptDef - Alimento o oreport (� o relatorio)
	
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
	
//	cPart := "% AND Z1_CODIGO >= '" + MV_PAR01 + "' "
//	cPart += "  AND Z1_CODIGO <= '" + MV_PAR02 + "' %"
	
  //cPart := "%%"
  
	BeginSql alias cAlias

        COLUMN Z1_DATA AS Date
        COLUMN Z1_QUANT AS Numeric(10,2)
        COLUMN Z1_VUNIT AS Numeric(12,2)
          	
		SELECT *
		FROM %table:SZ1% SZ1
		WHERE Z1_FILIAL = %xfilial:SZ1%
	    AND Z1_CODIGO >= %EXP:MV_PAR01%
	    AND Z1_CODIGO <= %EXP:MV_PAR02%
		AND SZ1.%notDel%
	
	
		ORDER BY Z1_CODIGO
	
	EndSql
		
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	oReport:SetMeter((cAlias)->(LastRec())) //Define o tamanho da regua de processamento

	//todos os meus registros
	While !(cAlias)->( EOF() )
		
		//Habilita o bot�o cancelar na tela que carrega o relatorio
		If oReport:Cancel()
			Exit
		EndIf
	
		oReport:IncMeter()
			
				
		//inicializo a primeira se��o
		
		oSection1:Init() //Constroi o cabe�alho de impress�o e seta a quantidade de linhas maximas
		                 //que ser�o exibidas nas pagina do relatorio
	
		//imprimo a se��o				
			
		oSection1:Cell("Z1_CODIGO"	):SetValue((cAlias)->Z1_CODIGO  )//Cell - puxa os campo do cabe�alho
		oSection1:Cell("Z1_NOME"  	):SetValue((cAlias)->Z1_NOME    )
		oSection1:Cell("Z1_DATA"	):SetValue((cAlias)->Z1_DATA	)
		oSection1:Cell("Z1_PRODUTO"	):SetValue((cAlias)->Z1_PRODUTO )
		oSection1:Cell("B1_DESC"	):SetValue(Posicione("SB1",1,xFilial("SB1")+(cAlias)->Z1_PRODUTO,"B1_DESC") )
		oSection1:Cell("Z1_QUANT"	):SetValue((cAlias)->Z1_QUANT	)
		oSection1:Cell("Z1_VUNIT"	):SetValue((cAlias)->Z1_VUNIT	)
		oSection1:Cell("Z1_TOTAL"	):SetValue((cAlias)->Z1_VUNIT *	(cAlias)->Z1_QUANT)
//		oSection1:Cell("Z1_OBS"  	):SetValue((cAlias)->Z1_OBS 	)
		
		oSection1:Printline() // Imprime os dados em uma linha
	
		(cAlias)->(dbSkip()) //Pula para a proxima linha do select
 			
		//imprimo uma linha em baixo de cada item
		//oReport:ThinLine()
		
	Enddo
	
	//finalizo se��o
	oSection1:Finish()
	
Return( NIL )
