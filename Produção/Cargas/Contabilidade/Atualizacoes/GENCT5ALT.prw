#include 'protheus.ch'
#include 'parmtype.ch'

user function GENCT5ALT()
	Local cAlias := "CT5"
	Local cTitulo := "Lan�amento Padr�o"
	Local cVldExc := ".T."
	Local cVldAlt := ".T."
	
	AxCadastro(cAlias, cTitulo,cVldExc,cVldAlt)
	
return Nil
