#Include 'Protheus.ch'

User Function xFor()

Local x := 0

For x:= 1 To 10  step 2
	msgInfo("Contador: " + cValToChar(x))
Next

Return

