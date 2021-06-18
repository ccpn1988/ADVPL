#include "rwmake.ch"

///--------------------------------------------------------------------------\
//| Função: CONVLD Autor: Flávio Santos       		    Data: 09/11/2010 |
//|         Utilizado por Rosana Nascimento                                  |
//|--------------------------------------------------------------------------|
//| Descrição: Função para Conversão da Representação Numérica do Código de  |
//|            Barras - Linha Digitável (LD) em Código de Barras (CB).       |
//|	       Disparado pelo gatilho em E2_XLINDIG (Linha Digitável) para   |
//|            E2_CODBAR.                                                    |
//|Leitura do código tem que ser feita diretamente no campo E2_CODBAR        |
//\--------------------------------------------------------------------------/

USER FUNCTION ConvLD()
Local cStr := ""

cStr := LTRIM(RTRIM(M->E2_XLINDIG))

IF VALTYPE(M->E2_XLINDIG) == NIL .OR. EMPTY(M->E2_XLINDIG)
	// Se o Campo está em Branco não Converte nada.
	cStr := ""
ELSE
	// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
	// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
	cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
ENDIF

DO CASE
	CASE LEN(cStr) == 47
		cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
	CASE LEN(cStr) == 48
		cStr := SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
	OTHERWISE
		cStr := cStr+SPACE(48-LEN(cStr))
ENDCASE
                                                     
RETURN(cStr)
