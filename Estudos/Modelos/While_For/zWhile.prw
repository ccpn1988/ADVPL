#include 'protheus.ch'
#include 'parmtype.ch'

/*A estrutura de controle WHILE...ENDDO, ou simplesmente o loop WHILE, repete uma se��o de
c�digo enquanto uma determinada express�o resultar em verdadeiro (.T.).

WHILE lExpressao
Comandos...
[EXIT]
[LOOP]
ENDDO*/


User Function zWhile()
Local nNum1 := 0
Local nNum2 := 10

	While nNum1 < nNum2
		nNum1++
			Alert(nNum1 + nNum2) //SEQUENCIAL
	EndDo
		Alert(nNum1 + nNum2) //SOMATORIA

Return


User Function zWhiC()
Local nNum1 := 1
Local cNome := "RCTI"

	While nNum1 != 10 .AND. cNome != "PROTHEUS"
		nNum1++ 
			IF nNum1 == 5 
				cNome := "PROTHEUS"
			EndIF
	EndDo
		Alert("O nome definido � "+ cValToChar(cNome) + " e o numero posicionado �: " + cValToChar(nNum1))

Return