
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT080RDES �Autor  �Cleuto Lima         � Data �  05/19/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Substitu��o da rotina de regra de desconto padr�o          ���
���          � O ponto de entrada FT080RDES substitui a rotina de regra   ���
���          � de desconto padr�o (MaRgrDesc).                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function FT080RDES()

Local nDesconto	:= 0

//�����������������������������������������������������������Ŀ
//�Cleuto Lima:                                               �
//�a fun��o de desconto padr�o est� calculando errado         �
//�o desconto quando � utilizada a fun��o caixa de texto, como�
//�o desconto por empresa n�o � necess�rio no or�amento       �
//�o mesmo ser� removido.                                     �
//�������������������������������������������������������������
If IsInCallStack("MATA415")
	nDesconto	:= TMP1->CK_DESCONT
EndIf	

Return nDesconto