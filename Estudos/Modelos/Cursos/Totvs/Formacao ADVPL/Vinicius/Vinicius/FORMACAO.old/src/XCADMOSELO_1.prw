
#include "rwmake.ch"

user function XCADMODELO1()
	
	local cAlias := "SZ0"
	Local aColors := {}
	private cCadastro := "Cadastro de Sucata"

	
	aRotina :=	{;
				{ "Pesquisar", "AxPesqui", 0, 1},;
				{ "Visualizar", "AxVisual", 0, 2},;
				{ "Incluir", "AxInclui", 0, 3},;
				{ "Alterar", "AxAltera", 0, 4},;
				{ "Exlcuir", "AxDeleta", 0, 5},;
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
