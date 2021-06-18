#Include 'Protheus.ch'

//pesquisar e retornar a resolução do monitor
User Function gScreen()

	local aScreens := getScreenRes()
	  msginfo(cValToChar(aScreens[1])+"x"+cValToChar(aScreens[2]), "getScreenRes()")
Return

