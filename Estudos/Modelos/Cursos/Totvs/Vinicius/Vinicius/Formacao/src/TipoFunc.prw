#Include 'Protheus.ch'

User Function TipoFunc()

Local cNome := fBuscaNome()
MsgInfo(cNome,"Retorno de uma Função")
Return

Static Function fBuscaNome()

Local cRet := "Seu Nome"

Return cRet

User Function Tipo2Func()
	Local cAlias := 'SA1'
	fListaNome(cAlias)
Return

Static Function fListaNome(fAlias)
	If fAlias == 'SA1'
		MsgInfo("Cadastro de Clientes!")
	else
		MsgInfo("CTabela não localizada!")	
	EndIf
return		
	
	
User Function Tipo3Func()
	Local cName := ""
	Local cSexo := "M"
	fDadosDoUsuario(@cName,@cSexo)
	
	MsgInfo("Nome: " + cName + CRLF + ;
			"Sexo: " + cSexo)
Return

Static Function fDadosDoUsuario(xName,xSexo)
	xName := "Seu Nome Sobrenome"
	xSexo := iif(xSexo == 'M',"Maculino","Feminino")
	
return		
		