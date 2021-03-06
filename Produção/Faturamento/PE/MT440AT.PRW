

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT440AT   �Autor  �Cleuto Lima         � Data �  08/07/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o pedido de venda pode ser liberado - PE       ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT440AT()

Local lRet  := .F.

IF Upper(Alltrim(GetEnvServer())) == "SCHEDULE"
    Return .T.
ENDIF

IF Select("TMP_PED") > 0
    TMP_PED->(DbCloseArea())
ENDIF

BeginSql Alias "TMP_PED"
    SELECT Count(*) QTD FROM %Table:SC9% SC9
        WHERE C9_FILIAL =  %Exp:SC5->C5_FILIAL%
        AND C9_PEDIDO =  %Exp:SC5->C5_NUM%
        AND SC9.%NotDel%
EndSql
IF TMP_PED->QTD > 0
    MsgStop("Pedido j� liberado, n�o ser� permitida manuten��o!")
ELSE   
    lRet := .T. 
ENDIF

TMP_PED->(DbCloseArea())

Return lRet