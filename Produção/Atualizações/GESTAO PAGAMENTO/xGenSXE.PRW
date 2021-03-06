/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xGenSXE   �Autor  �Cleuto e Arthur Lima� Data �  30/11/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o generica responsavel por criar numeros sequenciais   ���
���          �com base na getsx8num e validar se a numera��o � valida     ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Projeto Gest�o de Obras                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xGenSXE(cAliasSXE,cFieldSXE,nIndexSXE)

Local aArea		:= GetArea()
Local aAreaSXe	:= (cAliasSXE)->(GetArea())
Local cRet		:= ""
Local nQtdAux	:= 0

cRet := GetSX8Num(cAliasSXE,cFieldSXE,NIL,nIndexSXE)
(cAliasSXE)->(DbSetOrder(nIndexSXE))
While (cAliasSXE)->(DbSeek( xFilial(cAliasSXE) + cRet )) 
	ConfirmSX8()
	cRet := GetSX8Num(cAliasSXE,cFieldSXE,NIL,nIndexSXE)
	(cAliasSXE)->(DbSkip())
	nQtdAux++
	IF Mod(nQtdAux,100) == 0
		U_GenSendMail(,,,"noreply@grupogen.com.br","desenvolvimento@grupogen.com.br",oemtoansi("xGenSXE - controle de numera��o em loop"),"Poss�vel loop na rotina "+FunName()+chr(13)+chr(10)+;
		"Alias "+cAliasSXE+", campo "+cFieldSXE,,,.F.)			
	ENDIF
EndDo

RestArea(aAreaSXe)
RestArea(aArea)

Return cRet
