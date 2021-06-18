#Include 'Protheus.ch'
#include 'TopConn.CH'

/*/{Protheus.doc} trpt002
exemplo de relatorio em advpl
@type function
@author Curso Desenvolvendo relatórios com ADVPL - RCTI Treinamentos
@since 2019
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see www.rctitreinamentos.com.br
/*/

User Function Trpt002()

	Local oReport := Nil
	Local cPerg := Padr("TRPT002",10)
	
	Pergunte(cPerg,.T.) //SX1
	
	oReport := RptStruc(cPerg)
	oReport:PrintDialog()
Return

Static Function RPTPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery := ""
	Local cNumCod := ""
	
cQuery := " SELECT A1_COD,A1_NOME,C5_NUM,C6_QTDVEN,C6_PRCVEN,B1_DESC "   
   		cQuery += " FROM SA1990 SA1, SC5990 SC5, SC6990 SC6, SB1990 SB1 "
   			cQuery += " WHERE SA1.D_E_L_E_T_ = '' AND "
   				cQuery += " C5_FILIAL = '"+MV_PAR01+"' AND SC5.D_E_L_E_T_ = '' AND C5_CLIENTE = A1_COD AND "
   			cQuery += " C6_FILIAL = '"+MV_PAR01+"' AND SC6.D_E_L_E_T_ = '' AND C6_NUM = C5_NUM AND "
   		cQuery += " B1_FILIAL = '"+MV_PAR01+"' AND SB1.D_E_L_E_T_ = '' AND B1_COD = C6_PRODUTO "  
   cQuery += " ORDER BY A1_FILIAL,A1_COD,C5_FILIAL,C5_NUM,C6_FILIAL,C6_ITEM "
	
		//Verifica se a tabela ja está aberta.
			If Select("TEMP") <> 0
				DbSelectArea("TEMP")
				DbCloseArea()
			EndIf
			
		TCQUERY cQuery NEW ALIAS "TEMP"
			
			DbSelectArea("TEMP")
			TEMP->(dbGoTop())
			
			//Define o tamanho da regua de processamento e ordenando pelo R_E_C_N_O_
			oReport:SetMeter(TEMP->(LastRec()))
			
		While !EOF()
			If oReport:Cancel()
				Exit
			EndIf
			//Iniciando a primeira seção
			oSection1:Init()
			oReport:IncMeter()
			
			cNumCod := TEMP->A1_COD
			IncProc("Imprimindo Cliente "+ Alltrim(TEMP->A1_COD)) //Mensagem ao usuário
			lçlacj
			
	//Imprimindo primeira seção:
		oSection1:Cell("A1_COD"):SetValue(TEMP->A1_COD)
		oSection1:Cell("A1_NOME"):SetValue(TEMP->A1_NOME)				
		oSection1:Printline()
		
		
			//Iniciar a impressão da seção 2
		oSection2:Init()
		
			//verifica se o codigo do cliente é o mesmo, se sim, imprime os dados do pedido
		While TEMP->A1_COD == cNumCod
			oReport:IncMeter()
			
		IncProc("Imprimindo pedidos..."+ Alltrim(TEMP->C5_NUM))
			oSection2:Cell("C5_NUM"):SetValue(TEMP->C5_NUM)
			oSection2:Cell("B1_DESC"):SetValue(TEMP->B1_DESC)
			oSection2:Cell("C6_PRCVEN"):SetValue(TEMP->C6_PRCVEN)			
			oSection2:Cell("C6_QTDVEN"):SetValue(TEMP->C6_QTDVEN)	
			oSection2:Printline()
			
			TEMP->(dbSkip())
			
		EndDo
			oSection2:Finish()
			oReport:ThinLine()
			
			oSection1:Finish()
			
		EndDo
			
Return


Static Function RPTStruc(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	
	oReport := TReport():New(cNome,"Relatório de pedidos por clientes",cNome,{|oReport| RPTPRINT(oReport)},"Descricao do Help")
	
	oReport:SetPortrait() //Definindo a orientação como retrato
	
	oSection1 := TRSection():New(oReport, "Clientes",{"SA1"}, NIL,.F.,.T.)
	TRCell():New(oSection1,"A1_COD"		,"TEMP","CODIGO"  		,"@!",40)
	TRCell():New(oSection1,"A1_NOME"  ,"TEMP","NOME"	,"@!",200)
	
	oSection2 := TRSection():New(oReport, "Produtos",{"SB1"}, NIL,.F.,.T.)
	TRCell():New(oSection2,"C5_NUM"   	,"TEMP","Pedido"	,"@!",30)
	TRCell():New(oSection2,"B1_DESC"  	,"TEMP","Descrição"	,"@!",100)
	TRCell():New(oSection2,"C6_PRCVEN"	,"TEMP","Prec. Vend"	,"@E 999999.99",20)	
	TRCell():New(oSection2,"C6_QTDVEN"	,"TEMP","Quantidade"	,"@E 999999.99",30)	
	
	oSection1:SetPageBreak(.F.) //Quebra de seção
	

Return (oReport)