#Include 'Protheus.ch'
/*
Cl�udia Balestri - 06/04/2019
*/


User Function TipoFunc()

Local cNome:= fBuscaNome()

	msginfo(cNome)

Return

//--------------------------------------------------

Static Function fBuscaNome()

Local cRet := "Claudia Balestri"

Return cRet

//--------------------------------------------------

User Function Tipo2Func()
Local cAlias := 'SA1'
Local x:= "OutroValor"

fListaNome(cAlias,,,,X)

Return

//--------------------------------------------------

Static Function fListNome(fAlias, fNome, fCpf, fCep, fQualquerCoisa)

	if fAlias == 'SA1'
	    MSGiNFO("Cadastro do Cliente")
	else
	    MsgInfo("Tabela n�o localizada")
	endif    

Return

//--------------------------------------------------

User Function Tipo3Func()

Local cNome:="Cl�udia"
Local cSexo:="F"

	fDadosUsuario(@cNome,@cSexo)   
	//a variavel local com o @ fica como variavel private....
	
	MsgInfo("Nome: " + cNome + CRLF+;
	        "Sexo: " + cSexo)
Return
//------------------------------------------------

Static Function fDadosUsuario(xNome,xSexo)

	xNome := "Cl�udia Balestri"
	xSexo := Iif(xSexo == 'F',"Feminino","Masculino")

Return