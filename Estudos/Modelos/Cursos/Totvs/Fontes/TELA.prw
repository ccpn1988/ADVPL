#Include 'Protheus.ch'

User Function TELA()

//Local cTexto :=OEMTOANSI(“Total da Nota”)
Static oDlg, oGet  // Static nao consigo mudar o valor mas enxerga no prw inteiro
Local nLinha   := 10
Local cTitulo  := "Tela"
Local cCodigo  as Char
Local dData    as Date
Local cProduto as char
Local cDescri  as char
Private nQtd   as numeric 
Private nValor as numeric 
Private nTotal as numeric

RpcSetEnv("99","01") // nao precisa colocar no menu

cCodigo  := criavar("Z0_COD"   ,.T. )//  .t. pegar o sequencial do banco
dData    := criavar("Z0_DATA"  ,.T. )
cProduto := criavar("Z0_PROD"  ,.T. )
cDescri  := criavar("Z0_DESCR" ,.T. )
nQtd     := criavar("Z0_QTD"   ,.T. )
nValor   := criavar("Z0_VALOR" ,.T. )
nTotal   := criavar("Z0_TOTAL" ,.T. )

                                    // LINI COLI  LINF COLF
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 300,300 PIXEL
    //lin  col                  lar alt     
	@ nLinha,010 SAY "Código" SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET cCodigo SIZE 55,08 OF oDlg PIXEL //PICTURE “@R 99.999.999/9999-99”;
	
	nLinha+=15
	@ nLinha,010 SAY "Data" SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET dData SIZE 55,08 OF oDlg PIXEL
	
	nLinha+=15
	@ nLinha,010 SAY "Produto" SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET cProduto F3 "SB1" SIZE 55,08 OF oDlg PIXEL  
	
	nLinha+=15
	@ nLinha,010 SAY "Descrição" SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET cDescri WHEN .F. SIZE 80,08 OF oDlg PIXEL 
	
	nLinha+=15
	@ nLinha,010 SAY "Quantidade" SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET nQtd SIZE 80,08 OF oDlg PIXEL PICTURE X3Picture("Z0_QTD") Valid fGatilho()
	
	nLinha+=15
	@ nLinha,010 SAY "Valor" SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET nValor SIZE 80,08 OF oDlg PIXEL  PICTURE X3Picture("Z0_VALOR") Valid fGatilho()
	
	nLinha+=15
	@ nLinha,010 SAY "Total" SIZE 55,08 OF oDlg PIXEL
	@ nLinha,050 MSGET oTotal var nTotal WHEN .F. SIZE 80,08 OF oDlg PIXEL PICTURE X3Picture("Z0_VALOR")
	
	oTotal:Hide()
	
	nLinha+=30
	SButton():New(nLinha,40,02,{||oDlg:End()},oDlg,.T.,,)
     //	                                lar  alt
	@nLinha,080 BUTTON "Confirmar" SIZE 030, 010 PIXEL OF oDlg ACTION (fGrava(),oDlg:End())

 ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function fGrava()
	msginfo("Gravado com Sucesso", "SóQueNão")
$Return

Static Function fGatilho()
    oTotal:Show()
	nTotal:=nValor *nQtd
	oTotal:Refresh()
Return .T.
