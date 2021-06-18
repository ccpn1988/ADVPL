#Include 'Protheus.ch'
#Include 'Parmtype.ch'
#include "FWMVCDEF.CH"

User Function ADVPLA04()
	Local oBrowse
	//Montagem do Browse principal	
	oBrowse := FWMBrowse():New()

	oBrowse:AddLegend("ZZ4->ZZ4_STATUS=='A'", "GREEN"	, "Aberto")
	oBrowse:AddLegend("ZZ4->ZZ4_STATUS=='E'", "RED"		, "Efetivado")
	oBrowse:AddLegend("ZZ4->ZZ4_STATUS=='P'", "YELLOW"	, "Pago")
	oBrowse:AddLegend("ZZ4->ZZ4_STATUS=='C'", "CANCEL"	, "Cancelado")

	oBrowse:SetAlias('ZZ4')
	oBrowse:SetDescription('Cadastro de Movimentos')
	oBrowse:SetMenuDef('ADVPLA04')
	oBrowse:Activate()

Return

//Montagem do menu 
Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar'	, 'VIEWDEF.ADVPLA04'	, 0, 2, 0, NIL } ) 
	aAdd( aRotina, { 'Incluir' 		, 'VIEWDEF.ADVPLA04'	, 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar' 		, 'VIEWDEF.ADVPLA04'	, 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir' 		, 'VIEWDEF.ADVPLA04'	, 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir' 	, 'VIEWDEF.ADVPLA04'	, 0, 8, 0, NIL } )
	aAdd( aRotina, { 'Copiar' 		, 'VIEWDEF.ADVPLA04'	, 0, 9, 0, NIL } )
	aAdd( aRotina, { 'Efetivar' 	, 'U_ADPLA04b()'		, 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Cancelar' 	, 'U_ADPLA04c()'		, 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Imprimir Espelho', 'U_ADVPLR02()'		, 0, 2, 0, NIL } )

Return aRotina

//Construcao do mdelo
Static Function ModelDef()
	Local oModel
	Local oStruZZ4 := FWFormStruct(1,"ZZ4")
	Local oStruZZ5 := FWFormStruct(1,"ZZ5")

	oModel := MPFormModel():New("MD_ZZ4") 

	oModel:addFields('MASTERZZ4',,oStruZZ4)
	oModel:AddGrid('DETAILSZZ5', 'MASTERZZ4', oStruZZ5, {|oModel| U_ADVPL04A(oModel) }) 

	oModel:SetRelation('DETAILSZZ5', { {'ZZ5_FILIAL', 'xFilial("ZZ5")'}, {'ZZ5_CODZZ4', 'ZZ4_CODIGO'} }, ZZ5->(IndexKey(1)))

	oModel:SetPrimaryKey({'ZZ4_FILIAL', 'ZZ4_CODIGO'})

	oModel:GetModel('DETAILSZZ5'):SetUniqueLine({'ZZ5_CODZZ2'})

	oModel:AddCalc('QUANT', 'MASTERZZ4', 'DETAILSZZ5', 'ZZ5_TOTAL', 'QUANTIDADE', 'COUNT' )

Return oModel

//Construcao da visualizacao
Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStrZZ4:= FWFormStruct(2, 'ZZ4')
	Local oStrZZ5:= FWFormStruct(2, 'ZZ5')

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM_ZZ4' , oStrZZ4,'MASTERZZ4' ) 
	oView:CreateHorizontalBox( 'BOX_FORM_ZZ4', 30)
	oView:SetOwnerView('FORM_ZZ4','BOX_FORM_ZZ4')

	oView:CreateHorizontalBox( 'BOX_FORM_ZZ5', 60)	
	oView:AddGrid('VIEW_ZZ5', oStrZZ5, 'DETAILSZZ5')
	oView:SetOwnerView('VIEW_ZZ5', 'BOX_FORM_ZZ5')

	oView:EnableTitleView('VIEW_ZZ5', 'Itens do Movimento')

	oQuant	:= FwCalcStruct(oModel:GetModel('QUANT'))

	oView:CreateHorizontalBox( 'BOX_FORM_QUANT', 10)

	oView:AddField('VIEW_QUANT', oQuant, 'QUANT')

	oView:SetOwnerView('VIEW_QUANT', 'BOX_FORM_QUANT')


Return oView

User Function ADVPL04A(oModelZZ5)
	Local oModel	:= FWModelActive()
	Local oModelZZ4	:= oModel:GetModel('MASTERZZ4')
	Local nTotal	:= 0
	Local i

	For i := 1 to oModelZZ5:Length()

		oModelZZ5:GoLine(i)

		If oModelZZ5:IsDeleted()
			loop
		EndIf

		nTotal += oModelZZ5:GetValue('ZZ5_TOTAL')

	Next

	oModelZZ4:LoadValue('ZZ4_TOTAL', nTotal)

Return .T.


User Function ADPLA04b()
	Local aArray
	Local cPrefix	:= SuperGetMV('MS_PREFIXO', .F., 'ADV')
	Local cTipo		:= SuperGetMV('MS_TIPO', .F., 'NF')
	Local cNatu		:= SuperGetMV('MS_NATUREZ', .F., 'DIVERSOS')
	Local cFornece	:= SuperGetMV('MS_FORNECE', .F., '000001')
	Local cLoja		:= SuperGetMV('MS_LOJA', .F., '01')
	
	Private lMsErroAuto := .F.
		
	If ZZ4->ZZ4_STATUS == 'A'
		
		If MsgYesNo('Confirma a efetivação?')
		
			aArray := { 	{ "E2_PREFIXO"  , cPrefix           , NIL },;
							{ "E2_TIPO"     , cTipo             , NIL },;
							{ "E2_NATUREZ"  , cNatu             , NIL },;
							{ "E2_FORNECE"  , cFornece          , NIL },;
							{ "E2_LOJA"  	, cLoja	            , NIL },;
							{ "E2_EMISSAO"  , dDataBase			, NIL },;
							{ "E2_VENCTO"   , dDataBase + 30	, NIL },;
							{ "E2_YCODZZ4"  , ZZ4->ZZ4_CODIGO	, NIL },;
							{ "E2_VALOR"    , ZZ4->ZZ4_TOTAL	, NIL } }
		
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,,3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
		
			If lMsErroAuto
				MostraErro()
			Else
	
				RecLock('ZZ4', .F.)
					ZZ4->ZZ4_STATUS := 'E'
				ZZ4->(MsUnLock())
								
				ApMsgInfo("Título incluído com sucesso!", 'Atenção')
			Endif

		EndIf

	Else
		MsgAlert('Só efetivar um movimento ABERTO. ')
	EndIf

Return

User Function ADPLA04c()
	Local aArray
	
	Private lMsErroAuto := .F.
	
	If ZZ4->ZZ4_STATUS $ 'A,E'
		
		If MsgYesNo('Confirma a cancelamento?')
			
			If ZZ4->ZZ4_STATUS == 'E'
				
				SE2->(DbOrderNickName('E2YCODZZ4'))			

				If SE2->(DbSeek(xFilial('SE2') + ZZ4->ZZ4_CODIGO))
				
					aArray := { 	{ "E2_PREFIXO"  , SE2->E2_PREFIXO          , NIL },;
									{ "E2_NUM"      , SE2->E2_NUM              , NIL },;
									{ "E2_PARCELA"  , SE2->E2_PARCELA          , NIL },;																		
									{ "E2_TIPO"     , SE2->E2_TIPO             , NIL },;
									{ "E2_FORNECE"  , SE2->E2_FORNECE          , NIL },;
									{ "E2_LOJA"  	, SE2->E2_LOJA	           , NIL }}

					SE2->(DbSetOrder(1))

					MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,,5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
				
					If lMsErroAuto
						MostraErro()
					Else
			
						RecLock('ZZ4', .F.)
							ZZ4->ZZ4_STATUS := 'C'
						ZZ4->(MsUnLock())
										
						ApMsgInfo("Título excluído com sucesso!", 'Atenção')
					Endif
									
				EndIf
				
			Else

				RecLock('ZZ4', .F.)
					ZZ4->ZZ4_STATUS := 'C'
				ZZ4->(MsUnLock())
			
			EndIf
		EndIf
		

	Else
		MsgAlert('Só efetivar um movimento ABERTO. ')
	EndIf

Return

