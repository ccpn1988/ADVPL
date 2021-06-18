#include 'protheus.ch'
#include 'parmtype.ch'

//Passagem de parâmetros por conteúdo


User Function CalcFator(nFator)
Local nCnt
Local nResultado := 0
For nCnt := nFator To 1 Step -1
nResultado *= nCnt
Next nCnt
Alert("O fatorial de " + cValToChar(nFator) + ;
" é " + cValToChar(nResultado))
Return

