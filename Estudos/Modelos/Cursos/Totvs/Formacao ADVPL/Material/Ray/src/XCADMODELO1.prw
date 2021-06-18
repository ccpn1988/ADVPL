#include "rwmake.ch"


//------------------------------------------------------------------------------------------
user Function xCadModelo1()
	
	Local cAlias := "SZ0"
	
//	chkFile(cAlias) - Torna a tabela exclusiva

	private cCadastro := "Cadastro de Sucata"
	private aColors := {}
	
	aRotina := 	{;
				{ "Pesquisar",	"AxPesqui", 0, 1},;
				{ "Visualizar",	"AxVisual", 0, 2},;
				{ "Incluir",	"U_INCSZ0", 0, 3},;
				{ "Alterar",	"AxAltera", 0, 4},;
				{ "Exlcuir", 	"AxDeleta", 0, 5},;
				{ "Legenda", 	"U_LEGSZ0", 0, 7};
				}
				
	aAdd(aColors,{"Z0_ATIVO=='S'", "VERDE"})
	aAdd(aColors,{"Z0_ATIVO=='S'", "BR_VERDE"})
	aAdd(aColors,{"Z0_ATIVO=='N'", "BR_PINK"})

	dbSelectArea(cAlias)
//	mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>)
	mBrowse( , , , , cAlias, /*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/, /*"Z0_ATIVO=='S'" <cCorFun>*/, 4 /*<nClickDef>*/, aColors)
	
	
return(NIL)


//-----------------------------------------------------
User Function LEGSZ0()
	Local aLegenda := {}
	
	aAdd(aLegenda, {"BR_MARRON"	,	"Ativo"		})
	aAdd(aLegenda, {"BR_PINK"	,	"Desativado"})
	
	BrwLegenda( cCadastro, "Legenda", aLegenda )
Return

//-----------------------------------------------------
User Function INCSZ0(cAlias, nReg, nOpc)

	/*cAlias = Nome da área de trabalho definida para a mBrowse;
	nReg  = Número (Recno) do registro posicionado na mBrowse;
	nOpc  = Posição da opção utilizada na mBrowse, de acordo com a ordem da função no array aRotina.*/
	
	Static oDlg //Pagina 218 da apostila
	Private aGets := {} //definir a obrigatoriedadde da variável
	Private aTela := {} 
	
	oSize := FwDefSize():New( .T. ) // Com enchoicebar

	oSize:lLateral     := .F.  // Calculo vertical
	oSize:AddObject( "TELA", 100, 100, .T., .T. ) // Adiciona enchoice
	oSize:Process()
		
	aPos := {oSize:GetDimension("TELA","LININI"),;
			oSize:GetDimension("TELA","COLINI"),;
			oSize:GetDimension("TELA","LINEND"),;
			oSize:GetDimension("TELA","COLEND");
			}
	
	RegToMemory(cAlias)
	
	/*	For nCampo := 1 To (cAlias) -> (fCount()) //Quantidade de campo no SX3
			M->&(FieldName(nCampo))	:=	CriaVar(FieldName(nCampo),.T.) //Macrosubstituição da string para o campo (tira aspas)
		Next nCampo
	*/
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM  oSize:aWindSize[1],;
											   oSize:aWindSize[2] ;
											   To ;
											   oSize:aWindSize[3],;
											   oSize:aWindSize[4] ;
											   PIXEL
													
	/*	M->Z0_COD	:= CriaVar("Z0_COD",	.T.)	
		M->Z0_DATA	:= CriaVar("Z0_DATA",	.T.)
		M->Z0_PROD 	:= CriaVar("Z0_PROD",	.T.)
		M->Z0_DESCR	:= CriaVar("Z0_DESCR",	.T.)
		M->Z0_QTD	:= CriaVar("Z0_QTD",	.T.)
		M->Z0_VALOR	:= CriaVar("Z0_VALOR",	.T.)
		M->Z0_TOTAL	:= CriaVar("Z0_TOTAL",	.T.)
		Carregar as validações e iniciadores do Alias Acessado.
	*/																	    

//	Enchoice ( cAlias, nReg, nOpc, /*aCRA*/, /*cLetras*/, /*cTexto*/, /*aAcho*/, aPos)
	
	//ACTIVATE MSDIALOG oDlg CENTERED		
	
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| IIF(obrigatorio(aGets,aTela) ,;
														(Fgrava(cAlias, nOpc), oDlg:End()),;
														, NIL)},;
														{||oDlg:End(),ROLLBACKSX8()}/*,,@aButtons*/))
	
Return

//---------------------------------------------------------------------------

Static Function fGrava(cAlias, nOpc)

	// Exercicio fazer a gravação dos dados 
	Local lINCLUIR := .F.
	
	dbSelectArea("SZ0")
	dbSetOrder(1)
	lINCLUIR := MSSEEK(xFilial("SZ0")+M->Z0_COD) 
		
	RecLock(cAlias,!lINCLUIR)

	
	For nCampo := 1 To (cAlias) -> (fCount()) //Quantidade de campo no SX3
		//M->&(FieldName(nCampo))	:=	CriaVar(FieldName(nCampo),.T.) //Macrosubstituição da string para o campo (tira aspas)
		If "FILIAL" $ FieldName(nCampo)
			FieldPut(nCampo, xFilial(cAlias)) //FieldPut analisa os campos e desconsidera os campos virtuais
		Else
			FieldPut(nCampo, M->&(FieldName(nCampo)))
		Endif
	
	Next nCampo
		
	
	/*
	SZ0->Z0_FILIAL := xFilial("SZ0")	
	SZ0->Z0_COD    := M->Z0_COD   
	SZ0->Z0_DATA   := M->Z0_DATA  
	SZ0->Z0_PROD   := M->Z0_PROD  
	SZ0->Z0_QTD    := M->Z0_QTD   
	SZ0->Z0_VALOR  := M->Z0_VALOR 
	*/
	
	If lINCLUIR
		ConfirmSX8()
	Else
		ROLLBACKSX8()
	EndIf		
	
	MsUnlock()
Return