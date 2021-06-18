#Include 'Protheus.ch'

User Function xWhile()

Local nCount := 1
/*
Do While nCount <= 10
	MsgInfo('Contador ' + cValToChar(nCount))
	
	/*nCount +=1 / nCount := nCount + 1 / ++nCount
	nCount++
EndDo

nCount := 1

while(nCount <= 10)
	MsgInfo('Contador ' + cValToChar(nCount))
	nCount += 2
EndDo */

/*while(++nCount <= 10)
	MsgInfo('Contador ' + cValToChar(nCount))
	//nCount++
EndDo

while(nCount++ <= 10)
	MsgInfo('Contador ' + cValToChar(nCount))
	//nCount++
EndDo*/

while(.T.)
	if msgYesNo("Deseja sair do While ? ","Atenção !")
		if msgYesNo("Realmente deseja sair do While ? ","Atenção !")
			Exit
		EndIf	
	EndIf
EndDo

Return

