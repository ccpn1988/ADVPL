#Include 'Protheus.ch'

User Function xIF()
//	Local dDia	:= Day(Date())
	Local dMes	:= Month(Date())
//	Local dAno	:= Year(Date())
	
	If dMes <= 3
		MsgInfo("1º Trimestre")
	ElseIf dMes <= 6
		MsgInfo("2º Trimestre")
	ElseIf dMes <= 9
		MsgInfo("3º Trimestre")
	ElseIf dMes <= 12
		MsgInfo("4º Trimestre")
	EndIf
	
Return ( NIL )


User Function xCase()
//	Local dDia	:= Day(Date())
	Local dMes	:= Month(Date())
//	Local dAno	:= Year(Date())
	
Do Case
	Case dMes <= 3
		MsgInfo("1º Trimestre")
	Case dMes <= 6
		MsgInfo("2º Trimestre")
	Case dMes <= 9
		MsgInfo("3º Trimestre")
	OtherWise
		MsgInfo("4º Trimestre")
	EndCase
	
Return ( NIL )

