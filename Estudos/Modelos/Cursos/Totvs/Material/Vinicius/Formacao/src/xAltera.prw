#Include 'Protheus.ch'

User Function XMENUALTER()
	if MsgYesNo("Deseja executar a Rotina?")
	U_xALTERAR()
	MsgInfo(" Produto " + SB1->B1_DESC + CRLF + ;
	"Alteração realizada com sucesso "," Cadastrar Produto")
	EndIf		
Return nil

User Function xALTERAR()

/*PARA A ALTERAÇÂO DEVEMOS POSICIONAR NO CAMPO ATRAVES DO DBSEEK OU MSSEEK*/
dbSelectArea("SB1")
dbsetorder(1)
if MsSeek(xFilial("SB1") + 'TERCEIROS000002')
	RecLock("SB1",.F.) //ALTERAR
	SB1->B1_DESC := "Exemplo de Alteração"
	//SB1->B1_LOCPAD := "01"
	SB1->B1_UM := "XZ"
	//SB1->B1_MSBLQL = '1'
	MsUnlock() //LIBERA O REGISTRO
EndIF
Return

