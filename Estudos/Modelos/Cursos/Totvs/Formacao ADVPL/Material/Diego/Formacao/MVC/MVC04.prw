#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*CRIANDO UMA TELA COM INFORMA??ES DE CLIENTE E SE1 - A PAGAR*/
User Function MVC04()
Local oBrowser := FwmBrowse():New()

	/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	oBrowser:setAlias("SA1")
	oBrowser:setDescription("MVC - An?lise de Cr?dito ( Clientes )")
	/*LEGENDA DA TELA*/
	oBrowser:AddLegend("A1_MSBLQL=='2'","BR_PINK", "Ativo")
	oBrowser:AddLegend("A1_MSBLQL=='1'","BR_VERDE", "Desativado")
	oBrowser:AddLegend("A1_MSBLQL==' '","BR_AZUL", "BRACO")
	//Ativando o OBJETO - Nada pode ser colocado abaixo deste.
	oBrowser:Activate()
Return (NIL)

/*SEMPRE NOSSOS BOT?ES RECEBER? ESTE NOME DESTA FUNC?O POIS ESTA ENCAPSULADO*/
Static Function MenuDef()
	Private aRotina   := {}
	//CRIANDO OS BOT?ES VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR ATRAVES DO AROTINA
	AADD( aRotina, {"Analise de Cr?dito" , 'VIEWDEF.MVC04', 0, 4 , 0})
	/* OBSERVA??ES
	   AADD( aRotina, {"FUN??O CUSTOMIZADA"    , 'U_TELA', 0, 6 , 0}) N?O SEGUE UMA SEQUENCIA - POR?M PODEMOS COLOCAR
	   OU CHAMAR A FUN??O DO MVC PARA CRIAR A ESTRUTURA 
	   Local aRotina := FwMVCMenu('xMvcMod3')
	*/
	 //CRIANDO OS BOT?ES VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR
Return(aRotina)

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini??o do modelo de Dados

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

Local oStr1:= mldoStr1Str()
 
Local oStr2:= mldoStr2Str()
oModel := MPFormModel():New('MDLSA1SE1',,,{|oModel|fGrava(oModel)})
oModel:SetDescription('An?lise de Cr?dito')
oModel:addFields('SA1MASTER',,oStr1,,,{|oField, lCopy| fLoadSA1(oField, lCopy)})
oModel:addGrid('SE1GRID','SA1MASTER',oStr2,,,,,{|oField,lCopy|fLoadSE1(oField,lCopy)})

oModel:getModel('SA1MASTER'):SetDescription('Dados do Cliente')
/*DEFININDO PRIMARY KEY*/
oModel:SetPrimaryKey({ 'A1_COD', 'A1_LOJA' })
oModel:getModel('SE1GRID'):SetDescription('Contas a Receber')

oModel:getModel('SE1GRID'):SetNoInsertLine(.T.)
oModel:getModel('SE1GRID'):SetNoUpdateLine(.F.)
oModel:getModel('SE1GRID'):SetNoDeleteLine(.T.)
oModel:getModel('SE1GRID'):SetOptional(.T.)


Return oModel

