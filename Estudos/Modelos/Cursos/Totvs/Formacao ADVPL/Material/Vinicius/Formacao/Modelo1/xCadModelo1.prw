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
		{ "Incluir", "U_INCSZ0", 0, 3},;
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
	
	//<nClickDef> - Parametro para processar com o duplo clique
	//mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>)
	mBrowse( , , , , cAlias, /*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/, /*"Z0_ATIVO=='S'" /*<cCorFun>*/, 4 /* <nClickDef>*/, aColors)
return

User Function LEGSZ0()
	local aLegenda := {}
	aAdd(aLegenda,{"BR_PINK","Ativo"})
	aAdd(aLegenda,{"BR_VERDE","Desativado"})
	aAdd(aLegenda,{"BR_AZUL","Branco"})
	
	BrwLegenda (cCadastro,"Legenda", aLegenda)
return

User Function INCSZ0(cAlias,nReg,nOpc)
 
Static oDlg
Local oSize := FwDefSize():New( .T. ) // Com enchoicebar
Private aGets := {}
Private aTela := {}
/*
Ao definir as funções no array aRotina, caso o nome da função não seja especificado com os parênteses, “()”, a mBrowse passará as seguintes variáveis de controle como parâmetros:

cAlias = Nome da área de trabalho definida para a mBrowse;
nReg  = Número (Recno) do registro posicionado na mBrowse;
nOpc  = Posição da opção utilizada na mBrowse, de acordo com a ordem da função no array aRotina.
*/
/*CRIANDO UM DIALOG PARA O ENCHOICE OU MSMGET*/



/* FWDefSize - Serve para posionar e dividir a tela na horizontal e na Vertical*/
oSize:lLateral     := .F.  // Calculo vertical

// adiciona Enchoice - Vertical e Horizontal em %                                                          
oSize:AddObject( "ENCHOICE", 100, 100, .T., .T. ) // Adiciona enchoice

// Dispara o calculo a Dimensão dos Objetos                                                    
oSize:Process()

DEFINE MSDIALOG oDlg TITLE cCadastro FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

/* aPos := {
		oSize:GetDimension("ENCHOICE","LININI"),;
		 oSize:GetDimension("ENCHOICE","COLINI"),;
		 oSize:GetDimension("ENCHOICE","LINEND"),;
		 oSize:GetDimension("ENCHOICE","COLEND")}

/*************** TRES TRATAMENTOS PARA CARREGAR AS VARIAVEIS NA MEMORIA
M->Z0_COD := CriaVar("Z0_COD",.T.)
M->Z0_DATA := CriaVar("Z0_DATA",.T.)
M->Z0_PROD := CriaVar("Z0_PROD",.T.)
M->Z0_DESCR := CriaVar("Z0_DESCR",.T.)
M->Z0_QTD := CriaVar("Z0_QTD",.T.)
M->Z0_VALOR := CriaVar("Z0_VALOR",.T.)
M->Z0_TOTAL := CriaVar("Z0_TOTAL",.T.)
*/

/*VARREBDO TODOS OS CANPOS DA TABELA PARA INICIALIZAR O VALOR
for nCont := 1 To (cAlias)-> (fCount)
	M->&(fieldname(nCont)) := CriaVar(fieldname(nCont),.T.)
next
*/
/*************** TRES TRATAMENTOS PARA CARREGAR AS VARIAVEIS NA MEMORIA **************/
/* .T. - INCLUIR  .F. - PARA ALTERAÇAO*/
RegToMemory(cAlias,.T.)
/*************************************************************************************/

Enchoice (cAlias, nReg, nOpc, /*aCRA*/, /*cLetras*/, /*cTexto*/,/* aAcho*/,  {oSize:GetDimension("ENCHOICE","LININI"),;
																	          oSize:GetDimension("ENCHOICE","COLINI"),;
																	          oSize:GetDimension("ENCHOICE","LINEND"),;
																	          oSize:GetDimension("ENCHOICE","COLEND")}/*aPos*/)

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||IIF(Obrigatorio(aGets,aTela),(fGrava(cAlias,nOpc),oDlg:End()), NIL)},{||oDlg:End(), ROLLBACKSX8()}/*,,@aButtons*/))
//ACTIVATE MSDIALOG oDlg CENTERED	
return

Static Function fGrava(cAlias,nOpc)
			
	Local lINCLUIR := .F.
	dbSelectArea("SZ0")
	dbSetOrder(1)
		
	lINCLUIR := MsSeek(xFilial("SZ0") + M->Z0_COD)
	RecLock("SZ0",!lINCLUIR) //INCLUIR

	for nCont := 1 To (cAlias)-> (fCount())
		/* CASO TENHA CAMPO VIRYAUL DARÀ ERRO - DEVIDO A ISSO USAMOS O FIELDPUT
		*  (cAlias)->&(fieldname(nCont)) := M->&(fieldname(nCont),.T.)*/
		if "FILIAl" $ fieldname(nCont)
			fieldput(nCont, xFilial(cAlias))
		else
			fieldput(nCont, M->&(fieldname(nCont)))
		EndIf	
	next nCont
	
	/* PEGANDO OS VALORES DA MEMORIA E SALVANDO NO BANCO
	SZ0->Z0_FILIAL := xFilial("SZ0")
	SZ0->Z0_COD :=  M->Z0_COD
	SZ0->Z0_DATA := M->Z0_DATA 
	SZ0->Z0_PROD := M->Z0_PROD
	SZ0->Z0_NOME := M->Z0_NOME
	SZ0->Z0_QTD :=  M->Z0_QTD
	SZ0->Z0_VALOR := M->Z0_VALOR*/
			
	if ! lIncluir
		ConfirmSX8()
	else
		ROLLBACKSX8()
	endIf
	
	MsUnlock() //LIBERA O REGISTRO	 	
	MsgInfo("Gravado com sucesso!","Gravando")	
return 