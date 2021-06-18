#Include 'Protheus.ch'

User Function TipoFunc()
	Local cNome	:= fBuscaNome()
	
	MsgInfo(cNome)

Return

//-----------------------------------------------------------------------------------------------
Static Function fBuscaNome()

	Local cRet	:= "Seu nome"
	
Return cRet
//-----------------------------------------------------------------------------------------------

User Function Tipo2Func()
	
	Local cAlias	:= "SA1"
	Local x			:= "Outro Valor" 
	
	fListaNome(cAlias,,,,x)

Return

Static Function fListaNome(fAlias,fNome,fCpf,fCep,fQualquerCoisa)

	If fAlias == "SA1"
		MsgInfo("Cadastro de cliente")
	Else
		MsgInfo("Tabela não localizada")
	EndIf
	
Return

//-----------------------------------------------------------------------------------------------
User Function Tipo2Func()
	
	Local cNome	:= ""
	Local cSexo	:= "M" 
	
	fDadosUsuario(@cNome,@cSexo)
	
	MsgInfo("Nome: " + cNome + CRLF + ;
			"Sexo: " + cSexo)

Return

Static Function fDadosUsuario(xNome,xSexo)

	xNome	:= "Seu nome Sobrenome"
	xSexo	:= Iif(xSexo == 'M',"Masculino","Feminino")

Return
//-----------------------------------------------------------------------------------------------