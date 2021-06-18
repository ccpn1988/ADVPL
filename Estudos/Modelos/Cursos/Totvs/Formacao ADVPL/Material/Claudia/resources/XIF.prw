#Include 'Protheus.ch'

/*
Cláudia Balestri - 06/04/2019
*/


User Function xIf()
Local dMes:=Month(Date())

	if dMes <= 3
	   MsgInfo("1 Trimestre")
	elseif dMes <= 6
	   MsgInfo("2 Trimestre")
	elseif dMes <= 9
	   MsgInfo("3 Trimestre")
	elseif dMes <= 12
	   MsgInfo("4 Trimestre")
	endif
   
Return(nil)

//---------------------------------------------------------

User Function xCase
Local dMes:=Month(Date())

     Do Case
        Case dMes <= 3
             MsgInfo('1 Trimestre')
        Case dMes <= 6
             MsgInfo('2 Trimestre')
        Case dMes <= 9
             MsgInfo('3 Trimestre')
        OtherWise
             MsgInfo('4 Trimestre')             
     Endcase
        
Return(nil)