#Include 'Protheus.ch'

User Function xIF()
Local dMes := Month(Date())

If dMes<= 3
	MsgInfo("1� Trimestre")
Elseif dMes <= 6
	MsgInfo("2� Trimestre")
Elseif dMes <= 9
	MsgInfo("3� Trimestre")
Elseif dMes <= 12
	MsgInfo("4� Trimestre")
EndIf	


Return


User Function xcase()
Local dMes := Month(Date())
do case 
case dMes<= 3
	MsgInfo("1� Trimestre")
case dMes <= 6
	MsgInfo("2� Trimestre")
case dMes <= 9
	MsgInfo("3� Trimestre")
otherwise
	MsgInfo("4� Trimestre")
Endcase	


Return

