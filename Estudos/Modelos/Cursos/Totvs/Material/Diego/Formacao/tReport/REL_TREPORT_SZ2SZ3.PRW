#Include 'Protheus.ch'
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

User Function tReport2_Z2Z3()
	Local oReport := nil
	Local cPerg:= "RELZ2Z3"
	
	AjustaSX1(cPerg)	

	Pergunte(cPerg,.F.)	          
		
	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return()
//------------------------------------------------------------------------------------------------

Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Capa x Itens",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	//Monstando a primeira seção
	//Neste exemplo, a primeira seção será composta por duas colunas, código da NCM e sua descrição
	//Iremos disponibilizar para esta seção apenas a tabela SYD, pois quando você for em personalizar
	//e entrar na primeira seção, você terá todos os outros campos disponíveis, com isso, será
	//permitido a inserção dos outros campos
	//Neste exemplo, também, já deixarei definido o nome dos campos, mascara e tamanho, mas você
	//terá toda a liberdade de modificá-los via relatorio. 

	oSection1:= TRSection():New(oReport, "CAPA", {"SZ2"}, , .F., .T.)
	TRCell():New(oSection1,"Z2_COD"		,"SZ2SZ3","Codigo"  		,"@!",40)
	TRCell():New(oSection1,"Z2_CODFOR"  ,"SZ2SZ3","Codigo Fornecedor"	,"@!",200)
	TRCell():New(oSection1,"Z2_NOMEFOR" ,"SZ2SZ3","Nome"	,"@!",300)
	//A segunda seção, será apresentado os produtos, neste exemplo, estarei disponibilizando apenas a tabela
	//SB1,poderia ter deixado também a tabela de NCM, com isso, você poderia incluir os campos da tabela
	//SYD.Semelhante a seção 1, defino o titulo e tamanho das colunas

	oSection2:= TRSection():New(oReport, "Itens", {"SZ3"}, NIL, .F., .T.)
	TRCell():New(oSection2,"Z3_COD"   	,"SZ2SZ3","Produto"		,"@!",30)
	TRCell():New(oSection2,"Z3_CODPRO"  	,"SZ2SZ3","Codigo Produto"	,"@!",100)
	TRCell():New(oSection2,"Z3_DESCCOD"	,"SZ2SZ3","Descrição"	,"@!",20)	
	TRCell():New(oSection2,"Z3_ITEM"	,"SZ2SZ3","ITEM"		,"@!",30)	
	TRCell():New(oSection2,"Z3_QTD"	,"SZ2SZ3","QUANTIDADE"		,"@!",30)	
	TRCell():New(oSection2,"Z3_VALOR"	,"SZ2SZ3","VALOR"		,"@!",30)	
	TRCell():New(oSection2,"Z3_TOTAL"	,"SZ2SZ3","TOTAL"		,"@!",30)	

	TRFunction():New(oSection2:Cell("Z3_COD"),NIL,"COUNT",,,,,.F.,.T.)
	
	oReport:SetTotalInLine(.F.)
       
  //Pula de pagina por quebra
//	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText("EXEMPLO DA QUEBRA")				
Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cNcm      := ""   
	Local lPrim 	:= .T.	      

	//Monto minha consulta conforme parametros passado
	cQuery := "	SELECT Z3_FILIAL,Z3_COD,Z3_CODPRO,Z3_DESCCOD,Z3_ITEM,Z3_QTD,Z3_VALOR,Z3_TOTAL, "
	cQuery += "	Z2_FILIAL,Z2_COD,Z2_CODFOR,Z2_LOJAFOR,Z2_NOMEFOR,Z3_QTD,Z3_VALOR,Z3_TOTAL "
	cQuery += "	 FROM "+RETSQLNAME("SZ2")+" SZ2 "
	cQuery += "	 INNER JOIN "+RETSQLNAME("SZ3")+" SZ3 ON SB1.D_E_L_E_T_='' AND B1_FILIAL='"+xFilial("SB1")+"' AND B1_POSIPI=YD_TEC "
	cQuery += "	 WHERE SZ2.D_E_L_E_T_=' ' "
	cQuery += "	 AND YD_FILIAL='"+xFilial("SZ2")+"' "
	cQuery += " AND YD_TEC >= '"+MV_PAR01+"' AND YD_TEC <= '"+MV_PAR02+"'"
	cQuery += "	 ORDER BY YD_TEC,B1_COD "
		
	memowrite("C:\sql.txt",cQuery)
		
		
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("SZ2SZ3") <> 0
		SZ2SZ3->(DbCloseArea())
	ENDIF
	
	//crio o novo alias
	
	dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),"SZ2SZ3"	, .F., .T.)
	
	
	
	dbSelectArea("SZ2SZ3")
	SZ2SZ3->(dbGoTop())
	
	oReport:SetMeter(SZ2SZ3->(LastRec()))	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()

		oReport:IncMeter()
					
		cNcm 	:= SZ2SZ3->YD_TEC
		
		IncProc("Imprimindo NCM "+alltrim(SZ2SZ3->YD_TEC))
		
		//imprimo a primeira seção				
		oSection1:Cell("YD_TEC"):SetValue(SZ2SZ3->YD_TEC)
		oSection1:Cell("YD_DESC_P"):SetValue(SZ2SZ3->YD_DESC_P)				
	
		// Imprimindo a linha da seção 1
		oSection1:Printline()
		
		//inicializo a segunda seção 2
		oSection2:init()
		
		//verifico se o codigo da NCM é mesmo, se sim, imprimo o produto
		While SZ2SZ3->YD_TEC == cNcm
		
			oReport:IncMeter()		
		
			IncProc("Imprimindo produto "+alltrim(SZ2SZ3->B1_COD))
			oSection2:Cell("B1_COD"):SetValue(SZ2SZ3->B1_COD)
			oSection2:Cell("B1_DESC"):SetValue(SZ2SZ3->B1_DESC)
			oSection2:Cell("B1_LOCPAD"):SetValue(SZ2SZ3->B1_LOCPAD)			

			oSection2:Cell("B1_POSIPI"):SetValue(SZ2SZ3->B1_POSIPI)			
	         	// Imprimindo a linha da seção 1
			oSection2:Printline()

	
				
 			SZ2SZ3->(dbSkip())
 			
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
	
Return

static function ajustaSx1(cPerg)



cAlias	:= Alias()
_nPerg 	:= 1

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(cPerg)
	DO WHILE ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(cPerg)
		_nPerg := _nPerg + 1
		DBSKIP()
	ENDDO
ENDIF

aRegistro:= {}
//          Grupo/Ordem/Pergunt      /SPA/ENG/Variavl/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/Pyme/GRPSXG/HELP/PICTURE
aAdd(aRegistro,{cPerg,"01","NCM de?" ,"","","mv_ch1","C",tamSx3("B1_POSIPI")[1],00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegistro,{cPerg,"02","NCM ate?","","","mv_ch2","C",tamSx3("B1_POSIPI")[1],00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})


IF Len(aRegistro) >= _nPerg
	For i:= _nPerg  to Len(aRegistro)
		Reclock("SX1",.t.)
		For j:=1 to FCount()
			If J<= LEN (aRegistro[i])
				FieldPut(j,aRegistro[i,j])
			Endif
		Next
		MsUnlock()
	Next
EndIf

	
	
	
	
return