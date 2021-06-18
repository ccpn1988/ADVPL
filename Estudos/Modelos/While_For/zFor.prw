#include 'protheus.ch'
#include 'parmtype.ch'

/*FOR Variavel := nValorInicial TO nValorFinal [STEP nIncremento]
Comandos...(se a cl�usula STEP for omitida, o contador � incrementado em 1).

[EXIT] - Transfere o controle de dentro do comando FOR...NEXT para o
comando imediatamente seguinte ao NEXT, ou seja, finaliza a
repeti��o da se��o de comandos imediatamente. Pode-se
colocar o comando EXIT em qualquer lugar entre o FOR e o
NEXT.

[LOOP] - Retorna o controle diretamente para a cl�usula FOR sem
executar o restante dos comandos entre o LOOP e o NEXT. O
contador � incrementado ou decrementado normalmente, como
se o NEXT tivesse sido alcan�ado. Pode-se colocar o comando
LOOP em qualquer lugar entre o FOR e o NEXT.
NEXT*/

User Function zRept()
Local nCountx 
Local nNum 

	For nCountx := 0 TO 10 
	nNum += nCountx	
			
	Next
	Alert("Valor: "+ cValToChar(nNum))
Return




//Este exemplo imprime a soma dos 100 primeiros n�meros pares
USER FUNCTION zFor()
Local nCount
Local nSomaPar := 0
	
FOR nCount := 1 To 100 STEP 2
nSomaPar += nCount
Next
	Alert('A soma dos 100 primeiros numeros pares �:'+ cValToChar(nSomaPar))
return

//CONTADOR DE NUMEROS PARES ENTRE 0 E 100
USER FUNCTION zFor1()
Local nCount
Local nSomaPar := 0
Local lTst := .T.
	
FOR nCount := 0 To 100 STEP 2

	IF nCount == 20 
		lTst := .F.
	EndIF
		MsgInfo('Os numero pares de 0 a 100 s�o:'+ cValToChar(nCount))
Next
	
return

//CONTADOR PAR AT� 20 MUDANDO VARIAVEL ENCERRANDO 
USER FUNCTION zFor2()
Local nCount
Local nSomaPar := 0
Local lTst := .T.
	
FOR nCount := 0 To 60 STEP 2

	IF nCount == 20 
		lTst := .F.
		EXIT
	EndIF
		MsgInfo('Os numero pares de 0 a 100 s�o:'+ cValToChar(nCount))

Next
	
return

//CONTADOR PAR AT� 60 PULANDO 20 
USER FUNCTION zFor2()
Local nCount
Local nSomaPar := 0
Local lTst := .T.
	
FOR nCount := 0 To 30 STEP 2

	IF nCount == 20 
		lTst := .F.
		LOOP
	EndIF
		MsgInfo('Os numero pares de 0 a 100 s�o:'+ cValToChar(nCount))

Next
	
return
