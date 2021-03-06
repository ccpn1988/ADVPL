#include "rwmake.ch"

///--------------------------------------------------------------------------\
//| Fun��o: CONVLD Autor: Fl�vio Santos       		    Data: 09/11/2010 |
//|         Utilizado por Rosana Nascimento                                  |
//|--------------------------------------------------------------------------|
//| Descri��o: Fun��o para Convers�o da Representa��o Num�rica do C�digo de  |
//|            Barras - Linha Digit�vel (LD) em C�digo de Barras (CB).       |
//|	       Disparado pelo gatilho em E2_XLINDIG (Linha Digit�vel) para   |
//|            E2_CODBAR.                                                    |
//|Leitura do c�digo tem que ser feita diretamente no campo E2_CODBAR        |
//\--------------------------------------------------------------------------/

USER FUNCTION ConvLD()
Local cStr := ""

cStr := LTRIM(RTRIM(M->E2_XLINDIG))

IF VALTYPE(M->E2_XLINDIG) == NIL .OR. EMPTY(M->E2_XLINDIG)
	// Se o Campo est� em Branco n�o Converte nada.
	cStr := ""
ELSE
	// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
	// necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
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
