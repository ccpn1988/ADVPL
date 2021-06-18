#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function RELSB1()
	Local oReport := nil 

	
	oReport := RptDef() //RptDef - Alimento o oreport (é o relatorio)
	
	oReport:PrintDialog()
Return() 
//------------------------------------------------------------------------------------------------

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oBreak
	Local oFunction
	Default cNome := "RELSB1" //Default - define a propriedade
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Cadastro Produtos","",{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	                       //cNome - Nome do relatorio
	                              //Titulo do relatorio
	                                                 //Tras a tela de parametros preenchida
	                                                                                     //Tras a descricao do relatorio
	// Relatorio em retrato 
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	
	//Monstando a primeira seção

	oSection1:= TRSection():New(oReport, "Produtos", {"SB1"}, NIL, .F., .T.)
	          //TRSection - cria uma seção, onde é exibidos os dados da tabela SB1
	TRCell():New(oSection1,"B1_COD"   	,"SB1","Produto"		,"@!",30)
	TRCell():New(oSection1,"B1_DESC"  	,"SB1","Descrição"	,"@!",100)
	TRCell():New(oSection1,"B1_LOCPAD"	,"SB1","Arm.Padrao"	,"@!",20)
	TRCell():New(oSection1,"B1_POSIPI"	,"SB1","NCM"			,"@!",30)

	//O parâmetro que indica qual célula o totalizador se refere ,
	//será utilizado para posicionamento de impressão do totalizador quando 
	//estiver definido que a impressão será por coluna e como conteúdo para a 
	//função definida caso não seja informada uma fórmula para o totalizador
	//TRFunction():New(oSection1:Cell("B1_COD"),NIL,"COUNT",,,,,.F.,.T.)
	
	
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	Local cAlias  := GetNextAlias()
	
	cPart := "% AND B1_COD >= '" + MV_PAR01 + "' "
	cPart += "  AND B1_COD <= '" + MV_PAR02 + "' %"
	
  //cPart := "%%"
  
	BeginSql alias cAlias

		SELECT B1_COD,B1_DESC,B1_LOCPAD,B1_POSIPI
		FROM %table:SB1% SB1
		WHERE B1_FILIAL = %xfilial:SB1%
		AND B1_MSBLQL <> '1'
		AND SB1.%notDel%
	
	
		ORDER BY B1_COD
	
	EndSql
		
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	oReport:SetMeter((cAlias)->(LastRec())) //Define o tamanho da regua de processamento

	//todos os meus registros
	While !(cAlias)->( EOF() )
		
		//Habilita o botão cancelar na tela que carrega o relatorio
		If oReport:Cancel()
			Exit
		EndIf
	
		oReport:IncMeter()
			
				
		//inicializo a primeira seção
		
		oSection1:Init() //Constroi o cabeçalho de impressão e seta a quantidade de linhas maximas
		                 //que serão exibidas nas pagina do relatorio
	
		//imprimo a seção				
			
		oSection1:Cell("B1_COD"   ):SetValue((cAlias)->B1_COD    ) //Cell - puxa os campo do cabeçalho
		oSection1:Cell("B1_DESC"  ):SetValue((cAlias)->B1_DESC   )
		oSection1:Cell("B1_LOCPAD"):SetValue((cAlias)->B1_LOCPAD )
		oSection1:Cell("B1_POSIPI"):SetValue((cAlias)->B1_POSIPI)
		oSection1:Printline() // Imprime os dados em uma linha
	
		(cAlias)->(dbSkip()) //Pula para a proxima linha do select
 			
		//imprimo uma linha em baixo de cada item
		oReport:ThinLine()
		
	Enddo
	
	//finalizo seção
	oSection1:Finish()
	
Return( NIL )

