#Include 'Protheus.ch'
//http://tdn.totvs.com/pages/viewpage.action?pageId=24346937
User Function xIF()
Local dMes := Month( Date() ) // M�s

If dMes <= 3
	MsgInfo("1� Trimestre")
ElseIf dMes <= 6
	MsgInfo("2� Trimestre")
ElseIf dMes <= 9
	MsgInfo("3� Trimestre")
Else
	MsgInfo("4� Trimestre")
EndIf

Return

//-----------------------------------------------------------

User Function xIIF()
local nNum1 := 22
local nNum2 := 100

	IF (nNum1 <= nNum2) //IF (SE)
	MsgInfo ("A variavel nNum1 � menor ou igual a nNum2")
	
	Else // (SENAO)
	Alert ("A variavel nNum1 n�o � igual ou menor a nNum2")
	
	EndIF // Encerra o IF

return

//ELSE IF------------------------------------------------------

User Function xIIF()
local nNum1 := 22
local nNum2 := 100

IF(nNum1 == nNum2,"A variavel nNum1 � igual a variavel nNum2", IIF(nNum1 > nNum2,"A variavel nNum1 � maior que a variavel nNum2", IIF(nNum1 != nNum2,"A variavel nNum1 � diferente da variavel nNum2",0)))

return

