#include 'protheus.ch'
#include 'parmtype.ch'

/*Executa o primeiro conjunto de comandos cuja express�o condicional resulta em verdadeiro
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

Par�metros
CASE
lExpressao1
Comandos... -> Quando a primeira express�o CASE resultante em verdadeiro (.T.)
for encontrada, o conjunto de comandos seguinte � executado. A
execu��o do conjunto de comandos continua at� que a pr�xima
cl�usula CASE, OTHERWISE ou ENDCASE seja encontrada. Ao
terminar de executar esse conjunto de comandos, a execu��o
continua com o primeiro comando seguinte ao ENDCASE.
Se uma express�o CASE resultar em falso (.F.), o conjunto de
comandos seguinte a esta at� a pr�xima cl�usula � ignorado.
Apenas um conjunto de comandos � executado. Estes s�o os
primeiros comandos cuja express�o CASE � avaliada como
verdadeiro (.T.). Ap�s a execu��o, qualquer outra express�o CASE
posterior � ignorada (mesmo que sua avalia��o resultasse em
verdadeiro).

OTHERWISE
Comandos -> Se todas as express�es CASE forem avaliadas como falso (.F.), a
cl�usula OTHERWISE determina se um conjunto adicional de
comandos deve ser executado. Se essa cl�usula for inclu�da, os
comandos seguintes ser�o executados e ent�o o programa
continuar� com o primeiro comando seguinte ao ENDCASE. Se a
cl�usula OTHERWISE for omitida, a execu��o continuar�
normalmente ap�s a cl�usula ENDCASE.*/


User Function xCase()
Local cData := "27/12/2017"

	Do Case
		Case cData == "20/12/2017"
		Alert("N�o � Natal")
		 
		 Case cData == "25/12/2017"
		 Alert("� Natal")
		 
		 OtherWise 
		 MsgAlert("N�o sei que dia � hoje")
		 
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