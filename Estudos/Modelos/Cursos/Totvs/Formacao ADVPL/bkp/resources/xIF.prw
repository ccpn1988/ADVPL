#Include 'Protheus.ch'

User Function xIF()
//	Local dDia	:= Day(Date())
	Local dMes	:= Month(Date())
//	Local dAno	:= Year(Date())
	
	If dMes <= 3
		MsgInfo("1� Trimestre")
	ElseIf dMes <= 6
		MsgInfo("2� Trimestre")
	ElseIf dMes <= 9
		MsgInfo("3� Trimestre")
	ElseIf dMes <= 12
		MsgInfo("4� Trimestre")
	EndIf
	
Return ( NIL )


User Function xCase()
//	Local dDia	:= Day(Date())
	Local dMes	:= Month(Date())
//	Local dAno	:= Year(Date())
	
Do Case
	Case dMes <= 3
		MsgInfo("1� Trimestre")
	Case dMes <= 6
		MsgInfo("2� Trimestre")
	Case dMes <= 9
		MsgInfo("3� Trimestre")
	OtherWise
		MsgInfo("4� Trimestre")
	EndCase
	
Return ( NIL )

