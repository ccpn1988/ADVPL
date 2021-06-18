#include 'PROTHEUS.ch'
#include 'PARMTYPE.ch'
#include 'TOPCONN.ch'


//FONTE GERAL AULA: COMANDOS DE DECISÃO
//IF - THEN - ELSE
//AUTOR: CAIO NEVES
//CCPN1988

user function Logica()
	LOCAL CVAR := 0
	
	IF CVAR == 0
		MSGINFO('IGUAL A ZERO','ATENÇÃO!!!')
	ELSEIF CVAR == 1
		MSGINFO('IGUAL A UM!!!', 'ATENÇÃO!!!')
	ELSE 
		MSGINFO('HELO MUNDO','ATENÇÃO!!!')
	ENDIF
return()

//----------------------------------------------------------------------------------------

USER FUNCTION XUPIS()
	local cNamo := 'Sua namorada é: '
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
		MSGINFO(cTime + ' CAMPEÃO ')
	ELSEIF nNum1 == 2
		MSGINFO(cTime + ' BI CAMPEÃO ')
	ELSEIF nNum1 == 3
		MSGINFO(cTime + ' TRI CAMPEÃO ')
	ELSEIF nNum1 == 4
		MSGINFO(cTime + ' TETRA CAMPEÃO ')
	ELSEIF nNum1 == 5
		MSGINFO(cTime + ' PENTA CAMPEÃO ')
	ELSEIF nNum1 == 5
		MSGINFO(cTime + ' HEXA CAMPEÃO ')
	ELSEIF nNum1 == 7
		MSGINFO(cTime + ' HEPTA CAMPEÃO ')
	ELSEIF nNum1 == 8
		MSGINFO(cTime + ' OCTA CAMPEÃO ')
	ELSEIF nNum1 == 9
		MSGINFO(cTime + ' ENEA CAMPEÃO ')
	ELSEIF nNum1 == 10
		MSGINFO(cTime + ' DECA CAMPEÃO ')
	ELSE
		MSGINFO('CHUPA CAMBADA')
	ENDIF
ENDDO
RETURN()
