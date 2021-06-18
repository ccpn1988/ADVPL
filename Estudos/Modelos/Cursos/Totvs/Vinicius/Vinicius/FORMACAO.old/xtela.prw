#Include 'Protheus.ch'


User Function xtela()
Static oDlg,oTotal
Local cTitulo :="Tela"
Local nLinha := 10

Private cCodigo 	as 	Char 
Private dData 		as	Date
Private cProduto 	as	Char
Private cDescri 	as	char
Private nQtd 		as	numeric
Private nValor 		as	numeric	
Private nTotal 		as	numeric

RpcSetEnv("99","01")

cCodigo		:= CriaVar("Z0_COD",.T.)
dData 		:= CriaVar("Z0_DATA",.T.)
cProduto 	:= CriaVar("Z0_PROD",.T.)
cDescri		:= CriaVar("Z0_DESCR",.T.)
nQtd		:= CriaVar("Z0_QTD",.T.)
nValor		:= CriaVar("Z0_VALOR",.T.)
nTotal		:= CriaVar("Z0_TOTAL",.T.)


//define o numero de linhas e colunas FROM 000,000 TO 080,300 PIXEL
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 500,300 PIXEL

	@ nLinha,010 SAY "Codigo:" 	SIZE 55,07 OF oDlg PIXEL
	@ nLinha,050 MSGET cCodigo 	SIZE 55,11 OF oDlg PIXEL //PICTURE “@R 99.999.999/9999-99”;
 	
 	nLinha+= 15
	@ nLinha,010 SAY "Data:" 	SIZE 55,07 OF oDlg PIXEL
	@ nLinha,050 MSGET dData 	SIZE 55,11 OF oDlg PIXEL //PICTURE “@R 99.999.999/9999-99”;
	
	nLinha+= 15
	@ nLinha,010 SAY "Produto:"					SIZE 55,07 OF oDlg PIXEL
	@ nLinha,050 MSGET cProduto 	F3 "SB1" 	SIZE 55,08 OF oDlg PIXEL //PICTURE “@R 99.999.999/9999-99”;
	
	nLinha+= 15
	@ nLinha,010 SAY "Descrição:"	SIZE 55,07 OF oDlg PIXEL
	@ nLinha,050 MSGET cDescri 		WHEN .F. SIZE 80,08 OF oDlg PIXEL //PICTURE “@R 99.999.999/9999-99”; 
	
	nLinha+= 15
	@ nLinha,010 SAY "Quantidade:"	SIZE 55,07 OF oDlg PIXEL
	@ nLinha,050 MSGET nQtd 		SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_QTD")Valid fGatilho()
	 
	nLinha+= 15
	@ nLinha,010 SAY "Valor:"		SIZE 55,07 OF oDlg PIXEL
	@ nLinha,050 MSGET nValor 		SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_VALOR")Valid fGatilho() 
	
	nLinha+= 15
	@ nLinha,010 SAY "Total:"		SIZE 55,07 OF oDlg PIXEL
	@ nLinha,050 MSGET OTotal Var nTotal 		WHEN .F. SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_TOTAL")
												//false
	nLinha+= 15
	SButton():New( nLinha,100,02,{||oDlg:End()},oDlg,.T.,,)
	@nLinha,060 BUTTON "Confirmar" SIZE 030, 011 PIXEL OF oDlg ACTION (fGrava() := 1, oDlg:End())
	
	

ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function fGrava()

MsgInfo("Gravado com sucesso","SóQueNão")

Return

Static Function fGatilho()

nTotal := nValor * nQtd	
oTotal:Refresh()
Return.T. 

Static Function Exercicio()
Local lRet := .F.
dbSelectarea("SB1")
dbSetorder(1)

 If MsSeek (xFilial("SB1")+ cProduto)
 	cDescri := SB1->B1_DESC
 	lRet := .T.
 Else
 	MsgAlert("Produto não cadastrado", "Atenção !!")
 endif
 
return(lRet)
  
  
  
 
 
 

