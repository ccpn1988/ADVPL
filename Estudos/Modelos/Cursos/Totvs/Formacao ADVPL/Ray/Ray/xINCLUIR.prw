#Include 'Protheus.ch'

User Function xMenu()
/*	if MsgYesNo("Deseja executar a rotina?")
		U_xINCLUIR()
		MsgInfo("Produto: " + SB1->B1_DESC + CRLF +;
				"Cadastrado com Sucesso")
*/	
	If MsgYesNo("Deseja Alterar?")
		U_xAlterar()
		MsgInfo("Produto: " + SB1->B1_DESC + CRLF +;
				"Alterado com Sucesso")
	elseIf MsgYesNo("Deseja Excluir?")
		U_xDelete()
		MsgInfo("Produto: " + SB1->B1_DESC + CRLF +;
				"Deletado com Sucesso")
	Endif
Return()


User Function xINCLUIR()

RecLock("SB1",.T.) //Incluir
	
		SB1->B1_FILIAL	:= xFilial("SB1") //FwFilial para mesma unidade de negócio
		SB1->B1_COD 	:= GetSxeNum("SB1","B1_COD")
		SB1->B1_DESC 	:= "Exemplo Incluir"
		SB1->B1_LOCPAD	:= "01"
		SB1->B1_UM		:= "XX"
		SB1->B1_MSBLQL	:= '1'
	
	MsUnlock()//Libera o registro  
	ConfirmSX8()

Return

User Function xAlterar()

	dbSelectArea("SB1")
	dbSetOrder(1) //Filial + Codigo
	if MsSeek(xFilial("SB1") + 'TERCEIROS000001')
		RecLock("SB1",.F.) //Alterar
		
	//		SB1->B1_FILIAL	:= xFilial("SB1") //FwFilial para mesma unidade de negócio
	//		SB1->B1_COD 	:= GetSxeNum("SB1","B1_COD")
			SB1->B1_DESC 	:= "Exemplo Alterar"
	//		SB1->B1_LOCPAD	:= "01"
	//		SB1->B1_UM		:= "XX"
	//		SB1->B1_MSBLQL	:= '1'
	
		MsUnlock()//Libera o registro
	Endif

Return

User Function xDelete()

	dbSelecArea("SB1")
	dbSetOrder(1) //FILIAL + CODIGO
	if MsSeek(xFilial("SB1") + "TERCEIROS000001")
		RecLock("SB1",.F.) //Alterar
			dbDelete()
		MsUnlock()
	Endif
	
Return

User Function xSQL()

	Local cSQL := " UPDATE SB1990 Set D_E_L_E_T_ = ' ' where B1_FILIAL = '01' AND B1_COD = 'TERCEIROS000001'  "

	If TCSQLExec(cSQL) < 0
		MsgStop( "TCSQLError() " + TCSQLError(), 'Atenção!!!')
	endif

Return
