#include 'protheus.ch'
#include 'parmtype.ch'


//+--------------------------------------------------------------------+
//| Rotina | zAtualiza | Autor |CAIO NEVES            | Data | 09/05/19|
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso    | Para treinamento e capacitação AXCADASTRO	     		   |
//+--------------------------------------------------------------------+


user function zAtualiza()
	Local cAlias := "SB1"
	Local cTitulo := "CADASTRO AXCADASTRO"
	Local cVldExc := ".T."
	Local cVldAlt := ".T."
	
	AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)
	
return NIL