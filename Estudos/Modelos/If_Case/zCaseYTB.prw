#include 'protheus.ch'
#include 'parmtype.ch'

user function zCaseYTB()
Local dDataTst := Date()

//cDow == Dia da Semana
	Do Case
		Case UPPER(cDow(dDataTST)) == 'MONDAY'
		Alert("HOJE É SEGUNDA")
				
		Case UPPER(cDow(dDataTST)) == 'TUESDAY'
		Alert("HOJE É SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'WEDNESDAY'
		Alert("HOJE É SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'THURSDAY'
		Alert("HOJE É SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'FRIDAY'
		Alert("HOJE É SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'SATURDAY'
		Alert("HOJE É SEGUNDA")
		
		Case UPPER(cDow(dDataTST)) == 'SUNDAY'
		Alert("HOJE É SEGUNDA")
		
		OtherWise
		Alert("A PORRA DO DIA É ? " + DTOC(dDataTST))
	End Case
return