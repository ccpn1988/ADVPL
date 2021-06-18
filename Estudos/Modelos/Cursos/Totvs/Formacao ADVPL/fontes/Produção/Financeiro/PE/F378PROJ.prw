#INCLUDE "PROTHEUS.CH"

Static cRotPadr	:= ""

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F378PROJ �Autor  � Cleuto Lima        � Data �  20/10/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado antes da abertura do Mbrowse da ���
���          � rotina de aglutinacao de impostos                          ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F378PROJ()

Local nX		:= 0

Local aAreas	:= {SE5->(GetArea()), GetArea()}

//������������������������������������������������������������������������������Ŀ
//� Se variavel private lImpRelat existir (declarada em PE F376BRW) e parametro  �
//� MV_PAR04 estiver marcado para gerar relatorio, atualizo array private aRegs  �
//� (declarada em PE F376BRW) para gerar relatorio customizado.                  �
//��������������������������������������������������������������������������������
If IsInCallStack("U_GENA060")

	lChoImp		:= .F. // variavel que indica se o relatorio deve ser impressoa pela rotina padr�o
	aMyRegs		:= @aRegsImp 
	aMyTits		:= @aTitsImp
//	cMyProcess	:= @cProcess
	lImpRelat	:= .T.   

EndIf

aEval(aAreas, {|x| RestArea(x) })

Return PARAMIXB[1]


