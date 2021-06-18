#Include 'Protheus.ch'

User Function MVC04()

Local oBrowse	:= FwmBrowse():New()
		
	oBrowse:SetAlias("SA1")	// Qual tabela vou usar
	oBrowse:SetDescription("Cadastro de Cliente MVC") //Qual a descrição do meu browse
	oBrowse:AddLegend("A1_MSBLQL == '2'","BR_MARRON","Ativo"	 )	//Adiciona legenda
	oBrowse:AddLegend("A1_MSBLQL <> '2'","BR_PINK"	,"Desativado")	//Adiciona legenda
	oBrowse:Activate()	// Ativa o OBJETO
	
Return(Nil)
	
Static Function MenuDef()
Local aRotina := {}
	
	AADD( aRotina, {"Analise de Crédito" , 'VIEWDEF.MVC04', 0, 2 , 0} )
	
Return (aRotina)




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
oModel:SetDescription('Analise de Credito')
oModel:addFields('SA1MASTER',,oStr1,,,{|oFIELD,lCopy|floadSA1(oFIELD,lCopy)})
oModel:getModel('SA1MASTER'):SetDescription('Dados do Cliente')



Return oModel

Static Function fLoadSA1(oFIELD,lCopy)
Local aDados :=- {}

aADD(aDados,{SA1->A1_COD,;
			 SA1->A1_LOJA,;
			 SA1->A1_NOME,;
			 SA1->A1_CONTATO,;
			 SA1->A1_TEL})
			 
aADD(aDados,Recno()) //INFORMANDO recno DO REGISTRO
			 
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
oStruct:AddTable('TSA1',,'Cadastro de Cliente')
oStruct:AddField('Codigo ','Codigo do Cliente' , 'A1_COD', 'C', 6, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('LOJA','Loja do Cliente' , 'A1_LOJA', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Cliente','Nome Cliente' , 'A1_NOME', 'C', 50, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Contato','Nome do Contato' , 'A1_CONTATO', 'C', 40, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Telefone','Telefone' , 'A1_TEL', 'C', 12, 0, , , {}, .F., , .F., .F., .T., , )





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
oStruct:AddField( 'A1_COD','1','Codigo ','Codigo ',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_NOME','2','Cliente','Cliente',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_LOJA','3','LOJA','LOJA',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_CONTATO','4','Contato','Contato',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_TEL','5','Telefone','Telefone',, 'Get' ,,,,,,,,,,.T.,, )





return oStruct
