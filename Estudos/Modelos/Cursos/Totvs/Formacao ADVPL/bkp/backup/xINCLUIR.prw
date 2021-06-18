#Include 'Protheus.ch'

User Function xMENU()
IF MSGYESNO("DESEJA EXECUTAR A ROTINA?")
	U_xSQL()
END IF
RETURN()
//------------------------------------------------------------------------------------------------------
User Function xINCLUIR()
RECLOCK("SB1",.T.) //INCLUIR
	SB1->B1_FILIAL 	:= xFILIAL("SB1")//fwFILIAL (POSICIONA NA FILIAL DA TABELA)
	SB1->B1_COD 	:= GETSXENUM("SB1","B1_COD") 
	SB1->B1_DESC 	:= "EXEMPLO INCLUIR"
	SB1->B1_LOCPAD 	:= "01"
	SB1->B1_UM 		:= "XX"
	SB1->B1_MSBLQL	:= "1"
	
MSUNLOCK()//LIBERA O REGISTRO
CONFIRMSX8()//CONFIRMA INCLUSAO NUMERICA (GETSXENUM)
	
Return

//--------------------------------------------------------------------------------------------------------
User Function xSQL()

LOCAL CSQL := " UPDATE SB1990 SET D_E_L_E_T_ = ' ' WHERE B1_FILIAL = '01' AND B1_COD = 'TERCEIROS000001')

IF TCSQLEXEC(CSQL) <0
	MSGSTOP( " TCSQLERROR() " +TCSQLERROR(),"ATENÇÃO!!!!")
END IF
Return
