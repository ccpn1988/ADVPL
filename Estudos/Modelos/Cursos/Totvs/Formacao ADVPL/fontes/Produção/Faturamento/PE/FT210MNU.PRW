#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT210MNU  �Autor  � Joni Fujiyama      � Data �  21/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa contendo o ponto de entrada no menu de Bloqueio por���
���          �Regra (Valor m�nimo - MV_XVALMIN)                           ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FT210MNU()

Local nPosBut := AScan(aRotina,{ |x| Alltrim(x[2]) == "BlqRegBrw"})

//	aRotina[aScan(aRotina,{|x| upper(x[2]) = 'CN150APROV'}),2]:='u_MMXCN150'

If nPosBut > 0                                                     	
	
	aRotina[nPosBut][2] := "U_GENA007"
	//aadd(aRotina,{"Libera pedido",'U_GENA018', 0, 4, 0, NIL})
	
ENDIF

Return
