#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC04()
Local oBrowser := FwmBrowse():New()

	/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	oBrowser:setAlias("SA1")
	oBrowser:setDescription("MVC - Cadastro de Clientes")
	/*LEGENDA DA TELA*/
	oBrowser:AddLegend("A1_MSBLQL=='2'","BR_PINK", "Ativo")
	oBrowser:AddLegend("A1_MSBLQL=='1'","BR_VERDE", "Desativado")
	oBrowser:AddLegend("A1_MSBLQL==' '","BR_AZUL", "BRACO")
	//Ativando o OBJETO - Nada pode ser colocado abaixo deste.
	oBrowser:Activate()

Return (NIL)
//-------------------------------------------------------------------------

/*SEMPRE NOSSOS BOTÔES RECEBERÀ ESTE NOME DESTA FUNCÂO POIS ESTA ENCAPSULADO*/
Static Function MenuDef()
	Local aRotina :={}
AADD( aRotina, {"Analise de Credito" , "VIEWDEF.MVC04",0 ,4, 0})
Return(aRotina)



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
 
Local oStr2:= mldoStr2Str()
oModel := MPFormModel():New('MDLSA1SE1',,,{|oModel|fgrava(oModel)})
oModel:SetDescription('Analise de Credito')
oModel:addFields('SA1MASTER',,oStr1,,,{|oFIELD,lCopy|fLoadSA1(oFIELD,lCopy)})

oModel:addGrid('SE1GRID','SA1MASTER',oStr2,,,,,{|oGrid,lCopy|LoadSE1(oGrid,lCopy)})

oModel:getModel('SA1MASTER'):SetDescription('Dados do Cliente')
oModel:SetPrimaryKey({ 'A1_COD', 'A1_LOJA' })
oModel:getModel('SE1GRID'):SetDescription('Contas a Receber')

oModel:getModel('SE1GRID'):SetNoInsertLine(.T.)
oModel:getModel('SE1GRID'):SetNoUpdateLine(.F.)
oModel:getModel('SE1GRID'):SetNoDeleteLine(.T.)


Return oModel

Static Function fLoadSA1(oFIELD,lCopy)
Local aDados :={}

aAdd(aDados,{SA1->A1_COD ,;
			SA1->A1_LOJA ,;
			SA1->A1_NOME ,;
			SA1->A1_CONTATO ,;
			SA1->A1_TEL  })
			
aAdd(aDados,Recno()) //Informando recno do registro
			
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
oStruct:AddField('Codigo','Codigo do Cliente' , 'A1_COD', 'C', 6, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('LOJA','Loja' , 'A1_LOJA', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Cliente','Nome do cliente' , 'A1_NOME', 'C', 50, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Contato','Nome do contato' , 'A1_CONT', 'C', 30, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Telefone','Telefone de contato' , 'A1_TEL', 'C', 12, 0, , , {}, .F., , .F., .F., .T., , )





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
 
Local oStr2:= viewoStr2Str()
oView := FWFormView():New()

oView:SetModel(oModel)

oView:AddField('VIEWSA1' , oStr1,'SA1MASTER' )
oView:AddGrid('VIEWSE1' , oStr2,'SE1GRID')  
oView:CreateHorizontalBox( 'CAPA', 22)
oView:CreateHorizontalBox( 'BOXGRID', 78)
oView:SetOwnerView('VIEWSE1','BOXGRID')
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
oStruct:AddField( 'A1_COD','1','Codigo','Codigo',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'A1_LOJA','2','LOJA','LOJA',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'A1_NOME','3','Cliente','Cliente',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'A1_CONT','4','Contato','Contato',, 'Get' ,,,,.T.,,,,,,.T.,, )
oStruct:AddField( 'A1_TEL','5','Telefone','Telefone',, 'Get' ,,,,.T.,,,,,,.T.,, )

return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} mldoStr2Str()
Retorna estrutura do tipo FWformModelStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function mldoStr2Str()
Local oStruct := FWFormModelStruct():New()
oStruct:AddTable('TSE1',,'Contas a Receber')
oStruct:AddField('  ','CHECK DO CAMPO' , 'CHECK', 'L', 1, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Numero','Numero do Campo' , 'E1_NUM', 'C', 9, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('PARCELA','PARCELA' , 'E1_PARCELA', 'C', 1, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Prefixo','Prefixo' , 'E1_PREFIXO', 'C', 5, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Tipo','Tipo' , 'E1_TIPO', 'C', 3, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Vencimento','Vencimento' , 'E1_VENCREA', 'D', 8, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Valor','Valor' , 'E1_VALOR', 'N', 12, 2, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Saldo','Saldo' , 'E1_SALDO', 'N', 12, 2, , , {}, .F., , .F., .F., .T., , )








return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} viewoStr2Str()
Retorna estrutura do tipo FWFormViewStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function viewoStr2Str()
Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'CHECK','1','  ','  ',, 'Check' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'E1_NUM','2','Numero','Numero',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_PARCELA','3','PARCELA','PARCELA',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_PREFIXO','4','Prefixo','Prefixo',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_TIPO','5','Tipo','Tipo',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_VENCREA','6','Vencimento','Vencimento',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_VALOR','7','Valor','Valor',, 'Get' ,'@E 999,999,999.99',,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_SALDO','8','Saldo','Saldo',, 'Get' ,'@E 999,999,999.99',,,.F.,,,,,,.T.,, )

return oStruct

Static Function LoadSE1(oGrid,lCopy)
Local aDados :={}
Local cAlias := GetNextAlias()

BeginSql Alias cAlias
	column E1_VENCREA as Date
Select  E1_NUM,
		E1_PARCELA,
		E1_PREFIXO,
		E1_TIPO,
		E1_VENCREA,
		E1_VALOR,
		E1_SALDO
		
From %Table:SE1% SE1
	Where E1_FILIAL = %XFILIAL:SE1%
	AND E1_CLIENTE  = %EXP:SA1->A1_COD%
	AND E1_LOJA		= %EXP:SA1->A1_LOJA% 
	AND E1_SALDO > 0
	AND %notDel%
	
EndSql

aSql := GetLastQuery() // informaçoes sobre a query executada.

dbSelectArea (cAlias)
dbGotop()

While ! EOF()
	aAdd(aDados, {0,{.F.,;
			E1_NUM		,;
			E1_PARCELA	,;
			E1_PREFIXO	,;
			E1_TIPO		,;
			E1_VENCREA	,;
			E1_VALOR	,;
			E1_SALDO}})
		
		dbSkip()
		
Enddo
Return(aDados)



Static Function fgrava(oModel)

	RecLock("SA1",.F.)
		SA1->A1_CONTATO := oModel:GetValue("SA1MASTER","A1_CONT")
	MsUnLock()
Return .T.