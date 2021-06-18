#INCLUDE "PROTHEUS.CH"

Static cRotPadr	:= ""

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F376PROJ �Autor  � Renato Calabro'    � Data �  07/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado antes da abertura do Mbrowse da ���
���          � rotina de aglutinacao de impostos                          ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F376PROJ()

Local nX		:= 0

Local aTitulos	:= PARAMIXB[1]
Local aAreas	:= {SE5->(GetArea()), GetArea()}

//������������������������������������������������������������������������������Ŀ
//� Se variavel private lImpRelat existir (declarada em PE F376BRW) e parametro  �
//� MV_PAR04 estiver marcado para gerar relatorio, atualizo array private aRegs  �
//� (declarada em PE F376BRW) para gerar relatorio customizado.                  �
//��������������������������������������������������������������������������������
If MV_PAR04 == 1 .AND. Type("lImpRelat") == "L"		//MV_PAR04 - imprime relatorio = 1-SIM
	For nX := 1 To Len(aTitulos)
		aAdd(aMyRegs, {aTitulos[nX][1], aTitulos[nX][2] })
	Next nX
	//������������������������������������������������������������������������������Ŀ
	//� Atualizo variavel para imprimir relatorio customizado, e desmarco para nao   �
	//� gerar relatorio padrao F376REL atraves do parametro MV_PAR04 = 2 - NAO       �
	//��������������������������������������������������������������������������������
	lImpRelat := .T.
	MV_PAR04 := 2
EndIf

aEval(aAreas, {|x| RestArea(x) })

Return PARAMIXB
