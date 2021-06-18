#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function TREPORTSZ0_erro()
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
	oReport := TReport():New(cNome,"Cadastro Produtos",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	// Relatorio em retrato 
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	
	//Monstando a primeira seção

	oSection1:= TRSection():New(oReport, "Produtos", {"SZ0"}, NIL, .F., .T.)
	TRCell():New(oSection1,"Z0_FILIAL"   ,"SB1",)
	TRCell():New(oSection1,"Z0_COD"  	,"SZ0",)
	TRCell():New(oSection1,"Z0_DATA"	,"SZ0",)
	TRCell():New(oSection1,"Z0_PROD"	,"SZ0",)
	TRCell():New(oSection1,"Z0_QTD"		,"SZ0",)
	TRCell():New(oSection1,"Z0_VALOR"	,"SZ0",)
	TRCell():New(oSection1,"Z0_ATIVO"	,"SZ0",)
	TRCell():New(oSection1,"Z0_OBS"		,"SZ0",)
	

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
	
column Z0_DATA as Date
column Z0_QTD  as Numeric(12,2)
column Z0_VALOR as Numeric(12,2) 
column Z0_TOTAL as Numeric(12,2)


		SELECT Z0_FILIAL,
			   Z0_COD,
			   Z0_DATA,
			   Z0_NOME,
			   Z0_PROD,
			   Z0_QTD,
			   Z0_VALOR,
			   Z0_ATIVO,
				
			ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),Z0_OBS)),'') as MEMO,
				
				(Z0_VALOR * Z0_QTD) as Z0_TOTAL,
				
				CASE Z0_ATIVO
					WHEN  'S' THEN 'Sim'
					WHEN  'N' THEN 'Não'
				else 'Não'
				end as Z0_ATIVO
				
				
		FROM %table:SZ0% SZ0
		WHERE Z0_FILIAL = %xfilial:SZ0%
		AND SZ0.%notDel%
	
		//%exp:cPart%
	
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
			
				
		//inicializo a primeira seção
		
		oSection1:Init()
	
		//imprimo a seção				

		oSection1:Cell("Z0_FILIAL"):SetValue((cAlias)->Z0_FILIAL)
		oSection1:Cell("Z0_COD"):SetValue((cAlias)->Z0_COD)
		oSection1:Cell("Z0_DATA"):SetValue((cAlias)->Z0_DATA)
		//oSection1:Cell("Z0_NOME"):SetValue((cAlias)->Z0_NOME)
		oSection1:Cell("Z0_PROD"):SetValue((cAlias)->Z0_PROD)
		oSection1:Cell("Z0_QTD"):SetValue((cAlias)->Z0_QTD)
		oSection1:Cell("Z0_VALOR"):SetValue((cAlias)->Z0_VALOR)
		oSection1:Cell("Z0_ATIVO"):SetValue((cAlias)->Z0_ATIVO)
		oSection1:Cell("Z0_OBS"):SetValue((cAlias)->Z0_OBS)
		oSection1:Printline()//IMPRESSAO DO REGISTRO
	
	
	
	
		(cAlias)->(dbSkip())
 			
		//imprimo uma linha 
		oReport:ThinLine()
		
	Enddo
	
	//finalizo seção
	oSection1:Finish()
	
Return( NIL )

