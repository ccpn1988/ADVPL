#include 'protheus.ch'
#include 'parmtype.ch'

user function ADVPLA01()
	Local cAlias 	:= "ZZ1"
	Local cTitulo 	:= "Grupo de Despesas"
	Local cVldDel	:= '.T.' //PERMITE EXCLUSÃO
	Local cVldAlt	:= '.T.' //PERMITE ALTERAÇÃO
	
	AxCadastro(cAlias,cTitulo,cVldDel,cVldAlt)
	
return