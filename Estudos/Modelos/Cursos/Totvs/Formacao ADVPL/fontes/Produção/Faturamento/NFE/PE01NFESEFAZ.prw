#DEFINE _PaProd	  01
#DEFINE _PcMensCli   02
#DEFINE _PcMensFis   03
#DEFINE _PaDest      04
#DEFINE _PaNota      05
#DEFINE _PaInfoItem  06
#DEFINE _PaDupl      07
#DEFINE _PaTransp    08
#DEFINE _PaEntrega   09
#DEFINE _PaRetirada  10
#DEFINE _PaVeiculo   11
#DEFINE _PaReboque   12
#DEFINE _PcTipo	  	  13

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �PE01NFESEFAZ�Autor  �Cleuto Lima         � Data �  13/09/16   ���
���������������������������������������������������������������������������͹��
���Desc.     � ponto de entrada no NfeSefax para manipular informa��es      ���
���          � antes da gera��o da nota fiscal.                             ���
���������������������������������������������������������������������������͹��
���Uso       � Especifico Gen                                               ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

User function PE01NFESEFAZ()

//�������������������������������������������������������������������������������������Ŀ
//�Variaveis da rotina.                                                                 �
//���������������������������������������������������������������������������������������
Local aArea		:= GetArea()
Local aAuxPara	:= aClone(ParamIXB)
Local cAlAux	:= ""
Local cMsgAux	:= ""

If aAuxPara[18] == "1" // Saida
    
	cMsgAux	:= aAuxPara[_PcMensCli]

	cAlAux := GetNextAlias()
	BeginSql Alias cAlAux
		SELECT COUNT(*) QTD_ITENS,SUM(D2_QUANT) QTD_EXEMPL 
		FROM %Table:SD2% SD2
		WHERE D2_FILIAL = %xFilial:SD2%
		AND D2_DOC = %Exp:SF2->F2_DOC%
		AND D2_SERIE = %Exp:SF2->F2_SERIE%
		AND SD2.%NotDel%
	EndSql
	
	(cAlAux)->(DbGoTop())
	
	If (cAlAux)->(!EOF())
		
		cMsgAux += " Qtd.Itens Nota: "+AllTrim(Str((cAlAux)->QTD_ITENS))+" Qtd.Exemplares: "+AllTrim(Str((cAlAux)->QTD_EXEMPL))
		
	EndIf
	
	(cAlAux)->(DbCloseArea())
    
	aAuxPara[_PcMensCli] := cMsgAux

EndIf

RestArea(aArea)

Return aAuxPara
