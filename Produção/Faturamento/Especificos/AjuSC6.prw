#INCLUDE "rwmake.ch"
#INCLUDE "fivewin.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  17/04/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AjuSC6()

PREPARE ENVIRONMENT EMPRESA "00" FILIAL "1022" MODULO "EST" TABLES "SD3","SB1"

cIt := "99"
dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+"015904"+cIt)
nRec := Recno()
dbSetOrder(0)
Do While SC6->C6_NUM = "015904"

	Reclock("SC6",.F.)
	SC6->C6_ITEM := cIt
	MsUnlock()

	cIt := soma1(cIt)
	SC6->(dbSkip())
	
Enddo

RESET ENVIRONMENT

Return()
