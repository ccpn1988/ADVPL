#include 'protheus.ch'
#include 'parmtype.ch'

user function zEscopo()
	Local nPercentual 	:= 10
	Local nResultado 	:= 250*(1+(nPercentual/100))
	
	MsgInfo('O valor do calculo �: '+cValToChar(nResultado))

return

//ATRIBUI��O DE VARI�VEIS	
USER FUNCTION zAtrib()
Local xVariavel //INICIALIZADA COM VALOR NULO

xVariavel := 'Agora a variavel � caractere' //CARACTERE
Alert('Valor do Texto' + xVariavel)

xVariavel := 22 //NUMERICA
Alert(cValToChar(xVariavel))

xVariavel := .T. //L�GICA
IF xVariavel 
	Alert('A vari�vel � verdade')
Else
	Alert('A variavel � falsa')
EndIf

xVariavel := Date()//DATA
Alert('Hoje �:' + DTOC(xVariavel))

xVariavel :=  NIL
Alert('Valor da vari�vel � nulo')

Return

/*ATRIBUI��O COMPOSTA

Operador 	Exemplo Equivalente a
+= 			X += Y 	X = X + Y
-= 			X -= Y 	X = X - Y
*= 			X *= Y 	X = X * Y
/= 			X /= Y 	X = X / Y
**= ou ^= 	X **= Y X = X ** Y
%= 			X %= Y 	X = X % Y
		  */

//INCREMENTO 		  
USER FUNCTION zOPEINC()
/*
++ INCREMENTO P�S OU PR� FIXADO
-- DECREMENTO P�S OU PR� FIXADO	*/	  
	Local nA := 10
	//Local nB := nA++ + nA = 21
	Local nB := ++nA + nA // =22
	
	Alert('A soma do incremento �: '+ cValToChar(nB))
Return

//PRECEDENCIA DOS OPERADORES
/*O resultado desta express�o � 30, pois primeiramente � calculada a exponencia��o 2^3(=8),
ent�o s�o calculadas as multiplica��es e divis�es 10/2(=5) e 5*3(=15), e finalmente as
adi��es resultando em 2+5+15+8(=30).	
1. Exponencia��o
2. Multiplica��o e Divis�o
3. Adi��o e Subtra��o*/
USER FUNCTION zPreced()
	Local nResult := 2+10/2+5*3+2^3
	//Local nResult := 2+5+15+8
	Alert(cValToChar(nResult))
Return

//ALTERA��O DE PRECEDENCIA
/*No exemplo acima primeiro ser� calculada a exponencia��o 2^3(=8). Em seguida 2+10(=12)
ser� calculado, 2+5(=7) calculado, e finalmente a divis�o e a multiplica��o ser�o efetuadas, o
que resulta em 12/7*3+8(=13.14).
Se existirem v�rios par�nteses aninhados, ou seja, colocados um dentro do outro, a avalia��o
ocorrer� do par�nteses mais intero em dire��o ao mais externo.*/
USER FUNCTION zAltPrec()
	Local nResult := (2+10)/(2+5)*3+2^3
	Alert(cValToChar(nResult))
	
//Opera��o de Macro Substitui��o
/*O operador de macro substitui��o, simbolizado pelo "e" comercial (&), � utilizado para a
avalia��o de express�es em tempo de execu��o. Funciona como se uma express�o
armazenada fosse compilada em tempo de execu��o, antes de ser de fato executada.
*/
USER FUNCTION zMSUB()
	Local X := 10
	Local Y := "X+1"
	Local B := &Y // O conte�do de B ser� 11
	
	Alert(B)

Return

