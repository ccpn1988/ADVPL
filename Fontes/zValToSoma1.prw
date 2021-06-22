/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/10/24/funcao-converte-valor-numerico-para-soma1-em-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zValToSoma1
Fun��o criada para converter um valor num�rico em valor caracter do Soma1
@author Atilio
@since 16/06/2017
@version 1.0
@type function
	@param nValor, numeric, N�mero que deseja converter
	@param nQtdPos, numeric, Quantidade de casas a considerar
	@return cValor, Valor j� convertido
	@example u_zValToSoma1(100, 2) --> Retorna "A0"
	u_zValToSoma1(500, 2) --> Retorna "L4"
	u_zValToSoma1(500, 3) --> Retorna "500"
/*/

User Function zValToSoma1(nValor, nQtdPos)
	Local aArea  := GetArea()
	Local cValor := StrTran(Space(nQtdPos), ' ', '0')
	Local nAtual := 0
	
	//Percorrendo o valor
	For nAtual := 1 To nValor
		cValor := Soma1(cValor)
	Next
	
	RestArea(aArea)
Return cValor