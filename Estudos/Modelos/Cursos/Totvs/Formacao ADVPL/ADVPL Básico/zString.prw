#include 'protheus.ch'
#include 'parmtype.ch'

user function zString()

ALLTRIM(cString) := Retorna uma string sem os espaços à direita e à esquerda, referente ao
conteúdo informado como parâmetro.
A função ALLTRIM() implementa as ações das funções RTRIM (“right trim”) e
LTRIM (“left trim”).

ASC(cCaractere) := Converte uma informação caractere em seu valor de acordo com a tabela
ASCII.

AT(cCaractere, cString ) := Retorna a primeira posição de um caracter ou string dentro de outra string
especificada.

RAT(cCaractere, cString) := Retorna a última posição de um caracter ou string dentro de outra string
especificada.

CHR(nASCII) := Converte um valor número referente a uma informação da tabela ASCII no
caractere que esta informação representa.

LEN(cString) := Retorna o tamanho da string especificada no parâmetro.

LOWER(cString) := Retorna uma string com todos os caracteres minúsculos, tendo como base a
string passada como parâmetro.

UPPER(cString) := Retorna uma string com todos os caracteres maiúsculos, tendo como base a
string passada como parâmetro.

STUFF(cString, nPosInicial, nExcluir, cAdicao) := Permite substituir um conteúdo caractere em uma string já existente,
especificando a posição inicial para esta adição e o número de caracteres que
serão substituídos.

SUBSTR(cString, nPosInicial, nCaracteres) := Retorna parte do conteúdo de uma string especificada, de acordo com a
posição inicial deste conteúdo na string e a quantidade de caracteres que
deverá ser retornada a partir daquele ponto (inclusive).


	
return