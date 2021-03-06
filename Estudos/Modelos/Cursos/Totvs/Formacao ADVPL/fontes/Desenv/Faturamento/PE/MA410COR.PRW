
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410COR  �Autor  �Cleuto Lima         � Data �  04/04/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para manipular o array aCores              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen.                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MA410COR()

Local aCores	:= {}

aCores := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'ENABLE',nil },;		//Pedido em Aberto
			{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE',nil},;		   	//Pedido Encerrado
			{ "U_xRetBloq('C9_BLEST')","BR_MARROM",nil},; // Bloqueio de Estoque - Cleuto - incluida nova legenda
			{ "U_xRetBloq('C9_BLCRED')","PMSTASK3",nil},; // Bloqueio Financeiro - Cleuto - incluida nova legenda
			{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)","PMSTASK2",nil},;//'BR_AMARELO'
			{ "C5_BLQ == '1'",'BR_AZUL',nil},;	//Pedido Bloquedo por regra
			{ "C5_BLQ == '2'",'BR_LARANJA',nil},;	//Pedido Bloquedo por verba
			{ "C5_BLQ == '3'",'br_pink',nil},;	//"Pedido de Vendas com Bloqueio por regra de consigna��o"
			{ "C5_BLQ == '4'",'BR_PRETO',nil}}	//Pedido Bloquedo por verba


Return aCores


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xRetBloq  �Autor  �Cleuto Lima         � Data �  04/04/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclus�o de tratamento para nova legenda no pedido de      ���
���          � vendas.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Gen.                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
			
User Function xRetBloq(cVldField)

Local lStatus	:= .F.
Local aArea		:= GetArea()
Local cAliTmp	:= GetNextAlias()

/*
Campo: C9_BLCRED : Liberado 01 � Bloqueado p/ cr�dito 02 MV_BLQCRED = t 04 - Limite de Cr�dito Vencido 05 - Bloqueio Cr�dito por Estorno 06 � por risco 09 -  Rejeitado 10 - J� Faturado.
Campo: C9_BLEST: Liberado 02 - Bloqueio de Estoque 03 - Bloqueio Manual 10 - J� Faturado.
*/

BeginSql Alias cAliTmp
	SELECT MAX(C9_BLEST) C9_BLEST,MAX(C9_BLCRED) C9_BLCRED FROM %Table:SC9% SC9
	WHERE C9_FILIAL = %Exp:SC5->C5_FILIAL%
	AND C9_PEDIDO = %Exp:SC5->C5_NUM%
	AND SC9.%NotDel%
EndSql

(cAliTmp)->(DbGoTop())

If "C9_BLEST" == cVldField

	lStatus	:= (cAliTmp)->C9_BLEST $ "02#03"

ElseIf "C9_BLCRED" == cVldField 

	lStatus	:= (cAliTmp)->C9_BLCRED $ "01#02#04#05#06#09"
	
EndIf


(cAliTmp)->(DbCloseArea())
RestArea(aArea)

Return lStatus