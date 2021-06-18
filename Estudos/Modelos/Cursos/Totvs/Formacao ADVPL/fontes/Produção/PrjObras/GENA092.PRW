#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA092   ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutenção de Serie e Catalogos                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENA092B()

U_GENA092("S") // MANUTENÇÃO DE SERIE

Return nil

User Function GENA092C()

U_GENA092("C") // MANUTENÇÃO DE CATALOGO

Return nil

User Function GENA092(cParamTipo)

Private oBrowse                                                               
Private aRotina     := {}
Private cTipo       := ""
Private cTitTela    := ""

Default cParamTipo   := "S"

cTipo := cParamTipo

DbSelectArea("ZZX")
ZZX->(DbSetOrder(1))

// Definição das Operações disponíveis.
aRotina := MenuDef()           

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZZX')
Do Case
    Case cTipo == "C"
        cTitTela := "Manutenção de Coleção"
		//Adiciona um filtro ao browse
		oBrowse:SetFilterDefault( "ZZX->ZZX_TIPO=='C'" )
                
    Case cTipo == "S"
        cTitTela := "Manutenção de Series"
        oBrowse:SetFilterDefault( "ZZX->ZZX_TIPO=='S'" )
        
    OtherWise
        cTitTela := "Manutenção de Series/Coleção"
EndCase

oBrowse:SetDescription(cTitTela) 
oBrowse:Activate()

Return NIL

Static Function MenuDef()
Local aRotina := {}

//aRotina := FWMVCMenu( "GENA092" )
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.GENA092' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.GENA092' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.GENA092' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.GENA092' OPERATION 5 ACCESS 0

Return aRotina


Static Function ModelDef()     
// Cria Estruturas para serem usadas no Modelo de Dados
Local oStruZZX  := FWFormStruct(1,'ZZX')
Local oStruZZY  := FWFormStruct(1,'ZZY')
Local bBloco	:= {|oModel| loadField(oModel)}
// Cria Modelo de Dados
Local oModel 

oModel := MPFormModel():New('MDFGENA092')

// Adiciona um Componente de Formulário ao modelo.
oModel:AddFields('ZZX_FORM',/*cOwner*/,oStruZZX,/*blinePre*/,/*blinePos*/) 
oModel:AddGrid('ZZY_GRID',"ZZX_FORM",oStruZZY,/*blinePre*/,/*blinePos*/)   

oModel:SetRelation( 'ZZY_GRID', { { 'ZZY_FILIAL', 'xFilial("ZZY")' }, { 'ZZY_COD', "ZZX_COD" } }, ZZY->( IndexKey( 1 ) ) )


// Definição da Chave Primária
oModel:SetPrimaryKey({"ZZX_FILIAL","ZZX_COD"}) 

// Descrição do Modelo
oModel:SetDescription(cTitTela) 
// Descrição do Modelo
oModel:GetModel('ZZX_FORM'):SetDescription(cTitTela)
oModel:GetModel('ZZY_GRID'):SetDescription("Produtos relacionados")

oModel:SetActivate(bBloco)

Return oModel      

Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruZZX  := FWFormStruct(2,'ZZX')
Local oStruZZY  := nil
// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENA092')
// Cria o modelo da View
Local oView := FWFormView():New()

Do Case
    Case cTipo == "C"
        oStruZZY := FWFormStruct(2,'ZZY',{|cCampo| .NOT. AllTrim(cCampo) $ "ZZY_COD/ZZY_TPPROX"})
    Case cTipo == "S"
        oStruZZY := FWFormStruct(2,'ZZY',{|cCampo| .NOT. AllTrim(cCampo) $ "ZZY_COD"})
    OtherWise
        oStruZZY := FWFormStruct(2,'ZZY',{|cCampo| .NOT. AllTrim(cCampo) $ "ZZY_COD"})
EndCase

// Definimos qual modelo será carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Está relacionado à um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_ZZX', oStruZZX, 'ZZX_FORM')
oView:AddGrid('VIEW_ZZY', oStruZZY, 'ZZY_GRID')

oStruZZX:SetProperty( "ZZX_MSBLQL", MVC_VIEW_INSERTLINE , .T. )
oStruZZX:SetProperty( "ZZX_TITOBR", MVC_VIEW_INSERTLINE , .F. )
oStruZZX:SetProperty( "ZZX_DESC", MVC_VIEW_INSERTLINE , .T. )
oStruZZX:SetProperty( "ZZX_TIPO", MVC_VIEW_CANCHANGE,.F.)

Do Case
    Case cTipo == "C"
    	oStruZZX:SetProperty( "ZZX_COD"		, MVC_VIEW_TITULO , "ID/Sku Catalogo" )
        oStruZZY:SetProperty( "ZZY_CODPRO"	, MVC_VIEW_TITULO , "ID/Sku Catalogo" )
    Case cTipo == "S"
    	oStruZZX:SetProperty( "ZZX_COD"		, MVC_VIEW_TITULO , "ID/Sku Serie" )
        oStruZZY:SetProperty( "ZZY_CODPRO", MVC_VIEW_TITULO , "ID/Sku Proximo" )
    OtherWise
    	oStruZZX:SetProperty( "ZZX_COD", MVC_VIEW_TITULO , "ID/Sku" )
        oStruZZY:SetProperty( "ZZY_CODPRO", MVC_VIEW_TITULO , "ID/Sku" )
EndCase

// Agora vamos criar 'box' para suportar os componentes. Box é uma descrição genérica para Window, Panel, etc
oView:CreateHorizontalBox( 'CAB', 030 ) // ocupar 100% da tela
oView:CreateHorizontalBox( 'ITE', 070 ) // ocupar 100% da tela
 
// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_ZZX' ,'CAB')
oView:SetOwnerView('VIEW_ZZY' ,'ITE')

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_ZZX')
oView:EnableTitleView('VIEW_ZZY')

Return oView

Static Function loadField(oFieldModel)
Local oView		:= FWViewActive()

If oFieldModel:GetOperation() == 3
	If ISINCALLSTACK("U_GENA092B")
		oFieldModel:LoadValue( 'ZZX_FORM', 'ZZX_TIPO', "S" )
	ElseIf ISINCALLSTACK("U_GENA092C")
		oFieldModel:LoadValue( 'ZZX_FORM', 'ZZX_TIPO', "C" )
	EndIf			
EndIF

Return nil