#include "rwmake.ch"


user function XCADO02()

	Local cAlias := "SZ0"
	Local aColors := {}
	private cCadastro := "Cadastro de Sucata"
	

	aRotina := {;
		{ "Pesquisar",  "AxPesqui",  0, 1},;
		{ "Visualizar", "AxVisual",  0, 2},;
		{ "Incluir",    "U_INCSZ0",  0, 3},;
		{ "Alterar",    "U_INCSZ0",  0, 4},;
		{ "Exlcuir",    "U_INCSZ0",  0, 5},;
		{ "Legenda",    "U_LEGSZ01", 0, 7};
		}
	
	aAdd(aColors,{"Z0_ATIVO=='S'","BR_MARRON"})
	aAdd(aColors,{"Z0_ATIVO=='N'","BR_PINK"})

	dbSelectArea(cAlias)
		
	mBrowse( , , , , cAlias,/*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/, /*<cCorFun>*/,4 /*<nClickDef>*/, aColors)
return (NIL)

User Function LEGSZ01 ()

	Local aLegenda := {}

	aAdd(aLegenda,{"BR_MARRON","ATIVO"})
	aAdd(aLegenda,{"BR_PINK","DESATIVO"})

	BrwLegenda (cCadastro,"Legenda",aLegenda )

return ( NIL )

//----------------------

User Function INCSZ0 (cAlias, nReg, nOpc)

	Static oDlg
	Local oSize
	Private aGets := {}
	Private aTela := {}

// Calcula as dimensoes dos objetos                                         
	oSize := FwDefSize():New( .T. ) // Com enchoicebar
	oSize:lLateral     := .F.  // Calculo vertical
// adiciona Enchoice                                                          
	oSize:AddObject( "TELA", 100, 100, .T., .T. ) // Adiciona enchoice
// Dispara o calculo                                                     
	oSize:Process()

	aPos:= {oSize:GetDimension("TELA", "LININI"),;
		oSize:GetDimension("TELA", "COLINI"),;
		oSize:GetDimension("TELA", "LINEND"),;
		oSize:GetDimension("TELA", "COLEND")}
        
	RegToMemory (cAlias, nOpc == 3) //Tratamento para inclusão x alteração
        
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM   oSize:aWindSize[1],;
		oSize:aWindSize[2];
		TO;
		oSize:aWindSize[3],;
		oSize:aWindSize[4] ;
		PIXEL

	Enchoice (cAlias ,nReg , nOpc , /*aCRA*/,  /*cLetras*/ ,/* cTexto*/ , /*aAcho*/, aPos)

//ACTIVATE MSDIALOG oDlg CENTERED

	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| IIF ( Obrigatorio (aGets,aTela),;
		(fGrava(cAlias, nOpc),oDlg:End());
		,NIL)},;
		{||oDlg:End(),;
		ROLLBACKSX8()}))

return ( NIL )

Static Function fGrava(cAlias, nOpc)
		// Exercicio fazer a gravação dos dados 
	Local lINCLUIR := .F.

	dbSelectArea(cAlias)
	dbSetOrder(1)

	lINCLUIR := MSSEEK(xFilial(cAlias)+M->Z0_COD)
	
	if nOpc == 3
		RecLock(cAlias,.T.)
		For nCampo := 1 To (cAlias)->( fCount())//Quantidade de campo no SX3
			If "FILIAL" $ FieldName (nCampo)
				FieldPut (nCampo, xFilial (cAlias))
			Else
				FieldPut (nCampo, M->&(FieldName (nCampo)))
			Endif
		Next nCampo

		ConfirmSX8()
		MSUnlock()
		MsgInfo ("Gravação Realizada com Sucesso")
        
	Elseif nOpc == 4
		RecLock(cAlias,.F.)
		For nCampo := 1 To (cAlias)->( fCount())//Quantidade de campo no SX3
			If "FILIAL" $ FieldName (nCampo)
				FieldPut (nCampo, xFilial (cAlias))
			Else
				FieldPut (nCampo, M->&(FieldName (nCampo)))
			Endif
		Next nCampo
		MSUnlock()
		MsgInfo ("Alteração Realizada com Sucesso")
        
	Elseif nOpc ==5
        
		RecLock(cAlias,.F.)
		dbDelete ()
		MSUnlock()
		MsgInfo ("Excluído Realizada com Sucesso")
	Endif
return

