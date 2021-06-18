
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410PVNF  �Autor  �Cleuto Lima         � Data �  27/07/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na fun��o Ma410PvNfs para validar acesso   ���
���          �a rotina.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function M410PVNF()

Local lRet			:= .T.
Local cUserAcess	:= ""

If !(upper(alltrim(GetEnvServer())) $ "SCHEDULE")
	
	cUserAcess	:= SuperGetMv("GEN_FAT109",.F.,"")
	cAlAcess 	:= GetNextAlias()
	
	BeginSql Alias cAlAcess
		SELECT count(*) QTD FROM %Table:SC6% SC6
		  JOIN TOTVS.%Table:SF4% SF4
		    ON F4_FILIAL = %xFilial:SF4%
		    AND F4_CODIGO = C6_TES
		    AND SF4.%NotDel%
		    AND SF4.F4_XSEPPED     = '1'   
		WHERE C6_FILIAL = %Exp:SC5->C5_FILIAL%
		AND C6_NUM = %Exp:SC5->C5_NUM%
		AND SC6.%NotDel%
	EndSql
	
	(cAlAcess)->(DbGoTop())
	
	lTesWMS := (cAlAcess)->QTD > 0
    
	(cAlAcess)->(DbCloseArea())

	If lTesWMS
		If !( RetCodUsr() $ cUserAcess )
			MsgStop("Voc� n�o tem permiss�o para utilizar esta funcionalidade para pedidos com separa��o de estoque! Seu c�digo de usu�rio � "+RetCodUsr())
			Return .F.
		EndIf
	EndIf
	
EndIf

Return lRet