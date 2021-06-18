#include 'protheus.ch'
#include 'parmtype.ch'

/*Executa o primeiro conjunto de comandos cuja expressão condicional resulta em verdadeiro
(.T.).

Sintaxe
DO CASE
CASE lExpressao1
Comandos
[CASE lExpressao2
Comandos
...
CASE lExpressaoN
Comandos]
[OTHERWISE
Comandos]
ENDCASE

Parâmetros
CASE
lExpressao1
Comandos... -> Quando a primeira expressão CASE resultante em verdadeiro (.T.)
for encontrada, o conjunto de comandos seguinte é executado. A
execução do conjunto de comandos continua até que a próxima
cláusula CASE, OTHERWISE ou ENDCASE seja encontrada. Ao
terminar de executar esse conjunto de comandos, a execução
continua com o primeiro comando seguinte ao ENDCASE.
Se uma expressão CASE resultar em falso (.F.), o conjunto de
comandos seguinte a esta até a próxima cláusula é ignorado.
Apenas um conjunto de comandos é executado. Estes são os
primeiros comandos cuja expressão CASE é avaliada como
verdadeiro (.T.). Após a execução, qualquer outra expressão CASE
posterior é ignorada (mesmo que sua avaliação resultasse em
verdadeiro).

OTHERWISE
Comandos -> Se todas as expressões CASE forem avaliadas como falso (.F.), a
cláusula OTHERWISE determina se um conjunto adicional de
comandos deve ser executado. Se essa cláusula for incluída, os
comandos seguintes serão executados e então o programa
continuará com o primeiro comando seguinte ao ENDCASE. Se a
cláusula OTHERWISE for omitida, a execução continuará
normalmente após a cláusula ENDCASE.*/


User Function xCase()
Local cData := "27/12/2017"

	Do Case
		Case cData == "20/12/2017"
		Alert("Não é Natal")
		 
		 Case cData == "25/12/2017"
		 Alert("É Natal")
		 
		 OtherWise 
		 MsgAlert("Não sei que dia é hoje")
		 
	EndCase
	
Return

user function zCase()
	Local nMes := Month(Date())
	Local cPeriodo := ""
	
	Do Case
		Case nMes <= 3
			cPeriodo := "Primeiro Trimestre"
			MsgInfo(cPeriodo)
		Case nMes >= 5
			cPeriodo := "Segundo Trimestre"
			MsgInfo(cPeriodo)
		Case nMes >= 7
			cPeriodo := "Terceiro Trimestre"
			MsgInfo(cPeriodo)
		OtherWise
			cPeriodo := "Quarto Trimestre"
			MsgInfo(cPeriodo)
	EndCase
return