//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Composi��o de CDs"

/*/{Protheus.doc} zModel3
Fun��o para cadastro de Composi��o de CDs (Exemplo de Modelo 3 - ZZ2 x ZZ3)
@author Atilio
@since 03/09/2016
@version 1.0
	@return Nil, Fun��o n�o tem retorno
	@example
	u_zModel3()
/*/

User Function zModel3()
	Local aArea   := GetArea()
	Local oBrowse
	
	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de CDs
	oBrowse:SetAlias("ZZ2")

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
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zModel3' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/

Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'ZZ2')
	Local oStFilho 	:= FWFormStruct(1, 'ZZ3')
	Local aZZ3Rel		:= {}
	
	//Defini��es dos campos
	oStPai:SetProperty('ZZ2_CODCD',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
	oStPai:SetProperty('ZZ2_CODCD',    MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ2", "ZZ2_CODCD")'))       //Ini Padr�o
	oStPai:SetProperty('ZZ2_CODART',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("ZZ1", M->ZZ2_CODART)'))      //Valida��o de Campo
	oStFilho:SetProperty('ZZ3_CODCD',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi��o
	oStFilho:SetProperty('ZZ3_CODCD',  MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigat�rio
	oStFilho:SetProperty('ZZ3_CODART', MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigat�rio
	oStFilho:SetProperty('ZZ3_CODMUS', MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'u_zIniMus()'))                         //Ini Padr�o
	
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('zModel3M')
	oModel:AddFields('ZZ2MASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('ZZ3DETAIL','ZZ2MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
	
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aZZ3Rel, {'ZZ3_FILIAL','ZZ2_FILIAL'} )
	aAdd(aZZ3Rel, {'ZZ3_CODCD',	'ZZ2_CODCD'})
	aAdd(aZZ3Rel, {'ZZ3_CODART','ZZ2_CODART'}) 
	
	oModel:SetRelation('ZZ3DETAIL', aZZ3Rel, ZZ3->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
	oModel:GetModel('ZZ3DETAIL'):SetUniqueLine({"ZZ3_DESC"})	//N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})
	
	//Setando as descri��es
	oModel:SetDescription("Grupo de Produtos - Mod. 3")
	oModel:GetModel('ZZ2MASTER'):SetDescription('Cadastro')
	oModel:GetModel('ZZ3DETAIL'):SetDescription('CDs')
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 *---------------------------------------------------------------------*/

Static Function ViewDef()
	Local oView		:= Nil
	Local oModel		:= FWLoadModel('zModel3')
	Local oStPai		:= FWFormStruct(2, 'ZZ2')
	Local oStFilho	:= FWFormStruct(2, 'ZZ3')
	
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabe�alho e o grid dos filhos
	oView:AddField('VIEW_ZZ2',oStPai,'ZZ2MASTER')
	oView:AddGrid('VIEW_ZZ3',oStFilho,'ZZ3DETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZZ2','CABEC')
	oView:SetOwnerView('VIEW_ZZ3','GRID')
	
	//Habilitando t�tulo
	oView:EnableTitleView('VIEW_ZZ2','Cabe�alho - Cadastro')
	oView:EnableTitleView('VIEW_ZZ3','Grid - CDs')
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
	//Remove os campos de C�digo do Artista e CD
	oStFilho:RemoveField('ZZ3_CODART')
	oStFilho:RemoveField('ZZ3_CODCD')
Return oView

/*/{Protheus.doc} zIniMus
Fun��o que inicia o c�digo sequencial da grid
@type function
@author Atilio
@since 03/09/2016
@version 1.0
/*/

User Function zIniMus()
	Local aArea := GetArea()
	Local cCod  := StrTran(Space(TamSX3('ZZ3_CODMUS')[1]), ' ', '0')
	Local oModelPad  := FWModelActive()
	Local oModelGrid := oModelPad:GetModel('ZZ3DETAIL')
	Local nOperacao  := oModelPad:nOperation
	Local nLinAtu    := oModelGrid:nLine
	Local nPosCod    := aScan(oModelGrid:aHeader, {|x| AllTrim(x[2]) == AllTrim("ZZ3_CODMUS")})
	
	//Se for a primeira linha
	If nLinAtu < 1
		cCod := Soma1(cCod)
	
	//Sen�o, pega o valor da �ltima linha
	Else
		cCod := oModelGrid:aCols[nLinAtu][nPosCod]
		cCod := Soma1(cCod)
	EndIf
	
	RestArea(aArea)
Return cCod