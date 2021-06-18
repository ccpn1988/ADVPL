#Include 'Protheus.ch'

User Function xSQL()

Local cSQL := "UPDATE SB1990 SET D_E_L_E_T_ = '' WHERE B1_FILIAL = '01' AND B1_COD = 'TERCEIROS000002'"
if TCSQLExec(cSQL) < 0
	MsgStop("TCSQLError()" + TCSQLError(), 'Atenção !!!')
EndIf
Return

