#Include 'Protheus.ch'

User Function xTabWhile()

/*Seleciona Tabela*/
dbSelectArea("SA1")
dbSelectArea("SB1")
/*Seleciona INDICE*/
 SA1 -> (dbSetOrder(1))
/*POSICIONA NO TOPO DA TABELA*/
 SA1 -> (dbGotop())

//EOF() - FIM DA TABELA
//BOF() - INICIO DA TABELA

/*ENQUANTO NÂO ENCONTRA O FIM DA TABELA*/
while .Not. SA1 -> (EOF())
	Msginfo("Codigo: " + SA1->A1_COD + CHR(13) + " Nome: " + SA1->A1_NOME)
	/*VÀ PARA O PROXIMO RESGISTRO*/
	SA1 -> (dbSkip())
EndDo

 SA1 -> (dbclosearea())
 SB1 -> (dbclosearea())
 
Return (NIL)

