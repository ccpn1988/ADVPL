/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F401QRY2  �Autor  �Microsiga           � Data �  09/15/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �ponto de entrada da rotina fina401 fun��o F401BaseIr        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F401QRY2()

Local cQuery	:= ParamIxb[1]

If 	MV_PAR01 == 4 .AND.; // pela baixa
	MV_PAR04 == 1 // pessoa fisica
	
	cQuery	:= cQuery+=" AND SE2.E2_BAIXA <> ' ' AND SE2.E2_CODRET  <> ' ' "
Else
	/* deve enviar apenas titulos onde ouve a reten��o*/
	cQuery	:= cQuery+=" AND NOT ( SE2.E2_PRETIRF IN (' ','1','6') AND F_GET_TX_IR(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,1) = 0 ) "
	/*cQuery	:= cQuery+=" AND SE2.E2_CODRET IN ('0422','8045')  AND SE2.E2_BAIXA <> ' ' "*/
	
EndIf

WfForceDir("\dirf_2017\"+cFilAnt+"\")
MemoWrite("\dirf_2017\"+cFilAnt+"\"+DtoS(DDataBase)+"_F401QRY2_"+SA2->A2_COD+".sql",cQuery)

return cQuery
