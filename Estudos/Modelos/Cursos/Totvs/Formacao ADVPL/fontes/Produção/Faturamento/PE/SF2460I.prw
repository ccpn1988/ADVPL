#include 'protheus.ch'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF2460I   �Autor  �Rafael Leite        � Data �  21/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada no final da gravacao do doc de saida. Nao  ���
���          �recebe parametros, nao envia retorno.                       ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Faturamento                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function SF2460I

If ISINCALLSTACK("U_GENA011T") .OR. ISINCALLSTACK("U_GENA011C")
	Return .T.
EndIf

ConOut("SF2460I - Ajuste F2_XEBKNOT")

If Alltrim(SF2->F2_SERIE) == GetMV("GEN_FAT086") .and. Empty(SF2->F2_XEBKNOT)
	If Reclock("SF2",.F.)
		SF2->F2_XEBKNOT := "N"
		SF2->(MsUnlock())
	Endif
Endif

//������������������������������������������������������������������������������Ŀ
//� Renato Calabro' - 24/jun/2016                                                �
//� Se campos existirem, gravo o numero do pedido Protheus e o pedido WEB        �
//��������������������������������������������������������������������������������
If Reclock("SF2",.F.)
	SF2->F2_XPEDIDO := SC5->C5_NUM //SC6->C6_NUM - Utiliza o SC9 e n�o o SC6 para caso seja pedido parcial
	SF2->F2_XPEDWEB := SC5->C5_XPEDWEB
	SF2->(MsUnlock())
Endif
 
// Cleuto  - 3/04/2018 - resativado pois segundos os parametros informado a rotina n�o est� fazendo nada apenas onerando o desempenha da emiss�o da notas fiscal
//VerPromo()

Return()

/*/
������������������������������������������������������������ͻ��
��� FUNCAO PARA ENVIO DE EMAILS SOBRE CAMPANHAS PROMOCIONAIS ���
������������������������������������������������������������ͼ��
/*/

Static Function VerPromo()

cProduto	:= "00113470"
dInicio	:= CTOD("21/10/2015")
dFim		:= CTOD("16/11/2015")
cEol 		:= CHR(13)+CHR(10)
cEmpty		:= " "

cDoc		:= SF2->F2_DOC

If dDatabase >= dInicio .and. dDatabase <= dFim
	
	aAreaF2	:= SF2->(GetArea())
	aAreaD2	:= SD2->(GetArea())
	If Select("PROMO") > 0
		PROMO->(DbCloseArea())
		RestArea(aAreaF2)
	EndIf
	BeginSql Alias "PROMO"
		SELECT COUNT(*) QTD, C5_XPEDWEB, SUM(D2_QUANT) D2_QUANT FROM %Table:SD2% SD2
		JOIN %Table:SC5% SC5 ON SD2.D2_PEDIDO = SC5.C5_NUM
		WHERE SD2.D2_FILIAL = %xFilial:SD2%
		AND SC5.C5_FILIAL = %xFilial:SC5%
		AND SD2.D2_DOC = %Exp:cDoc%
		AND SD2.D2_COD = %Exp:cProduto%
		AND SD2.D2_TES IN ('503','506')
		AND SC5.C5_XPEDWEB <> %Exp:cEmpty%
		AND SD2.%NotDel%
		AND SC5.%NotDel%
		GROUP BY C5_XPEDWEB
	EndSql
	PROMO->(DbGoTop())
	nQt := PROMO->QTD
	nQtVnd := PROMO->D2_QUANT
	cPedWeb := alltrim(PROMO->C5_XPEDWEB)
	PROMO->(DbClosearea())
	RestArea(aAreaD2)
	RestArea(aAreaF2)
	
	If nQt > 0
		aDest		:= {}
		
		aAdd(aDest,GETMV("GEN_FAT128",.F.,"cleuto.lima@grupogen.com.br"))
		aAdd(aDest,"operacoes@grupogen.com.br")
		aAdd(aDest,"andreax@grupogen.com.br")
		aAdd(aDest,"thiago.santos@grupogen.com.br")
		aAdd(aDest,"sac@grupogen.com.br")
		
		cSubj := "[CAMPANHA PROMOCIONAL] - BRINDE SACOLA BRUNNER
		cMsg := "### EMAIL AUTOM�TICO - FAVOR N�O RESPONDER ###"
		cMsg += cEol
		cMsg += cEol
		cMsg += cEol
		cMsg += "O Documento de Sa�da "+cDoc+", referente ao pedido Web "+cPedWeb+" possui um ou mais produtos promocionais."
		cMsg += cEol
		cMsg += cEol
		cMsg += "Produto: "+cProduto+" - "+alltrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC"))+"  ISBN "+alltrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_ISBN"))
		cMsg += cEol
		cMsg += "Quantidade: "+cValToChar(nQtVnd)
		cMsg += cEol
		cMsg += cEol
		cMsg += "Observa��o: a quantidade de itens do produto promocional corresponder� � quantidade de brindes."
		cMsg += cEol
		cMsg += cEol
		cMsg += cEol
		cMsg += "### EMAIL AUTOM�TICO - FAVOR N�O RESPONDER ###"
		
		For i := 1 to len(aDest)
			U_GenSendMail(,,,"noreply@grupogen.com.br",aDest[i],oemtoansi(cSubj),oemtoansi(cMsg),,,.F.)
		Next i
		
	Endif
Endif

Return()
