#Include 'Protheus.ch'

User Function XIF()

	Local dMes := Month(Date())
	
	If dMes <= 3
		MsgInfo("1º Trimestre")
	Elseif dMes <= 6
		MsgInfo("2º Trimestre")
	Elseif dMes <= 9
		MsgInfo("3º Trimestre")
	Elseif dMes <= 12
		MsgInfo("4º Trimestre")
	Endif
	
Return

User function xCase()

	Local dMes := Month(Date())
	Local nTres := 3

	Do Case
		Case dMes <= nTres
			MsgInfo("1º Trimestre")
		Case dMes <= 6
			MsgInfo("2º Trimestre")
		Case dMes <= 9
			MsgInfo("3º Trimestre")
		OtherWise //Else
			MsgInfo("4º Trimestre")
	endcase

return