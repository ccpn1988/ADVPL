#include 'protheus.ch'
#include 'parmtype.ch'

/*Executa um conjunto de comandos baseado no valor de uma express�o l�gica.

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

LExpressao := Especifica uma express�o l�gica que � avaliada. Se lExpressao
resultar em verdadeiro (.T.), qualquer comando seguinte ao IF e
antecedente ao ELSE ou ENDIF (o que ocorrer primeiro) ser�
executado.
Se lExpressao resultar em falso (.F.) e a cl�usula ELSE for definida,
qualquer comando ap�s essa cl�usula e anterior ao ENDIF ser�
executada. Se a cl�usula ELSE n�o for definida, todos os comandos
entre o IF e o ENDIF s�o ignorados. Neste caso, a execu��o

Comandos:= Conjunto de comandos ADVPL que ser�o executados dependendo da
avalia��o da express�o l�gica em lExpressao.

Pode-se aninhar um bloco de comando IF...ELSE...ENDIF dentro de
outro bloco de comando IF...ELSE...ENDIF. Por�m, para a avalia��o de
mais de uma express�o l�gica, deve-se utilizar o comando DO
CASE...ENDCASE ou a vers�o estendida da express�o
IF...ELSE...ENDIF denominada IF...ELSEIF...ELSE...ENDIF.*/

User Function zZIF()
Local nNum := 22
Local nNum2 := 100
	
	IF nNum <= nNum2
		MsgInfo("A vari�vel nNum1 � menor ou igual nNum2")
	Else 
		Alert("A vari�vel nNum1 n�o � igual ou menor nNum2")
	EndIF
	
Return

User Function zZIIF()
Local nNum := 22
Local nNum2 := 100
	
	IF nNum = nNum2
		MsgInfo("A vari�vel nNum1 � menor ou igual nNum2")
	
	ElseIF nNum > nNum2
		MsgAlert("A vari�vel nNum1 � maior do que nNum2")
		
	ElseIF nNum <> nNum2
		Alert("A vari�vel nNum1 � diferente de nNum2")
			
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