#include 'protheus.ch'
#include 'parmtype.ch'

user function ADVPLA01()
	Local cAlias 	:= "ZZ1"
	Local cTitulo 	:= "Grupo de Despesas"
	Local cVldDel	:= '.T.' //PERMITE EXCLUS�O
	Local cVldAlt	:= '.T.' //PERMITE ALTERA��O
	
	AxCadastro(cAlias,cTitulo,cVldDel,cVldAlt)
	
return