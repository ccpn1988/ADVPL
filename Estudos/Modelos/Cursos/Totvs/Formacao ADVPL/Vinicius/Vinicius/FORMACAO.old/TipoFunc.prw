#Include 'Protheus.ch'

User Function TipoFunc()
Local cNome:= fBuscaNome()
MsgInfo(cNome)
Return

//---------------------------------------------

Static Function fBuscaNome()
Local cRet:= "Cachorro"
return cRet


//----------------------------------------------------

//User Function Tipo2Func()
//Local cAlias:='SA1'
//fListaNome(cAlias)
//
//Return
////-----------------------------------------------------
//
//Static Function fListaNome(fAlias)
//
//	if fAlias =='SA1'
//		MsgInfo ("Cadastro de cliente")
//	Else
//		MsgInfo("Tabela  não localizada")
//		
//	Endif
//	
//Return

User Function Tipo2Func()
Local cNome:= ""
Local cSexo:= "M"

fdadosUsuario(@cNome,@cSexo)

MsgInfo("Nome:"+ cNome + CRLF +; 
			"Sexo:" +cSexo)


Return

//------------------------------------------------------

Static Function fDadosUsuario(xNome,xSexo)

xNome:= "Seu nome Sobrenome"
xSexo:= Iif(xSexo =='M','Masculino','Feminino')

Return
//-------------------------------------------------