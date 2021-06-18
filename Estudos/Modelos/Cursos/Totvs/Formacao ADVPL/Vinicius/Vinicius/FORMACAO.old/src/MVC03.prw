#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC03()

Local oBrowser := FwmBrowse():New()

	oBrowser:SetAlias("SZ2")
	oBrowser:SetDescription("Pedido de Sucata")

	oBrowser:AddLegend("A1_MSBLQL=='2'","BR_MARRON","ATIVO")
	oBrowser:AddLegend("A1_MSBLQL=='1'","BR_PINK", "DESATIVADO")
	oBrowser:Activate() //Ativando o obj

Return(Nil)

Static Function MenuDef()
	Local aRotina :=FwMVCMenu('MVC03') //cRIANDO OS BOTÕES VISUALIZAR,INCLUIR,ALTERAR,EXCLUIR,COPIAR,IMPRIMIR{}.

//Local aRotina:= {}

	//AADD(aRotina,{"Pesquisar"	, "AxPesqui"		,0,1	})
	//AADD(aRotina,{"Visualizar"	, 'VIEWDEF.MVC03'	,0,2,0	})
	//AADD(aRotina,{"Incluir"		, 'VIEWDEF.MVC03'	,0,3,0	})
	//AADD(aRotina,{"Alterar"		, 'VIEWDEF.MVC03'	,0,2,0	})
	
	
	
Return (aRotina)

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 25/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'SZ2')
 
Local oStr2:= FWFormStruct(1,'SZ3')
oModel := MPFormModel():New('MDLSZ2')
oModel:SetDescription('Pedido de Sucata')
oModel:addFields('Mastersz2',,oStr1)
oModel:addGrid('GRID1','Mastersz2',oStr2)

oModel:SetRelation('GRID1', { { 'SZ3_FILIAL', "xFilial('SZ3')" },{'Z3_COD','Z2_COD'}}, SZ3->(IndexKey(1)) )



oModel:SetPrimaryKey({ 'Z2_COD' })


oModel:getModel('Mastersz2'):SetDescription('Dados do Fornecedor')
oModel:getModel('GRID1'):SetDescription('Dados do Produto')




Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 25/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= FWFormStruct(2, 'SZ2')
 
Local oStr2:= FWFormStruct(2, 'SZ3')
oView := FWFormView():New()

oStr2:SetProperty('Z3_ITEM',MVC_VIEW_ORDEM,'01')

oView:SetModel(oModel,'Mastersz2')
oView:AddField('VIEWSZ2' , oStr1,'Mastersz2' )
oView:AddGrid('VIEWSZ3' , oStr2,'GRID1') 
 
oView:CreateHorizontalBox( 'BOXFORM1', 50)


oStr2:SetProperty('Z3_TOTAL',MVC_VIEW_ORDEM,'05')

oView:CreateHorizontalBox( 'BOXFORM3', 50)
oView:SetOwnerView('VIEWSZ3','BOXFORM3')
oView:SetOwnerView('VIEWSZ2','BOXFORM1')
oView:AddIncrementField('VIEWSZ3' , 'Z3_ITEM' ) 


Return oView