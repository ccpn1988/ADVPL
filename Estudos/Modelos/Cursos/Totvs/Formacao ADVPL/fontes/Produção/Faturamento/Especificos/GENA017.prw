#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA017   �Autor  �Danilo Azevedo      � Data �  25/03/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para validar regra de desconto                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Faturamento/Pedido de Venda                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENA017()

Local _aAreaSA1	:= SA1->(GetArea())
Local _aAreaSC5	:= SC5->(GetArea())
Local _aAreaSC6	:= SC6->(GetArea())

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+SC5->C5_NUM)

lBlq := .F.
Do While SC6->C6_NUM = SC5->C5_NUM
	cClasse := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_GRUPO")
	nPercD := POSICIONE("SZ2",1,XFILIAL("SZ2")+SA1->A1_XTPDES+cClasse,"Z2_PERCDES")
	
	If SC6->C6_DESCONT <> nPercD
		If RecLock("SC6",.F.)
			SC6->C6_BLOQUEI := "01"
			lBlq := .T.
			SC6->(MsUnlock())
		Else
			MsgBox("GENA017 - Falha no reclock da tabela SC6. Atencao o blqueio de regra nao est� funcionando. Informe o administrador do sistema.")
		Endif
	Else
		If RecLock("SC6",.F.)
			SC6->C6_BLOQUEI := ""
			SC6->(MsUnlock())
		Else
			MsgBox("GENA017 - Falha no reclock da tabela SC6. Atencao o blqueio de regra nao est� funcionando. Informe o administrador do sistema.")
		Endif
	Endif
	SC6->(dbSkip())
EndDo

If lBlq
	If RecLock("SC5",.F.)
		SC5->C5_BLQ := "1"
		SC5->(MsUnlock())
	Else
		MsgStop("GENA017 - Falha no reclock da tabela SC5. Atencao o blqueio de regra nao est� funcionando. Informe o administrador do sistema.")
	Endif
Endif

RestArea(_aAreaSC6)
RestArea(_aAreaSC5)
RestArea(_aAreaSA1)

Return()
