#include 'protheus.ch'
#include 'parmtype.ch'

user function zVarNum()

ABS(nValor) := 	Retorna um valor absoluto (independente do sinal) com base no valor
especificado no par�metro.

INT(nValor) := Retorna a parte inteira de um valor especificado no par�metro.

NOROUND(nValor, nCasas) := Retorna um valor, truncando a parte decimal do valor especificado no
par�metro de acordo com a quantidade de casas decimais solicitadas.

ROUND(nValor, nCasas) := Retorna um valor, arredondando a parte decimal do valor especificado no
par�metro de acordo com a quantidades de casas decimais solicitadas,
utilizando o crit�rio matem�tico.

return