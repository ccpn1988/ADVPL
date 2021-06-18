#Include 'Protheus.ch'

User Function OperadorRelacional()
	
	Local cNome := "DIEGO "
	Local cNome2 := "DIEGO"

If cNome = cNome2
	MsgInfo("Verdadeiro")
else
	MsgInfo("False")
EndIf		

If cNome == cNome2
	MsgInfo("Verdadeiro")
else
	MsgInfo("False")
EndIf		

Return

User Function OperString()

Local cNome := "Maria"

If ("M" - cNome) $ cNome
	MsgInfo("Verdadeiro")
else
	MsgInfo("False")
EndIf

Return


User Function OperStringMenos()

Local cNome := "Maria   "
Local cNome2 := "Maria"

MsgInfo(cNome - cNome2)

Return
/*
User Function ValCampo()

Local lRet := .T.
Local cPar := GetMv("XX_NOME")
lRet := MsgYesNo("Deseja Editar o campo","X3_WHEN")
Return lRet
*/

User Function ValCampo()

Local lRet := .F.
Local cPar := GetMv("XX_NOME")

IIf(UPPER(AllTrim(cUserName)) $ UPPER(AllTrim(cPar)), lRet := .T.,lRet := .F.) 
/*
If UPPER(AllTrim(cUserName)) $ UPPER(AllTrim(cPar))
	lRet := .T.
EndIf
*/
Return lRet
