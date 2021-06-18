//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Artistas (Mod.X)"

/*/{Protheus.doc} zModelX
Fun��o de exemplo de Modelo X (Pai, Filho e Neto), com as tabelas de Artistas, CDs e M�sicas
@author Atilio
@since 03/09/2016
@version 1.0
	@return Nil, Fun��o n�o tem retorno
	@example
	u_zModelX()
/*/

User Function zModelX()
	Local aArea   := GetArea()
	Local oBrowse
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZZ1")

	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zModelX' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/

Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'ZZ1')
	Local oStFilho 	:= FWFormStruct(1, 'ZZ2')
	Local oStNeto 	:= FWFormStruct(1, 'ZZ3')
	Local aZZ2Rel		:= {}
	Local aZZ3Rel		:= {}
	
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('zModelXM')
	oModel:AddFields('ZZ1MASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('ZZ2DETAIL','ZZ1MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
	oModel:AddGrid('ZZ3DETAIL','ZZ2DETAIL',oStNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
	
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aZZ2Rel, {'ZZ2_FILIAL',	'ZZ1_FILIAL'} )
	aAdd(aZZ2Rel, {'ZZ2_CODART',	'ZZ1_COD'})
	
	//Fazendo o relacionamento entre o Filho e Neto
	aAdd(aZZ3Rel, {'ZZ3_FILIAL',	'ZZ2_FILIAL'} )
	aAdd(aZZ3Rel, {'ZZ3_CODART',	'ZZ2_CODART'})
	aAdd(aZZ3Rel, {'ZZ3_CODCD',		'ZZ2_CODCD'}) 
	
	oModel:SetRelation('ZZ2DETAIL', aZZ2Rel, ZZ2->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
	oModel:GetModel('ZZ2DETAIL'):SetUniqueLine({"ZZ2_CODCD"})	//N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})
	
	oModel:SetRelation('ZZ3DETAIL', aZZ3Rel, ZZ3->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
	oModel:GetModel('ZZ3DETAIL'):SetUniqueLine({"ZZ3_CODMUS"})	//N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})
	
	//Setando as descri��es
	oModel:SetDescription("Grupo de Produtos - Mod. X")
	oModel:GetModel('ZZ1MASTER'):SetDescription('Modelo Artistas')
	oModel:GetModel('ZZ2DETAIL'):SetDescription('Modelo CDs')
	oModel:GetModel('ZZ3DETAIL'):SetDescription('Modelo Musicas')
	
	//Adicionando totalizadores
	oModel:AddCalc('TOTAIS', 'ZZ1MASTER', 'ZZ2DETAIL', 'ZZ2_PRECO',  'XX_VALOR', 'SUM',   , , "Valor Total:" )
	oModel:AddCalc('TOTAIS', 'ZZ2DETAIL', 'ZZ3DETAIL', 'ZZ3_CODMUS', 'XX_TOTAL', 'COUNT', , , "Total Musicas:" )
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ViewDef()
	Local oView		:= Nil
	Local oModel		:= FWLoadModel('zModelX')
	Local oStPai		:= FWFormStruct(2, 'ZZ1')
	Local oStFilho	:= FWFormStruct(2, 'ZZ2')
	Local oStNeto		:= FWFormStruct(2, 'ZZ3')
	Local oStTot		:= FWCalcStruct(oModel:GetModel('TOTAIS'))
	
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabe�alho e o grid dos filhos
	oView:AddField('VIEW_ZZ1', oStPai,   'ZZ1MASTER')
	oView:AddGrid('VIEW_ZZ2',  oStFilho, 'ZZ2DETAIL')
	oView:AddGrid('VIEW_ZZ3',  oStNeto,  'ZZ3DETAIL')
	oView:AddField('VIEW_TOT', oStTot,   'TOTAIS')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC', 20)
	oView:CreateHorizontalBox('GRID',  40)
	oView:CreateHorizontalBox('GRID2', 27)
	oView:CreateHorizontalBox('TOTAL', 13)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZZ1', 'CABEC')
	oView:SetOwnerView('VIEW_ZZ2', 'GRID')
	oView:SetOwnerView('VIEW_ZZ3', 'GRID2')
	oView:SetOwnerView('VIEW_TOT', 'TOTAL')
	
	//Habilitando t�tulo
	oView:EnableTitleView('VIEW_ZZ1','Artista')
	oView:EnableTitleView('VIEW_ZZ2','CDs')
	oView:EnableTitleView('VIEW_ZZ3','Musicas')
	
	//Removendo campos
	oStFilho:RemoveField('ZZ2_CODART')
	oStNeto:RemoveField('ZZ3_CODART')
	oStNeto:RemoveField('ZZ3_CODCD')
Return oView