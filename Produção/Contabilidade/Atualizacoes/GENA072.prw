#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GENA072  �Autor  � Helimar Tavares    � Data �  09/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de rotina da tabela ZZA - De x Para: centro de    ���
���          � lucro maker e centro de custo Protheus                     ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA072()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cVldAlt 		:= ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc 		:= ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString		:= "ZZA"

dbSelectArea("ZZA")
dbSetOrder(1)

AxCadastro(cString, "De x Para: Centro de Lucro x Centro de Custo", cVldAlt, cVldExc)

Return()
