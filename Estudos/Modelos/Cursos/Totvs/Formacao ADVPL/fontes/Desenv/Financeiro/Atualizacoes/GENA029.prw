#include 'rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA029   �Autor  �Romadier Mendonca   � Data �  26/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro Boletos Confirmados E-commerce                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro Gen                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA029()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cVldAlt 		:= ".F." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc 		:= ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString		:= "SZU"

dbSelectArea("SZU")
dbSetOrder(1)

AxCadastro(cString,"Cadastro Boletos Confirmados E-commerce ",cVldAlt,cVldExc)

Return()
