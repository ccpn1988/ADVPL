#Include 'Protheus.ch'

// Ponto de entrada em MVC no cadastro de produtos SB1

User Function ITEM()
Local aParam := PARAMIXB

If aParam[2] == "FORMPOS" .AND. aParam[3] == "SB1MASTER" // ID do ponto de entrada
oField := aParam[1] // Objeto do formulario
	
	If ! oField:GetValue("B1_ORIGEM") $ "0|1" // Verifica se o campo B1_ORIGEM � 0 ou 1
		
		Help(NIL, NIL, "Aten��o", NIL, "O campo origem deve ser preenchido com 0 ou 1.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione outra op��o."})
		Return .F.
	
	EndIf
	
EndIf  

//MASTERSB1


Return .T.

