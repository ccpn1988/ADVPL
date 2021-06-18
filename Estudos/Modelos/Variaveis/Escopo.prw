#include 'protheus.ch'
#include 'parmtype.ch'

/*
FUNCTION() //INTELIGENCIA PROTHEUS 10 CARACTERES (MATA001CLI()) RESTRITA
USER FUNCTION() //FUNÇÕES DEFINIDAS PELO USUÁRIO U_FUNCTION()
STATIC FUNCTION() //UTILIZADA APENAS NO MESMO CÓDIGO FONTE
MAIN FUNCTION() //TELA DE PARÂMETROS PROTHEUS, RESTRITA "SIGAADV"
*/

User Function xEscopoo()
/*
FUNCTION() //INTELIGENCIA PROTHEUS 10 CARACTERES (MATA001CLI()) RESTRITA
USER FUNCTION() //FUNÇÕES DEFINIDAS PELO USUÁRIO U_FUNCTION()
STATIC FUNCTION() //UTILIZADA APENAS NO MESMO CÓDIGO FONTE
MAIN FUNCTION() //TELA DE PARÂMETROS PROTHEUS, RESTRITA "SIGAADV"
*/

	Local cLocal     := "Só pode ser visualizada na funcao que foi criada"
	Static cStatic   := "Pode ser visualizada em qualquer parte do PRW, mas nao alteremos seu valor"
	Private cPrivate := "Pode ser visualizada em outros PRW"
	Public cPublic   := "Pode ser visualizada em qualquer parte"

//VARIAVEL SEM DECLARAÇÃO := PRIVATE

	xEs()
	msginfo (cLocal  , "Local"  )
Return
//-----------------------------------------------------------------------------------------------
Static Function xEs() // Não é aconselhavel ter duas funçoes com o mesmo nome

	Local cLocal     := "Só pode ser visualizada na funcao que foi criada"
	Static cStatic   := "Pode ser visualizada em qualquer parte do PRW, mas nao alteremos seu valor"
	Private cPrivate := "Pode ser visualizada em outros PRW"
	Public cPublic   := "Pode ser visualizada em qualquer parte"

msginfo(cLocal , "Local")
msginfo(cStatic, "Static")
msginfo(cPrivate, "Private")
msginfo(cPublic, "Public")

Return()

//-----------------------------------------------------------------------------------
User Function xEscx()

	//VARIAVEIS LOCAIS
	Local nVar01 := 5
	Local nVar02 := 8
	Local nVar03 := 10
	
	//VARIAVEIS PRIVADAS
	Private cTst := "Teste PVT"
	cTst2 := "Teste PVT2"
	
	//VARIAVEIS PUBLICAS
	Public __cTeste := "Daniel"
	Public __cTeste2 := "Atilio"
	
	//Chamando outra rotina para demonstrar o escopo de variaveis
	fEscopo(nVar01,@nVar02) //@ RECEBE O CONTEUDO DEFINIDO
	
	Alert(nVar02)
	Alert("Public: " + __cTeste2)
	
Return

Static Function fEscopo(nValor1,nValor2,nValor3)

	//VARAIVEIS PUBLICAS
	Local __cTeste2 := "Teste2"

	//VALORES DEFAULT
	Default nValor1 := 0
	Default nValor2 := 0
	Default nValor3 := 0
	
	//ALTERANDO CONTEUDO nValor2
	nValor2 += 10
	
	//MOSTRANDO CONTEUDO DA VARIAVEL PRIVATE
	Alert("Private: " + cTst2)
	
	//SETANDO O VALOR DA VARIAVAEL PUBLICA PARA DEMONSTRAR COMO PDOE SER PERIGOSO
	__cTeste := "Teste1"
	
Return
	