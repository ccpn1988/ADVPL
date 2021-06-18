#Include 'Protheus.ch'

User Function xFOR()
local x := 0

FOR x := 1 TO 10 STEP 2 //(STEP:= MUDA DE 2 EM 2)
	MSGINFO("CONTADOR: " + cValToChar(X))

NEXT 

Return
//////////////////////////////////////////////////////////////////////////////////

User Function xFOR1()
local x := 0

FOR x := 10 TO 1 STEP -1 
	MSGINFO("CONTADOR: " + cValToChar(X))

NEXT 

Return

//////////////////////////////////////////////////////////////////////////////////

User Function xFOR2()
local x := 0

	FOR x := 1 TO 10 
		IF X := 5
			LOOP //PULA A CONDIÇÃO DE X
		ENDIF
		MSGINFO("CONTADOR: " + cValToChar(X))
	NEXT 

Return

//////////////////////////////////////////////////////////////////////////////////

User Function xFOR2()
local x := 0

	FOR x := 1 TO 10 
		IF X := 5
			EXIT //SAI NA DA CONDIÇÃO DEFINIDA
		ENDIF
		MSGINFO("CONTADOR: " + cValToChar(X))
	NEXT 
	
Return
	
