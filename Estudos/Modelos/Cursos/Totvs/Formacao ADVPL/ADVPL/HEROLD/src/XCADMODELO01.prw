#INCLUDE "RWMAKE.CH"


//------------------------------------------------------------------------------------------
User Function XCADMODELO01()
	
	Local cAlias  := "SZ0"
	Local aColors := {}
	Private cCadastro := "Cadastro de Sucata"
	
	aRotina := {;
		{ "Pesquisar" , "AxPesqui", 0, 1},;
		{ "Visualizar", "U_INCSZ0", 0, 2},;
		{ "Incluir"   , "U_INCSZ0", 0, 3},;
		{ "Alterar"   , "U_INCSZ0", 0, 4},;
		{ "Excluir"   , "U_INCSZ0", 0, 5},;
		{ "Legenda"   , "U_LEGSZ0", 0, 7};
		}

	aAdd(aColors,{"Z0_ATIVO=='S'","BR_MARRON"   })
//aAdd(aColors,{"Z0_ATIVO=='S'","BR_VERDE"})
	aAdd(aColors,{"Z0_ATIVO=='N'","BR_PINK" })

	
	dbSelectArea(cAlias)
//	mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>)
	mBrowse(  , , , , cAlias,/*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/, /*"Z0_ATIVO=='S'" <cCorFun>*/, 3 /*<nClickDef>*/, aColors)
	
Return( NIL )
//-----------------------------------------------------------------------------------------------

User Function LEGSZ0()
	Local aLegenda := {}

	aAdd(aLegenda,{"BR_MARRON","Ativo"        } )
	aAdd(aLegenda,{"BR_PINK"  ,"Desativado"   } )

	BrwLegenda( cCadastro, "Legenda", aLegenda )

Return( NIL )
//------------------------------------------------------------------------------------

User Function INCSZ0(cAlias,nReg,nOpc)

/*cAlias = Nome da ·rea de trabalho definida para a mBrowse;
nReg  = N˙mero (Recno) do registro posicionado na mBrowse;
nOpc  = PosiÁ„o da opÁ„o utilizada na mBrowse, de acordo com a ordem da funÁ„o no array aRotina.
*/
	Static oDlg
	Private aGets := {}
	Private aTela := {}



	oSize := FwDefSize():New( .T. ) // Com enchoicebar
	oSize:lLateral     := .F.  // Calculo vertical
// adiciona Enchoice                                                          
	oSize:AddObject( "TELA", 100, 100, .T., .T. ) // Adiciona enchoice
// Dispara o calculo                                                     
	oSize:Process()

	aPos :={oSize:GetDimension("TELA","LININI"),;
		oSize:GetDimension("TELA","COLINI"),;
		oSize:GetDimension("TELA","LINEND"),;
		oSize:GetDimension("TELA","COLEND")}
          


 
	RegToMemory(cAlias, nOpc == 3 )


	DEFINE MSDIALOG oDlg TITLE cCadastro FROM  oSize:aWindSize[1],;
		oSize:aWindSize[2] ;
		To ;
		oSize:aWindSize[3],;
		oSize:aWindSize[4] ;
		PIXEL

	Enchoice( cAlias, nReg, nOpc, /*aCRA*/, /*cLetras*/,  /*cTexto*/, /*aAcho*/,aPos)

//ACTIVATE MSDIALOG oDlg CENTERED
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar( oDlg, {|| IIF( obrigatorio(aGets,aTela) ,;
		(FGrava(cAlias,nOpc),;
		oDlg:End()), NIL )},;
		{||oDlg:End(),ROLLBACKSX8()}/*,,@aButtons*/))

Return( NIL )
//------------------------------------------------------------------------------------


Static Function fGrava(cAlias,nOpc)
	// Exercicio fazer a gravaÁ„o dos dados 

	Local lINCLUIR := .F.

	If nOpc == 3
		RecLock(cAlias,.T. )
		For nCampo := 1 To (cAlias)->( fCount() ) // Quantidade de campo no SX3
		    //(cAlias)->&(FieldName(nCampo)) :=   M->&(FieldName(nCampo))
			If "FILIAL" $ FieldName(nCampo)
				FieldPut(nCampo,  xFilial(cAlias))
			Else
				FieldPut(nCampo,  M->&(FieldName(nCampo)))
			Endif
		    
		Next nCampo
	
		ConfirmSX8()

		MsUnLock()
		msginfo("Grava do com sucesso","SÛQueN„o")

	ElseIf nOpc == 4

		RecLock("SZ0",.F. )
		For nCampo := 1 To (cAlias)->( fCount() ) // Quantidade de campo no SX3
		    //(cAlias)->&(FieldName(nCampo)) :=   M->&(FieldName(nCampo))
			If "FILIAL" $ FieldName(nCampo)
				FieldPut(nCampo,  xFilial(cAlias))
			Else
				FieldPut(nCampo,  M->&(FieldName(nCampo)))
			Endif
		    
		Next nCampo
		MsUnLock()
		msginfo("Grava do com sucesso","SÛQueN„o")

	ElseIf nOpc == 5

		RecLock("SZ0",.F. )
		dbDelete()
			MsUnLock()
		msginfo("Excluido com sucesso","SÛQueN„o")
	EndIf

Return
















