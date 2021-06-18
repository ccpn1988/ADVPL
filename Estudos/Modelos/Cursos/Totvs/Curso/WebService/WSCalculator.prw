#Include 'Protheus.ch'

User Function WSCalculator()
Local oWs     := WSCalculator():New() //WSCalculator - Método do webservice | New - Novo
Local nResult := "" //Cria a variavel
Local cErro   := "" //Cria a variavel

If oWs:add(3,5) // Se o add de 3+5 | Método add pode ser pego no fonte wsdl
	nResult := oWs:nAddResult //nResult - recebe a variavel oWs:nAddResult - que resulta o valor do add
	MsgInfo(nResult)
Else
	cErro := GetWSCError() //Em casa do erro, mostra onde esta o erro
	MsgInfo("Erro: " +cErro)
EndIf

Return

