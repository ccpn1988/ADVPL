#Include 'Protheus.ch'

User Function xWhile()
Local nCount  := 1
Local nCount2 := 1

Do While nCount <= 10

	MsgInfo("Contador: " + cValToChar(nCount))
	
	nCount++
//	nCount:= nCount + 1
//	nCount+= 1
//	++nCount
	
Enddo

MsgInfo("Final do 1º While")

//Altera o loop 5 para a palavra loop e continua
While nCount2 <= 10
	If nCount2 == 5
		MsgInfo("Loop")
		nCount2++
		Loop
	Endif
	MsgInfo("Contador: " + cValToChar(nCount2))
	nCount2++
Enddo

MsgInfo("Final do 2º While")

//
While .T.
	For x:= 1 To 5
		MsgInfo("FOR " + cValToChar(x))
	Next
	
	If MsgYesNo("Deseja sair do While")
		If MsgNoYes("Realmente deseja sair do While")
			Exit
		Endif
	Endif
Enddo

MsgInfo("Final do 3º While")

Return
//-----------------------------------------------------------------------------------
User Function Wile()

local nNum1 := 0
Local nNum2 := 10

While nNum1 < nNum2
	nNum1 ++ //Incrementa valor
EndDo

Alert (nNum1 + nNum2)
Return

//--------------------------------------------------------------------------------------

User Function Wile2()

local nNum1 := 1
local cNome := "RCTI"

While  nNum1 != 10 .AND. cNome != "Protheus"
	nNum1 ++ 
	IF nNum1 == 5
		cNome := "Protheus"

		EndIF
EndDo

Alert ("Numero:" + cValToChar (nNum1))
Alert ("Nome: " + cValToChar(cNome))
Return

//--------------------------------------------------------------------------------------------

User Function While3()

Local cTeste := "CAIO NEVES"
Local nNum1:= 10

While cTeste == "CAIO NEVES"
	++ nNum1
	
 IF nNum1 == -1
 	cTeste := "RCTI"
 EndIF

EndDo

Return
//---------------------------------------------------------------------------------------
User Function TESTE()

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