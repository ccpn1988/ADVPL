#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"

#Define ENTER Chr(13)+Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENCADTP  �Autor  �Cleuto Lima         � Data �  09/08/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de tipo de publica��o.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Projeto Gest�o de Obras                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENCADTP()

Private oBrowse                                                               
Private aRotina	:= {}

DbSelectArea("ZZT")
ZZT->(DbSetOrder(1))

// Defini��o das Opera��es dispon�veis.
aRotina := MenuDef()           

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZZT')
oBrowse:SetDescription("Manuten��o de Processos") 

oBrowse:Activate()

Return NIL

Static Function MenuDef()
Local aRotina := {}

aRotina := FWMVCMenu( "GENCADTP" )

Return aRotina


Static Function ModelDef()     
// Cria Estruturas para serem usadas no Modelo de Dados
Local oStruZZT  := FWFormStruct(1,'ZZT')

// Cria Modelo de Dados
Local oModel 

oModel := MPFormModel():New('GENCA_TP')

// Adiciona um Componente de Formul�rio ao modelo.
oModel:AddFields('ZZT_FORM',/*cOwner*/,oStruZZT,/*blinePre*/,/*blinePos*/)   

// Descri��o do Modelo
oModel:SetDescription("Tipo de Publica��o") 
// Descri��o do Modelo
oModel:GetModel('ZZT_FORM'):SetDescription("Tipo de publica��o")

Return oModel      

Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruZZT  := FWFormStruct(2,'ZZT')

// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENCADTP')

// Cria o modelo da View
Local oView := FWFormView():New()

// Definimos qual modelo ser� carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Est� relacionado � um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_ZZT', oStruZZT, 'ZZT_FORM')

// Agora vamos criar 'box' para suportar os componentes. Box � uma descri��o gen�rica para Window, Panel, etc
oView:CreateHorizontalBox( 'TELA', 100 ) // ocupar 100% da tela
 
// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_ZZT' ,'TELA')

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_ZZT')

Return oView