#include 'protheus.ch'
#include 'parmtype.ch'

user function OPERMAT()
	Local nNum1 := 10
	Local nNum2 := 20
	
	
	MSGALERT(nNum1 + nNum2,"SOMA!!!") //ALTERA NOME JANELA
	MSGALERT("A subtração é: "+ cValToChar (nNum2 - nNum1))
	MSGALERT("A multiplicação é: "+ cValToChar (nNum1 * nNum2))
	MSGALERT("A divisão é: "+ cValToChar (nNum2 / nNum1))
	MSGALERT("O restante da divisão é: "+ cValToChar (nNum2 % nNum1))
	
return

//------------------------------------------------------------------------------

User Function OPERREL() //RETORNA .T. ou .F.
	Local nNum1 := 10
	Local nNum2 := 20
	
	Alert(nNum1 < nNum2)  //MENOR
	Alert(nNum2 > nNum1)  //MAIOR
	Alert(nNum1 <> nNum2) //DIFERENTE
	Alert(nNum1 == nNum2) //IGUALDADE
	Alert(nNum1 <= nNum2) //MENOR OU IGUAL
	Alert(nNum2 >= nNum1) //MAIOR OU IGUAL
	Alert(nNum1 != nNum2) //DIFERENTE
	
Return
//-------------------------------------------------------------------------------

User Function OPERATRIB()
	Local nNum1 := 10
	Local nNum2 := 20
	
	Alert(nNum1 := 10) // nNum1 := 10
	Alert(nNum1 += nNum2) // nNum1 := nNum1 + nNum2
	Alert(nNum2 -= nNum1) // nNum2 := nNum2 - nNum1
	Alert(nNum1 *= nNum2) // nNum1 := nNum1 * nNum2
	Alert(nNum2 /= nNum1) // nNum2 := nNum2 / nNum1
	//Alert(nNum2 %= nNum1) // nNum2 := nNum2 % nNum1
	&("nNum2 := 8") //MACRO SUBSTITUIÇÃO
	Alert(nNum2)
Return

//----------------------------------------------------------------------------------

User Function TSTCNOUT()

	Local nValor1 := 5
	Local nValor2 := 3
	Local cTexto1 := "Daniel Atilio"
	Local cTexto2 := "Atilio"
	
//ConOut = Apresenta no console.log, do Application Server, uma mensagem
ConOut("Teste Compostos: ")
ConOut(nValor1 == nvalor2)
ConOut(!(nValor1 == nValor2) ) //NEGAÇÃO DE TESTE

//----------------------------------------------------------------------------------


