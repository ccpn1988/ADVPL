#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function MVCSA2ExecAuto()
	// Importamos outro registro
	aCampos := {}
	aAdd( aCampos, { 'A2_COD'      , '000104' } )
	aAdd( aCampos, { 'A2_LOJA'     , '02' } )
	aAdd( aCampos, { 'A2_NOME'     , 'MVC EXEC' } )
	aAdd( aCampos, { 'A2_NREDUZ'   , 'Emilio Santiago' } )
	aAdd( aCampos, { 'A2_TIPO'     , 'F' } )
	aAdd( aCampos, { 'A2_EST'      , 'SP' } )
	aAdd( aCampos, { 'A2_MUN'      , 'S�O PAULO' } )
	aAdd( aCampos, { 'A2_END'      , 'EXEMPLO' } )
	
	Import( 'SA2', aCampos, "MATA020")
Return()
//-------------------------------------------------------------------------------------------------------------------------------------------
Static Function Import( cAlias, aCampos, cFonte )
	Local oModel, oAux
	Local nPos := 0
	Local lRet := .T.
	Local aAux := {}
	
	oModel := FWLoadModel( cFonte )
	oModel:SetOperation( MODEL_OPERATION_INSERT )
	oModel:Activate()
	oAux := oModel:GetModel( "SA2MASTER" )// ID do componete addfields
  oAux:GetStruct():SetProperty('*',MODEL_FIELD_WHEN , FWBuildFeature( STRUCT_FEATURE_WHEN , NIL   ) )
  // Desativando valida�ao	   
	//oAux:GetStruct():SetProperty('*',MODEL_FIELD_VALID, FWBuildFeature( STRUCT_FEATURE_VALID, '.T.' ) )   
	
	aAux := oAux:GetStruct():GetFields()
	
	For nI := 1 To Len( aCampos )
		If ( aScan( aAux, {|x| AllTrim( x[3] ) == AllTrim( aCampos[nI][1]) } ) ) > 0
	// � feita a atribui��o do dado ao campo do Model
			If !( lAux := oModel:SetValue( "MATA020_SA2", aCampos[nI][1], aCampos[nI][2] ) )
	// Caso a atribui��o n�o possa ser feita, por algum motivo (valida��o, por exemplo) o m�todo SetValue retorna .F.
				lRet := .F.
				Exit	
			EndIf
		EndIf
	Next nI

If lRet
// neste momento os dados n�o s�o gravados, s�o somente validados.
	If ( lRet := oModel:VldData() )
		// Se os dados foram validados faz-se a grava��o efetiva dos dados (commit)
		oModel:CommitData()
	EndIf
EndIf

	If ! lRet
		// Se os dados n�o foram validados obtemos a descri��o do erro para gerar LOG ou mensagem de aviso
			aErro := oModel:GetErrorMessage()
		// A estrutura do vetor com erro �:
			// [1] identificador (ID) do formul�rio de origem
				// [2] identificador (ID) do campo de origem
				// [3] identificador (ID) do formul�rio de erro
				// [4] identificador (ID) do campo de erro
				// [5] identificador (ID) do erro
				// [6] mensagem do erro
				// [7] mensagem da solu��o
				// [8] Valor atribu�do
				// [9] Valor anterior
	
				AutoGrLog( "Id do formul�rio de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
				AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
				AutoGrLog( "Id do formul�rio de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
				AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
				AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) +']' )
				AutoGrLog( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
				AutoGrLog( "Mensagem da solu��o: " + ' [' + AllToChar( aErro[7] ) + ']' )
				AutoGrLog( "Valor atribu�do: " + ' [' + AllToChar( aErro[8] ) + ']' )
				AutoGrLog( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )
				MostraErro()
	Else
		MsgInfo("Registro gavado com sucesso")			
	EndIf
	
	// Desativamos o Model
	oModel:DeActivate()
Return(lRet)

