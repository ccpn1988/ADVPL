#include 'protheus.ch'
#include 'parmtype.ch'

/*
IF ELSEIF ELSE ENDIF
*/
user function xxIF()

	Local nNum1 := 22
	Local nNum2 := 100
	
	IF (nNum1 <= nNum2)
		MSGINFO("A variavel nNum1 � menor ou igual a nNum2")
	Else 
		Alert("A variavel nNum1 n�o � igual ou menor do que nNum2")
	ENDIF
return

//-------------------------------------------------------------------------------

User Function xIFx()
	local nNum1 := 22
	local nNum2 := 100
	
	IF (nNum1 = nNum2)
		MSGINFO("A variavel nNum1 � menor ou igual a nNum2")
	ELSEIF (nNum1 > nNum2)
		MSGINFO("A variavel nNum1 � maior ou igual a nNum2")
	ELSEIF (nNum1 != nNum2)
		MSGINFO("A variavel nNum1 � diferente de nNum2")
	ENDIF
RETURN

//-----------------------------------------------------------------------------------
User Function IFTESTES()
	Local dDataTst := Date()
	Local lQuinta := .T.
	
	//TESTANDO SE O DIA DE HOJE � QUINTA
	IF UPPER(cDow(dDataTst)) == "THURSDAY" //cDow = RETORNA O DIA DA SEMANA
		lQuinta := .T.
		Alert("Hoje � Quinta")
	ELSE 
		lQuinta := .F.
		Alert("Hoje n�o � Quinta")
	ENDIF
	
RETURN	