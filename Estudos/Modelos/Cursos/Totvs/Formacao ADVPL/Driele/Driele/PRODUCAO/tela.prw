#Include 'Protheus.ch'
#Include 'rwmake.ch'

User Function TELA()

Static oDlg ,oGetCod := NIL
Local nLinha   := 10
Local cTitulo  := "Tela"

Private cCodigo  as Char 
Private dData    as Date
Private cProduto as char
Private cDescri  as char

Private nQtd     as numeric
Private nValor   as numeric
Private nTotal   as numeric


RpcSetEnv("99","01") 

cCodigo  := CriaVar("Z0_COD"   ,.T.)
dData    := CriaVar("Z0_DATA"  ,.T.)
cProduto := CriaVar("Z0_PROD"  ,.T.)
cDescri  := CriaVar("Z0_DESCR" ,.T.)
nQtd     := CriaVar("Z0_QTD"   ,.T.)
nValor   := CriaVar("Z0_VALOR" ,.T.)
nTotal   := CriaVar("Z0_TOTAL" ,.T.)


DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 0300,300 PIXEL

	@ nLinha,010 SAY "Código:"   SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET oGetCod Var cCodigo SIZE 55,08 OF oDlg PIXEL //PICTURE "@R 99.999.999/9999-99" VALID !Vazio()
   
    nLinha+= 15
	@ nLinha,010 SAY "Data:"   SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET dData   SIZE 55,08 OF oDlg PIXEL 
 
    nLinha+= 15
	@ nLinha,010 SAY "Produto:"            SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET cProduto   F3 "SB1" SIZE 55,08 OF oDlg PIXEL  Valid fGrava()
 
    nLinha+= 15
	@ nLinha,010 SAY "Descrição:"           SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET cDescri     WHEN .F. SIZE 80,08 OF oDlg PIXEL 
 
	nLinha+= 15
	@ nLinha,010 SAY "Quantidade:"   SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET nQtd          SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_QTD") Valid fGatilho()
 	
 	nLinha+= 15
	@ nLinha,010 SAY "Valor:"   SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET nValor   SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_VALOR") Valid fGatilho()
 	
 	nLinha+= 15
	@ nLinha,010 SAY "Total:"            SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET oTotal var nTotal WHEN .F.  SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("ZZ0_TOTAL")
 	oTotal:Hide()
	
	nLinha+=30
	SButton():New(nLinha,40,02,{||oDlg:End()},oDlg,.T.,,)
     //	                                lar  alt
	@nLinha,080 BUTTON "Confirmar" SIZE 030, 010 PIXEL OF oDlg ACTION (fGrava(),oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED
Return
//----------------------------------------------------------------------------------

Static Function fGrava()
		// Exercicio fazer a gravação dos dados 
Local lINCLUIR := .F.

dbSelectArea("SZ0")
dbSetOrder(1)
lINCLUIR := MSSEEK(xFilial("SZ0")+cCodigo) 
	
RecLock("SZ0", ! lINCLUIR)
	
SZ0->Z0_COD    := cCodigo  
SZ0->Z0_DATA   := dData    
SZ0->Z0_PROD   := cProduto 
SZ0->Z0_QTD    := nQtd     
SZ0->Z0_VALOR  := nValor   

If lINCLUIR
	ConfirmSX8()
Else
	ROLLBACKSX8()
EndIf	
MsUnlock()	
Return
//----------------------------------------------------------------------------------

Static Function fGatilho()
    oTotal:Show()
	nTotal:=nValor *nQtd
	oTotal:Refresh()
Return .T.
//----------------------------------------------------------------------------------