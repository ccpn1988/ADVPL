
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT210COR  �Autor  �Cleuto Lima         � Data �  08/04/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada da rotina FATA210 utilizado para manipular���
���          � o array de cores dos registros do Browse.                  ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

User Function FT210COR()

Local aCoresNew	:= aClone(ParamIXB)

Aadd(aCoresNew, { "C5_BLQ == '3'",'br_pink'})	//Pedido de Vendas com Bloqueio por regra de consigna��o
Aadd(aCoresNew, { "C5_BLQ == '4'",'BR_PRETO'})	//Pedido de Vendas com Bloqueio por regra de black list
	
Return aCoresNew