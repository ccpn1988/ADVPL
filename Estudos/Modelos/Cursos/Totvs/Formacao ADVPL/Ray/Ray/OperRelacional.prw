#Include 'Protheus.ch'

User Function OperRelacional()

	Local cNome := "HEROLD "
	Local cNome2 := "HEROLD"
	
	If cNome == cNome2
		MsgInfo("Verdadeiro","parte 1")
	Else
		MsgInfo("False","parte 2")
	EndIf

Return

//---------------------------------------------------------

User Function OperString

Local cNome := "Maria   "
Local cNome2 := "Maria"


/*
	if "M" $ cNome
		msginfo("Verdadeiro")
	EndIf
*/

msginfo(cnome - cnome2)


Return	

//--------------------------------------------------------------

User Function ValCampo()

	Local lRet := .T.
	Local cPar := GetMv("XX_NOME") //GetMV() => Retorna o conteudo do parametro
	
	
	If UPPER(Alltrim(cUserName))$ UPPER(Alltrim(GetMv("XX_NOME")))
		MsgAlert("O usuário não está na lista de liberados!!", "Atenção")
		lRet := .F.
	EndIf
	
	//lRet := MsgYesNo("Deseja editar o campo", "X3_EDIT")
	//	Msginfo(cPar)
	
Return lRet
