#include 'protheus.ch'
#include 'parmtype.ch'

user function zCaseYTB()
Local dDataTst := Date()

//cDow == Dia da Semana
	Do Case
		Case UPPER(cDow(dDataTST)) == 'MONDAY'
		Alert("HOJE � SEGUNDA")
				
		Case UPPER(cDow(dDataTST)) == 'TUESDAY'
		Alert("HOJE � SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'WEDNESDAY'
		Alert("HOJE � SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'THURSDAY'
		Alert("HOJE � SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'FRIDAY'
		Alert("HOJE � SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'SATURDAY'
		Alert("HOJE � SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'SUNDAY'
		Alert("HOJE � SEGUNDA")
		
		OtherWise
		Alert("A PORRA DO DIA � ? " + DTOC(dDataTST))
	End Case
return