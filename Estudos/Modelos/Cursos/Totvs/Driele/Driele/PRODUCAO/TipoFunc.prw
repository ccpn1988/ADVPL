#Include 'Protheus.ch'

User Function TipoFunc()

Local cNome := fBuscaNome()
      
      MSginfo (cNome)
      
Return



//---------------------------------------


Static Function fBuscaNome()

Local cRet := "Seu nome"

Return cRet


//---------------------------------------

User Function Tipo2Func()
Local cAlias := "SA1"
      
fListaNome (cAlias)
      
Return


Static Function fListaNome (fAlias)
Local cAlias := "SA1"
      
      If fAlias == 'SA1'
         MsgInfo ("Cadastro Cliente")
      Else   
         MsgInfo ("Tabela não localizada")
      Endif    
Return


//---------------------------------------------------------

User Function Tipo3Func()

Local cNome := ""
Local cSexo := "M"

fDadosUsuario (@cNome, @cSexo)


Msginfo ("Nome: " + cNome + CRLF +; 
         "Sexo: " + cSexo)
Return

//---------------------------------------

Static Function fDadosUsuario(xNome, xSexo)

xNome := "Seu nome Sobrenome"
xSexo := Iif (xSexo == 'M', "Masculino", "Femino")