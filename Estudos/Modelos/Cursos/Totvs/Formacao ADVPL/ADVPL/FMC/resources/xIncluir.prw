#Include 'Protheus.ch'

User Function xMenu()

	If MsgYesNo("Deseja executar a rotina?")
		//U_xINCLUIR()
		//U_xALTERAR()
		//U_xPesqCli()
		//U_xDelete()
		U_xSQL()
		MsgInfo("Produto: " + SB1->B1_DESC + CRLF + ;
				"Cadastrado com sucesso")
	EndIf

Return

User Function xINCLUIR()
	
	RecLock("SB1",.T.)	//	Incluir
		SB1->B1_FILIAL	:=	xFilial("SB1")	//FwFIlial("SB1")
		SB1->B1_COD		:=	GetSxeNum("SB1","B1_COD")
		SB1->B1_DESC	:=	"Exemplo Incluir"
		SB1->B1_LOCPAD	:=	"01"
		SB1->B1_UM		:=	"XX"
		SB1->B1_MSBLQL	:=	"1"
	MsUnLock()			//	Libera o registro
	
	ConfirmSX8()		//Confirma o número alocado através do último comando GETSXENUM()
	
Return

User Function xALTERAR()

	dbSelectArea("SB1")
	dbSetOrder(1)		// FILIAL + COD
	If MsSeek(xFilial("SB1")+'TERCEIROS000001')
		RecLock("SB1",.F.)	//	Incluir
			//SB1->B1_FILIAL	:=	xFilial("SB1")	//FwFIlial("SB1")
			//SB1->B1_COD		:=	GetSxeNum("SB1","B1_COD")
			SB1->B1_DESC	:=	"Exemplo Alterar"
			//SB1->B1_LOCPAD	:=	"01"
			//SB1->B1_UM		:=	"XX"
			//SB1->B1_MSBLQL	:=	"1"
		MsUnLock()			//	Libera o registro
	EndIf

Return

User Function xPesqCli()

	dbSelectArea("SA1")
	dbSetOrder(3)		// FILIAL + CGC
	If MsSeek(xFilial("SA1")+'03338610002646')
		Reclock("SA1",.F.)
			SA1->A1_NOME := "Exemplo Alterar " + AllTrim(SA1->A1_NOME)
		MsUnLock()
		MsgInfo("Cod.Cli: " + SA1->A1_COD + CRLF + "Nome: " + SA1->A1_NOME + CRLF +;
				"CNPJ: " +cValToChar(SA1->A1_CGC))
	EndIf

Return

User Function xDelete()

	dbSelectArea("SB1")
	dbSetOrder(1)		// FILIAL + CODIGO
	If MsSeek(xFilial("SB1")+'TERCEIROS000001')
		Reclock("SB1",.F.)
			dbDelete()
		MsUnLock()		// Libera o registro
	EndIf

Return

User Function xSQL()
	Local cSQL	:= "UPDATE SB1990 Set D_E_L_E_T_ = '' Where B1_FILIAL = '01' AND B1_COD = 'TERCEIROS000001' "
	
	If TcSqlExec(cSQL) < 0
		MsgStop( "TcSqlError() " + TcSqlError(), 'Atenção!!!' )
	EndIf
Return()