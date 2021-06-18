#Include 'Protheus.ch'

User Function OperRelaci()

	Local cNome := "CAIO NEVES"
	Local cNome2 := "CAIONEVES"
	
IF cNome2 = cNome
	MsgInfo("Verdadeiro")
Else
	MsgInfo("Falso")
ENDIF
	
Return

//-----------------------------------------------------------------------------------------------

User Function OperString1()

	Local cNome:= "MARIA"
	
IF "M" $ cNome
	MsgInfo("VDD")
ENDIF

Return


User Function OperRelaci1()

	Local cNome := "CAIO NEVES"
	Local cNome2 := "CAIONEVES"
	
MsgInfo (cNome - cNome2)

Return
//-----------------------------------------------------------------------------------------------

user Function ValCampo()

Local lRet := .T.
Local cPar := GetMv("XX_NOME")//GetMv -> Retorna conteúdo do Parâmetro

MsgInfo(cUserName) // cUserName -> Retorna o Nome do Usuário

lRet:= MsgYesNo("Deseja Ativar o Campo?", "X3_EDIT")


Return lRet
//-----------------------------------------------------------------------------------------------

/*
EXERCICIO 
USAR PARÂMETRO XX_NOME
SÓ PODE EDITAR O CAMPO OS USUARIOS QUE ESTAO NO PARAÂMETRO
*/ 
//BLOQUEIA A EDIÇÃO DO CAMPO POR USUÁRIO

User Function Exec()

Local lRet := .F.
Local cPar := GetMv("XX_NOME")

//UPPER(ALLTRIM(cUserName)) $ UPPER(Alltrim(GETMV("XX_NOME"))) -> DIFETO NO CAMPO
IF UPPER(Alltrim(cUserName)) $ UPPER(Alltrim(cPar))
	lRet:= .T.
ENDIF

Return lRet
