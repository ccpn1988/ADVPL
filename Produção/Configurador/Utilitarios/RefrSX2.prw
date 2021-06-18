#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RefrSX2   � Autor � Danilo Azevedo     � Data �  20/03/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para forcar atualizacao do "cache" do Top Connect.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ao atualizar o banco de dados sem reiniciar o Top Connect. ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RefrSX2()

Prepare Environment Empresa "00" Filial "1022"

dbSelectArea("SX2")
dbSetOrder(1)
dbGoTop()
Do While !EOF()
	TCREFRESH(alltrim(SX2->X2_ARQUIVO))
	dbSkip()
Enddo

Reset Environment

Return()
