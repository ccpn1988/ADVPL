//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zTstTab
Fun��o que testa a cria��o de tabelas, campos e �ndices
@type function
@author Atilio
@since 03/10/2015
@version 1.0
	@example
	u_zTstTab()
/*/

User Function zTstTab()
	Processa( {|lEnd| fRunProc(@lEnd)}, "Aguarde...","Atualizando tabelas...", .T. )
Return

/*---------------------------------------------------------------------*
 | Func:  fRunCroc                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/10/2015                                                   |
 | Desc:  Fun��o auxiliar chamada pelo Processamento                   |
 *---------------------------------------------------------------------*/

Static Function fRunProc(lEnd)
	DbSelectArea("SX2")
	
	//Setando a r�gua
	ProcRegua(2) 
	
	//Chamando a cria��o da tabela customizada
	IncProc("Atualizando ZD0 - Logs")
	fAtualZD0()
	
	//Atualizando tabelas padr�o
	IncProc("Atualizando tabelas padr�o...")
	cMsg := "Aten��o, as seguintes tabelas <b>ser�o atualizadas</b>: <br>"
	cMsg += "<b>SB1:</b> Produtos <br>"
	cMsg += "<br>Verifique se elas n�o est�o sendo utilizadas.<br>"
	cMsg += "<b>Deseja atualizar essas tabelas?</b>"
	If MsgYesNo(cMsg, "Aten��o")
		fAtualSB1()
	EndIf
	
	MSGInfo('Atualiza��es conclu�das.','Aten��o')
Return

/*---------------------------------------------------------------------*
 | Func:  fAtualZD0                                                    |
 | Autor: Daniel Atilio                                                |
 | Data:  03/10/2015                                                   |
 | Desc:  Fun��o para criar a tabela ZD0 - Logs                        |
 *---------------------------------------------------------------------*/

Static Function fAtualZD0()
	Local aSX2 := {}
	Local aSX3 := {}
	Local aSIX := {}
	
	//Tabela
	//			01			02								03		04			05
	//			Chave		Descri��o						Modo	Modo Un.	Modo Emp.
	aSX2 := {	'ZD0',		'Logs de Campos',				'C',	'C',		'C'}
	
	//Campos
	//				01				02			03					04			05		06					07							08			09		10			11		12										13			14			15			16		17			18					19			20			21
	//				Campo			Filial?	Tamanho			Decimais	Tipo	Titulo				Descri��o					M�scara	N�vel	Vld.Usr	Usado	Ini.Padr.								Cons.F3	Visual		Contexto	Browse	Obrigat	Lista.Op			Mod.Edi	Ini.Brow	Pasta
	aAdd(aSX3,{	'ZD0_FILIAL',	.T.,		FWSizeFilial(),	0,			'C',	"Filial",			"Filial do Sistema",		"",			1,		"",			.F.,	"",										"",			"",			"",			"N",	.T.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_SEQ',		.F.,		10,					0,			'C',	"Sequencia",		"Sequencia",				"@!",		1,		"",			.T.,	"GetSXENum('Z00','Z00_SEQ')",		"",			"A",		"R",		"S",	.T.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_USRCOD',	.F.,		10,					0,			'C',	"Usr.Codigo",		"C�digo do Usu�rio",		"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.T.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_USRNOM',	.F.,		30,					0,			'C',	"Usr.Nome",		"Nome do Usu�rio",		"",			1,		"",			.T.,	"",										"",			"A",		"R",		"S",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_DATA',	.F.,		8,					0,			'D',	"Data",			"Data",					"",			1,		"",			.T.,	"Date()",								"",			"A",		"R",		"S",	.T.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_HORA',	.F.,		8,					0,			'C',	"Hora",			"Hora",					"",			1,		"",			.T.,	"Time()",								"",			"A",		"R",		"S",	.T.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_DESCRI',	.F.,		100,				0,			'C',	"Descricao",		"Descricao",				"",			1,		"",			.T.,	"",										"",			"A",		"R",		"S",	.T.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_FUNC',	.F.,		20,					0,			'C',	"Funcao",			"Funcao",					"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_FILORI',	.F.,		FWSizeFilial(),	0,			'C',	"Fil.Orig.",		"Filial Origem",			"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_AMB',		.F.,		30,					0,			'C',	"Ambiente",		"Ambiente",				"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_TAB',		.F.,		3,					0,			'C',	"Tabela",			"Alias da Tabela",		"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_CAMPO',	.F.,		10,					0,			'C',	"Campo",			"Campo",					"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_CONANT',	.F.,		240,				0,			'C',	"Cont.Ant.",		"Conteudo Antigo",		"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_CONNOV',	.F.,		240,				0,			'C',	"Cont.Nov.",		"Conteudo Novo",			"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_CHAVE',	.F.,		100,				0,			'C',	"Chave",			"Chave da Tabela",		"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_CONCHA',	.F.,		100,				0,			'C',	"Cont.Chave",		"Conteudo da Chave",		"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})
	aAdd(aSX3,{	'ZD0_REC',		.F.,		18,					0,			'N',	"RecNo Chave",	"RecNo da Chave",			"",			1,		"",			.T.,	"",										"",			"A",		"R",		"N",	.F.,		"",					"",			"",			""})


	//�ndices
	//				01			02			03								04				05				06			07
	//				�ndice		Ordem		Chave							Descri��o		Propriedade	NickName	Mostr.Pesq
	aAdd(aSIX,{	"ZD0",		"1",		"ZD0_FILIAL+ZD0_SEQ",		"Sequencia",	"U",			"",			"S"})
		
	//Criando os dados
	u_zCriaTab(aSX2, aSX3, aSIX)
Return 

/*---------------------------------------------------------------------*
 | Func:  fAtualSB1                                                    |
 | Autor: Daniel Atilio                                                |
 | Data:  03/10/2015                                                   |
 | Desc:  Fun��o para criar campos na tabela SB1 - Produtos            |
 *---------------------------------------------------------------------*/

Static Function fAtualSB1()
	Local aSX2 := {}
	Local aSX3 := {}
	Local aSIX := {}
	Local cOrdem := ""
	
	//Tabela
	//			01			02								03		04			05
	//			Chave		Descri��o						Modo	Modo Un.	Modo Emp.
	aSX2 := {	'SB1',		'',								'',		'',			''}
	
	//Campos
	//				01				02			03					04			05		06					07							08			09		10			11		12				13			14			15			16		17			18					19			20			21
	//				Campo			Filial?	Tamanho			Decimais	Tipo	Titulo				Descri��o					M�scara	N�vel	Vld.Usr	Usado	Ini.Padr.		Cons.F3	Visual		Contexto	Browse	Obrigat	Lista.Op			Mod.Edi	Ini.Brow	Pasta
	aAdd(aSX3,{	'B1_X_CAMPO',	.F.,		10,					0,			'C',	"Campo Novo",		"Campo Novo",				"",			1,		"",			.T.,	"",				"",			"A",		"R",		"S",	.F.,		"",					".F.",		"",			""})

	//Somente se n�o existir o �ndice do pocket
	If ! u_zExistSIX('SB1', 'CAMPO', @cOrdem)
		//�ndices
		//				01			02			03								04				05				06				07
		//				�ndice		Ordem		Chave							Descri��o		Propriedade	NickName		Mostr.Pesq
		aAdd(aSIX,{	"SB1",		cOrdem,	"B1_FILIAL+B1_X_CAMPO",		"Campo Novo",	"U",			"CAMPO",		"N"})
	EndIf
	
	//Criando os dados
	u_zCriaTab(aSX2, aSX3, aSIX)
Return