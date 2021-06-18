#Include 'TOTVS.ch'
#include "rwmake.ch"

User Function XTELA01()
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
	@ nLinha,050 MSGET cProduto   F3 "SB1" SIZE 55,08 OF oDlg PIXEL 
 
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
	@ nLinha,050 MSGET nTotal   WHEN .F. SIZE 55,08 OF oDlg PIXEL PICTURE X3Picture("Z0_TOTAL")
 	
 	
 	nLinha += 15
	SButton():New( nLinha,100,02,{||/*oDlg:End(),*/close(oDlg) },oDlg,.T.,,)
 	@nLinha,060 BUTTON "Confirmar" SIZE 030, 011 PIXEL OF oDlg ACTION (fGrava(), oDlg:End())

 	

ACTIVATE MSDIALOG oDlg CENTERED
Return
//----------------------------------------------------------------------------------

Static Function fGrava()
	msginfo("Gravado com sucesso","SóQueNão")

Return
//----------------------------------------------------------------------------------




Static Function fGatilho()

nTotal := nValor * nQtd

Return .T.
















