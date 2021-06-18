#Include 'Protheus.ch'
#Include 'rwmake.ch'

User Function TELA()
	Static oDlg , oTotal, GetCod := Nil //pode acessar a variável, mas não muda os valores
	Local nLinha := 10 // facilitar digitação e padronizar os tamanhos
	Local cTitulo := "Tela"
	
	Private cCodigo := ""
	Private dData := Date()
	Private cProduto := ""
	Private cDescri := ""
	
	Private nQtd := 0
	Private nValor := 0
	Private nTotal := 0
	
	RpcSetEnv("99","01") //POSICIONA EMPRESA E FILIAL
	cCodigo		:= CriaVar("Z0_COD",.T.)	
	dData 		:= CriaVar("Z0_DATA",.T.)
	cProduto 	:= CriaVar("Z0_PROD",.T.)
	cDescri		:= CriaVar("Z0_DESCR",.T.)
	nQtd 		:= CriaVar("Z0_QTD",.T.)
	nValor 		:= CriaVar("Z0_VALOR",.T.)
	nValor 		:= CriaVar("Z0_TOTAL",.T.)
		
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 300,300 PIXEL
	
		@ nLinha,010 SAY "Código" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET cCodigo SIZE 55,08 OF oDlg PIXEL //PICTURE “@R 99.999.999/9999-99”; VALID !Vazio()
		
		nLinha += 15
		@ nLinha,010 SAY "Data" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET dData SIZE 55,08 OF oDlg PIXEL
		
		nLinha += 15
		@ nLinha,010 SAY "Produto:" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET cProduto F3 "SB1" SIZE 55,08 OF oDlg PIXEL VALID fExercicio()
		
		nLinha += 15
		@ nLinha,010 SAY "Descrição:" 		SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET cDescri WHEN .F. SIZE 80,08 OF oDlg PIXEL
		
		nLinha += 15
		@ nLinha,010 SAY "Quantidade:" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET nQtd SIZE 55,08 OF oDlg PIXEL PICTURE X3PICTURE("Z0_QTD") VALID fGatilho()
		
		nLinha += 15
		@ nLinha,010 SAY "Valor:" SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET nValor SIZE 55,08 OF oDlg PIXEL PICTURE X3PICTURE("Z0_VALOR")VALID fGatilho()
		
		nLinha += 15
		@ nLinha,010 SAY "Total:" 		   			  SIZE 55,08 OF oDlg PIXEL
		@ nLinha,050 MSGET oTotal Var nTotal WHEN .F. SIZE 55,08 OF oDlg PIXEL PICTURE X3PICTURE("Z0_TOTAL")
		//CRIADO OBJETO oTotal APONTANDO PARA VARIAVEL nTotal
		
		oTotal:Hide()//OCULTA OBJETO
		
		nLinha += 15
		SButton():New( nLinha,100,02,{||oDlg:End()},oDlg,.T.,,)		//executar o método de fechar a janela dDlg
//		SButton():New( nLinha,100,02,{|| close(oDlg)},oDlg,.T.,,)	//utiliza o Include RwMake, foi substituído

		@ nLinha,60 BUTTON "Confirmar" SIZE 030, 010 PIXEL OF oDlg ACTION (fGrava(), oDlg:End()) //acionar função para uso
				
	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function Fgrava()
	MsgInfo("Gravado com sucesso", "só que não")
Return

Static Function fGatilho() //GATILHA O VALOR TOTAL USANDO OBJETO oTotal
	oTotal:Show()
	nTotal := nValor * nQtd
	oTotal:Refresh()
Return .T.
//-------------------------------------------------------------------------------------------

Static Function fGrava()
	// Exercicio fazer a gravação dos dados 
Local lINCLUIR := .F.

dbSelectArea("SZ0")
dbSetOrder(1)
lINCLUIR := MSSEEK(xFilial("SZ0")+cCodigo) 
	
RecLock("SZ0",lINCLUIR)
	
SZ1->Z0_COD    := cCodigo  
SZ1->Z0_DATA   := dData    
SZ1->Z0_PROD   := cProduto 
SZ1->Z0_QTD    := nQtd     
SZ1->Z0_VALOR  := nValor   

If lINCLUIR
	ConfirmSX8()
Else
	ROLLBACKSX8()
EndIf		
	              
msginfo("Grava do com sucesso","SóQueNão")

Return


//--------------------------------------------------------------------------------------------

Static Function fExercicio() //VALIDAR PRODUTO GATILHANDO DESCRIÇÃO
	Local lRet := .F.
	DbSelectArea("SB1")
	DbSetOrder(1)
	
	IF DbSeek(xFilial("SB1") + cProduto)
		cDescri := SB1->B1_DESC
		lRet := .T.
	Else
		MsgInfo("Produto não localizado", "Atenção!!!")
	ENDIF		
Return(lRet)

