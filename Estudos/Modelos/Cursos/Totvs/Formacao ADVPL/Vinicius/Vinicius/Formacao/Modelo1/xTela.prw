#Include 'Protheus.ch'
/*BIBLIOTECA PROTHEUS È A MAIS NOVA*/

User Function xTela()

Static oDlg
Local cTitulo := "Tela da tabela Z0"
Local nLinha := 10

Private dData as Date
Private cDescricao as char
Private cProduto as char
Private cCodigo as char

Private nValor as numeric
Private nQuantidade as numeric
Private nTotal as numeric

/*PREPARA BANCO PARA NÂO PRECISAR TRABALHAR COM MENU*/
RpcSetEnv("99","01")

cCodigo := CriaVar("Z0_COD",.T.)
dData := CriaVar("Z0_DATA",.T.)
cProduto := CriaVar("Z0_PROD",.T.)
cDescricao := CriaVar("Z0_DESCR",.T.)
nQuantidade := CriaVar("Z0_QTD",.T.)
nValor := CriaVar("Z0_VALOR",.T.)
nTotal := CriaVar("Z0_TOTAL",.T.)
 
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 350,300 PIXEL

@ nLinha,010 SAY "Codigo" SIZE 55,11 OF oDlg PIXEL 
@ nLinha,050 MSGET cCodigo SIZE 45,11 OF oDlg PIXEL

nLinha += 20
@ nLinha,010 SAY "Data" SIZE 55,11 OF oDlg PIXEL 
@ nLinha,050 MSGET dData SIZE 55,11 OF oDlg PIXEL

nLinha += 20
/*INSERINDO CONSULTA PADRÂO F3*/
@ nLinha,010 SAY "Produto" SIZE 55,11 OF oDlg PIXEL 
@ nLinha,050 MSGET cProduto  F3 "SB1" SIZE 45,11 OF oDlg PIXEL Valid fGatilhoDesc()

nLinha += 20
/*NÂO PERMITINDO EDIÇÂO DO CAMPO ATRAVES DO WHEN*/
@ nLinha,010 SAY "Descrição" SIZE 55,11 OF oDlg PIXEL 
@ nLinha,050 MSGET cDescricao WHEN .F. SIZE 85,11 OF oDlg PIXEL

nLinha += 20
/*COLOVANDO UMA MASCARA NO CAMPO PARTINDO DA MASCARA DO BANCO PICTURE X3Picture("CAMPO")*/
@ nLinha,010 SAY "Quantidade" SIZE 55,11 OF oDlg PIXEL 
@ nLinha,050 MSGET nQuantidade SIZE 25,11 OF oDlg PIXEL PICTURE X3Picture("Z0_QTD") Valid fGatilho()

nLinha += 20
/*CRIANDO UM GATILHO PARA O CAMPO Valid fGatilho()*/
@ nLinha,010 SAY "Valor" SIZE 55,11 OF oDlg PIXEL 
@ nLinha,050 MSGET nValor SIZE 45,11 OF oDlg PIXEL PICTURE  X3Picture("Z0_VALOR") Valid fGatilho()

nLinha += 20
@ nLinha,010 SAY "Total" SIZE 55,11 OF oDlg PIXEL 
@ nLinha,050 MSGET nTotal WHEN .F. SIZE 45,11 OF oDlg PIXEL PICTURE X3Picture("Z0_TOTAL")

nLinha += 20
/* Close(oDlg)-  Outra OPÇÂO DE ENCERRAR O DIALOG - POREM PRECISA DO INCLUDE RWMAKE.CH*/
/*@ informa que o componente pertence a tela*/
@ nLinha,50 BUTTON "Confirmar" SIZE 040, 11 PIXEL OF oDlg ACTION (fGrava(), oDlg:End(), MsgInfo(X3Picture("Z0_VALOR"),"MASCARA"))
SButton():New( nLinha ,100,02,{||oDlg:End()},oDlg,.T.,"Teste",)

ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function fGrava()
	
	Local lINCLUIR := .F.
	dbSelectArea("SZ0")
	dbSetOrder(1)
	
	lINCLUIR := MsSeek(xFilial("SZ0") + cCodigo)
	RecLock("SZ0",!lINCLUIR) //INCLUIR
	
	SZ0->Z0_FILIAL := xFilial("SZ0")
	SZ0->Z0_COD :=  cCodigo
	SZ0->Z0_DATA := dData
	SZ0->Z0_PROD := cProduto
	SZ0->Z0_NOME := cDescricao
	SZ0->Z0_QTD :=  nQuantidade
	SZ0->Z0_VALOR := nValor	
		
	if lIncluir
		ConfirmSX8()
	else
		ROLLBACKSX8()
	endIf
		 
	MsUnlock() //LIBERA O REGISTRO 	
	MsgInfo("Gravado com sucesso!","Gravando")	
return 

Static Function fGatilho()
	nTotal := nValor * nQuantidade
return .T.

Static Function fGatilhoDesc()
	Local lRet := .F.
	
	dbSelectArea("SB1")
	DbSetOrder(1)
	
	if MsSeek(xFilial("SB1") + cProduto)
		cDescricao := SB1->B1_DESC
		lRet = .T.
	else
		cDescricao := ""
		/* NÂO MOSTRA NA TELA POIS ESTAVA RODANDO O RPCSETEV */
		MsgInfo("Código não Localizado!")	
	EndIf
	
return (lRet)
