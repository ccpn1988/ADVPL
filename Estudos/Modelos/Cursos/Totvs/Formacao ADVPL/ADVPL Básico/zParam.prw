#include 'protheus.ch'
#include 'parmtype.ch'

//Passagem de par�metros por conte�do


User Function CalcFator(nFator)
Local nCnt
Local nResultado := 0
For nCnt := nFator To 1 Step -1
nResultado *= nCnt
Next nCnt
Alert("O fatorial de " + cValToChar(nFator) + ;
" � " + cValToChar(nResultado))
Return

