#Include 'Protheus.ch'

User Function xIfCase()

Local dMes := Month(Date())

if dMes <= 3
	MsgInfo("1� Trimestre")
elseif dMes <= 6
	MsgInfo("2� Trimestre")
elseif dMes <= 9
	MsgInfo("3� Trimestre")
elseif dMes <= 12
	MsgInfo("4� Trimestre")
EndIF
		
Do Case
	Case (dMes <= 3)
		MsgInfo("1� Caso Trimestre")
	Case (dMes <= 6)
		MsgInfo("2� Caso Trimestre")
	Case (dMes <= 9)
		MsgInfo("3� Caso Trimestre")
	Case (dMes <= 12)
		MsgInfo("4� Caso Trimestre")	
	OtherWise
		MsgInfo("M�s n�o esperado")	
EndCase		
		
Return

