#include 'protheus.ch'
#include 'parmtype.ch'

user function xCase()
	
Local dMes := Month( Date() ) // M�s

Do case
Case dMes <= 3
	MsgInfo("1� Trimestre")
Case dMes <= 6
	MsgInfo("2� Trimestre")
Case dMes <= 9
	MsgInfo("3� Trimestre")
OtherWise
	MsgInfo("4� Trimestre")
EndCase

Return
//-------------------------------------------

user function DoCase()

	local cData := "09/09/1988"
	
Do Case 

Case cData == "23/05/1992"
	MsgInfo ("Niver da Gabi")
	
Case cData == "02/03/1970"
	MsgInfo ("Niver Telma")
	
Case cData == "17041969"
	MsgInfo ("Niver Adilson")
	
OtherWise // Caso nenhuma das op��es sejam verdadeiras
	Alert ("Niver Caio")

End Case
 
Return 