#include 'protheus.ch'
#include 'parmtype.ch'

user function zIFYTB()
Local aArea := GetArea()
Local dDataTst := Date()
Local lQuinta := .F.
	
	//TESTANDO SE O DIA HOJE � QUINTA
	IF UPPER(cDow(dDataTst)) == 'THURDAY'
		lQuinta := .T.
		Alert("Hoje � quinta")
	
	//SEN�O MOSTRA UM ALERTA 
	Else
		lQuinta := .F.
		Alert("Hoje n�o � quinta")
	EndIF

	//SEN�O FOR QUINTA E FOR SABADO
	IF !lQuinta .AND. UPPER(cDow(dDataTst)) == 'SATURDAY'
		Alert("SABAD�O")
	//SEN�O FOR QUINTA E FOR SEGUNDA
	ELSEIF !lQuinta .AND. UPPER(cDow(dDataTst)) = "MONDAY"
		Alert("HOJE � SEGUNDA VC SE FUDEU, V� TRAB")
	EndIF
return