Static Function fGrava(oModel)
Local lRet := .T.
	RecLock("SA1",.F.)
		SA1->A1_CONTATO := oModel:GetValue("SA1MASTER","A1_CONTATO")
		Help(NIL, NIL, "Aten??o", NIL, "Altera??o Contato", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Contato Alterado com sucesso!"})		
	MsUnLock() 
Return (lRet)

Static Function fLoadSA1(oField,lCopy)
Local aDados := {}
	aAdd(aDados, {SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NOME, SA1->A1_CONTATO, SA1->A1_TEL})
	aAdd(aDados, Recno()) //INFORMANDO O RECNO DO REGISTRO
Return aDados

Static Function fLoadSE1(oField,lCopy)

Local aDados := {}
Local cAlias := getnextAlias()

BeginSql Alias cAlias
//Column E1_EMISSAO As Date //Converte a Data no Banco
Select E1_NUM, E1_PARCELA, E1_PREFIXO, E1_EMISSAO, E1_VENCREA, E1_TIPO, E1_VALOR, E1_SALDO
from %Table:SE1% SE1 WHERE E1_FILIAL = %xFILIAL:SE1%  
AND E1_CLIENTE = %EXP:SA1->A1_COD% 
AND E1_LOJA = %EXP:SA1->A1_LOJA% 
AND E1_SALDO > 0 
AND %notDel%	
EndSql

aSql := GetLastQuery() //informa??es sobre a Query Executada 

DbSelectArea(cAlias)
(cAlias)->(DbGotop())
	while ! EOF()
		aAdd(aDados, {0,{.F., (cAlias)->E1_NUM, (cAlias)->E1_PARCELA, (cAlias)->E1_PREFIXO, stod((cAlias)->E1_EMISSAO), stod((cAlias)->E1_VENCREA), (cAlias)->E1_TIPO, (cAlias)->E1_VALOR, (cAlias)->E1_SALDO}})
		(cAlias)->(dbSkip())
	EndDo
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
oStruct:AddField('C?digo','C?digo de Cliente' , 'A1_COD', 'C', 6, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Loja','Informa??o Loja' , 'A1_LOJA', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Cliente','Nome Cliente' , 'A1_NOME', 'C', 50, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Contato','Nome do Contato' , 'A1_CONTATO', 'C', 20, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Telefone','Telefone do Cliente' , 'A1_TEL', 'C', 12, 0, , , {}, .F., , .F., .F., .T., , )

return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini??o do interface

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
 
Local oStr3:= viewoStr3Str()
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEWSA1' , oStr1,'SA1MASTER' )
oView:AddGrid('VIEWSE1' , oStr3,'SE1GRID') 

oView:CreateHorizontalBox( 'BOXFORM1', 30)
oView:CreateHorizontalBox( 'BOXGRID', 70)
oView:SetOwnerView('VIEWSE1','BOXGRID')


oView:SetOwnerView('VIEWSA1','BOXFORM1')

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
oStruct:AddField( 'A1_COD','1','C?digo','C?digo',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'A1_LOJA','2','Loja','Loja',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'A1_NOME','3','Cliente','Cliente',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'A1_CONTATO','4','Contato','Contato',, 'Get' ,,,,.T.,,,,,,.T.,, )
oStruct:AddField( 'A1_TEL','5','Telefone','Telefone',, 'Get' ,,,,.F.,,,,,,.T.,, )

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
oStruct:AddTable('TSE1',,'Contas a receber do Cliente')
oStruct:AddField(' ','Check do Campo' , 'CHECK', 'L', 1, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('N?mero','Numero do T?tulo' , 'E1_NUM', 'C', 9, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Parcela','Numero Parcela' , 'E1_PARCELA', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Prefixo','Prefixo do T?luto' , 'E1_PREFIXO', 'C', 5, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Emiss?o','Data de Emiss?o' , 'E1_EMISSAO', 'D', 8, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Vencimento','Data de Vencimento' , 'E1_VENCREA', 'D', 8, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Tipo','Tipo de Titulo' , 'E1_TIPO', 'C', 3, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Valor','Valor do Titulo' , 'E1_VALOR', 'N', 12, 2, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Saldo','Saldo do Titulo' , 'E1_SALDO', 'N', 12, 2, , , {}, .F., , .F., .F., .T., , )

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
return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} viewoStr3Str()
Retorna estrutura do tipo FWFormViewStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function viewoStr3Str()

Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'CHECK','1',' ',' ',, 'Check' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'E1_NUM','2','N?mero','N?mero',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_PARCELA','3','Parcela','Parcela',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_PREFIXO','4','Prefixo','Prefixo',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_EMISSAO','5','Emiss?o','Emiss?o',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_VENCREA','6','Vencimento','Vencimento',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_TIPO','7','Tipo','Tipo',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_VALOR','8','Valor','Valor',, 'Get' ,'@E 999,999,999.99',,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_SALDO','9','Saldo','Saldo',, 'Get' ,'@E 999,999,999.99',,,.F.,,,,,,.T.,, )

return oStruct
