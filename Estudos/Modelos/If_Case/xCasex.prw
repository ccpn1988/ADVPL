#include 'protheus.ch'
#include 'parmtype.ch'

user function xCasex()
		
		Local cData := "17/04/2019"
	
	Do Case 
	
		Case cData != "17/04/2019"
			Alert("Não é Natal " + cData)
			
		Case cData == "17/04/2019"
			Alert("É Niver do ICO!!!")
			
		OtherWise
			Alert("Outra Data")
		
	ENDCASE
		
return
//-------------------------------------------------------------------------------

User Function xxCase()//SEGUNDO CASE
		Local cData := "17/04/2019"
	
	Do Case 
	
		Case cData != "17/04/2019"
			Alert("Não é Natal " + cData)
			
		Case cData == "17/04/2019"
			Alert("É Niver do ICO!!!" + cData)
			
		OtherWise
			Alert("Outra Data")
		
	ENDCASE
Return
//-------------------------------------------------------------------------------

User Function xxCasex() //OTHERWISE
		Local cData := "17/04/2019"
	
	Do Case 
	
		Case cData != "17/04/2019"
			Alert("Não é Natal " + cData)
			
		Case cData == "16/04/2019"
			Alert("É Niver do ICO!!!" + cData)
			
		OtherWise
			Alert("Outra Data")
		
	ENDCASE
Return
