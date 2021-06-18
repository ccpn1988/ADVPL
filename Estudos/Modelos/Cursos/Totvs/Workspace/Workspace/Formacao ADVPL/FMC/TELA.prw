#Include 'Protheus.ch'
#Include 'rwmake.ch' //Legado do Protheus10

User Function TELA()

	Static oDlg,oGetCod,oTotal,oProd
	Local	nLinha	:= 10
	Local	cTitulo	:= "Tela" 
	Private cCodigo	 as char 
	Private cProduto as char 
	Private cDescri	 as char
	Private nQtd	 as numeric	 
	Private nValor	 as numeric
	Private nTotal	 as numeric
	Private dData	 as date

	RpcSetEnv("99","01")
	
	cCodigo 	:= CriaVar("Z0_COD"		,.T.)
	cProduto	:= CriaVar("Z0_PROD"	,.T.)
	cDescri		:= CriaVar("Z0_DESCR"	,.T.)
	nQtd		:= CriaVar("Z0_QTD"		,.T.)
	nValor		:= CriaVar("Z0_VALOR"	,.T.)
	nTotal		:= CriaVar("Z0_TOTAL"	,.T.)
	dData		:= CriaVar("Z0_DATA"	,.T.)
	
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 300,300 PIXEL

	@ nLinha,010 SAY  "CÛdigo:"		SIZE 055,008 OF oDlg PIXEL //OF significa que este label pertende ao objeto oDlg	 
	@ nLinha,050 MSGET oGetCod Var cCodigo	SIZE 055,008 OF oDlg PIXEL //PICTURE ì@R 99.999.999/9999-99î	VALID !Vazio()

	nLinha += 15
	@ nLinha,010 SAY  "Data:" 		SIZE 055,008 OF oDlg PIXEL //OF significa que este label pertende ao objeto oDlg	 
	@ nLinha,050 MSGET dData    	SIZE 055,008 OF oDlg PIXEL //PICTURE ì@R 99.999.999/9999-99î	VALID !Vazio()	

	nLinha += 15
	@ nLinha,010 SAY  "Produto:"	SIZE 055,008 OF oDlg PIXEL //OF significa que este label pertende ao objeto oDlg	 
	@ nLinha,050 MSGET oProd Var cProduto F3 "SB1" SIZE 055,008 OF oDlg PIXEL Valid fExercicio()
	
	nLinha += 15
	@ nLinha,010 SAY  "DescriÁ„o:"	SIZE 055,008 OF oDlg PIXEL //OF significa que este label pertende ao objeto oDlg	 
	@ nLinha,050 MSGET oDesc Var cDescri WHEN .F. SIZE 080,008 OF oDlg PIXEL //PICTURE ì@R 99.999.999/9999-99î	VALID !Vazio()

	nLinha += 15
	@ nLinha,010 SAY  "Quantidade:"	SIZE 055,008 OF oDlg PIXEL //OF significa que este label pertende ao objeto oDlg	 
	@ nLinha,050 MSGET nQtd			SIZE 055,008 OF oDlg PIXEL PICTURE X3Picture("Z0_QTD"  ) VALID fGatilho()
	
	nLinha += 15
	@ nLinha,010 SAY   "Valor:"		SIZE 055,008 OF oDlg PIXEL //OF significa que este label pertende ao objeto oDlg	 
	@ nLinha,050 MSGET nValor		SIZE 055,008 OF oDlg PIXEL PICTURE X3Picture("Z0_VALOR") VALID fGatilho()
	
	nLinha += 15
	@ nLinha,010 SAY   "Total:"		SIZE 055,008 OF oDlg PIXEL //OF significa que este label pertende ao objeto oDlg	 
	@ nLinha,050 MSGET oTotal Var nTotal WHEN .F. SIZE 055,008 OF oDlg PIXEL PICTURE X3Picture("Z0_TOTAL")
	
	oTotal:Hide()
	
	nLinha += 15
	SButton():New( nLinha,100,02,{||/*oDlg:End(),*/Close(oDlg)},oDlg,.T.,,)
	@ nLinha,60 BUTTON "Confirmar" 	SIZE 030,011 PIXEL OF oDlg ACTION (fGrava(),oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED

Return

//----------------------------------------------------------------------------------------------------------------------

Static Function fExercicio()
	Local lRet := .F.
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	If MsSeek(xFilial("SB1")+AvKey(cProduto,"B1_COD"))
		cDescri := SB1->B1_DESC
		lRet := .T.
	Else
		MsgInfo("Este produto " + cProduto + " n„o existe!","Cadastro de Produtos")
		lRet := .F.
		cProduto := ""
		oProd:Refresh()
		cDescri := ""
		oDesc:Refresh()
	EndIf
	
Return lRet

//----------------------------------------------------------------------------------------------------------------------

Static Function fGatilho()
	oTotal:Show()
	nTotal := nValor * nQtd
	oTotal:Refresh()
Return .T.

//----------------------------------------------------------------------------------------------------------------------

Static Function fGrava()
	Local lALTERAR	:= .F.
	
	dbSelectArea("SZ0")
	dbSetOrder(1)
	
	lALTERAR := MSSEEK(xFilial("SZ0")+cCodigo)

	RecLock("SZ0",! lALTERAR)
	
	SZ0->Z0_COD	  := cCodigo
	SZ0->Z0_PROD  := dData
	SZ0->Z0_DESCR := cProduto
	SZ0->Z0_QTD	  := nQtd
	SZ0->Z0_VALOR := nValor
	
	MsUnLock() 	

	If lALTERAR
		RollBackSX8()
	Else
		ConfirmSX8()
	EndIf
	
	MsUnLock()

	MsgInfo("Gravado com sucesso","SÛQueN„o")
	
Return

