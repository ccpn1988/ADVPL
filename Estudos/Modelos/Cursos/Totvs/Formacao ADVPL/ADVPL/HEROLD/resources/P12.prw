#Include 'TOTVS.ch'
#include "rwmake.ch"

User Function TELA()
Static oDlg ,oGetCod,oTotal := NIL
Local nLinha   := 10
Local cTitulo  := "Tela"

Private cCodigo  as Char 
Private dData    as Date
Private cProduto as char
Private cDescri  as char

Private nQtd     as numeric
Private nValor   as numeric
Private nTotal   as numeric
Private aSize := MsAdvSize(.F.)

RpcSetEnv("99","01") 

cCodigo  := CriaVar("Z0_COD"   ,.T.)
dData    := CriaVar("Z0_DATA"  ,.T.)
cProduto := CriaVar("Z0_PROD"  ,.T.)
cDescri  := CriaVar("Z0_DESCR" ,.T.)
nQtd     := CriaVar("Z0_QTD"   ,.T.)
nValor   := CriaVar("Z0_VALOR" ,.T.)
nTotal   := CriaVar("Z0_TOTAL" ,.T.)


DEFINE MSDIALOG oDlg TITLE cTitulo FROM  aSize[7],aSize[4] To aSize[6],aSize[5]  PIXEL

	@ nLinha,010 SAY "Código:"   SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET oGetCod Var cCodigo SIZE 55,08 OF oDlg PIXEL //PICTURE "@R 99.999.999/9999-99" VALID !Vazio()
   
   nLinha+= 15
	@ nLinha,010 SAY "Data:"   SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET dData   SIZE 55,08 OF oDlg PIXEL 
 
    nLinha+= 15
	@ nLinha,010 SAY "Produto:"            SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET cProduto   F3 "SB1" SIZE 55,08 OF oDlg PIXEL Valid Exercicio()
 
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
	@ nLinha,050 MSGET oTotal Var nTotal   WHEN .F. SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_TOTAL")
 	
 	oTotal:Hide()
 	
 	nLinha += 15
	SButton():New( nLinha,100,02,{||/*oDlg:End(),*/close(oDlg) },oDlg,.T.,,)
 	@nLinha,060 BUTTON "Confirmar" SIZE 030, 011 PIXEL OF oDlg ACTION (fGrava(), oDlg:End())

 	

ACTIVATE MSDIALOG oDlg CENTERED




Return
//----------------------------------------------------------------------------------

Static Function fGatilho()
oTotal:Show()
nTotal := nValor * nQtd
oTotal:Refresh()

Return .T.
//----------------------------------------------------------------------------------



Static Function fGrava()
	// Exercicio fazer a gravação dos dados 
Local lINCLUIR := .F.

dbSelectArea("SZ0")
dbSetOrder(1)
lINCLUIR := MSSEEK(xFilial("SZ0")+cCodigo) 
		
RecLock("SZ0",! lINCLUIR)
		
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
MsUnLock()
msginfo("Grava do com sucesso","SóQueNão")

Return
//----------------------------------------------------------------------------------

Static Function Exercicio()
Local lRet := .F.
dbSelectArea("SB1")
dbSetorder(1)

If MsSeek(xFilial("SB1")+cProduto)	
	cDescri := SB1->B1_DESC
	lRet := .T.
Else
	MsgAlert("Produto não localizado","Atenção !!")	
EndIf

Return(lRet)
