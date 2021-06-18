#include "rwmake.ch" 

/*MUDAR O NOME NO MENU*/
user function xMod21SZ0()
  
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
		{ "Pesquisar",  "AxPesqui", 0, 1},;
		{ "Visualizar", "U_INCSZ0", 0, 2},;
		{ "Incluir",    "U_INCSZ0", 0, 3},;
		{ "Alterar",    "U_INCSZ0", 0, 4},;
		{ "Exlcuir",    "U_INCSZ0", 0, 5},;
		{ "Legenda",    "U_LEGSZ0", 0, 7};
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
	
	//<nClickDef> - Parametro para processar com o duplo clique
	//mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>)
	mBrowse( , , , , cAlias, /*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/, /*"Z0_ATIVO=='S'" /*<cCorFun>*/, 4 /* <nClickDef>*/, aColors)
return

User Function LEG2SZ0()
	local aLegenda := {}
	aAdd(aLegenda,{"BR_PINK","Ativo"})
	aAdd(aLegenda,{"BR_VERDE","Desativado"})
	aAdd(aLegenda,{"BR_AZUL","Branco"})
	
	BrwLegenda (cCadastro,"Legenda", aLegenda)
return

User Function INC2SZ0(cAlias,nReg,nOpc)
 
Static oDlg
Local oSize := FwDefSize():New( .T. ) // Com enchoicebar
Private aGets := {}
Private aTela := {}
/*
Ao definir as fun��es no array aRotina, caso o nome da fun��o n�o seja especificado com os par�nteses, �()�, a mBrowse passar� as seguintes vari�veis de controle como par�metros:

cAlias = Nome da �rea de trabalho definida para a mBrowse;
nReg  = N�mero (Recno) do registro posicionado na mBrowse;
nOpc  = Posi��o da op��o utilizada na mBrowse, de acordo com a ordem da fun��o no array aRotina.
*/
/*CRIANDO UM DIALOG PARA O ENCHOICE OU MSMGET*/



/* FWDefSize - Serve para posionar e dividir a tela na horizontal e na Vertical*/
oSize:lLateral     := .F.  // Calculo vertical

// adiciona Enchoice - Vertical e Horizontal em %                                                          
oSize:AddObject( "ENCHOICE", 100, 100, .T., .T. ) // Adiciona enchoice

// Dispara o calculo a Dimens�o dos Objetos                                                    
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
/**************** TRES TRATAMENTOS PARA CARREGAR AS VARIAVEIS NA MEMORIA **************/
/* .T. - INCLUIR  .F. - PARA ALTERA�AO*/
/* IRA VALIDAR SEM O COMANDO IF UMA VEZ QUE VAI RETORNAR TRUE OU FALSE ****************/
RegToMemory(cAlias,nOpc == 3)
/*************************************************************************************/

Enchoice (cAlias, nReg, nOpc, /*aCRA*/, /*cLetras*/, /*cTexto*/,/* aAcho*/,  {oSize:GetDimension("ENCHOICE","LININI"),;
																	          oSize:GetDimension("ENCHOICE","COLINI"),;
																	          oSize:GetDimension("ENCHOICE","LINEND"),;
																	          oSize:GetDimension("ENCHOICE","COLEND")}/*aPos*/)

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||IIF(Obrigatorio(aGets,aTela),(fGrava2(cAlias,nOpc),oDlg:End()), NIL)},{||oDlg:End(), ROLLBACKSX8()}/*,,@aButtons*/))
//ACTIVATE MSDIALOG oDlg CENTERED	
return

Static Function fGrava2(cAlias,nOpc)
			
	Local lINCLUIR := .F.
	dbSelectArea(cAlias)
	dbSetOrder(1)
		
MsSeek(xFilial(cAlias) + M->Z0_COD)
	
if nOpc == 3
	lINCLUIR := .T.
	RecLock(cAlias,lINCLUIR) //INCLUIR
	for nCont := 1 To (cAlias)-> (fCount())
		if "FILIAL" $ fieldname(nCont)
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

	ConfirmSX8()
	MsUnlock() //LIBERA O REGISTRO	 	
	MsgInfo("Inclu�do com sucesso!","Gravando")
	
elseif nOpc == 4	
	RecLock(cAlias,lINCLUIR) //ALTERA
	for nCont := 1 To (cAlias)-> (fCount())
		if "FILIAL" $ fieldname(nCont)
			fieldput(nCont, xFilial(cAlias))
		else
			fieldput(nCont, M->&(fieldname(nCont)))
		EndIf	
	next nCont

	MsUnlock() //LIBERA O REGISTRO	 	
	MsgInfo("Alterado com sucesso!","Gravando")
	
elseif nOpc == 5		
	RecLock(cAlias,lINCLUIR) //DELETAR
		dbDelete()
	MsUnlock() //LIBERA O REGISTRO	 	
	MsgInfo("Deletado  com sucesso!","Gravando")	
endIf
	
return 