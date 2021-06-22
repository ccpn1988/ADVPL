/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2015/12/08/vd-advpl-013/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zDebug
Fun��o de teste para Debug / Depurar programas via TDS
@type function
@author Atilio
@since 06/12/2015
@version 1.0
	@example
	u_zDebug()
/*/

User Function zDebug()
	Local aArea := GetArea()
	Local aProds := {}
	Local nSequen := 0
	
	//Selecionando a tabela de produtos e posicionando no topo
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1)) //Filial + C�digo
	SB1->(DbGoTop())
	//TODO fazer rotina X
	//Enquanto n�o for fim do arquivo
	While ! SB1->(EoF())
		aAdd(aProds,{	SB1->B1_COD,;
						SB1->B1_DESC,;
						SB1->B1_TIPO})
	
		nSequen++
		SB1->(DbSkip())
	EndDo
	
	Alert(nSequen)
	RestArea(aArea)
Return