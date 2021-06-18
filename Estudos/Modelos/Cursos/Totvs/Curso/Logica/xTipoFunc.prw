#Include 'Protheus.ch'

// Passagem de função

User Function xTipoFunc()
Local cNome := SeuNome() //Variavel chama a funcção SeuNome()
MsgInfo (cNome)
Return (NIL)

//-----------------------------------------------------------------
Static Function SeuNome()
Local cRet:= "Seu Nome"
Return (cRet) // Passar para o retorno o conteudo que voce quer retornar (Variavel cRet)
//-----------------------------------------------------------------

// Passagem de parametros

User Function xTipoFunc2()
Local cNome := "Seu Nome"
Local cCPF := "00000000000"

IF fValDados(cNome,cCPF)
	MsgInfo("Cliente alterado com sucesso")
Else
	MsgInfo("Dados não localizados")
Endif

Return (NIL)

//-----------------------------------------------------------------

Static Function fValDados(pNome,pCPF)
Local lRet := .F.

IF ! Empty(pNome)
	IF pNome == "Seu Nome"
		lRet:= .T.
	Endif
Elseif ! Empty(pCPF)
	IF Len(pCPF) == 11
		lRet:= .T.
	Endif
Endif

Return (lRet)

//-----------------------------------------------------------------

// Teste com apenas 1 parametro

//User Function xTipoFunc2()
//Local cNome := "Seu Nome"
//Local cCPF := "00000000000"
//
//IF fValDados(,cCPF) // Nessa caso esta sendo passado apenas 1 parametro, mas é necessário informar a , para indicar a posição do primeiro parametro
//	MsgInfo("Cliente alterado com sucesso")
//Else
//	MsgInfo("Dados não localizados")
//Endif
//
//Return (NIL)

//-----------------------------------------------------------------

//Static Function fValDados(pNome,pCPF)
//Local lRet := .F.
//
//IF ! Empty(pNome)
//	IF pNome == "Seu Nome"
//		lRet:= .T.
//	Endif
//Elseif ! Empty(pCPF)
//	IF Len(pCPF) == 11
//		lRet:= .T.
//	Endif
//Endif
//
//Return (lRet)

//-----------------------------------------------------------------

User Function xTipoFunc3()

Local cNome  := "Seu Nome"
Local nIdade := "12"
Local cSexo  := "M"

fMudaTudo(@cNome,@nIdade,@cSexo) // Quando colocado o @ na variavel, informa que a variavel cNome e a variavel a tem o mesmo caminho de memória
                                 // ou seja passa o valor da variavel por referencia
MsgInfo("Nome: " + cNome + CRLF + ;
        "Idade: " + cValToChar(nIdade) + CRLF + ;
        "Sexo: " + cSexo)
        
Return (NIL)

//-----------------------------------------------------------------

Static Function fMudaTudo(a,b,c)

a:= "Seu nome e sobrenome"
b:= 100
c:= "Masculino"

Return (NIL)













