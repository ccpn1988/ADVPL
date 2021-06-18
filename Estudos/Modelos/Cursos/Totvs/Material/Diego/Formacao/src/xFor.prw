#Include 'Protheus.ch'

User Function xFor()

Local x:= 0
For x:= 1 to 10 step 2
	//msgInfo("Contador: " + LTrim(Str(x))
	msgInfo("Contador: " + cValToChar(x))
next

For x:= 10 to 1 step -1
	msgInfo("Contador: " + cValToChar(x))
next 

For x:= 1 to 10
	if x == 7
		msgInfo("Vai sair")
		Exit
	elseif x == 5 .or. x == 6
		msgInfo("Valor de X ser " + cValToChar(x))
		Loop
	EndIf
	msgInfo("Contador: " + cValToChar(x))
next

Return

