
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA067   �Autor  �Cleuto Lima         � Data �  05/19/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � valida libera��o do or�amento.                             ���
���          � rotina utilizada no ponto de entrada MA416MNU.             ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA067(cAlias,nRecSCJ,xNop)

If SCJ->CJ_STATUS <> "F"
	MsgStop("Apenas or�amentos com situa��o bloqueados podem ser liberados!")
	Return nil
EndIf

If !Empty(SCJ->CJ_VALIDA) .AND. SCJ->CJ_VALIDA < DDataBase
	xMagHelpFis("Data de vencimento","Or�amento n�o pode ser liberado, expirou em "+DtoC(SCJ->CJ_VALIDA),"Verifique a data de vencimento!")
	Return nil
EndIf

If MsgYesNo("Confirma libera��o do or�amento?")
	RecLock("SCJ",.F.)
	SCJ->CJ_STATUS	:= "A"
	SCJ->CJ_XAPROVA	:= cUserName
	MsUnLock()
	MsgInfo("Or�amento liberado com sucesso!")
EndIf

Return nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA067   �Autor  �Microsiga           � Data �  05/19/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function GENA067B(cX3Opx)

Local cRet		:= ""
Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())

Do  Case
	Case cX3Opx == "X3_RELACAO"
		cRet	:= Posicione("SB1",1,xFilial("SB1")+TMP1->CK_PRODUTO,"B1_ISBN")
	Case cX3Opx == "X3_INIBROW"
		cRet	:= Posicione("SB1",1,xFilial("SB1")+TMP1->CK_PRODUTO,"B1_ISBN")
EndCase

RestArea(aAreaSB1)
RestArea(aArea)

Return cRet