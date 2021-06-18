#Include 'Protheus.ch'

User Function xMenu()
	if MsgYesNo("Deseja executar a Rotina?")
	U_xINCLUIR()
	MsgInfo(" Produto " + SB1->B1_DESC + CRLF + ;
	"Cadastro realizado com sucesso "," Cadastrar Produto")
	EndIf		
Return nil



User Function xINCLUIR()

/*RESERVA O REGISTRO*/
/*CAMPO MAIS IMPORTANTE DO SISTEMA È A FILIAL*/
RecLock("SB1",.T.) //INCLUIR

/*ATRIBUINDO OS CAMPOS A TABELA*/
SB1->B1_FILIAL := xFilial("SB1") //FWFilial("SB1")
SB1->B1_COD := getSXeNum("SB1","B1_COD") //GERANDO UM CODIGO AUTOMATICO
SB1->B1_DESC := "Exemplo de Inclusão"
SB1->B1_LOCPAD := "01"
SB1->B1_UM := "XX"
SB1->B1_MSBLQL = '1'

MsUnlock() //LIBERA O REGISTRO
ConfirmSX8()//CONFIRMA O USO DO GetSXeNum ou podemos usar o ROLLBACK

Return

