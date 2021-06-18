#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MODELO1
//TODO PROGRAMA DE ATUALIZAÇÃO
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function MODELO1()
	Local cAlias := "SB1"
	Local cTitulo := "Cadastro - AXCadastro"
	Local cVldExc := ".T."
	Local cVldAlt := ".T."
	
	AxCadastro(cAlias, cTitulo,cVldExc,cVldAlt)
	
return Nil