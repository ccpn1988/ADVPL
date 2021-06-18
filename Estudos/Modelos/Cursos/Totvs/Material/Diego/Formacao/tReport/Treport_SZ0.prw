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
	oReport := TReport():New(cNome,"Cadastro Sucata",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	// Relatorio em retrato 
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	
	//Monstando a primeira seção

	oSection1:= TRSection():New(oReport, "Sucatas", {"SZ0"}, NIL, .F., .T.)
	TRCell():New(oSection1,"Z0_COD"   	,"SZ0","Sucata"		,"@!",30)
	TRCell():New(oSection1,"Z0_DATA"   	,"SZ0","Data"		,"@!",30)
	TRCell():New(oSection1,"B1_DESC"  	,"SB1","Descrição"	,"@!",100)
	TRCell():New(oSection1,"Z0_QTD"	    ,"SZ0","Quantidade"	,"@!",20)
	TRCell():New(oSection1,"Z0_VALOR"	,"SZ0","Valor"			,"@!",30)

	//O parâmetro que indica qual célula o totalizador se refere ,
	//será utilizado para posicionamento de impressão do totalizador quando 
	//estiver definido que a impressão será por coluna e como conteúdo para a 
	//função definida caso não seja informada uma fórmula para o totalizador
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
		
		//inicializo a primeira seção
		/*CONSTROI O CABEÇALHO DE IMPRESSÂO*/
		oSection1:Init()
	
		//imprimo a seção				
		oSection1:Cell("Z0_COD"   ):SetValue((cAlias)->Z0_COD  )
		oSection1:Cell("Z0_DATA"  ):SetValue(STOD((cAlias)->Z0_DATA))
		oSection1:Cell("B1_DESC"  ):SetValue((cAlias)->B1_DESC )
		oSection1:Cell("Z0_QTD"   ):SetValue((cAlias)->Z0_QTD  )
		oSection1:Cell("Z0_VALOR" ):SetValue((cAlias)->Z0_VALOR)
		/*vai escrever o dados na Linha, caso queira tratar usar esta função*/
		oSection1:Printline()
	
		(cAlias)->(dbSkip())
 			
		//imprimo uma linha 
		oReport:ThinLine()
		
	Enddo
	
	//finalizo seção - Encerra forçando um novo cabeçalho
	oSection1:Finish()
	
Return( NIL )

//--------------------------------------------------------------------------------------------------------
Static Function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
	putSx1(cPerg, "01", "SUCATA DE ?"	  , "", "", "mv_ch1", "C", tamSx3("Z0_COD")[1], 0, 0, "G", "", "SZ0", "", "", "mv_par01")
	putSx1(cPerg, "02", "SUCATA ATE?"	  , "", "", "mv_ch2", "C", tamSx3("Z0_COD")[1], 0, 0, "G", "", "SZ0", "", "", "mv_par02")
return