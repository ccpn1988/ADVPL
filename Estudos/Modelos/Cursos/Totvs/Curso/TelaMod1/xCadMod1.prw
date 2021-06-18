#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a manutenção de dados armazenados em SZ0 tabela deve ser criada.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/04/2019
@modelo UNICA TABELA 
/*/
//------------------------------------------------------------------------------------------
user function xCadMod1()
	local cAlias := "SZ0"
	Local aColors := {} //LEGENDA
	private cCadastro := "Cadastro de Sucata" //cCadastro deve ser Private com MBrowse 
	
	//CRIAÇÃO DOS BOTÕES DA TELA
		aRotina :=  {;
				    { "Pesquisar" 	, "AxPesqui", 0, 1},;
					{ "Visualizar"	, "AxVisual", 0, 2},;
					{ "Incluir"		, "AxInclui", 0, 3},;
					{ "Alterar"		, "AxAltera", 0, 4},;
					{ "Exlcuir"		, "AxDeleta", 0, 5},;
					{ "Legenda"		, "U_LEGSZ0", 0, 7};
					}

//AADD(aColors,{"X3_CAMPO ==''","COR"})
AADD(aColors,{"Z0_ATIVO =='S'","BR_VERDE"})
AADD(aColors,{"Z0_ATIVO =='N'","BR_VERMELHO"})

	
	dbSelectArea(cAlias)
	//	mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>
		mBrowse( , , , , cAlias,/*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/,/* "Z0_ATIVO =='S'" *//*<cCorFun>*/, 4 /*<nClickDef>*/, aColors)
	
	
return(Nil)

//FUNÇÂO CRIADA PELA AROTINA TEM QUE SER USER FUNCTION

//CRIANDO LEGENDA
User Function LEGSZ0()
Local aLegenda := {}


//AADD(Array ,{"COR","DESCRIÇÃO"})
AADD(aLegenda,{"BR_VERDE"	, "Ativo"	  })
AADD(aLegenda,{"BR_VERMELHO", "Desativado"})

//BrwLegenda ( cCadastro, cTitulo  , aLegenda [ nXSize ] )
  BrwLegenda ( cCadastro, "Legenda", aLegenda)

Return(Nil)