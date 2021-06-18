#include 'protheus.ch'
#include 'parmtype.ch'

/*Executa um conjunto de comandos baseado no valor de uma expressão lógica.

SINTAXE
IF lExpressao
Comandos
[ELSE
Comandos...]
ENDIF

IF lExpressao1
Comandos
[ELSEIF lExpressaoX
Comandos]
[ELSE
Comandos...]
ENDIF

LExpressao := Especifica uma expressão lógica que é avaliada. Se lExpressao
resultar em verdadeiro (.T.), qualquer comando seguinte ao IF e
antecedente ao ELSE ou ENDIF (o que ocorrer primeiro) será
executado.
Se lExpressao resultar em falso (.F.) e a cláusula ELSE for definida,
qualquer comando após essa cláusula e anterior ao ENDIF será
executada. Se a cláusula ELSE não for definida, todos os comandos
entre o IF e o ENDIF são ignorados. Neste caso, a execução

Comandos:= Conjunto de comandos ADVPL que serão executados dependendo da
avaliação da expressão lógica em lExpressao.

Pode-se aninhar um bloco de comando IF...ELSE...ENDIF dentro de
outro bloco de comando IF...ELSE...ENDIF. Porém, para a avaliação de
mais de uma expressão lógica, deve-se utilizar o comando DO
CASE...ENDCASE ou a versão estendida da expressão
IF...ELSE...ENDIF denominada IF...ELSEIF...ELSE...ENDIF.*/

User Function zZIF()
Local nNum := 22
Local nNum2 := 100
	
	IF nNum <= nNum2
		MsgInfo("A variável nNum1 é menor ou igual nNum2")
	Else 
		Alert("A variável nNum1 não é igual ou menor nNum2")
	EndIF
	
Return

User Function zZIIF()
Local nNum := 22
Local nNum2 := 100
	
	IF nNum = nNum2
		MsgInfo("A variável nNum1 é menor ou igual nNum2")
	
	ElseIF nNum > nNum2
		MsgAlert("A variável nNum1 é maior do que nNum2")
		
	ElseIF nNum <> nNum2
		Alert("A variável nNum1 é diferente de nNum2")
			
	EndIF
	
Return


User Function zIIF()
Local x:= 10
Local Y:= 20

If X > Y
Alert("X")
Z := 1
Else
Alert("Y")
Z := -1
Endif

//IIF(x>y,(Alert("x"),z:=1),(Alert("y"),z:=-1))

Return



user function zIF()
Local dVencto := CTOD("31/12/01")
	If Date() > dVencto
		Alert("Vencimento ultrapassado!")
	Endif
Return


USER FUNCTION zELSEIF()
	Local dVencto := CTOD("31/12/01")

	If Date() > dVencto
		Alert("Vencimento ultrapassado!")
	ElseIf Date() == dVencto
		Alert("Vencimento na data!")
	Else
		Alert("Vencimento dentro do prazo!")
Endif
Return