#include 'protheus.ch'
#include 'parmtype.ch'

//+--------------------------------------------------------------------+
//| Rotina | zPE | Autor |CAIO NEVES       		      | Data | 14/05/19|
//+--------------------------------------------------------------------+
//| Descr. | Ponto de Entrada.     									   |
//+--------------------------------------------------------------------+
//| Uso    | INCLUSAO DE ITEM SEM SER TIPO PA USANDO TUDOOK			   |
//+--------------------------------------------------------------------+

user function A010TOK()
	Local lExecuta 	:= .T.
	Local cTipo 	:= AllTrim(M->B1_TIPO)
	Local cConta 	:= AllTrim(M->B1_CONTA)
	
	IF(cTipo == 'PA' .AND. cConta == '31101001')
		Alert ("A conta "+ cConta +" não pode estar"+;
				"associada a um produto do tipo"+ cTipo)
				lExecuta := .F.
	ENDIF

return(lExecuta) //Não permite incluir enquanto estiver .F.