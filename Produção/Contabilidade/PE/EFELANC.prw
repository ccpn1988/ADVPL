/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EFELANC   �Autor  �Rafael Lima         � Data �  05/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para nao permitir a efetivacao de          ���
���          �lancamentos que foram incluidos manualmente e ainda nao     ���
���          �foram aprovados.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function EFELANC

Local aArea			:= GetArea()
Public lAtSldBase	:= (GetMv("MV_ATUSAL") == "S")

If CT2->CT2_XAPROV <> 'S' .And. Alltrim(CT2->CT2_ROTINA) == 'CTBA102'//N�o est� aprovado e foi criado pela rotina CTBA102

	//Volta para tipo de saldo 9
	Reclock("CT2",.F.)
	CT2->CT2_TPSALD := '9'
	CT2->(MsUnlock())           
	
	//Coloca variavel lAtSldBase como .F. para n�o seguir processo de efetiva��o
	lAtSldBase := .F.
	
Endif

RestArea(aArea)
Return
