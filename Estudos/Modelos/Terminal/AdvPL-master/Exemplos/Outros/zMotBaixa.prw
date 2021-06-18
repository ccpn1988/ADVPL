//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zMotBaixa
Fun��o que exemplifica como acessar os motivos de baixa financeiro
@type function
@author Atilio
@since 07/05/2016
@version 1.0
/*/

User Function zMotBaixa()
	Local aArea     := GetArea()
	Local aMotBx    := {}
	Local aBaixaAtu := {}
	
	//Pegando os motivos de baixa
	aMotBx := ReadMotBx()
	
	//Quebrando a primeira posi��o do Motivo de Baixas
	//  Abaixo as posi��es do motivo de baixas
	//  [1] -> Sigla
	//  [2] -> Descri��o
	//  [3] -> Movimenta��o Banc�ria
	//  [4] -> Comiss�o
	//  [5] -> Carteira
	//  [6] -> Cheque
	aBaixaAtu := StrTokArr(aMotBx[1], '�')
	
	RestArea(aArea)
Return