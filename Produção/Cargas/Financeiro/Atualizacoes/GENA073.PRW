#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA073   �Autor  � Cleuto Lima        � Data �  28/05/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o saldo do titulo para o CANB contas a recebre j�  ���
���          � com valor tratato no formato aceito pelo CNAB.             ���
�������������������������������������������������������������������������͹��
���Retorno   � Nil                                                        ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA073()

Local cBc		:= ParamIXB[1]
Local cValLiq	:= ""
Local nSaldo	:= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,dDatabase,,SE1->E1_LOJA )
Local nValLiq	:= nSaldo-SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA)

If cBc == "I"
	cValLiq := STRZERO((ROUND( nValLiq ,2)*100),13)
ElseIf cBc == "S"
	cValLiq := STRZERO((nValLiq*100),15)
EndIf	

Return cValLiq
