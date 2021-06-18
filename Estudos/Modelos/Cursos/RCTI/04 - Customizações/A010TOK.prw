#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} A010TOK
//TODO Utilizando um ponto de entrada - cadastro de produtos.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function A010TOK()
	Local lExecuta := .T.
	Local cTipo := AllTrim(M->B1_TIPO)
	Local cConta := AllTrim(M->B1_CONTA)
	
		If (cTipo = "PA" .AND. cConta = "001")
		
			Alert("A conta <b> "+ cConta + "</b> não pode estar "+ ;
			"associada a um produto do tipo <b>" + cTipo)
			
			lExecuta := .F.
			
		EndIf
	
	
return(lExecuta)