#include "rwmake.ch" 

user function xMod1SZ0()
  
	Local cAlias := "SZ0"
	Local aColors := {}
	//CRTL K - LOCALIZA PALAVRA SELECIONADA
	Private cCadastro := "Cadastro de Sucata"
	
	/*	
	[n][1]  -->  Título da rotina que será exibido no menu
	[n][2]  -->  Nome da função que será executada
	[n][3]  -->  Parâmetro reservado. Deve ser sempre 0 (zero)
	[n][4]  -->  Número da operação que a função executará. As alternativas são:

	1=Pesquisa
	2=Visualização
	3=Inclusão
	4=Alteração
	5=Exclusão
	6=Alteração sem a permissão para incluir novas linhas. É válido apenas para os objetos GetDados e GetDb.
	*/
	
	//TODA FUNÇÂO CHAMADA PELO AROTINA DEVE SER UMA USER FUNCTION
	aRotina := {;
		{ "Pesquisar", "AxPesqui", 0, 1},;
		{ "Visualizar", "AxVisual", 0, 2},;
		{ "Incluir", "AxInclui", 0, 3},;
		{ "Alterar", "AxAltera", 0, 4},;
		{ "Exlcuir", "AxDeleta", 0, 5},;
		{ "Legenda", "U_LEGSZ0", 0, 7};
	}
	
	dbSelectArea(cAlias)
	
	/*
	
	Linha Inicia - Não usado, pois usa a resolução do MDI
	Coluna Inicial - Não usado, pois usa a resolução do MDI 
	<aFixe> - posiciona a coluna em sua ordem
	CCPO - Trata campo vazio
	nPar - Reservado, enviamos 0
	cCorFun - Muda a cor da linha
	*/
	
	aAdd(aColors,{"Z0_ATIVO=='S'","BR_PINK"})
	aAdd(aColors,{"Z0_ATIVO=='N'","BR_VERDE"})
	aAdd(aColors,{"Z0_ATIVO==' '","BR_AZUL"})
	
	//mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>)
	mBrowse( , , , , cAlias, /*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/, /*"Z0_ATIVO=='S'" /*<cCorFun>*/, 4 /* <nClickDef>*/, aColors)
return

User Function LEGSZ0()
	local aLegenda := {}
	aAdd(aLegenda,{"BR_PINK","Ativo"})
	aAdd(aLegenda,{"BR_VERDE","Desativado"})
	aAdd(aLegenda,{"BR_AZUL","Branco"})
	
	BrwLegenda (cCadastro,"Legenda", aLegenda)
return .T.