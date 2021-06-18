#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function REL01SB1()
	Local oReport := nil
	Local cPerg:= "XRELPROD"
	
			
	oReport := RptDef(cPerg)
	
	oReport:PrintDialog()
Return()
//------------------------------------------------------------------------------------------------

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Cadastro Produtos",cNome,{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	// Relatorio em retrato 
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	
	//Monstando a primeira se��o

	oSection1:= TRSection():New(oReport, "Produtos", {"SB1"}, NIL, .F., .T.)
	TRCell():New(oSection1,"B1_COD"   	,"SB1","Produto"		,"@!",30)
	TRCell():New(oSection1,"B1_DESC"  	,"SB1","Descri��o"	,"@!",100)
	TRCell():New(oSection1,"B1_LOCPAD"	,"SB1","Arm.Padrao"	,"@!",20)
	TRCell():New(oSection1,"B1_POSIPI"	,"SB1","NCM"			,"@!",30)

	//O par�metro que indica qual c�lula o totalizador se refere ,
	//ser� utilizado para posicionamento de impress�o do totalizador quando 
	//estiver definido que a impress�o ser� por coluna e como conte�do para a 
	//fun��o definida caso n�o seja informada uma f�rmula para o totalizador
	TRFunction():New(oSection1:Cell("B1_COD"),NIL,"COUNT",,,,,.F.,.T.)
	
	
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
	
		//%exp:cPart%
	
		ORDER BY B1_COD
	
	EndSql
		
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	oReport:SetMeter((cAlias)->(LastRec()))

	//todos os meus registros
	While !(cAlias)->( EOF() )
		
		If oReport:Cancel()
			Exit
		EndIf
	
		oReport:IncMeter()
						
		//inicializo a primeira se��o
		
		oSection1:Init() //iniciar se��o  = constroi o cabe�alho de impress�o
	
		//imprimo a se��o				
		
		oSection1:Cell("B1_COD"   ):SetValue((cAlias)->B1_COD    )
		oSection1:Cell("B1_DESC"  ):SetValue((cAlias)->B1_DESC   )
		oSection1:Cell("B1_LOCPAD"):SetValue((cAlias)->B1_LOCPAD )
		oSection1:Cell("B1_POSIPI"):SetValue((cAlias)->B1_POSIPI)
		oSection1:Printline() // dado aparecer no relat�rio
	
		(cAlias)->(dbSkip())
 			
		//imprimo uma linha 
		oReport:ThinLine()
		
	Enddo
	
	//finalizo se��o
	oSection1:Finish()// se estiver dentro do enddo o cabe�alho do init() imprime para cada linha do relat�rio 
	
Return( NIL )

