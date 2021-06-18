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
user function CadMod01()
	local cAlias := "SZ0"
	Local aColors := {} //LEGENDA
	Private cCadastro := "Cadastro de Sucata" //cCadastro deve ser Private com MBrowse 
	
	//CRIAÇÃO DOS BOTÕES DA TELA
		aRotina :=  {;
			    { "Pesquisar" 	, "AxPesqui", 0, 1},;
				{ "Visualizar"	, "AxVisual", 0, 2},;
				{ "Incluir"		, "U_INCSZ0", 0, 3},;
				{ "Alterar"		, "AxAltera", 0, 4},;
				{ "Exlcuir"		, "AxDeleta", 0, 5},;
				{ "Legenda"		, "U_LGSZ0", 0, 7};
				}

//AADD(aColors,{"X3_CAMPO ==''","COR"})
AADD(aColors,{"Z0_ATIVO =='S'","BR_VERDE"})
AADD(aColors,{"Z0_ATIVO =='N'","BR_VERMELHO"})

	
	dbSelectArea(cAlias)
	//	mBrowse( <nLinha1>, <nColuna1>, <nLinha2>, <nColuna2>, <cAlias>, <aFixe>, <cCpo>, <nPar>, <cCorFun>, <nClickDef>, <aColors>
		mBrowse( , , , , cAlias,/*<aFixe>*/, /*<cCpo>*/, /*<nPar>*/,/* "Z0_ATIVO =='S'" *//*<cCorFun>*/, 4 /*<nClickDef>*/, aColors)
	
	
return(Nil)

//FUNÇÂO CRIADA PELA AROTINA TEM QUE SER USER FUNCTION

//-----------------------------------------------------------------------------------------------------
//CRIANDO LEGENDA
User Function LGSZ0()
Local aLegenda := {}


//AADD(Array ,{"COR","DESCRIÇÃO"})
AADD(aLegenda,{"BR_VERDE"	, "Ativo"	  })
AADD(aLegenda,{"BR_VERMELHO", "Desativado"})

//BrwLegenda ( cCadastro, cTitulo  , aLegenda [ nXSize ] )
  BrwLegenda ( cCadastro, "Legenda", aLegenda)

Return(Nil)

//-------------------------------------------------------------------------------------------------
/*cAlias = Nome da área de trabalho definida para a mBrowse;
nReg  = Número (Recno) do registro posicionado na mBrowse;
nOpc  = Posição da opção utilizada na mBrowse, de acordo com a ordem da função no array aRotina.
*/
User Function INCSZ0(cAlias,nReg,nOpc)

Static oDlg
Private aGets := {}
Private aTela := {}
// Calcula as dimensoes dos objetos                                         
oSize := FwDefSize():New( .T. ) // Com enchoicebar
// adiciona Enchoice                                                          
oSize:AddObject( "TELA", 100, 100, .T., .T. ) // Adiciona enchoice
              
// Dispara o calculo                                                     
oSize:Process()

aPos := {oSize:GetDimension("TELA","LININI"),;
	 	oSize:GetDimension ("TELA","COLINI"),;
	 	oSize:GetDimension ("TELA","LINEND"),;
	  	oSize:GetDimension ("TELA","COLEND")} 
	  	
RegToMemory(cAlias,.T.)	 //VARIAVEIS DE MEMORIA SIMPLIFICA ITENS ABAIXO

/*For nCampo := 1 To (cAlias)->( fCount())//QUANTIDADE DE CAMPO NO SX3 
M->&(FieldName(nCampo)) := CriaVar(FieldName(nCampo),.T.)
Next nCampo*/

/*M->cCodigo	:= CriaVar("Z0_COD"		,.T.)	
M->dData 	:= CriaVar("Z0_DATA"	,.T.)
M->cProduto := CriaVar("Z0_PROD"	,.T.)
M->cDescri	:= CriaVar("Z0_DESCR"	,.T.)
M->nQtd 	:= CriaVar("Z0_QTD"		,.T.)
M->nValor 	:= CriaVar("Z0_VALOR"	,.T.)
M->nValor 	:= CriaVar("Z0_TOTAL"	,.T.)*/

DEFINE MSDIALOG oDlg TITLE cCadastro FROM oSize:aWindSize[1],;
										  oSize:aWindSize[2];
										  TO;
										  oSize:aWindSize[3],;
										  oSize:aWindSize[4];
										  PIXEL

Enchoice( cAlias, nReg, nOpc, /*aCRA*/, /*cLetras*/, /*cTexto*/, /*aAcho*/aPos)

//ACTIVATE MSDIALOG oDlg CENTERED

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||IIF( obrigatorio(aGets,aTela),; 
													   (fGrava(cAlias,nOpc),oDlg:End()),;
													   NIL)},; 
													   {||oDlg:End(),ROLLBACKSX8()}))
 
Return(NIL)

//---------------------------------------------------------------------------------------------------------------------

Static Function fGrava(cAlias,nOpc)
	// Exercicio fazer a gravação dos dados 
Local lINCLUIR := .F.

dbSelectArea("SZ0")
dbSetOrder(1)
lINCLUIR := MSSEEK(xFilial("SZ0")+ M->Z0_COD) 
	
RecLock("SZ0",! lINCLUIR)

//UTILIZADO QUANDO EXISTE CAMPO VIRTUAL (FieldPut)<>(FieldName)
For nCampo := 1 To (cAlias)->( fCount())//QUANTIDADE DE CAMPO NO SX3 
	//(cAlias)->&(FieldName(nCampo)) := M->&(FieldName(nCampo))
	IF "FILIAL" $ FieldName(nCampo)
	FieldPut(nCampo, M->&(FieldName(nCampo)))
	ELSE
	FieldPut(nCampo, M->&(FieldName(nCampo)))
	ENDIF
	
Next nCampo

If ! lINCLUIR
	ConfirmSX8()
Else
	ROLLBACKSX8()
EndIf	
MSUNLOCK()	
	              
msginfo("Grava do com sucesso","SóQueNão")

Return