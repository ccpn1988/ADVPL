#Include 'Protheus.ch'

User Function xMENUx()
IF MSGYESNO("DESEJA EXECUTAR A ROTINA?")
	U_xALTERAR()
	MSGINFO("PRODUTO " + SB1->B1_DESC + CRLF +;
			"CADASTRADO COM SUCESSO")
END IF
RETURN()
//------------------------------------------------------------------------------------------------------
User Function xALTERA()

dbSelectArea("SB1")//SELECIONA A AREA
dbSetOrder(1)//POSICIONA NO INDICE
IF MSSEEK(xFILIAL("SB1") + 'TERCEIROS000001')
	RECLOCK("SB1",.F.) //ALTERAR
	//SB1->B1_FILIAL 	:= xFILIAL("SB1")//fwFILIAL (POSICIONA NA FILIAL DA TABELA)
	//SB1->B1_COD 	:= GETSXENUM("SB1","B1_COD") 
	SB1->B1_DESC 	:= "EXEMPLO ALTERAR"
	//SB1->B1_LOCPAD 	:= "01"
	//SB1->B1_UM 		:= "XX"
	//SB1->B1_MSBLQL	:= "1"
	
MSUNLOCK()//LIBERA O REGISTRO
//CONFIRMSX8()//CONFIRMA INCLUSAO NUMERICA (GETSXENUM)
END IF	
Return
