
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA416PV  �Autor  �Cleuto Lima         � Data �  05/19/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �ponto de entrada na efetiva��o do or�amento para complemento���
���          �de informa��o antes de apresentar a tela com o pedido venda ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA416PV()
Local aAreaSF4	:= SF4->(GetArea())

cRet	:= Posicione("SF4",1,xFilial("SF4")+SCK->CK_TES,"F4_XTESPAI")
cRet	:= Posicione("SF4",1,xFilial("SF4")+cRet,"F4_XNATURE")

RestArea(aAreaSF4)

//�������������������������������������������������Ŀ
//�incluir a natureza do pedido com base na TES     �
//���������������������������������������������������

M->C5_NATUREZ	:= cRet

//�������������������������������������������������Ŀ
//�incluior numero do or�amento no pedido de vendas.�
//���������������������������������������������������
M->C5_XNUMORC	:= SCJ->CJ_NUM

RecLock("SCJ",.F.)
SCJ->CJ_XEFETIV	:= cUserName
MsUnLock()

Return nil
