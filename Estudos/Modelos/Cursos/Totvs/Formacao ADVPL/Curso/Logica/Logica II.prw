#include 'PROTHEUS.ch'
#include 'PARMTYPE.ch'
#include 'TOPCONN.ch'


//FONTE GERAL AULA: COMANDOS DE DECIS�O
//IF - THEN - ELSE
//AUTOR: CAIO NEVES
//CCPN1988

user function Logica()
	LOCAL CVAR := 0
	
	IF CVAR == 0
		MSGINFO('IGUAL A ZERO','ATEN��O!!!')
	ELSEIF CVAR == 1
		MSGINFO('IGUAL A UM!!!', 'ATEN��O!!!')
	ELSE 
		MSGINFO('HELO MUNDO','ATEN��O!!!')
	ENDIF
return()

//----------------------------------------------------------------------------------------

USER FUNCTION XUPIS()
	local cNamo := 'Sua namorada �: '
	local cIrma := 'Gabriela'
	
	If cIrma == 'Gabriela' 
		MSGALERT(cNamo + 'Fernanda Marques Faber','ALERT!!!!')
	ELSEIF cIrma == ' '
		MSGALERT(cNamo + ' Qualquer uma!!!','ALERT!!!')
	ELSE
		MSGALERT('Fica Solteiro','ALERT!!!')
	ENDIF
RETURN

//---------------------------------------------------------------------------------------
User Function SEP()

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
