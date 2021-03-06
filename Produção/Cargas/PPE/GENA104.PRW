#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TBICONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA104   �Autor  �Cleuto              � Data �  25/06/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Manuten��o de acessos RPA e PPE                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function GENA104()

Private oBrowse                                                               
Private aRotina     := {}
Private cTipo       := ""
Private cTitTela    := "Acessos RPA/PPE"

DbSelectArea("ZZF")
ZZF->(DbSetOrder(1))

// Defini��o das Opera��es dispon�veis.
aRotina := MenuDef()           

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZZF')

//oBrowse:AddLegend( "ZZF_MSBLQL=='2'", "GREEN", "Ativo" )
//oBrowse:AddLegend( "ZZF_MSBLQL=='1'", "RED", "Bloqueado" )

oBrowse:DisableDetails()
oBrowse:SetDescription(cTitTela) 
oBrowse:Activate()

Return NIL

Static Function MenuDef()
Local aRotina := {}

//aRotina := FWMVCMenu( "GENA092" )
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.GENA104' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.GENA104' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.GENA104' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.GENA104' OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
// Cria Estruturas para serem usadas no Modelo de Dados
Local oStruZZF  := FWFormStruct(1,'ZZF')
Local bBloco	:= {|oModel| loadField(oModel)}
// Cria Modelo de Dados
Local oModel 

oModel := MPFormModel():New('MDFGENA104')

// Adiciona um Componente de Formul�rio ao modelo.
oModel:AddFields('ZZF_FORM',/*cOwner*/,oStruZZF,/*blinePre*/,/*blinePos*/) 

// Descri��o do Modelo
oModel:SetDescription(cTitTela) 
// Descri��o do Modelo
oModel:GetModel('ZZF_FORM'):SetDescription(cTitTela)

Return oModel      

Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruZZF  := FWFormStruct(2,'ZZF')
// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENA104')
// Cria o modelo da View
Local oView := FWFormView():New()

// Definimos qual modelo ser� carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Est� relacionado � um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_ZZF', oStruZZF, 'ZZF_FORM')

// Agora vamos criar 'box' para suportar os componentes. Box � uma descri��o gen�rica para Window, Panel, etc
oView:CreateHorizontalBox( 'CAB', 100 ) // ocupar 100% da tela
 
// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_ZZF' ,'CAB')

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_ZZF')

Return oView
