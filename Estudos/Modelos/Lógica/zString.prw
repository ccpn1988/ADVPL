#include 'protheus.ch'
#include 'parmtype.ch'

user function zString()

ALLTRIM(cString) := Retorna uma string sem os espa�os � direita e � esquerda, referente ao
conte�do informado como par�metro.
A fun��o ALLTRIM() implementa as a��es das fun��es RTRIM (�right trim�) e
LTRIM (�left trim�).

ASC(cCaractere) := Converte uma informa��o caractere em seu valor de acordo com a tabela
ASCII.

AT(cCaractere, cString ) := Retorna a primeira posi��o de um caracter ou string dentro de outra string
especificada.

RAT(cCaractere, cString) := Retorna a �ltima posi��o de um caracter ou string dentro de outra string
especificada.

CHR(nASCII) := Converte um valor n�mero referente a uma informa��o da tabela ASCII no
caractere que esta informa��o representa.

LEN(cString) := Retorna o tamanho da string especificada no par�metro.

LOWER(cString) := Retorna uma string com todos os caracteres min�sculos, tendo como base a
string passada como par�metro.

UPPER(cString) := Retorna uma string com todos os caracteres mai�sculos, tendo como base a
string passada como par�metro.

STUFF(cString, nPosInicial, nExcluir, cAdicao) := Permite substituir um conte�do caractere em uma string j� existente,
especificando a posi��o inicial para esta adi��o e o n�mero de caracteres que
ser�o substitu�dos.

SUBSTR(cString, nPosInicial, nCaracteres) := Retorna parte do conte�do de uma string especificada, de acordo com a
posi��o inicial deste conte�do na string e a quantidade de caracteres que
dever� ser retornada a partir daquele ponto (inclusive).


	
return