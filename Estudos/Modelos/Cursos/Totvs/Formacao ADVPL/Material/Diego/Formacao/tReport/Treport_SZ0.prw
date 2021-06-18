#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function TreportSZ0()
	Local oReport := nil
	Local cPerg:= "XRELSUC"
	
	AjustaSX1(cPerg)

	Pergunte(cPerg,.F.)
		
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
	oReport := TReport():New(cNome,"Cadastro Sucata",cNome,{|oReport| ReportPrint(oReport)},"Descri��o do meu relat�rio")
	// Relatorio em retrato 
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	
	//Monstando a primeira se��o

	oSection1:= TRSection():New(oReport, "Sucatas", {"SZ0"}, NIL, .F., .T.)
	TRCell():New(oSection1,"Z0_COD"   	,"SZ0","Sucata"		,"@!",30)
	TRCell():New(oSection1,"Z0_DATA"   	,"SZ0","Data"		,"@!",30)
	TRCell():New(oSection1,"B1_DESC"  	,"SB1","Descri��o"	,"@!",100)
	TRCell():New(oSection1,"Z0_QTD"	    ,"SZ0","Quantidade"	,"@!",20)
	TRCell():New(oSection1,"Z0_VALOR"	,"SZ0","Valor"			,"@!",30)

	//O par�metro que indica qual c�lula o totalizador se refere ,
	//ser� utilizado para posicionamento de impress�o do totalizador quando 
	//estiver definido que a impress�o ser� por coluna e como conte�do para a 
	//fun��o definida caso n�o seja informada uma f�rmula para o totalizador
	TRFunction():New(oSection1:Cell("Z0_COD"),NIL,"COUNT",,,,,.F.,.T.)

Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	Local cAlias  := GetNextAlias()
	
	cPart := "% AND Z0_COD >= '" + MV_PAR01 + "' "
	cPart += "  AND Z0_COD <= '" + MV_PAR02 + "' %"
	
  //cPart := "%%"
  
	BeginSql alias cAlias

		SELECT Z0_COD, Z0_DATA, B1_DESC,Z0_QTD,Z0_VALOR
		FROM %table:SZ0% SZ0
		JOIN %table:SB1% SB1 ON (B1_COD = Z0_PROD)
		WHERE Z0_FILIAL = %xfilial:SZ0%
		AND SZ0.%notDel%
		ORDER BY Z0_COD
	
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
			
		IncProc("Imprimindo " + alltrim((cAlias)->Z0_COD))
		
		//inicializo a primeira se��o
		/*CONSTROI O CABE�ALHO DE IMPRESS�O*/
		oSection1:Init()
	
		//imprimo a se��o				
		oSection1:Cell("Z0_COD"   ):SetValue((cAlias)->Z0_COD  )
		oSection1:Cell("Z0_DATA"  ):SetValue(STOD((cAlias)->Z0_DATA))
		oSection1:Cell("B1_DESC"  ):SetValue((cAlias)->B1_DESC )
		oSection1:Cell("Z0_QTD"   ):SetValue((cAlias)->Z0_QTD  )
		oSection1:Cell("Z0_VALOR" ):SetValue((cAlias)->Z0_VALOR)
		/*vai escrever o dados na Linha, caso queira tratar usar esta fun��o*/
		oSection1:Printline()
	
		(cAlias)->(dbSkip())
 			
		//imprimo uma linha 
		oReport:ThinLine()
		
	Enddo
	
	//finalizo se��o - Encerra for�ando um novo cabe�alho
	oSection1:Finish()
	
Return( NIL )

//--------------------------------------------------------------------------------------------------------
Static Function ajustaSx1(cPerg)
	//Aqui utilizo a fun��o putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "SUCATA DE ?"	  , "", "", "mv_ch1", "C", tamSx3("Z0_COD")[1], 0, 0, "G", "", "SZ0", "", "", "mv_par01")
	putSx1(cPerg, "02", "SUCATA ATE?"	  , "", "", "mv_ch2", "C", tamSx3("Z0_COD")[1], 0, 0, "G", "", "SZ0", "", "", "mv_par02")
return