#Include 'Protheus.ch'

User Function OperRelacional()

Local cNome  := "HEROLD "
Local cNome2 := "HEROLD"



If cNome2 = cNome
	MsgInfo("Verdadeiro")
Else
  MsgInfo("False")
EndIf



Return
//--------------------------------------------------------------
User Function OperString 

Local cNome  := "Maria   "
Local cNome2 := "Maria"


	msginfo(cNome - cNome2)


Return
//--------------------------------------------------------------

User Function ValCampo()

Local lRet := .F.
Local cPar := GetMv("XX_NOME") // GetMV() => Retorna o conteudo do parametro	

If UPPER(Alltrim(cUserName)) $ UPPER(Alltrim(GetMv("XX_NOME")))
	lRet := .T.
Endif
	

//Msginfo(cUserName) // cUserName => Retorna o nome do usuario logado

//lRet := MsgYesNo("Deseja ativar o campo","X3_WHEN")

Return lRet















