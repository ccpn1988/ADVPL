#Include 'Protheus.ch'

User Function XIF()

	Local dMes := Month(Date())
	
	If dMes <= 3
		MsgInfo("1� Trimestre")
	Elseif dMes <= 6
		MsgInfo("2� Trimestre")
	Elseif dMes <= 9
		MsgInfo("3� Trimestre")
	Elseif dMes <= 12
		MsgInfo("4� Trimestre")
	Endif
	
Return

User function xCase()

	Local dMes := Month(Date())
	Local nTres := 3

	Do Case
		Case dMes <= nTres
			MsgInfo("1� Trimestre")
		Case dMes <= 6
			MsgInfo("2� Trimestre")
		Case dMes <= 9
			MsgInfo("3� Trimestre")
		OtherWise //Else
			MsgInfo("4� Trimestre")
	endcase

return