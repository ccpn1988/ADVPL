#Include 'Protheus.ch'

User Function xFor()
Local x
//Local y

For x:= 1 To 10 Step 1
	MsgInfo("Contador: " + CVALTOCHAR(x))
Next

MsgInfo("Loop 1 finalizado")

// Exercicio fazer um contador que o inicio é 10 e finaliza com 1
For x:= 10 To 1 Step -1
	MsgInfo("Contador: " + CVALTOCHAR(x))
Next

MsgInfo("Loop 2 finalizado")

// Exercicio fazer um for que informar se é PAR ou IMPAR. Exemplo 1 = Impar | 10 = Par
For x:= 1 To 10
// IF X%2 == 0
	IF MOD(x,2)==0 // Compara se o resto de divisão por 2 é 0 ou 1
		MsgInfo("Contador Par: " + cValToChar(x))
	ELSE 
		MsgInfo("Contador Impar: " + cValToChar(x))
	ENDIF
Next

MsgInfo("Loop 3 finalizado")

// Desconsidera o valor informado na variavel
For x:= 1 To 10
	If x == 5
		Loop
	Endif
	MsgInfo ("Contador: " + cValToChar(x))
Next

MsgInfo("Loop 4 finalizado")

// Sai do loop assim que chegar no valor da variavel
For x:= 1 To 10
	If x == 5
		Exit
	Endif
	MsgInfo ("Contador: " + cValToChar(x))
Next

MsgInfo("Loop 5 finalizado")


Return

//-------------------------------------------------------------------------------------------------------------------------

User Function RepFor()

	local nCount 
	local nNum := 0
	
	For nCount := 0 To  10 //De 0 até 10
	
	nNum += nCount //incrementa até 10 somando os valores das variáveis
	
	Next
	
	Alert ("Valor:" + cValToChar (nnum))
Return
	
	





