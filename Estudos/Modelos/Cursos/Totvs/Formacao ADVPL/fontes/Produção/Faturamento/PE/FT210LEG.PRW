
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT210LEG  �Autor  �Cleuto Lima         � Data �  08/04/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada da rotina FATA210 utilizado para manipular���
���          � o array de cores da legranda                               ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FT210LEG()

Local aCoresNew	:= aClone(ParamIXB)

Aadd(aCoresNew, { 'br_pink'		,  "Pedido bloqueado por regra de consigna��o" })	//Pedido de Vendas com Bloqueio por regra de consigna��o
Aadd(aCoresNew, { 'BR_PRETO' 	,  "Pedido bloqueado por regra de black list" })	//Pedido de Vendas com Bloqueio por regra de consigna��o

	
Return aCoresNew