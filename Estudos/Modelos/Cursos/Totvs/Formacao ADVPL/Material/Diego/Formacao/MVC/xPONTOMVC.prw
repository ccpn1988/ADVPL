#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function CUSTOMERVENDOR
Local lRet := .T.
Local oObj     := PARAMIXB[1]
Local cIdPonto := PARAMIXB[2]
Local cIdModel := PARAMIXB[3]


  If cIdPonto == "MODELVLDACTIVE" // Verifica se pode ativa??o do modelo
	      	// Podemos ultizar para adicionar alguma manuten??o na estrutura dos campos
	      	//  Valida??o para ativa??o do Model,
	      	// Exemplo podemos Removendo o Inicializador padr?o 
	      	//oModel:GetStruct() Recuperando a estrutura dos campos
	      	//oModel:GetStruct():SetProperty() // Propriedades dos campos
		      	If oObj:GetOperation() == MODEL_OPERATION_INSERT
		        	oObj:GetModel( "SA2MASTER" ):GetStruct():SetProperty('A2_COD',MODEL_FIELD_OBRIGAT,.F.) 
		        	oObj:GetModel( "SA2MASTER" ):GetStruct():SetProperty('A2_LOJA',MODEL_FIELD_OBRIGAT,.F.)
		        	/*MUDANDO PARA CAMPO PADRAO MVC*/
		        	oObj:GetModel( "SA2MASTER" ):GetStruct():SetProperty('A2_MSBLQL',MODEL_FIELD_INIT,FWBuildFeature( STRUCT_FEATURE_INIPAD, "'1'"))
		   		EndIf
	      	Return 	.T.
	      Endif

/*TUDO OK  - APOS CLICAR EM OK*/
If cIdPonto == 'FORMPOS' .AND. cIdModel == "SA2MASTER"
	If oObj:GetValue("A2_EST") == "RJ" 
	//MsgInfo("Dados de outra empresa")
 		Help(NIL, NIL, "UF", NIL, "N?o temos opera??o nesse estado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurar outra empresa"})
 	 	Return .F.
	Endif
Endif    

If cIdPonto == 'FORMPRE' .AND. cIdModel == "SA2MASTER"
	/* VALIDANDO O CAMPO ANTES DE ENTRAR NA ALTERA??O -
	SEMPRE VALIDAMOS A OPERA??O FEITA NOS PARAMETROS RETORNADOS PELA FUN??O FORM PRE OU POS
	APOS ESTA VALIDA??O< NO DEBUG SABEMOS O QUE CADA UMA RETORNA.

	If oObj:GetOperation() <> MODEL_OPERATION_INSERT
		if oObj:GetValue("A2_EST") == " " //CANSETVALUE - BLOQUEIA CAMPO
			Help(NIL, NIL, "UF", NIL, "Dado n?o V?lido no campo Estado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe outro estado"})
			Return .F.	
		Elseif oObj:GetValue("A2_TIPO") <> "F" 
			/*TRATANDO JANELA EXIBIDA AO ENCONTRAR O PROBLEMA
			Help(NIL, NIL, "Tipo de pessoa", NIL, "N?o Trabalhamos com este Tipo De Pessoa", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurara uma outro Tipo para Trabalhar"})
			Return .F.
		EndIf
	EndIf */
	
	/*VALIDANDO O C?DIGO AO SER DIGITADO - VALIDANDO CAMPO AO SAIR*/
	If PARAMIXB[4] == "SETVALUE" //CANSETVALUE - BLOQUEIA CAMPO
		If PARAMIXB[5] == "A2_EST" .AND. PARAMIXB[6] == "RJ"
			Help(NIL, NIL, "UF", NIL, "Dado n?o V?lido no campo Estado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe outro estado"})
			Return .F.	
		EndIf
		
		If PARAMIXB[5] == "A2_INSCR" .AND. PARAMIXB[6] == "ISENTO"
			Help(NIL, NIL, "INSCRI??O", NIL, "Dado n?o V?lido no Campo Inscri??o", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe a Inscri??o"})
			Return .F.	
		EndIf
		
		If oObj:GetOperation() == MODEL_OPERATION_INSERT .AND. PARAMIXB[5] == "A2_MSBLQL" .AND. PARAMIXB[6] <> "1"
			Help(NIL, NIL, "Bloqueado", NIL, "Fornecedor deve estar bloqueado", 1, 0, NIL, NIL, NIL, NIL, NIL, {" Deve ficar com valor = 1 - SIM "})
			Return .F.	
		EndIf
	EndIf
Endif    

If cIdPonto == "BUTTONBAR" // Adiciona bot?o no enchoiceBar     				
     Return { {'Exemplo', 'CLIPS', { || Msginfo( 'New Botton' ) }, 'Exemplo novo Bot?o' } } 	
Endif    
	
Return lRet
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

oView := FWFormView():New()

oView:SetModel(oModel)

Return oView