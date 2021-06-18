#include 'protheus.ch'
#include 'parmtype.ch'
/*
nNum := NUMERICO := 3
lVar := LOCIGO := .T. / .F.
cVar := CARACTERE := "D" / 'C'
dDate := DATA := DATE()
aVar  := ARRAY := {"VALOR1","VALOR2","VALOR3"}
bBloc := BLOCO := {||VALOR := 1, MSGALERT("VALOR É IGUAL A :" + CVALTOCHAR(VALOR))}
*/
user function Varivel()
	Local nNum := 66
	local lLogic := .T.
	local cCarac := "String"
	local dData := DATE() //DATA ATUAL
	local aArray := {"João","Maria","Jose"}
	local bBloco := {||nValor := 2,MsgAlert('O numero é :' + cValToChar(nNum))}
	
	MSGAlert(nNum,"Variavel Numerica")
	MSGAlert(lLogic,"Variavel Logica")
	MSGINFO(cCarac,"Variavel Caractere")
	MSGAlert(dData,"Variavel Data")
	MSGAlert(aArray[1],"Array")
	Eval(bBloco)//IMPRIME BLOCO DE CODIGO
return()

/*IMPRESSÃO
EVAL := BLOCO DE CÓDIGO
Alert("Stop")
MsgInfo("Informativo")
MsgStop("Stop")
MsgAlert("Alerta")
MsgNoYes("No/Yes")
MsgYesNo("Yes/No")