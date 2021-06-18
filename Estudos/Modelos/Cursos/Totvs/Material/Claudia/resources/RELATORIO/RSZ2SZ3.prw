#Include 'Protheus.ch'

User Function RELSZ2SZ3()
	Local oReport := nil
	
	Pergunte("RSZ2SZ3",.F.)  // BUSCAR AS PERGUNTAS NO SX1	
			
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
	oReport := TReport():New("RSZ2SZ3","Pedidos",'RSZ2SZ3',{|oReport| ReportPrint(oReport)},"Dados dos pedidos")
	
	oSection1:= TRSection():New(oReport, "Pedidos", {""}, NIL, .F., .T.)
	TRCell():New(oSection1,"Z2_COD"         ,"SZ2")
	TRCell():New(oSection1,"Z2_CODFOR"      ,"SZ2")
	TRCell():New(oSection1,"Z2_LOJAFOR"     ,"SZ2")		
	TRCell():New(oSection1,"Z2_Z2_NOMEFOR"  ,"SZ2")
	TRCell():New(oSection1,"Z2_DATA"        ,"SZ2")
	TRCell():New(oSection1,"Z2_PAG"         ,"SZ2")
	TRCell():New(oSection1,"Z2_SOLICIT"     ,"SZ2")
	
	oReport:SetTotalInLine(.F.) 
	
	TRFunction():New(oSection1:Cell("Z2_COD"  ),NIL,"COUNT")
			
	oSection2:= TRSection():New(oSection, "Itens Pedidos", {""}, NIL, .F., .T.)
	TRCell():New(oSection2,"Z3_COD"         ,"SZ3")
	TRCell():New(oSection2,"Z3_CODPRO"      ,"SZ3")
	TRCell():New(oSection2,"Z3_DESCCOD"     ,"SZ3")		
	TRCell():New(oSection2,"Z3_ITEM"        ,"SZ3")
	TRCell():New(oSection2,"Z3_QTD"         ,"SZ3")
	TRCell():New(oSection2,"Z3_VALOR"       ,"SZ3")
	TRCell():New(oSection2,"Z3_TOTAL"       ,"SZ3")
	
	TRFunction():New(oSection1:Cell("Z3_COD"   ),NIL,"COUNT")
	TRFunction():New(oSection1:Cell("Z3_QTD"   ),NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("Z3_VALOR" ),NIL,"SUM",,,,,.F.,.T.)
	TRFunction():New(oSection1:Cell("Z3_TOTAL" ),NIL,"SUM",,,,,.F.,.T.)	
		
	//O parâmetro que indica qual célula o totalizador se refere ,
	//será utilizado para posicionamento de impressão do totalizador quando 
	//estiver definido que a impressão será por coluna e como conteúdo para a 
	//função definida caso não seja informada uma fórmula para o totalizador	
	
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local cNcm      := ""
	Local lPrim 	:= .T.
	Local cAlias  := GetNextAlias()
	
    cPart := "% AND Z0_COD  >= '"+MV_PAR01+"'" 
    cPart += "  AND Z0_COD  <= '"+MV_PAR02+"'"
    
    IF MV_PAR03 == 1
       cPart += "  AND Z0_ATIVO = 'S'"
    ELSEIF MV_PAR03 == 2 
        cPart += "  AND Z0_ATIVO <> 'S'"
    ENDIF    
    
    cPart += "%"
  
BeginSql alias cAlias
	
	column Z0_DATA  as Date
	column Z0_QTD   as Numeric(12,2)
	column Z0_VALOR as Numeric(12,2)
	column Z0_TOTAL as Numeric(12,2)
	
	
	SELECT *
		   
	FROM %TABLE:SZ2% SZ2,  %TABLE:SZ3% SZ3
	WHERE Z2_FILIAL = %xfilial:SZ2%
 	  AND Z2_COD    = Z3_COD
	  AND SZ2.%notDel%
	  AND SZ3.%notDel%  
	
EndSql

aSql := GetLastQuery()

		
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	oReport:SetMeter((cAlias)->(LastRec()))

	While !(cAlias)->( EOF() )
		
		oReport:IncMeter()
		oSection1:Init()

		oSection1:Cell("Z2_COD"     ):SetValue((cAlias)->Z2_COD) 
		oSection1:Cell("Z2_CODFOR"  ):SetValue((cAlias)->Z2_CODFOR) 
		oSection1:Cell("Z2_LOJAFOR" ):SetValue((cAlias)->Z2_LOJAFOR) 
		oSection1:Cell("Z2_NOMEFOR" ):SetValue((cAlias)->Z2_NOMEFOR) 
		oSection1:Cell("Z2_DATA"    ):SetValue((cAlias)->Z2_DATA) 
		oSection1:Cell("Z2_PAG"     ):SetValue((cAlias)->Z2_PAG) 
		oSection1:Cell("Z2_SOLICIT" ):SetValue((cAlias)->Z2_SOLICIT)   		
		
		oSection1:Printline()
		
		
		oSection2:Init()		
		
		oSection2:Cell("Z3_COD"     ):SetValue((cAlias)->Z3_COD) 
		oSection2:Cell("Z3_CODPRO"  ):SetValue((cAlias)->Z3_CODPRO) 
		oSection2:Cell("Z3_DESCCOD" ):SetValue((cAlias)->Z3_DESCCOD) 
		oSection2:Cell("Z3_ITEM"    ):SetValue((cAlias)->Z3_ITEM) 
		oSection2:Cell("Z3_QTD"     ):SetValue((cAlias)->Z3_QTD) 
		oSection2:Cell("Z3_VALOR"   ):SetValue((cAlias)->Z3_VALOR) 
		oSection2:Cell("Z3_TOTAL"   ):SetValue((cAlias)->Z3_TOTAL)   		
		
		oSection2:Printline()
	
		(cAlias)->(dbSkip())
		
	Enddo
	
	oSection1:Finish()
	oSection2:Finish()
	
Return( NIL )
