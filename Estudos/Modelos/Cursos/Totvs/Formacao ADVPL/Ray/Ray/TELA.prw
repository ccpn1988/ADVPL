#Include 'Protheus.ch'
#Include 'rwmake.ch'

User Function TELA()

	Local nLinha := 10 // facilitar digita��o e padronizar os tamanhos
	Local cTitulo := "Tela"
	Local cCodigo  		as Char //definir a tipagem na declara��o da vari�vel: Boa pr�tica
	Local dData 		as Date
	Private cProduto    as Char
	Private cDescri	    as Char
	Private nQtd        as numeric
	Private nValor      as numeric
	Private nTotal	    as numeric
	Private oTotal		as numeric	
	
	RpcSetEnv("99","01")
	cCodigo		:= CriaVar("Z0_COD",.T.)	
	dData 		:= CriaVar("Z0_DATA",.T.)
	cProduto 	:= CriaVar("Z0_PROD",.T.)
	cDescri		:= CriaVar("Z0_DESCR",.T.)
	nQtd 		:= CriaVar("Z0_QTD",.T.)
	nValor 		:= CriaVar("Z0_VALOR",.T.)
	nTotal 		:= CriaVar("Z0_TOTAL",.T.)
		
	Static oDlg				//pode acessar a vari�vel, mas n�o muda os valores

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 300,300 PIXEL
	
		@ nLinha,010 SAY "C�digo" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET cCodigo SIZE 55,08 OF oDlg PIXEL //PICTURE "@R 99.999.999/9999-99"; VALID !Vazio()
		
		nLinha += 15
		@ nLinha,010 SAY "Data" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET dData SIZE 55,08 OF oDlg PIXEL
		
		nLinha += 15
		@ nLinha,010 SAY "Produto:" SIZE 55,08 OF oDlg PIXEL 
		@ nLinha,050 MSGET cProduto F3 "SB1" SIZE 55,08 OF oDlg PIXEL Valid vProduto(cProduto)
		
		nLinha += 15
		@ nLinha,010 SAY "Descri��o:" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET cDescri WHEN .F. SIZE 80,08 OF oDlg PIXEL
		
		nLinha += 15
		@ nLinha,010 SAY "Quantidade:" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET nQtd SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_QTD") Valid fGatilho()
		
		nLinha += 15
		@ nLinha,010 SAY "Valor:" SIZE 55,08 OF oDlg PIXEL 
		@ nLinha,050 MSGET nValor SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_VALOR") Valid fGatilho()
		
		nLinha += 15
		@ nLinha,010 SAY "Total:" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET oTotal Var nTotal WHEN .F. SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_TOTAL") //for�ar a atualiza��o do objeto oTotal

		oTotal:Hide
		
		nLinha += 15
		SButton():New( nLinha,100,02,{||oDlg:End()},oDlg,.T.,,)		//executar o m�todo de fechar a janela dDlg
//		SButton():New( nLinha,100,02,{|| close(oDlg)},oDlg,.T.,,)	//utiliza o Include RwMake, foi substitu�do

		@ nLinha,60 BUTTON "Confirmar" SIZE 030, 010 PIXEL OF oDlg ACTION (fGrava(), oDlg:End()) //acionar fun��o para uso
				
	ACTIVATE MSDIALOG oDlg CENTERED

Return

//---------------------------------------------------------------------------------------------------------------------

Static Function Fgrava()

	Local lIncluir := .F.
	
	MsgInfo("Gravado com sucesso", "s� que n�o")

Return

//---------------------------------------------------------------------------------------------------------------------

Static Function fGatilho()
	oTotal:Show()
	nTotal := nValor * nQtd
	oTotal:Refresh
Return .T.

//---------------------------------------------------------------------------------------------------------------------
Static Function vProduto(cProduto)
	
	Local lValida := .F.
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	/*if ExistCpo("SB1",xFilial("sb1")+cProduto)
		lValida := .T.
		cDescri := Posicione("SB1", 1, xFilial("Sb1")+ cProduto, "B1_DESC")
	else 
		lValida := .F.
		MsgInfo("O c�digo est� errado, Favor corrigir","Seu Burro")
	endif
	*/
	
	If MsSeek(xFilial("SB1")+cProduto)
		cDescri := SB1->B1_DESC
		lValida := .T.
	Else
		MsgAlert("Produto n�o Localizado","Aten��o!!")
		cDescri := ""
	Endif
	
	dbCloseArea()

Return(lValida)

//---------------------------------------------------------------------------------------------------------------------


