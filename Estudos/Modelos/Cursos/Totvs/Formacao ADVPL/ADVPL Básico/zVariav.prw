#include 'protheus.ch'
#include 'parmtype.ch'

/*Além de atribuir, controlar o escopo e macro executar o conteúdo das variáveis é necessário
manipular seu conteúdo através de funções específicas da linguagem para cada situação.
As operações de manipulação de conteúdo mais comuns em programação são:
 Conversões entre tipos de variáveis
*/

CTOD(cData) := Realiza a conversão de uma informação do tipo caracter no formato
“DD/MM/AAAA” para uma variável do tipo data.

CVALTOCHAR(nValor) := Realiza a conversão de uma informação do tipo numérico em uma string,
sem a adição de espaços a informação.

DTOC(dData) := Realiza a conversão de uma informação do tipo data para em caracter, sendo
o resultado no formato “DD/MM/AAAA”.

DTOS(dData) := Realiza a conversão de uma informação do tipo data em um caracter, sendo
o resultado no formato “AAAAMMDD”.

STOD(sData) := Realiza a conversão de uma informação do tipo caracter com conteúdo no
formato “AAAAMMDD” em data.

STR(nValor) := Realiza a conversão de uma informação do tipo numérico em uma string,
adicionando espaços à direita.

STRZERO(nValor, nTamanho) := Realiza a conversão de uma informação do tipo numérico em uma string,
adicionando zeros à esquerda do número convertido, de forma que a string
gerada tenha o tamanho especificado no parâmetro.

VAL(cValor) := Realiza a conversão de uma informação do tipo caracter em numérica.

TYPE(“cVariavel”) := Determina o tipo do conteúdo de uma variável, a qual não foi definida na
função em execução.

VALTYPE(cVariável) := Determina o tipo do conteúdo de uma variável, a qual foi definida na função
em execução.
