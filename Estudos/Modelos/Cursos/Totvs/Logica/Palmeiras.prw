#include 'protheus.ch'
#include 'parmtype.ch'

User Function TESTE()

	LOCAL cTime := "Palmeiras"
	LOCAL nNum1 := 0
WHILE nNum1 != 11		
	nNum1++
	IF nNum1 == 1
		MSGINFO(cTime + ' CAMPE�O ')
	ELSEIF nNum1 == 2
		MSGINFO(cTime + ' BI CAMPE�O ')
	ELSEIF nNum1 == 3
		MSGINFO(cTime + ' TRI CAMPE�O ')
	ELSEIF nNum1 == 4
		MSGINFO(cTime + ' TETRA CAMPE�O ')
	ELSEIF nNum1 == 5
		MSGINFO(cTime + ' PENTA CAMPE�O ')
	ELSEIF nNum1 == 5
		MSGINFO(cTime + ' HEXA CAMPE�O ')
	ELSEIF nNum1 == 7
		MSGINFO(cTime + ' HEPTA CAMPE�O ')
	ELSEIF nNum1 == 8
		MSGINFO(cTime + ' OCTA CAMPE�O ')
	ELSEIF nNum1 == 9
		MSGINFO(cTime + ' ENEA CAMPE�O ')
	ELSEIF nNum1 == 10
		MSGINFO(cTime + ' DECA CAMPE�O ')
	ELSE
		MSGINFO('CHUPA CAMBADA')
	ENDIF
ENDDO
RETURN()
