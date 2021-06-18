#include 'protheus.ch'
#include 'parmtype.ch'

user function zWhileYT()
Local aArea := GetArea()
Local nValor := 1

	While nValor != 10
		nValor++
		Alert("While: " + cValToChar(nValor))
	EndDo
		RestArea(aArea)
return

User Function zWhYTBC()
Local aArea := GetArea()
Local nValor := 1
Local cNome := ""

	While nValor != 10 .AND. cNome !="DANIEL"
		IF nValor == 5 
			cNome := "DANIEL"
		EndIF
		nValor++
	EndDo
		Alert("While: " + cValToChar(nValor))
		Alert("While: " + cValToChar(cNome))
	
	RestArea(aArea)
Return