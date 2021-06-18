#include "rwmake.ch" 

user function xMod1SZ0()
  
	Local cAlias := "SZ0"
	Local aColors := {}
	//CRTL K - LOCALIZA PALAVRA SELECIONADA
	Private cCadastro := "Cadastro de Sucata"
	
	/*	
	[n][1]  -->  T�tulo da rotina que ser� exibido no menu
	[n][2]  -->  Nome da fun��o que ser� executada
	[n][3]  -->  Par�metro reservado. Deve ser sempre 0 (zero)
	[n][4]  -->  N�mero da opera��o que a fun��o executar�. As alternativas s�o:

	1=Pesquisa
	2=Visualiza��o
	3=Inclus�o
	4=Altera��o
	5=Exclus�o
	6=Altera��o sem a permiss�o para incluir novas linhas. � v�lido apenas para os objetos GetDados e GetDb.
	*/
	
	//TODA FUN��O CHAMADA PELO AROTINA DEVE SER UMA USER FUNCTION
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
	
	Linha Inicia - N�o usado, pois usa a resolu��o do MDI
	Coluna Inicial - N�o usado, pois usa a resolu��o do MDI 
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