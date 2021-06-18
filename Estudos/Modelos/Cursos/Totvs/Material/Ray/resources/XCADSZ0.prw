// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : XCADSZ0
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 30/03/19 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a manutenção de dados armazenados em SZ0.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     30/03/2019
/*/
//------------------------------------------------------------------------------------------
user function XCADSZ0()
	//--< variáveis >---------------------------------------------------------------------------
	
	//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	local cVldAlt := ".T." // Operacao: ALTERACAO
	local cVldExc := ".T." // Operacao: EXCLUSAO
	
	//trabalho/apoio
	local cAlias
	
	//--< procedimentos >-----------------------------------------------------------------------
	cAlias := "SZ0"
	chkFile(cAlias)
	dbSelectArea(cAlias)
	//indices
	dbSetOrder(1)
	axCadastro(cAlias, "Cadastro de sucata", cVldExc, cVldAlt)
	
return
//--< fim de arquivo >----------------------------------------------------------------------
