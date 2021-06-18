#Include 'Protheus.ch'

User Function xIfCase()

Local dMes := Month(Date())

if dMes <= 3
	MsgInfo("1º Trimestre")
elseif dMes <= 6
	MsgInfo("2º Trimestre")
elseif dMes <= 9
	MsgInfo("3º Trimestre")
elseif dMes <= 12
	MsgInfo("4º Trimestre")
EndIF
		
Do Case
	Case (dMes <= 3)
		MsgInfo("1º Caso Trimestre")
	Case (dMes <= 6)
		MsgInfo("2º Caso Trimestre")
	Case (dMes <= 9)
		MsgInfo("3º Caso Trimestre")
	Case (dMes <= 12)
		MsgInfo("4º Caso Trimestre")	
	OtherWise
		MsgInfo("Mês não esperado")	
EndCase		
		
Return

