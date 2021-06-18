#include 'protheus.ch'
#include 'parmtype.ch'

User Function zOperadores()
	Local aArea := GetArea()
	
	//Declara��o de vari�veis
	Local nValor1	:= 5
	Local nValor2	:= 3
	Local cTexto1	:= "Daniel Atilio"
	Local cTexto2	:= "Atilio"
	
	//Atribui��o
	nValor1 := 6	//Existe tamb�m o replace, por�m ele � utilizado para campos (RecLock)
	
	//Manipula��o
	nValor1++		//Soma 1 na vari�vel. Outro exemplo:		nValor1 := nValor1 + 1
	nValor1--		//Subtrai 1 na vari�vel. Outro exemplo:	nValor1 := nValor1 - 1
	nValor1 *= 2	//Multiplica o valor. Outro exemplo:		nValor1 := nValor1 * 2
	nValor1 /= 2	//Divide o valor. Outro exemplo:			nValor1 := nValor1 / 2
	nValor1 += 7  //Soma o valor. Outro exemplo:				nValor1 := nValor1 + 7
	nValor1 -= 7	//Subtrai o valor. Outro exemplo:			nValor1 := nValor1 - 7
	
	//Testes
	ConOut("Testes: ")
	ConOut( nValor1 == nValor2 )		//Exatamente igual
	ConOut( !(nValor1 == nValor2) )		//Nega��o de teste
	ConOut( nValor1 != nValor2 )		//Diferente de (tamb�m pode ser usado <>)
	ConOut( cTexto2 $ cTexto1 )			//Est� contido
	ConOut( nValor1 > nValor2 )			//� maior que (tamb�m pode ser >=, seria maior ou igual)
	ConOut( nValor1 < nValor2 )			//� menor que (tamb�m pode ser <=, seria menor ou igual)
	
	//Testes compostos
	ConOut("Testes Compostos: ")
	ConOut( (1==1) .And. (1!=1) )		//Teste com .And. s� retorna verdadeiro, se todos os testes forem verdadeiro
	ConOut( (1==1) .Or.  (1!=1) )		//Teste com .Or.  retorna verdadeiro, se qualquer teste for verdadeiro
	
	//Macro Substitui��o
	&("nValor3 := 8")
	Alert(nValor3)
	
	RestArea(aArea)
Return


user function OPERMAT()
	Local nNum1 := 10
	Local nNum2 := 20
	
	
	/* MSGALERT(nNum1 + nNum2,"SOMA!!!") //ALTERA NOME JANELA
	MSGALERT("A subtra��o �: "+ cValToChar (nNum2 - nNum1))
	MSGALERT("A multiplica��o �: "+ cValToChar (nNum1 * nNum2))
	MSGALERT("A divis�o �: "+ cValToChar (nNum2 / nNum1))
	MSGALERT("O restante da divis�o �: "+ cValToChar (nNum2 % nNum1)) */
	

	MSGALERT(nNum1 + nNum2,"SOMA!!!") //ALTERA NOME JANELA
	MSGALERT("A subtra��o �: "+ cValToChar (nNum2 += nNum1))
	MSGALERT("A multiplica��o �: "+ cValToChar (nNum1 *= nNum2))
	MSGALERT("A divis�o �: "+ cValToChar (nNum2 /= nNum1))
	MSGALERT("O restante da divis�o �: "+ cValToChar (nNum2 -= nNum1))
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
	&("nNum2 := 8") //MACRO SUBSTITUI��O
	Alert(nNum2)
Return

//----------------------------------------------------------------------------------

