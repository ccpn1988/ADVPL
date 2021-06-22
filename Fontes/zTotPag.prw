/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2019/09/19/funcao-que-retorna-o-total-de-paginas-em-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zTotPag
Retorna o n�mero total de p�ginas para imprimir em um relat�rio
@author Atilio
@since 02/06/2019
@param nRegistros, numeric, Quantidade total de registros que ser�o impressos, por exemplo, 520
@param nPorPag, numeric, Quantidade de registros / linhas que cabem em uma p�gina, por exemplo, 30
@version 1.0
@example
	...
	Local nLinhas := 30

	...
	DbSelectArea('SEU_ALIAS')
	SEU_ALIAS->(DbGoTop())
	Count To nTotRegis

	...
	nPagFim := u_zTotPag(nTotRegis, nLinhas)

	...
	oPrint:Say(nLinRod+20, 3100, 'P�gina ' + cValToChar(nPag) + ' de ' + cValToChar(nPagFim), oFontRod,,,,PAD_RIGHT)
/*/

User Function zTotPag(nRegistros, nPorPag)
	Local aArea        := GetArea()
	Local nTotPag      := 0
	Default nRegistros := 0
	Default nPorPag    := 0
	
	//Se tiver mais registros do que cabe por p�gina
	If nRegistros > nPorPag
		
		//O total de p�ginas, ser� a parte inteira da divis�o de quantidade de registros pelo n�mero de linhas que cabe numa p�gina
		nTotPag := Int(nRegistros / nPorPag)
		
		//Se houver resto na divis�o, ent�o sobrou 1 p�gina
		If nRegistros % nPorPag != 0
			nTotPag++
		EndIf
	
	//Sen�o ser� apenas 1 p�gina
	Else
		nTotPag  := 1
	EndIf
	
	RestArea(aArea)
Return nTotPag