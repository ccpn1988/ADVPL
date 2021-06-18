#Include 'Protheus.ch'

User Function xUpdate()

Local: xUpdate:= " UPDATE SB1990 SET D_E_L_E_T_ = '' WHERE B1_FILIAL = '01' AND B1_COD = 'TERCEIROS000001' "

If TCSQLEXEC (xUpdate) < 0
   MsgStop ("TCSQLError()" + TCSQLError(), 'Atenção!!!' )
Endif

Return()

