#Include 'Protheus.ch'

User Function xWHILE()

local nCount := 1

Do While nCount <= 10
	MsgInfo("Contador: " + cValToChar(nCount))
	//nCoubnt := nCount +1
	//nCount += 1
	//++nCount incrementa antes de validar
	//nCount++ valida e incrementa
	
End Do

Return(nil)
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function xWHILE1()

local nCount := 1

Do While nCount <= 10
IF nCount == 5
	nCount++
	Loop
END IF
	MsgInfo("Contador: " + cValToChar(nCount))
	//nCoubnt := nCount +1
	//nCount += 1
	//++nCount incrementa antes de validar
	//nCount++ valida e incrementa
	
End Do

Return(nil)
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function xWHILE2()

local nCount := 1
While .T.

	IF MsgYesNo("Deseja sair do While?", "Atenção")
		IF MsgNoYes(" 'Realmente' deseja sair do While?", "Atenção !")
			EXIT
		ENDIF
	ENDIF
ENDDO

RETURN
////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function xWHILE3()

dbSelectArea("SA1")//SELECIONA A TABELA
dbSelectArea("SB1")//SELECIONA A TABELA
SA1->(dbSetOrder(1)) // POSICIONA NO INDICE 1 DA TABELA ESPECIFICADA
SA1->(dbGoTop()) //POSICIONA 1 REGISTRO DA TABELA ESPECIFICADA

//EOF() FIM DA TABELA
//BOF() INICIO DA TABELA

WHILE .NOT. SA1->(EOF())//REFERENCIA %TABLE->(FUNÇÃO())
MSGINFO(" CODIGO : " + SA1->A1_COD + CRLF +" NOME: " + SA1->A1_NOME)//CHR(13)OU CRLF QUEBRA LINHA
SA1->(dbSkip()) //PROXIMO REGISTRO DA TABELA ESPECIFICADA
ENDDO

SA1->(dbclosearea())
SA1->(dbclosearea())

RETURN(NIL)
