#include 'protheus.ch'
#include 'parmtype.ch'

user function zMbrow()
	Local cAlias 	:= 'ZZ1'
	Local cTitulo	:= 'Grupo de Despesas'
	Local cVldDel	:= 'U_ADVPL01A'
	Local cVldAlt	:= '.T.'
	
	AxCadastro(cAlias,cTitulo,cVldDel,cVldAlt)
	
return

//--------------------------------------------------------------------------

User Function ADVPL01A()
	Local lRet	:= .T.
	
		IF MsgYesNo('Tem certeza que deseja excluir? ', 'Atenção')
			lRet := .T.
		ELSE
			lRet := .F.
		ENDIF

Return(lRet)