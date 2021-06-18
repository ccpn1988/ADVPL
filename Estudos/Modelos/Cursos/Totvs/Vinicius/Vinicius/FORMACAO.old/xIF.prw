#Include 'Protheus.ch'

User Function xIF()
Local dMes := Month(Date())

If dMes<= 3
	MsgInfo("1º Trimestre")
Elseif dMes <= 6
	MsgInfo("2º Trimestre")
Elseif dMes <= 9
	MsgInfo("3º Trimestre")
Elseif dMes <= 12
	MsgInfo("4º Trimestre")
EndIf	


Return


User Function xcase()
Local dMes := Month(Date())
do case 
case dMes<= 3
	MsgInfo("1º Trimestre")
case dMes <= 6
	MsgInfo("2º Trimestre")
case dMes <= 9
	MsgInfo("3º Trimestre")
otherwise
	MsgInfo("4º Trimestre")
Endcase	


Return

