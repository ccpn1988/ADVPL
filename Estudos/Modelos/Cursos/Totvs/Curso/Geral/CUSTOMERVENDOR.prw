#Include 'Protheus.ch'

// Ponto de entrada no cadastor de fornecedor

User Function CUSTOMERVENDOR()
Local aParam := PARAMIXB

// Execicio - não podemos fazer negocios com o pessoal do estado do RJ

// Validação FORMPRE - valida os dados ao trocar de campo

	If aParam[2] == "FORMPRE" .AND. aParam[3] == "SA2MASTER"
	
		If aParam[4] == "SETVALUE"
		
			If aParam[5] == "A2_EST" .AND. aParam[6] == "RJ"
			
				Help(NIL, NIL, "Atenção", NIL, "Não fazemos negocios com o pessoal do RJ.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione outro estado."})
				Return .F.
			
			EndIF
	
		EndIf
		
	EndIf


// Validação FORMPOS - valida os dados ao salvar o cadastro

	If aParam[2] == "FORMPOS" .AND. aParam[3] == "SA2MASTER" // ID do ponto de entrada
		oField := aParam[1] // Objeto do formulario
		
		If oField:GetValue("A2_EST") == "RJ"
		
			Help(NIL, NIL, "Atenção", NIL, "Não fazemos negocios com o pessoal do RJ.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione outro estado."})
			Return .F.
			
		EndIF
		
	EndIf
		
Return .T.

