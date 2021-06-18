#Include 'Protheus.ch'
//http://tdn.totvs.com/pages/viewpage.action?pageId=24346937
User Function xIF()
Local dMes := Month( Date() ) // Mês

If dMes <= 3
	MsgInfo("1º Trimestre")
ElseIf dMes <= 6
	MsgInfo("2º Trimestre")
ElseIf dMes <= 9
	MsgInfo("3º Trimestre")
Else
	MsgInfo("4º Trimestre")
EndIf

Return

//-----------------------------------------------------------

User Function xIIF()
local nNum1 := 22
local nNum2 := 100

	IF (nNum1 <= nNum2) //IF (SE)
	MsgInfo ("A variavel nNum1 é menor ou igual a nNum2")
	
	Else // (SENAO)
	Alert ("A variavel nNum1 não é igual ou menor a nNum2")
	
	EndIF // Encerra o IF

return

//ELSE IF------------------------------------------------------

User Function xIIF()
local nNum1 := 22
local nNum2 := 100

IF(nNum1 == nNum2,"A variavel nNum1 é igual a variavel nNum2", IIF(nNum1 > nNum2,"A variavel nNum1 é maior que a variavel nNum2", IIF(nNum1 != nNum2,"A variavel nNum1 é diferente da variavel nNum2",0)))

return

