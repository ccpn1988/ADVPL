/* ===
    Esse ? um exemplo disponibilizado no Terminal de Informa??o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/07/17/advpl-027/
    Caso queira ver outros conte?dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari?veis Est?ticas
Static cTitulo  := "Composi??o de CDs"

/*/{Protheus.doc} zCopMVC
Fun??o para c?pia do cadastro de Composi??o de CDs (Exemplo de Modelo 3 - ZZ2 x ZZ3)
@author Atilio
@since 29/04/2017
@version 1.0
	@return Nil, Fun??o n?o tem retorno
	@example
	u_zCopMVC()
/*/

User Function zCopMVC()
	Local  aArea     := GetArea()
	Local  oBrowse
	Local  cFunBkp   := FunName()
	Private __lCopia := .F.
	
	SetFunName("zCopMVC")
	
	//Inst?nciando FWMBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZ2")
	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Desc:  Cria??o do menu MVC                                          |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando op??es - est?o no zCopMVC.prw
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zCopMVC' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zCopMVC' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zCopMVC' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zCopMVC' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

	//Rotina de Copiar
	ADD OPTION aRot TITLE 'Copiar'     ACTION 'u_zCopyZZ2'      OPERATION 9                      ACCESS 0

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Desc:  Cria??o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/

Static Function ModelDef()
	Local oModel 	:= Nil
	Local oStPai 	:= FWFormStruct(1, 'ZZ2')
	Local oStFilho 	:= FWFormStruct(1, 'ZZ3')
	Local aZZ3Rel	:= {}
	
	//Defini??es dos campos
	oStPai:SetProperty('ZZ2_CODCD',    MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZZ2", "ZZ2_CODCD")'))       //Ini Padr?o
	oStPai:SetProperty('ZZ2_CODART',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("ZZ1", M->ZZ2_CODART)'))      //Valida??o de Campo
	oStFilho:SetProperty('ZZ3_CODCD',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edi??o
	oStFilho:SetProperty('ZZ3_CODCD',  MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigat?rio
	oStFilho:SetProperty('ZZ3_CODART', MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigat?rio
	
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('zCopMVCM')
	oModel:AddFields('ZZ2MASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('ZZ3DETAIL','ZZ2MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner ? para quem pertence
	
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aZZ3Rel, {'ZZ3_FILIAL','ZZ2_FILIAL'} )
	aAdd(aZZ3Rel, {'ZZ3_CODCD',	'ZZ2_CODCD'})
	aAdd(aZZ3Rel, {'ZZ3_CODART','ZZ2_CODART'}) 
	
	oModel:SetRelation('ZZ3DETAIL', aZZ3Rel, ZZ3->(IndexKey(1))) //IndexKey -> quero a ordena??o e depois filtrado
	oModel:GetModel('ZZ3DETAIL'):SetUniqueLine({"ZZ3_DESC"})	//N?o repetir informa??es ou combina??es {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})
	
	//Setando as descri??es
	oModel:SetDescription("Grupo de Produtos - Mod. 3")
	oModel:GetModel('ZZ2MASTER'):SetDescription('Cadastro')
	oModel:GetModel('ZZ3DETAIL'):SetDescription('CDs')
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Desc:  Cria??o da vis?o MVC                                         |
 *---------------------------------------------------------------------*/

Static Function ViewDef()
	Local oView		:= Nil
	Local oModel	:= FWLoadModel('zCopMVC')
	Local oStPai	:= FWFormStruct(2, 'ZZ2')
	Local oStFilho	:= FWFormStruct(2, 'ZZ3')
	
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabe?alho e o grid dos filhos
	oView:AddField('VIEW_ZZ2',oStPai,'ZZ2MASTER')
	oView:AddGrid('VIEW_ZZ3',oStFilho,'ZZ3DETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZZ2','CABEC')
	oView:SetOwnerView('VIEW_ZZ3','GRID')
	
	//Define campo com auto incremento
	oView:AddIncrementField('VIEW_ZZ3', 'ZZ3_CODMUS')
	
	//Habilitando t?tulo
	oView:EnableTitleView('VIEW_ZZ2','Cabe?alho - Cadastro')
	oView:EnableTitleView('VIEW_ZZ3','Grid - CDs')
	
	//For?a o fechamento da janela na confirma??o
	oView:SetCloseOnOk({||.T.})
	
	//Remove os campos de C?digo do Artista e CD
	oStFilho:RemoveField('ZZ3_CODART')
	oStFilho:RemoveField('ZZ3_CODCD')
Return oView

/*/{Protheus.doc} zCopyZZ2
Fun??o para c?pia dos dados em MVC
@type function
@author Atilio
@since 29/04/2017
@version 1.0
/*/

User Function zCopyZZ2()
	Local aArea        := GetArea()
	Local cTitulo      := "C?pia"
	Local cPrograma    := "zCopMVC"
	Local nOperation   := MODEL_OPERATION_INSERT
	Local nLin         := 0
	Local nCol         := 0
	Local nTamanGrid   := 0
	
	//Caso precise testar em algum lugar
	__lCopia     := .T.
	
	//Carrega o modelo de dados
	oModel := FWLoadModel(cPrograma)
	oModel:SetOperation(nOperation) // Inclus?o
	oModel:Activate(.T.) // Ativa o modelo com os dados posicionados
	
	//Pegando o campo de chave
	cCodCd := GetSXENum("ZZ2", "ZZ2_CODCD")
	ConfirmSX8()
	
	//Setando os campos do cabe?alho
	oModel:SetValue("ZZ2MASTER", "ZZ2_CODCD",  cCodCd)
	oModel:SetValue("ZZ2MASTER", "ZZ2_DESC",   "COP - "+Alltrim(ZZ2->ZZ2_DESC))
	
	//Pegando os dados do filho
	oModelGrid := oModel:GetModel("ZZ3DETAIL")
	oStruct    := oModelGrid:GetStruct()
	aCampos    := oStruct:GetFields()
	
	//Se n?o for P12, pega do aCols, sen?o pega do aDataModel
	nTamanGrid := Iif(GetVersao(.F.) < "12", Len(oModelGrid:aCols), Len(oModelGrid:aDataModel))
	
	//Zerando os campos da grid
	For nLin := 1 To nTamanGrid
	
		//Setando a linha atual
		oModelGrid:SetLine(nLin)
		
		//Percorrendo as colunas
		For nCol := 1 To Len(aCampos)
		
			//Se for a coluna desejada, ir? zerar
			If Alltrim(aCampos[nCol][3]) == "ZZ3_DESC"
				oModel:SetValue("ZZ3DETAIL", aCampos[nCol][3], "Linha "+cValToChar(nLin))
			EndIf
		Next nCol
	Next nLin
	oModelGrid:SetLine(1)  
	
	//Executando a visualiza??o dos dados para manipula??o
	nRet     := FWExecView( cTitulo , cPrograma, nOperation, /*oDlg*/, {|| .T. } ,/*bOk*/ , /*nPercReducao*/, /*aEnableButtons*/, /*bCancel*/ , /*cOperatId*/, /*cToolBar*/, oModel )
	__lCopia := .F.
	oModel:DeActivate()
	
	//Se a c?pia for confirmada
	If nRet == 0
		MsgInfo("C?pia confirmada!", "Aten??o")
	EndIf
	
	RestArea(aArea)
Return oModel