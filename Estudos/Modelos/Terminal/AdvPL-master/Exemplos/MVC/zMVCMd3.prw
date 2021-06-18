//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Grp.Produtos (Mod.3)"

/*/{Protheus.doc} zMVCMd3
Fun��o para cadastro de Grupo de Produtos (SBM) e Produtos (SB1), exemplo de Modelo 3 em MVC
@author Atilio
@since 17/08/2015
@version 1.0
	@return Nil, Fun��o n�o tem retorno
	@example
	u_zMVCMd3()
	@obs N�o se pode executar fun��o MVC dentro do f�rmulas
/*/

User Function zMVCMd3()
	Local aArea   := GetArea()
	Local oBrowse
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("SBM")

	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Legendas
	oBrowse:AddLegend( "SBM->BM_PROORI == '1'", "GREEN",	"Original" )
	oBrowse:AddLegend( "SBM->BM_PROORI == '0'", "RED",	"N�o Original" )
	
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zMVCMd3' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
	//ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zMVCMd3' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	//ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCMd3' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	//ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMd3' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'SBM')
	Local oStFilho 	:= FWFormStruct(1, 'SB1')
	Local aSB1Rel		:= {}
	
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('zMVCMd3M')
	oModel:AddFields('SBMMASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('SB1DETAIL','SBMMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
	
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aSB1Rel, {'B1_FILIAL',	'BM_FILIAL'} )
	aAdd(aSB1Rel, {'B1_GRUPO',	'BM_GRUPO'}) 
	
	oModel:SetRelation('SB1DETAIL', aSB1Rel, SB1->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
	oModel:GetModel('SB1DETAIL'):SetUniqueLine({"B1_FILIAL","B1_COD"})	//N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})
	
	//Setando as descri��es
	oModel:SetDescription("Grupo de Produtos - Mod. 3")
	oModel:GetModel('SBMMASTER'):SetDescription('Modelo Grupo')
	oModel:GetModel('SB1DETAIL'):SetDescription('Modelo Produtos')
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ViewDef()
	Local oView		:= Nil
	Local oModel		:= FWLoadModel('zMVCMd3')
	Local oStPai		:= FWFormStruct(2, 'SBM')
	Local oStFilho	:= FWFormStruct(2, 'SB1')
	
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabe�alho e o grid dos filhos
	oView:AddField('VIEW_SBM',oStPai,'SBMMASTER')
	oView:AddGrid('VIEW_SB1',oStFilho,'SB1DETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_SBM','CABEC')
	oView:SetOwnerView('VIEW_SB1','GRID')
	
	//Habilitando t�tulo
	oView:EnableTitleView('VIEW_SBM','Grupo')
	oView:EnableTitleView('VIEW_SB1','Produtos')
Return oView