#include "fivewin.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F200TIT   �Autor  �Romadier Mendonca   � Data �  26/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para alimentar a tabela SZU (Controle de boletos)    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Financeiro                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F200TIT()

Local lReturn		:= .T.
Local aArea			:= GetArea()

DbSelectArea("SZU")
DbSetOrder(1)
SZU->(dbSeek(xFilial("SZU")+cNumTit))

If !SZU->( found() )
	Reclock("SZU",.T.)
	SZU->ZU_NUMERO := cNumTit
	SZU->ZU_DATABAI := dBaixa
	SZU->ZU_NOSSONU := cNsNum
	SZU->ZU_VALORRE := nValRec
	MsUnlock()
EndIf

RestArea(aArea)

Return(lReturn)
