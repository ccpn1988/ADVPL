
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410TIP9  �Autor  �Cleuto Lima         � Data �  03/24/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �ponto de entrada no pedido de venda para validar a condi��o ���
���          �de pagamento tipo 9                                         ���
�������������������������������������������������������������������������͹��
���Uso       � gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function M410TIP9

Local lRet	:= .F.

If ISINCALLSTACK("U_GENA011T") .OR. ISINCALLSTACK("U_GENA011C")
	Return .T.
EndIf

lRet	:= U_GENI018C()

Return lRet