#Include 'Protheus.ch'

User Function OperRelacional()

	Local cNome		:= "MARCUS "
	Local cNome2	:= "MARCUS"
	
	If cNome == cNome2
		MsgInfo("Verdadeiro")
	Else
		MsgInfo("False")
	EndIf
	
Return
//-----------------------------------------------------------------------------------------------
User Function OperString

	Local cNome  := "Maria"
	Local cNome2 := "Maria   "
	
	If "M" $ cNome
		MsgInfo("Verdadeiro")
	EndIf

	MsgInfo(cNome2 - cNome)
	
Return
//-----------------------------------------------------------------------------------------------
User Function ValCampo()
	Local lRet := .T.
	Local cPar := GetMv("XX_NOME") //GetMv() => Retorna o conteudo do parametro
	
	//lRet := MsgYesNo("Deseja ativar o campo?","X3_WHEN")
	
	If !(UPPER(TRIM(cUserName)) $ UPPER(TRIM(cPar)))
		lRet := .F.
	EndIf
		 

Return lRet
//-----------------------------------------------------------------------------------------------