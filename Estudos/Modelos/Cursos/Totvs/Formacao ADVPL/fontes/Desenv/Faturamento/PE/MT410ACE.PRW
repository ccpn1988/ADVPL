#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO8     �Autor  �Microsiga           � Data �  05/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MT410ACE()

Local lRet		:= .T.
Local cAliAux	:= ""

If lRet .AND. ALTERA     
	If ISINCALLSTACK("U_JFILA02B") .OR. "PRODUCAO" <> upper(alltrim(GetEnvServer()))
		lRet	:= .T.
	Else
		If "RPC" $ FunName()
			lRet := U_xStsRoma(SC5->C5_FILIAL,SC5->C5_NUM,nil,nil,.t.)
		Else
			MsAguarde({|| lRet := U_xStsRoma(SC5->C5_FILIAL,SC5->C5_NUM,nil,nil,.t.) },"Processamento","Aguarde! Consultando Romaneio...")	
		EndIF	
		
		If lRet
			
			cAliAux := GetNextAlias()
			
			BeginSql Alias cAliAux
				SELECT count(*) QTD FROM %Table:SC6% SC6
				  JOIN %Table:SF4% SF4
				    ON F4_FILIAL = %xFilial:SF4%
				    AND F4_CODIGO = C6_TES
				    AND SF4.%NotDel%
				    AND SF4.F4_XSEPPED = '1'
			      JOIN %Table:SC9% SC9
			      ON C9_FILIAL = C6_FILIAL
			      AND C9_PEDIDO = C6_NUM
			      AND SC9.%NotDel%
					WHERE C6_FILIAL = %Exp:SC5->C5_FILIAL%
					AND C6_NUM = %Exp:SC5->C5_NUM%
					AND SC6.%NotDel%
			EndSql
			
			(cAliAux)->(DbgoTop())
			If (cAliAux)->(!EOF()) .AND. (cAliAux)->QTD > 0
				If !("RPC" $ FunName())
					MsgStop("Pedido liberado, por favor, estorne a libera��o antes da altera��o!")
				EndIf
				lRet := .F.
			EndIf
			(cAliAux)->(DbCloseArea())
		EndIf
		
	EndIf
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xStsRoma  �Autor  �Cleuto Lima         � Data �  05/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Consulta Status do Romaneio no WMS Pix.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function xStsRoma(cFilPedido,cPedido,cIdPedido,cRoma,lUpdSC5)

//�����������������������������������������������������������������������Ŀ
//�variaveis da rotina.                                                   �
//�������������������������������������������������������������������������
Local oWmsPix 	:= nil
Local oRetWms	:= nil
Local cQuebra	:= Chr(13)+Chr(10)
Local lRet		:= .T.
Local cIdFil	:= ""  

Local cError	:= ""
Local cWarning	:= ""

Default cPedido		:= ""
Default cFilPedido	:= ""
Default cIdPedido	:= ""
Default lUpdSC5		:= .F.

If Empty(cPedido) .AND.  ( Empty(cIdPedido) .OR. Empty(cFilPedido) )
	MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Nenhum numero de pedido foi informado!")
	lRet	:= .F.
	Return .F.
EndIf

If Empty(cIdPedido) 	
	U_GetFilGen(@cIdFil,cFilPedido)	
	If Empty(cIdFil)
		MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Nenhum numero de pedido foi informado!")
		lRet	:= .F.
		Return .F.	
	EndIf
	cIdPedido	:= cIdFil+cPedido
EndIf

oWmsPix := WSWSRomaneiosService():NEW()

If ValType(oWmsPix) <> "O"
	MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Tente novamente em alguns instantes, caso o problema continue entre em contato com departamento de TI.")
	lRet	:= .F.
	Return .F.	
EndIf

oWmsPix:CIDPEDIDO	:= cIdPedido

