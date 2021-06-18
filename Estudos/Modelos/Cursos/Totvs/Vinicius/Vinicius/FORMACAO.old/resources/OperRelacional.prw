#Include 'Protheus.ch'

User Function OperRelacional()

Local cNome:= 'Vini '
Local cNome2:= 'Vini'

If cNome == cNome2
	MsgInfo ('Verdadeiro')
	Else
	MsgInfo ('False')
EndIf

Return
//-----------------------------------------------------------

User Function OperString
Local cNome := 'Maria'


If 'M' $ cNome
	msginfo ('Verdadeiro')
	
EndIf

Return	

User Function OperStrin

Local cNome:= 'Vini '
Local cNome2:= 'Vini'

MsgInfo (cNome - cNome2)
//If cNome - cNome2
	//MsgInfo ('Verdadeiro')
	//Else
	//MsgInfo ('False')
//EndIf
     	
 Return nil
 
 //------------------------------------------
 
 
 User Function ValCampo()
 Local lRet := .F.
 Local cPar := GetMv('xx_nome') //GetMV() => Retorna o conteudo do parametro
//---------------------------------
//Msginfo(cUserName)
//Msginfo(cPar)
//If cUserName $ cPar
//lRet:= .T.
//endif
//----------------------------------
	if UPPER(AllTRIM(cUserName)) $ upper(alltrim(cPar))
	lRet:= .T.
	Endif
//lRet:= MsgYesNo('Deseja Ativar o campo', 'x3_when')

 //Msginfo(cUserName) // cUserName => Retorna o nome do usuario logado     	
 Return lRet
 
 
      
     
