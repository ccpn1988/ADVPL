#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460NUM   �Autor  �Leandro Ribeiro     � Data �  29/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada executado no momento da inclus�o do docu- ���
���          � mento de saida, para utilizar a numera��o do documento de  ���
���          � oriundo da View e n�o a numera��o automatica do Protheus.  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function admin	()

Local _aM460NUM := GetArea()

//Conout("M460NUM - FUNCAO:" +FUNNAME())

If Type("_cNumNF") == "C"
	
	If((FUNNAME() == "GENI021") .OR. (FUNNAME() == "RPC:JOB"))
		Conout("M460NUM - COLOCANDO O NUMERO DA NF DE SAIDA DA VIEW")
		cNumero := _cNumNF
	EndIf
	
EndIf

RestArea(_aM460NUM)

Return() 
