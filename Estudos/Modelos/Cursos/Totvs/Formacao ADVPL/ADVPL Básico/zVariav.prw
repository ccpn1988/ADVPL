#include 'protheus.ch'
#include 'parmtype.ch'

/*Al�m de atribuir, controlar o escopo e macro executar o conte�do das vari�veis � necess�rio
manipular seu conte�do atrav�s de fun��es espec�ficas da linguagem para cada situa��o.
As opera��es de manipula��o de conte�do mais comuns em programa��o s�o:
 Convers�es entre tipos de vari�veis
*/

CTOD(cData) := Realiza a convers�o de uma informa��o do tipo caracter no formato
�DD/MM/AAAA� para uma vari�vel do tipo data.

CVALTOCHAR(nValor) := Realiza a convers�o de uma informa��o do tipo num�rico em uma string,
sem a adi��o de espa�os a informa��o.

DTOC(dData) := Realiza a convers�o de uma informa��o do tipo data para em caracter, sendo
o resultado no formato �DD/MM/AAAA�.

DTOS(dData) := Realiza a convers�o de uma informa��o do tipo data em um caracter, sendo
o resultado no formato �AAAAMMDD�.

STOD(sData) := Realiza a convers�o de uma informa��o do tipo caracter com conte�do no
formato �AAAAMMDD� em data.

STR(nValor) := Realiza a convers�o de uma informa��o do tipo num�rico em uma string,
adicionando espa�os � direita.

STRZERO(nValor, nTamanho) := Realiza a convers�o de uma informa��o do tipo num�rico em uma string,
adicionando zeros � esquerda do n�mero convertido, de forma que a string
gerada tenha o tamanho especificado no par�metro.

VAL(cValor) := Realiza a convers�o de uma informa��o do tipo caracter em num�rica.

TYPE(�cVariavel�) := Determina o tipo do conte�do de uma vari�vel, a qual n�o foi definida na
fun��o em execu��o.

VALTYPE(cVari�vel) := Determina o tipo do conte�do de uma vari�vel, a qual foi definida na fun��o
em execu��o.
