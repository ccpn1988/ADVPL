#INCLUDE "PROTHEUS.CH"

Static cRotPadr	:= ""

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F376BRW  �Autor  � Renato Calabro'    � Data �  07/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado antes da abertura do Mbrowse da ���
���          � rotina de aglutinacao de impostos                          ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F376BRW()

Local nRot		:= 0

Local aAreas	:= {SE5->(GetArea()), GetArea()}

nRot := aScan(aRotina, {|x| AllTrim(Upper(x[1])) == "AGLUTINAR"})

If nRot > 0
	cRotPadr := aRotina[nRot][2]
	aRotina[nRot][2] := "U_GENA048"
EndIf

aEval(aAreas, {|x| RestArea(x) })

Return Nil