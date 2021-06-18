/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENV001   �Autor  �Rafael Lima         � Data �  11/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para validar a digitacao da conta contabil na       ���
���          � empresa corrente. Esse campo esta relacionado ao campo     ���
���          � de movimentacao por empresa. CT1_XEMPXX.                   ���
���          � Essa funcao � chamada na validacao de usuario dos campos:  ���
���          � CT2_DEBITO e CT2_CREDIT.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENV001(cConta)

Local aArea	:= GetArea()
Local lRet	:= .T.

If CT1->(FieldPos("CT1_XEMP"+cEmpAnt))	> 0 //Verifica a exist�ncia do campo para a empresa logada.
	If &("CT1->CT1_XEMP"+cEmpAnt) == 'N'
		lRet := .F.
		Alert('N�o ser�o aceitos movimentos dessa conta na empresa corrente')
	Endif
Endif

RestArea(aArea)

Return lRet