If !oWmsPix:consultaStatusRomaneio()
	MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Tente novamente em alguns instantes, caso o problema continue entre em contato com departamento de TI.")
	lRet	:= .F.
	Return .F.	
EndIf

oRetWms	:= XmlParser(oWmsPix:cconsultaStatusRomaneioReturn, "_", @cError, @cWarning)

If !Empty(cError)
	MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Tente novamente em alguns instantes, caso o problema continue entre em contato com departamento de TI.")
	lRet	:= .F.
	Return .F.	
EndIf

If !Empty(cWarning)
	MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Tente novamente em alguns instantes, caso o problema continue entre em contato com departamento de TI.")
	lRet	:= .F.
	Return .F.	
EndIf

If Valtype(XmlChildEx( oRetWms, "_VAZIO" )) == "O" .OR. Valtype(XmlChildEx( oRetWms, "_ERROR" )) == "O" .OR. Valtype(XmlChildEx( oRetWms, "_ERRORS" )) == "O"
	MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Tente novamente em alguns instantes, caso o problema continue entre em contato com departamento de TI.")
	lRet	:= .F.
	Return .F.	
EndIf  

Do Case
	Case Valtype(XmlChildEx( oRetWms, "_RETORNO" )) <> "O"
		MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Tente novamente em alguns instantes, caso o problema continue entre em contato com departamento de TI.")
		lRet	:= .F.
		Return .F.		
	Case Valtype(XmlChildEx( oRetWms:_RETORNO, "_CODRETORNO" )) <> "O"
		MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Tente novamente em alguns instantes, caso o problema continue entre em contato com departamento de TI.")
		lRet	:= .F.
		Return .F.
	Case Valtype(XmlChildEx( oRetWms:_RETORNO, "_NRROMANEIO" )) <> "O"
		MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Tente novamente em alguns instantes, caso o problema continue entre em contato com departamento de TI.")
		lRet	:= .F.
		Return .F.
	Case Valtype(XmlChildEx( oRetWms:_RETORNO, "_STATUSROMANEIO" )) <> "O"
		MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+"Tente novamente em alguns instantes, caso o problema continue entre em contato com departamento de TI.")
		lRet	:= .F.
		Return .F.
	Case !(oRetWms:_RETORNO:_CODRETORNO:TEXT $ "0000#00001")
		MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+AllTrim(oRetWms:_RETORNO:_MENSAGEMRETORNO:TEXT))
		lRet	:= .F.
		Return .F.
	Case Val(oRetWms:_RETORNO:_NRROMANEIO:TEXT) <> 0 .OR. oRetWms:_RETORNO:_STATUSROMANEIO:TEXT == "S"
		MsgStop("Pedido n�o pode ser manipulado pois j� tem romaneio: "+oRetWms:_RETORNO:_NRROMANEIO:TEXT)
		lRet	:= .F.
		Return .F.				
	/*Case Val(oRetWms:_RETORNO:_NRROMANEIO:TEXT) == 0 .AND. (oRetWms:_RETORNO:_CODRETORNO:TEXT $ "0000#0001") .AND. oRetWms:_RETORNO:_STATUSROMANEIO:TEXT == "N"
		MsgStop("Falha ao consultar Status do Romaneio!"+cQuebra+AllTrim(oRetWms:_RETORNO:_MENSAGEMRETORNO:TEXT))
		lRet	:= .F.
		Return .F.		*/
	OtherWise
		cRoma	:= oRetWms:_RETORNO:_NRROMANEIO:TEXT
		If lUpdSC5
			If SC5->(FieldPos("C5_XROMANE")) <> 0
				RecLock("SC5",.F.)
				SC5->C5_XROMANE	:= Val(cRoma)
				MsUnLock()	
			EndIf		
		EndIf		
		If Val(cRoma) <> 0
			lRet	:= .F.			
			MsgStop("Pedido n�o pode ser manipulado pois j� tem romaneio: "+cRoma)
		EndIf	
EndCase

Return lRet