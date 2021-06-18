#Include 'Protheus.ch'

User Function TRep1()
	Local oReport := nil
			
	Pergunte("RELSZ0",.T.)//SE .T. o sistema apresenta os parâmentros no momento da abertura da rotina
	oReport := RptDef()
	
	oReport:PrintDialog()
Return()
//------------------------------------------------------------------------------------------------

Static Function RptDef()
	Local oReport := Nil
	Local oSection1:= Nil
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New("RELSZ0","Cadastro de Sucata","RELSZ0",{|oReport| ReportPrint(oReport)},"Dados dos pedidos")
	
	oSection1:= TRSection():New(oReport, "Sucata", {""}, NIL, .F., .T.)
		TRCell():New(oSection1,"Z0_COD"    ,"SZ0")
		TRCell():New(oSection1,"Z0_DATA"   ,"SZ0")
		TRCell():New(oSection1,"Z0_NOME"   ,"SZ0")
		TRCell():New(oSection1,"Z0_PROD"   ,"SZ0")
		TRCell():New(oSection1,"Z0_DESC"   ,"SZ0")
		TRCell():New(oSection1,"Z0_QTD"    ,"SZ0")
		TRCell():New(oSection1,"Z0_VALOR"  ,"SZ0")
		TRCell():New(oSection1,"Z0_TOTAL"  ,"SZ0")
		TRCell():New(oSection1,"Z0_ATIVO"  ,"SZ0")
		TRCell():New(oSection1,"Z0_OBS"    ,"SZ0")

	//O parâmetro que indica qual célula o totalizador se refere ,
	//será utilizado para posicionamento de impressão do totalizador quando 
	//estiver definido que a impressão será por coluna e como conteúdo para a 
	//função definida caso não seja informada uma fórmula para o totalizador
	
	oReport:SetTotalInLine(.F.) 
	
	TRFunction():New(oSection1:Cell("Z0_COD"  ),NIL,"COUNT")
	TRFunction():New(oSection1:Cell("Z0_VALOR"),NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("Z0_QTD"  ),NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("Z0_TOTAL"),NIL,"SUM",,,,,.F.,.T.)
	
	
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	Local cAlias  := GetNextAlias()
	
	cPart := "% AND Z0_COD >= '" + MV_PAR01 + "' "
	cPart += " AND Z0_COD <= '" + MV_PAR02 + "' "
	
	If MV_PAR03 == 1
		cPart += "AND Z0_ATIVO = 'S'"
	ElseIf MV_PAR03 == 2
		cPart += "AND Z0_ATIVO = 'N'"
	Endif
		cPart += "%"
  
BeginSql alias cAlias
	
	column Z0_DATA  as Date
	column Z0_QTD   as Numeric(12,2)
	column Z0_VALOR as Numeric(12,2)
	column Z0_TOTAL as Numeric(12,2)

	SELECT Z0_COD   ,
		   Z0_DATA	,
		   Z0_NOME	,
		   Z0_PROD	,
		   B1_DESC  ,
		   Z0_QTD	,
		   Z0_VALOR ,
		   
		   ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),Z0_OBS)),'') as MEMO,  
	   
	   (Z0_VALOR * Z0_QTD) as Z0_TOTAL  ,
	   
		Case Z0_ATIVO
		  WHEN 'S' Then 'Sim'
		  WHEN 'N' Then 'Não'
		else 'Não'
		end as Z0_ATIVO
		
		   
	FROM %TABLE:SZ0% SZ0,  %TABLE:SB1% SB1
	WHERE Z0_FILIAL = %xfilial:SZ0%
	 AND B1_COD    = Z0_PROD  
	 AND B1_FILIAL = %xfilial:SB1%
	 AND SB1.%notDel%
	 AND SZ0.%notDel%
	 %Exp:cPart%
	
EndSql

aSql := GetLastQuery()

		
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	oReport:SetMeter((cAlias)->(LastRec()))

	While !(cAlias)->( EOF() )
		
		oReport:IncMeter()
		oSection1:Init()
	
		oSection1:Cell("Z0_COD"  ):SetValue((cAlias)->Z0_COD   ) 
		oSection1:Cell("Z0_DATA" ):SetValue((cAlias)->Z0_DATA  ) 
		oSection1:Cell("Z0_NOME" ):SetValue((cAlias)->Z0_NOME  ) 
		oSection1:Cell("Z0_PROD" ):SetValue((cAlias)->Z0_PROD  ) 
		oSection1:Cell("Z0_DESC" ):SetValue((cAlias)->B1_DESC  ) 
		oSection1:Cell("Z0_QTD"  ):SetValue((cAlias)->Z0_QTD   ) 
		oSection1:Cell("Z0_VALOR"):SetValue((cAlias)->Z0_VALOR ) 
		oSection1:Cell("Z0_TOTAL"):SetValue((cAlias)->Z0_TOTAL ) 
		oSection1:Cell("Z0_ATIVO"):SetValue((cAlias)->Z0_ATIVO ) 
		oSection1:Cell("Z0_OBS"  ):SetValue((cAlias)->MEMO	   )     		
		
		oSection1:Printline()
	
		(cAlias)->(dbSkip())
		
	Enddo
	
	oSection1:Finish()
	
Return( NIL )
