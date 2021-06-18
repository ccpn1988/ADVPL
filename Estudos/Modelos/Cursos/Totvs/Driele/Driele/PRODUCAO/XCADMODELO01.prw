#include "rwmake.ch"


user function XCADMODELO01()

	Local cAlias := "SZ0"
	Local aColors := {}
	private cCadastro := "Cadastro de Sucata"
	

	aRotina := {;
		{ "Pesquisar",  "AxPesqui", 0, 1},;
		{ "Visualizar", "AxVisual", 0, 2},;
		{ "Incluir",    "AxInclui", 0, 3},;
		{ "Alterar",    "AxAltera", 0, 4},;
		{ "Exlcuir",    "AxDeleta", 0, 5},;
		{ "Legenda",    "U_LEGSZ0", 0, 7};
		}
	
	aAdd(aColors,{"Z0_ATIVO=='S'","BR_MARRON"})
//	aAdd(aColors,{"Z0_ATIVO=='S'","BR_AMARELO"})
	aAdd(aColors,{"Z0_ATIVO=='N'","BR_PINK"})

		dbSelectArea(cAlias)
		
mBrowse( , , , , cAlias,/*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/, /*<cCorFun>*/,4 /*<nClickDef>*/, aColors)	
return ( NIL )

User Function LEGSZ0 ()

Local aLegenda := {}

aAdd(aLegenda,{"BR_MARRON","ATIVO"})
aAdd(aLegenda,{"BR_PINK","DESATIVO"})

BrwLegenda (cCadastro,"Legenda",aLegenda )

return ( NIL )




