#Include 'Protheus.ch'

User Function xPesqCNPJ()

dbSelectArea("SA1")
dbSetOrder(3)
if MsSeek(xFilial("SA1") + '03338610002646')
	MsgInfo(" Cliente Encontrado " + CRLF + CRLF + SA1->A1_NOME)
	/*ALTERANDO A TABELA*/
	RecLock("SA1",.F.) //ALTERAR
	SA1->A1_NOME := ALLTRIM(SA1->A1_NOME) + " Teste "
	MsUnlock() //LIBERA O REGISTRO
else
	MsgInfo(" Cliente não Localizado ")	
EndIf

Return

