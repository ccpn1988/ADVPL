
#include "rwmake.ch"

user function XCADMODELO1()
	
	local cAlias := "SZ0"
	Local aColors := {}
	private cCadastro := "Cadastro de Sucata"

	
	aRotina :=	{;
				{ "Pesquisar", "AxPesqui", 0, 1},;
				{ "Visualizar", "U_INCSZ0", 0, 2},;
				{ "Incluir", "U_INCSZ0", 0, 3},;
				{ "Alterar", "U_INCSZ0", 0, 4},;
				{ "Exlcuir", "U_INCSZ0", 0, 5},;
				{ "Legenda", "U_LEGSZ0", 0, 7};
				}
aAdd(aColors,{"Z0_ATIVO=='S'","BR_MARRON"})
//aAdd(aColors,{"Z0_ATIVO=='S'","BR_VERDE"})
aAdd(aColors,{"Z0_ATIVO=='N'","BR_PINK"})

	dbSelectArea(cAlias)
	//mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>
	mBrowse( , , , , cAlias,/*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/, /*"Z0_ATIVO=='S'"*//*<cCorFun>*/, 4 /*<nClickDef>*/, aColors)
	
	
return

USER FUNCTION LEGSZ0()
LOCAL aLegenda:= {}
aAdd(aLegenda,{"BR_MARRON","Ativo"})
aAdd(aLegenda,{"BR_PINK", "Desativado"})
BrwLegenda ( cCadastro, "Legenda" ,aLegenda)

Return(NIL)


User Function INCSZ0(cAlias,nReg,nOpc)

Static oDlg
Private aGets :={}
Private aTela :={}

oSize := FwDefSize():New( .T. ) // Com enchoicebar
oSize:lLateral     := .F.  // Calculo vertical
oSize:AddObject( "TELA", 100, 100, .T., .T. ) // Adiciona enchoice
oSize:Process()

aPos:={oSize:GetDimension("TELA","LININI"),;
		oSize:GetDimension("TELA","COLINI"),;
		oSize:GetDimension("TELA","LINEND"),;
		oSize:GetDimension("TELA","COLEND")}

RegToMemory(cAlias,nOpc==3)



/*For nCampo :=1 To (cAlias)->(fCount() ) //Quantidade de campo no SX3
	M->(FieldName(nCampo)) := CriarVar(FielsName (nCampo),.T.)
Next nCampo*/

		
/*M->Z0_COD		:= CriaVar("Z0_COD",.T.)
M->Z0_DATA 		:= CriaVar("Z0_DATA",.T.)
M->Z0_PROD	 	:= CriaVar("Z0_PROD",.T.)
M->Z0_DESCR		:= CriaVar("Z0_DESCR",.T.)
M->Z0_QTD		:= CriaVar("Z0_QTD",.T.)
M->Z0_VALOR		:= CriaVar("Z0_VALOR",.T.)
M->Z0_TOTAL		:= CriaVar("Z0_TOTAL",.T.)*/


DEFINE MSDIALOG oDlg TITLE cCadastro FROM oSize:aWindSize[1],oSize:aWindSize[2] To oSize:aWindSize[3],oSize:aWindSize[4] PIXEL
Enchoice( cAlias, nReg, nOpc, /*aCRA*/, /*cLetras*/, /*cTexto*/, /*aAcho*/, aPos)

// PAGINA 218

//ACTIVATE MSDIALOG oDlg CENTERED
ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||IIF(obrigatorio(aGets,aTela) ,;
												 (fGrava(cAlias,nOpc),oDlg:End()),;
												 NIL )},;
												 {||oDlg:End(),ROLLBACKSX8()}))

return (NIL)

Static Function fGrava(cAlias,nOpc)

Local lINCLUIR:= .F.
dbSelectArea("SZ0")
dbSetOrder(1)

lINCLUIR := MSSEEK(xFilial("SZ0")+M->Z0_COD)

RecLock("SZ0",!lINCLUIR)

For nCampo := 1 To (cAlias)->(fCount() ) //Quantidade de campo no SX3
	
	if "FILIAL" $ FieldName(nCampo)
		FieldPut(nCampo, xFilial(cAlias))
	Else
		FieldPut(nCampo, M->&(FieldName(nCampo))) 
	Endif
	
Next nCampo
	
	/*SZ0->Z0_FILIAL 	:= xFilial("SZ0")
	SZ0->Z0_COD		:= M->Z0_COD
	SZ0->Z0_DATA	:= M->Z0_DATA
	SZ0->Z0_PROD	:= M->Z0_PROD
	SZ0->Z0_QTD		:= M->Z0_QTD
	SZ0->Z0_VALOR	:= M->Z0_VALOR*/
	
	If !lINCLUIR
		ConfirmSX8()
	Else
		ROLLBACKSX8()
	EndIf
	
MsUnlock()
MsgInfo("Gravado com sucesso")
//_____________________________________________________________

If nOpc ==3
RecLock("SZ0",.T.)

For nCampo := 1 To (cAlias)->(fCount() ) //Quantidade de campo no SX3
	
	if "FILIAL" $ FieldName(nCampo)
		FieldPut(nCampo, xFilial(cAlias))
	Else
		FieldPut(nCampo, M->&(FieldName(nCampo))) 
	Endif
	
Next nCampo
	
	ConfirmSX8()
	
	MsUnlock()
MsgInfo("Gravado com sucesso")

//_______________________________________________________________

ElseIf nOpc ==4
RecLock("SZ0",!lINCLUIR)

For nCampo := 1 To (cAlias)->(fCount() ) //Quantidade de campo no SX3
	
	if "FILIAL" $ FieldName(nCampo)
		FieldPut(nCampo, xFilial(cAlias))
	Else
		FieldPut(nCampo, M->&(FieldName(nCampo))) 
	Endif
	
Next nCampo
		
	ConfirmSX8()
	MsUnlock()
MsgInfo("Gravado com sucesso")
//______________________________________________________________

ElseIf nOpc ==5
RecLock("SZ0",.F.)
	dbDelete()	
MsUnlock()
MsgInfo("Excluido com sucesso")	
Endif
Return (Nil)