#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA018   �Autor  �Danilo Azevedo      � Data �  16/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para liberar bloqueio por regras.                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Faturamento                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENA018()

Local _aAreaSA1	:= SA1->(GetArea())
Local _aAreaSC5	:= SC5->(GetArea())
Local _aAreaSC6	:= SC6->(GetArea())

dbSelectArea("SC6")
dbSetOrder(1)
dbGoTop()
dbSeek(xFilial("SC6")+SC5->C5_NUM)

lBlq := .F.
Do While SC6->C6_NUM = SC5->C5_NUM
	If !Empty(SC6->C6_BLOQUEI)
		If RecLock("SC6",.F.)
			SC6->C6_BLOQUEI := "  "
			lBlq := .T.
			SC6->(MsUnlock())
		Else
			MsgBox("GENA018 - Falha no reclock da tabela SC6. A libera��o de regra nao est� funcionando. Informe o administrador do sistema.")
		Endif
	Endif
	SC6->(dbSkip())
EndDo                                                                       					

If lBlq
	If RecLock("SC5",.F.)
		SC5->C5_BLQ := " "
		SC5->(MsUnlock())
	Else
		MsgStop("GENA018 - Falha no reclock da tabela SC5. A libera��o de regra nao est� funcionando. Informe o administrador do sistema.")
	Endif
Endif

RestArea(_aAreaSC6)
RestArea(_aAreaSC5)
RestArea(_aAreaSA1)

Return()
