#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


User Function mvc04()
	Local oBrowser := FwmBrowse():New()
	oBrowser:SetAlias("SA1")
	oBrowser:SetDescription("Cadastro de Cliente")
	oBrowser:AddLegend("A1_MSBLQL == '2'", "BR_MARRON","Ativo")
	oBrowser:AddLegend("A1_MSBLQL == '1'", "BR_PINK","Desativado")
	oBrowser:Activate() //Ativando o objeto
	
Return(NIL)

Static Function MenuDef() //Barra de botões
	//Local aRotina:=FwMVCMenu('mvc04')//Criando os botões visualizar, incluir, alterar, excluir, copiar, imprimir
	Local aRotina := {}
	AADD(aRotina , {"Analise de Credito", 'VIEWDEF.MVC04', 0,2,0})
Return(aRotina)

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------


/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
	Local oModel
	
	
	Local oStr1:= mldoStr1Str()
	oModel := MPFormModel():New('MDLSA1SE1')
	oModel:SetDescription('ANALISE DE CREDITO')
	oModel:addFields('SA1MASTER',,oStr1,,,{|oField,lCopy|fLoadSa1(oField,lCopy)})
	oModel:getModel('SA1MASTER'):SetDescription('DADOS DO CLIENTE')
	
	
	
Return oModel


Static Function fLoadSa1(oField,lCopy)

Local aDados := {}

aAdd (aDados, {SA1->A1_COD ,;
              SA1->A1_LOJA ,;
              SA1->A1_NOME ,;
              SA1->A1_CONTATO, ;
              SA1->A1_TEL})
              
aAdd (aDados,Recno()) //Informado recno do registro              

Return aDados
//-------------------------------------------------------------------
/*/{Protheus.doc} mldoStr1Str()
Retorna estrutura do tipo FWformModelStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function mldoStr1Str()
	Local oStruct := FWFormModelStruct():New()
	oStruct:AddTable('TSA1',,'CADASTRO DE CLIENTE ')
	oStruct:AddField('CODIGO','CODIGO DO CLIENTE' , 'A1_COD', 'C', 6, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('LOJA','LOJA' , 'A1_LOJA', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('CLIENTE','NOME CLIENTE' , 'A1_NOME', 'C', 50, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CONTATO','NOME DO CONTATO' , 'CONTATO', 'C', 30, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('TELEFONE','TELEFONE DE CONTATO' , 'A1_TEL', 'C', 12, 0, , , {}, .F., , .F., .F., .T., , )
	
	
	
	
	
return oStruct


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= viewoStr1Str()
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEWSA1' , oStr1,'SA1MASTER' ) 
oView:CreateHorizontalBox( 'CAPA', 100)
oView:SetOwnerView('VIEWSA1','CAPA')

Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} viewoStr1Str()
Retorna estrutura do tipo FWFormViewStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function viewoStr1Str()
Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'A1_COD','1','CODIGO','CODIGO',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_LOJA','2','LOJA','LOJA',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_NOME','3','CLIENTE','CLIENTE',, 'Get' ,,,,,,,,,,,, )
oStruct:AddField( 'CONTATO','4','CONTATO','CONTATO',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_TEL','5','TELEFONE','TELEFONE',, 'Get' ,,,,,,,,,,.T.,, )

return oStruct
