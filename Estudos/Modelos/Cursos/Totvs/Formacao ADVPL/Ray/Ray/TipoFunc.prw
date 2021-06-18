#Include 'Protheus.ch'

User Function TipoFunc()

	Local cNome := fBuscaNome()
	msginfo(cNome)
	
Return

//-----------------------------------------

Static Function fBuscaNome()

	Local cRet := "Seu nome"
	
return cRet

//---------------------------------------------

User Function Tipo2Func()

	Local cAlias	:= 'SA1'
	Local x			:= "OutroValor"
	
	fListaNome(cAlias,,,,x)
	
return

//---------------------------------------------

Static Function fListaNome(fAlias,fNome,fCpf,fCep,fQualquerCoisa)
	If fAlias == 'SA1'
		MsgInfo("Cadastro de cliente")
	Else
		MsgInfo("Tabela não Localizada")
	Endif
Return

//---------------------------------------------

User Function Tipo3Func
	
	Local cNome := ""
	Local cSexo := "M"
	
	fDadosUsuario(@cNome,@cSexo)
	
	MsgInfo("Nome: " + cNome + CRLF +;
			"Sexo: " + cSexo)

Return

//---------------------------------------------

Static Function fDadosUsuario(xNome,xSexo)
	
	xNome := "Seu nome Sobrenome"
	xSexo := Iif(xSexo == 'M',"Masculino","Feminino")
	
Return	
	

//---------------------------------------------