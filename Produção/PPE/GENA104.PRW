#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA104   ºAutor  ³Cleuto              º Data ³  25/06/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutenção de acessos RPA e PPE                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function GENA104()

Private oBrowse                                                               
Private aRotina     := {}
Private cTipo       := ""
Private cTitTela    := "Acessos RPA/PPE"

DbSelectArea("ZZF")
ZZF->(DbSetOrder(1))

// Definição das Operações disponíveis.
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

// Adiciona um Componente de Formulário ao modelo.
oModel:AddFields('ZZF_FORM',/*cOwner*/,oStruZZF,/*blinePre*/,/*blinePos*/) 

// Descrição do Modelo
oModel:SetDescription(cTitTela) 
// Descrição do Modelo
oModel:GetModel('ZZF_FORM'):SetDescription(cTitTela)

Return oModel      

Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruZZF  := FWFormStruct(2,'ZZF')
// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENA104')
// Cria o modelo da View
Local oView := FWFormView():New()

// Definimos qual modelo será carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Está relacionado à um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_ZZF', oStruZZF, 'ZZF_FORM')

// Agora vamos criar 'box' para suportar os componentes. Box é uma descrição genérica para Window, Panel, etc
oView:CreateHorizontalBox( 'CAB', 100 ) // ocupar 100% da tela
 
// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_ZZF' ,'CAB')

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_ZZF')

Return oView
