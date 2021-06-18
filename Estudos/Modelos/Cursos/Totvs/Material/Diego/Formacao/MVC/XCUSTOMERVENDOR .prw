#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//User function CUSTOMERVENDOR //mata030
User function CUSTOMERVENDOR //mata020
Local oObj     := PARAMIXB[1]
Local cIdPonto := PARAMIXB[2]
Local cIdModel := PARAMIXB[3]


  If cIdPonto == "MODELVLDACTIVE" // Verifica se pode ativação do modelo
	      	// Podemos ultizar para adicionar alguma manutenção na estrutura dos campos
	      	//  Validação para ativação do Model,
	      	// Exemplo podemos Removendo o Inicializador padrão 
	      	//oModel:GetStruct() Recuperando a estrutura dos campos
	      	//oModel:GetStruct():SetProperty() // Propriedades dos campos
		      	If oObj:GetOperation() == MODEL_OPERATION_INSERT
		        	oObj:GetModel( "SA2MASTER" ):GetStruct():SetProperty('A2_COD',MODEL_FIELD_OBRIGAT,.F.) 
		        	oObj:GetModel( "SA2MASTER" ):GetStruct():SetProperty('A2_LOJA',MODEL_FIELD_OBRIGAT,.F.)
		   		EndIf
	      	Return 	.T.
	      Endif

If cIdPonto == 'FORMPOS' .AND. cIdModel == "SA2MASTER"
	
	If oObj:GetValue("A2_EST") == "RJ" 
	//MsgInfo("Dados de outra empresa")
 		Help(NIL, NIL, "UF", NIL, "Não temos operação nesse estado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurar outra empresa"})
 	 	Return .F.
	Endif
Endif        
        
 If cIdPonto == "BUTTONBAR" // Adiciona botão no enchoiceBar     				
     Return { {'Exemplo', 'CLIPS', { || Msginfo( 'New Botton' ) }, 'Exemplo novo Botão' } } 	
 Endif
	      







Return .T.