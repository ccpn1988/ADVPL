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