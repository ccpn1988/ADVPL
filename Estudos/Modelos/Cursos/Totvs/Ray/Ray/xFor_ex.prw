#Include 'Protheus.ch'

User Function xFor_ex()

Local x := 0

/*
For x:= 10 To 1 step (-1)
	msgInfo("Contador: " + cValToChar(x))
Next
*/

For x:= 1 To 10
	If x == 5
		Loop
	Endif
	msgInfo("Contador: " + cValToChar(x))
Next


Return

