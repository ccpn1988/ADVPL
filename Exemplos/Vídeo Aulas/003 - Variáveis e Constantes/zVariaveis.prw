/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2015/10/19/vd-advpl-003/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zVariaveis
Exemplo de declara��o de vari�veis
@author Atilio
@since 13/10/2015
@version 1.0
	@example
	u_zVariaveis()
/*/

User Function zVariaveis()
	Local aArea := GetArea()
	
	//Declara��o de vari�veis
	Local nValor	:= 0
	Local dData	:= Date()
	Local lTeste	:= .T.
	Local cTexto	:= "Terminal de Informa��o"
	Local oObjeto	:= TFont():New("Tahoma")
	Local xInfo	:= 0
	Local aDados	:= {"Daniel", "Atilio", dData}
	Local bBloco1	:= {||			nValor := 1,;
									Alert("Valor � igual a "+cValToChar(nValor))}
	Local bBloco2	:= {|nValor|	nValor += 2,;
									Alert("Valor � igual a "+cValToChar(nValor))}
	
	//Executando o bloco de c�digo
	EVal(bBloco1)
	EVal(bBloco2, 5)
	
	//Alterando valores
	xInfo := "Teste"
	
	RestArea(aArea)
Return