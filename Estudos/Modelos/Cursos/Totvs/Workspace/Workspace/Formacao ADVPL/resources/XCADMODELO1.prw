// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : XCADMODELO1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 27/04/19 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a manutenção de dados armazenados em SZ0.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/04/2019
/*/
//------------------------------------------------------------------------------------------
user function XCADMODELO1()
	
	Local cAlias := "SZ0"
	Local aColors :={}
	Private cCadastro := "Cadastro de Sucata"
		
	aRotina := 	{;
				{ "Pesquisar"	, "AxPesqui", 0, 1},;
				{ "Visualizar"	, "U_INCSZ0", 0, 2},;
				{ "Incluir"		, "U_INCSZ0", 0, 3},;
				{ "Alterar"		, "U_INCSZ0", 0, 4},;
				{ "Excluir"		, "U_INCSZ0", 0, 5},;
				{ "Legenda"		, "U_LEGSZ0", 0, 7};
				}
	
	//aAdd(aColors,{"Z0_ATIVO=='S'","GREEM"	})
	//aAdd(aColors,{"Z0_ATIVO=='S'","BR_VERDE"})
	aAdd(aColors,{"Z0_ATIVO=='S'","BR_VERDE_ESCURO"})
	aAdd(aColors,{"Z0_ATIVO=='N'","BR_MARRON"	})
	
	dbSelectArea(cAlias)
//	mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>
	mBrowse( /*6*/, /*1*/, /*22*/, /*75*/, cAlias,/*<aFixe>*/,/* <cCpo>*/,/* <nPar>*/,"Z0_ATIVO=='S'"/*<cCorFun>*/,3/* <nClickDef>*/,aColors)
	
return

//----------------------------------------------------------------------------------------------------------------------
User Function LEGSZ0()

	Local aLegenda := {}

	aAdd(aLegenda,{"BR_VERDE"	,"Ativo"	 })
	aAdd(aLegenda,{"BR_MARRON"	,"Desativado"})
	
	BrwLegenda ( cCadastro, "Legenda", aLegenda )

Return ( NIL )

//----------------------------------------------------------------------------------------------------------------------

/*
Ao definir as funções no array aRotina, caso o nome da função não seja especificado com os parênteses, “()”, a mBrowse passará as seguintes variáveis de controle como parâmetros:

* cAlias = Nome da área de trabalho definida para a mBrowse;
* nReg  = Número (Recno) do registro posicionado na mBrowse;
* nOpc  = Posição da opção utilizada na mBrowse, de acordo com a ordem da função no array aRotina.
*/

User Function INCSZ0(cAlias,nReg,nOpc)
	
	Static oDlg
	Private aGets := {} // Definição obrigatória da tipagem desta variável para uso da função Obrigatorio
	Private aTela := {} // Definição obrigatória da tipagem desta variável para uso da função Obrigatorio

	oSize := FwDefSize():New( .T. ) // Com enchoicebar
	oSize:lLateral     := .F.  // Calculo vertical
	// adiciona Enchoice                                                          
	oSize:AddObject( "TELA"	 , 100,100, .T., .T. ) // Adiciona enchoice
	// Dispara o calculo                                                     
	oSize:Process()

	aPos := {oSize:GetDimension("TELA","LININI"),;
			 oSize:GetDimension("TELA","COLINI"),;
			 oSize:GetDimension("TELA","LINEND"),;
			 oSize:GetDimension("TELA","COLEND")}
	
	RegToMemory(cAlias,nOpc == 3) // Prepara os campos do Alias em memória.

/*LEGADO*/
	/*For nCampo := 1 To (cAlias)->( fCount() ) // Quantidade de campo na tabela SX3
		M->&(FieldName(nCampo)) := CriaVar(FieldName(nCampo),.T.)		
	Next nCampo*/
	
	/*M->Z0_COD	:= CriaVar("Z0_COD"		,.T.)
	M->Z0_PROD	:= CriaVar("Z0_PROD"	,.T.)
	M->Z0_DESCR	:= CriaVar("Z0_DESCR"	,.T.)
	M->Z0_QTD	:= CriaVar("Z0_QTD"		,.T.)
	M->Z0_VALOR	:= CriaVar("Z0_VALOR"	,.T.)
	M->Z0_TOTAL	:= CriaVar("Z0_TOTAL"	,.T.)
	M->Z0_DATA	:= CriaVar("Z0_DATA"	,.T.)*/
/*LEGADO*/

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM	oSize:aWindSize[1],;
												oSize:aWindSize[2] ;
												TO ;
												oSize:aWindSize[3],;
												oSize:aWindSize[4] ;
												PIXEL

	Enchoice( cAlias,nReg,nOpc,/*aCRA*/,/*cLetras*/,/*cTexto*/,/*aAcho*/,aPos )

	ACTIVATE MSDIALOG oDlg ON INIT	(EnchoiceBar(oDlg,{|| IIF( OBRIGATORIO(aGets,aTela),;
														  (FGrava(cAlias,nOpc),oDlg:End()),;
														  NIL)},;
									{||oDlg:End(),ROLLBACKSX8()}/*,,@aButtons*/))
	

Return ( NIL )



Static Function fGrava(cAlias,nOpc)

	//Local lINCLUIR	:= .F.
	Local nCampo
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	//lINCLUIR := MSSEEK(xFilial(cAlias)+M->Z0_COD)

	If nOpc == 3
		RecLock(cAlias,.T.)
		
		For nCampo := 1 To (cAlias)->( fCount() ) // Quantidade de campo na tabela SX3
			/*(cAlias)->&(FieldName(nCampo)) := M->&(FieldName(nCampo))*/ //Este tipo de atribuição não trata campo VIRTUAL
			If "FILIAL" $ FieldName(nCampo)
				FieldPut(nCampo,xFilial(cAlias))
			Else
				FieldPut(nCampo,M->&(FieldName(nCampo)))
			EndIf
			
		Next nCampo
		
		ConfirmSX8()
		
		MsUnLock()
	
		MsgInfo("Gravado com sucesso","SóQueNão")
		
	ElseIf nOpc == 4
		RecLock(cAlias,.F.)
		
		For nCampo := 1 To (cAlias)->( fCount() ) // Quantidade de campo na tabela SX3
			/*(cAlias)->&(FieldName(nCampo)) := M->&(FieldName(nCampo))*/ //Este tipo de atribuição não trata campo VIRTUAL
			If "FILIAL" $ FieldName(nCampo)
				FieldPut(nCampo,xFilial(cAlias))
			Else
				FieldPut(nCampo,M->&(FieldName(nCampo)))
			EndIf
			
		Next nCampo
		
		MsUnLock()
	
		MsgInfo("Alterado com sucesso","SóQueNão")
		
	ElseIf nOpc == 5

		RecLock(cAlias,.F.)
			dbDelete()
		MsUnLock()
		
		MsgInfo("Excluído com sucesso","SóQueNão")
	
	EndIf
	
Return
