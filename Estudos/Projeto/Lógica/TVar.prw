
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
/*
LOCAL = S�O VISIVEIS EM QUALQUER LOCAL DO FONTE AONDE FORAM DECLARADAS.

STATIC = SE FOREM DECLARADAS DENTRO DE UMA FUN��O O ESCOPO SER A LIMITADO, SE DECLARADO FORA DO CORPO DA FUN��O
         QUALQUER UN��O PODERA UTILIZAR.

PRIVATE = VISIVEL EM TODO O PROGRAMA, S�O DESTRUIDAS QUANDO FUN�AO INTERNA CHAME UMA VARIAVEL DO MESMO NOME, POREM
          COM OUTRO VALOR.

PUBLIC = VISIVEL EM TODO PROGRAMA, SENDO ESCONDIDA POR UMA VARIAVEL PRIVATE COM MESMO NOME.

OBS: VARIAVEL SEM ESCOPO POR PADRAO � PRIVATE.
*/

STATIC cStatic := ''

User Function TVar()
    LOCAL aArea := GetArea()
    LOCAL nVar0 := 1
    LOCAL nVar1 := 20

    PRIVATE cPri := 'Private!'

    PUBLIC __cPublic := 'RCTI'

    TestEscop(nVar0, @nVar1)

    RestArea(aArea)

Return

Static Function TestEscop(vValor1, nValor2)
    
    LOCAL __cPublic := 'Alterei'
    Default nValor1 := 0

    MsgInfo("Variavel nValor2 com resultado: "+ cValToChar(nValor2))

    nValor2 := 10

     MsgInfo("Variavel nValor2 apos altera��o: "+ cValToChar(nValor2))

    Alert("Private: "+ cPri)

    Alert("Publica: "+ __cPublic)
Return
