#Include 'Protheus.ch'

User Function TipoFunc()
local cNome:= fBuscaNome()
msginfo(cNome)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function fBuscaNome()
local cRet := "CAIO NEVES"
Return cRet

////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Tipo2Func()
local cAlias := "SA1" 

fListaNome(cAlias)
Return
////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListaNome(cAlias)

	IF cAlias == "SA1"
		MSGInfo("Cadastro de Cliente")
	Else
		MSGInfo("Tabela n�o localizada")
	End IF
Return
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Tipo3Func()
Local cNome := ""
Local cSexo := "M"

fDadosUsuario(@cNome,@cSexo) //@ PASSAGEM DE PAR�METRO POR VARIAVEL

MSGINFO("Nome: " + cNome + CRLF +;
		"Sexo: " + cSexo)
Return
////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDadosUsuario(xNome,xSexo)

xNome := "CAIO NEVES"
xSexo := IIF(xSexo == 'M', "Masculno", "Feminino")

Return

//---------------------------------------------------------------------------------

User Function zTpFuncB()
	Local aArea := GetArea()
	
	//MOSTRA MENSAGEM E CHAMA FUN��O EST�TICA
	MsgInfo("Estou na Fun��o u_zTpFunB()", "ALERTA!!!!")
	fTesteB()
	
	RestArea(aArea)
Return

Static Function fTesteB(cPar1)
	Local aArea := GetArea()
	Default cPar1 := ""
	
	//MOSTRANDO MENSAGEM
	MsgInfo("Estou em uma fun��o est�tica <b>(B)</b>, "+cPar1+"!", "Aten��o!!!!")
Return


