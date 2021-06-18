#INCLUDE "PROTHEUS.CH"
Static lFWCodFil := FindFunction("FWCodFil")


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA060   �Autor  � Cleuto Lima        � Data �  19/10/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � Nil                                                        ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA060(nPosArotina)

Private cMyProcess	:= ""
Private lImpRelat	:= .F.
Private aMyRegs		:= {}
Private aMyTits		:= {}

INCLUI := .T.

If !Pergunte("AFI378",.T.)
	Return .F.
EndIf

If !Pergunte("FIN378MARK",.T.)
	Return .F.
EndIf	

If MV_PAR01 == 1
	MsgStop("Selecione a op��o selecionar titulos como n�o!")	
	Return .F.
EndIf

If MV_PAR02 == 1
	FinA378(3) // 3 -> Aglutinar
Else
	MsgStop("Caso n�o seja necessaria a impress�o do relat�rio de aglutin��o utilize a rotina padr�o!")	
EndIf	

If lImpRelat

	//������������������������������������������������������������������������������Ŀ
	//� Armazeno numero do processo para referencia de titulos gerados               �
	//��������������������������������������������������������������������������������
	cProcess := SE5->E5_AGLIMP
	//������������������������������������������������������������������������������Ŀ
	//� Restauro parametro que imprime relatorio para 1 - SIM pois usuario solicitou �
	//� imprimir relatorio no pergunte padrao                                        �
	//��������������������������������������������������������������������������������

	//aTits := GetTitGer(SE5->E5_CLIFOR, SE5->E5_LOJA, cProcess)
	U_GENA048R(aMyRegs,aMyTits,cProcess,.F.)

EndIf

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GetTitGer� Autor � Renato Calabro     � Data �  07/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao do relatorio analitico para conferencia. Este    ���
���          � relatorio se baseia no relatorio padrao F376Rel, localiza- ���
���          � do na funcao padrao FINA376 - aglutinacao de impostos      ���
�������������������������������������������������������������������������͹��
���Parametros� oExp1 = Objeto TReport instanciado                      	  ���
���          � aExp2 = Array contendo dados dos titulos baixados       	  ���
���          � aExp3 = Array contendo dados dos titulos gerados        	  ���
���          � cExp4 = Codigo do processo de aglutinacao de impostos   	  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GetTitGer(cFornece, cLoja, cProcess)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

Local aTits		:= {}

cQuery := "SELECT R_E_C_N_O_ RECNOSE2 " + CRLF
cQuery += "  FROM " + RetSqlTab("SE2")
cQuery += " WHERE E2_NUM = '" + cProcess + "' " + CRLF
cQuery += "   AND E2_FORNECE = '" + cFornece + "' " + CRLF
cQuery += "   AND E2_LOJA = '" + cLoja + "' " + CRLF
cQuery += "   AND D_E_L_E_T_ <> '*'" + CRLF

cQuery := ChangeQuery(cQuery)
DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T. )

(cAlias)->( DbGoTop() )

While (cAlias)->(!EOF())
	aAdd(aTits, (cAlias)->RECNOSE2 )
	(cAlias)->( DbSkip() )
EndDo

If Select(cAlias) > 0
	(cAlias)->( DbCloseArea() )
EndIf

Return aTits
