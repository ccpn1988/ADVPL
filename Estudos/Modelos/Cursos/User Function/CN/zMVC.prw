#include 'protheus.ch'
#include 'parmtype.ch'
#include 'FWMVCDEF.ch'


user function zMVC()
	Local oBrowse
	//MONTAGEM DO BROWSE PRINCIPAL
	oBrowse	:= FWMBrowse():New()
	oBrowse:SetAlias('ZZ3')
	oBrowse:SetDescription('Cadastro de Contas')
	oBrowse:SetMenuDef('zMVC')
	oBrowse:Activate()
return

//MONTAGEM DO MENU
Static Function MenuDef()
	Local aRotina := {}
	
	aAdd(aRotina,{'Visualizar'	,'VIEWDEF.zMVC'	,0,	2,	0, NIL})
	aAdd(aRotina,{'Incluir'		,'VIEWDEF.zMVC'	,0,	3,	0, NIL})
	aAdd(aRotina,{'Alterar'		,'VIEWDEF.zMVC'	,0,	4,	0, NIL})
	aAdd(aRotina,{'Excluir'		,'VIEWDEF.zMVC'	,0,	5,	0, NIL})
	aAdd(aRotina,{'Imprimir'	,'VIEWDEF.zMVC'	,0,	8,	0, NIL})
	aAdd(aRotina,{'Copiar'		,'VIEWDEF.zMVC'	,0,	9,	0, NIL})
	
Return aRotina

//CONTRUÇÂO DO MODELO
Static Function ModelDef()
	Local oModel // Modelo de dados que será construído
	Local oStruZZ3	:= FWFormStruct(1,"ZZ3") //CRIANDO ESTRUTURA PARAMETRO 1
	
	oModel	:= MPFormModel() :New("MD_ZZ3") //MPFormModel é a classe utilizada para a construção de um objeto de modelo de dados
	oModel:addFields('MASTERZZ3', /*cOwner*/,oStruZZ3)
	oModel:SetPrimaryKey({'ZZ3_FILIAL', 'ZZ3_CODIGO'}) //INDICE 1 DA TABELA
	
Return oModel

//CONSTRUINDO VISUALIZAÇÃO
Static Function ViewDef()
	Local oModel := ModelDef() //Definimos qual o modelo de dados (Model) que será utilizado na interface (View).
	Local oView
	Local oStrZZ3 := FWFormStruct(2,'ZZ3') //CRIA A ESTRUTURA PARAMETRO 2
		
		//RESTRINGINDO CAMPOS
		/*If __cUserID <> "000000" //USUÁRIO ADMINISTRADOR
			oStruct:RemoveField( "A1_DESC" )
		Endif*/
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField('FORM_ZZ3',oStrZZ3,'MASTERZZ3')
	oView:CreateHorizontalBox('BOX_FORM_ZZ3',100)
	oView:SetownerView('FORM_ZZ3','BOX_FORM_ZZ3')
	
	Return oView
