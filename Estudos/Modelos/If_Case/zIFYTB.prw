#include 'protheus.ch'
#include 'parmtype.ch'

user function zIFYTB()
Local aArea := GetArea()
Local dDataTst := Date()
Local lQuinta := .F.
	
	//TESTANDO SE O DIA HOJE É QUINTA
	IF UPPER(cDow(dDataTst)) == 'THURDAY'
		lQuinta := .T.
		Alert("Hoje é quinta")
	
	//SENÃO MOSTRA UM ALERTA 
	Else
		lQuinta := .F.
		Alert("Hoje não é quinta")
	EndIF

	//SENÃO FOR QUINTA E FOR SABADO
	IF !lQuinta .AND. UPPER(cDow(dDataTst)) == 'SATURDAY'
		Alert("SABADÂO")
	//SENÃO FOR QUINTA E FOR SEGUNDA
	ELSEIF !lQuinta .AND. UPPER(cDow(dDataTst)) = "MONDAY"
		Alert("HOJE É SEGUNDA VC SE FUDEU, VÁ TRAB")
	EndIF
return