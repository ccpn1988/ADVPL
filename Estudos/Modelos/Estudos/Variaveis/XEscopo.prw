#Include 'Protheus.ch'

/* ORDEM DAS VARIAVEIS
local
static
private
public*/


User Function Escopo()
	local clocal := "Só pode ser vista na função que foi criada"
	private cprivate := "Pode ser vista em outro PRW"
	static cstatic := "Só pode ser vista no .PRW, mas não pode alterar seu valor"
	public cpublic := "Pode ser vista em qualquer parte da Thread"
	
	Msginfo(clocal,"Variavel Local")
	Msginfo(cstatic,"Variavel Static")
	Msginfo(cprivate,"Variavel Private")
	Msginfo(cpublic,"Variavel Public")

Return
//-------------------------------------------------------------------------------
Static cStat := ' ' //CRIADO FORA DA FUNÇÂO E USADA EM QQ LUGAR DO CODIGO

User Function ESCOPO1()
	//VARIAVEIS LOCAIS
	Local nVar := 0
	Local nVar1 := 20
	
	//VARIAVEIS PRIVATE
	Private cPri := "Private"
	
	//VARIAVEIS PUBLIC
	Public __cPublic := "RCTI"
	
	TestEscop(@nVar,@nVar1)//@ := REFERENCIA
	
Return
//FUNÇÂO STATIC---------------------------------------------------------------=--

Static Function TestEscop(nValor1, nValor2)

	Local __cPublic := "Alterei" //ALTERADA PARA VARIAVE LOCAL E CONTEUDO
	Default nValor1 := 0 
	
	//Alterando conteudo da Variavel
	nValor2 += 10 //SOMA O VALOR DE @nVAR1
	
	//Alterando variavel Private
	Alert("Private: " + cPri)
	
	//Alterar valor da variavel Public
	Alert("Public: " + __cPublic)
	
	MsgAlert(nValor2)
	Alert("Variavel Static: "+ cStat)

Return
	
	
