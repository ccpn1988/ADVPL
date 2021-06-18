#include 'protheus.ch'
#include 'parmtype.ch'

user function zEscopo()
	Local nPercentual 	:= 10
	Local nResultado 	:= 250*(1+(nPercentual/100))
	
	MsgInfo('O valor do calculo é: '+cValToChar(nResultado))

return

//ATRIBUIÇÃO DE VARIÁVEIS	
USER FUNCTION zAtrib()
Local xVariavel //INICIALIZADA COM VALOR NULO

xVariavel := 'Agora a variavel é caractere' //CARACTERE
Alert('Valor do Texto' + xVariavel)

xVariavel := 22 //NUMERICA
Alert(cValToChar(xVariavel))

xVariavel := .T. //LÓGICA
IF xVariavel 
	Alert('A variável é verdade')
Else
	Alert('A variavel é falsa')
EndIf

xVariavel := Date()//DATA
Alert('Hoje é:' + DTOC(xVariavel))

xVariavel :=  NIL
Alert('Valor da variável é nulo')

Return

/*ATRIBUIÇÃO COMPOSTA

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
++ INCREMENTO PÓS OU PRÉ FIXADO
-- DECREMENTO PÓS OU PRÉ FIXADO	*/	  
	Local nA := 10
	//Local nB := nA++ + nA = 21
	Local nB := ++nA + nA // =22
	
	Alert('A soma do incremento é: '+ cValToChar(nB))
Return

//PRECEDENCIA DOS OPERADORES
/*O resultado desta expressão é 30, pois primeiramente é calculada a exponenciação 2^3(=8),
então são calculadas as multiplicações e divisões 10/2(=5) e 5*3(=15), e finalmente as
adições resultando em 2+5+15+8(=30).	
1. Exponenciação
2. Multiplicação e Divisão
3. Adição e Subtração*/
USER FUNCTION zPreced()
	Local nResult := 2+10/2+5*3+2^3
	//Local nResult := 2+5+15+8
	Alert(cValToChar(nResult))
Return

//ALTERAÇÃO DE PRECEDENCIA
/*No exemplo acima primeiro será calculada a exponenciação 2^3(=8). Em seguida 2+10(=12)
será calculado, 2+5(=7) calculado, e finalmente a divisão e a multiplicação serão efetuadas, o
que resulta em 12/7*3+8(=13.14).
Se existirem vários parênteses aninhados, ou seja, colocados um dentro do outro, a avaliação
ocorrerá do parênteses mais intero em direção ao mais externo.*/
USER FUNCTION zAltPrec()
	Local nResult := (2+10)/(2+5)*3+2^3
	Alert(cValToChar(nResult))
	
//Operação de Macro Substituição
/*O operador de macro substituição, simbolizado pelo "e" comercial (&), é utilizado para a
avaliação de expressões em tempo de execução. Funciona como se uma expressão
armazenada fosse compilada em tempo de execução, antes de ser de fato executada.
*/
USER FUNCTION zMSUB()
	Local X := 10
	Local Y := "X+1"
	Local B := &Y // O conteúdo de B será 11
	
	Alert(B)

Return

