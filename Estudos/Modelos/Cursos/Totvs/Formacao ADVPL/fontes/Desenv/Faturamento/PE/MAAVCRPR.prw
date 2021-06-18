#include 'protheus.ch'
#include 'parmtype.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MAAVCRPR � Autor � Bruno Parreira     � Data �  22/05/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada que pertence a rotina de avalizacao de    ���
���          � credito de clientes, MaAvalCred() - FATXFUN(). Ele permite ���
���          � que apos avaliacao padrao o usu�rio possa fazer sua propria���
�������������������������������������������������������������������������͹��
���Parametros� ParamIxb -> Array                                          ���
���          � ParamIxb[1] -> Codigo do Cliente                           ���
���          � ParamIxb[2] -> Filial do Cliente                           ���
���          � ParamIxb[3] -> Valor da venda                              ���
���          � ParamIxb[4] -> Moeda da venda                              ���
���          � ParamIxb[5] -> Considera acumulados de Pedido de Venda do  ���
���          �                SA1                                         ���
���          � ParamIxb[6] -> Tipo de credito (L - Codigo cliente + Filial���
���          �                C - codigo do cliente)                      ���
���          � ParamIxb[7] -> Indica se o credito sera liberado           ���
���          � ParamIxb[8] -> Indica o codigo de bloqueio do credito      ���
�������������������������������������������������������������������������͹��
���Retorno   � lRet - .T. Credito Aprovado / .F. Credito nao Aprovado     ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MAAVCRPR()
Local aArea   := GetArea()
Local cTES    := SuperGetMV("GEN_FAT243",.F.,"524/") //TES que sao utilizadas para acerto de consignacao de cliente. Pedidos com essa TES nao terao credito bloqueado.
Local lRet    := ParamIxb[7] //Indica se o credito sera liberado
Local cCli    := ParamIxb[1] //Codigo do cliente 
Local nVlInad := 0 //SA1->A1_ATR
Local nRiscoB := GetMV("MV_RISCOB") //Dias de tolerancia para atraso Risco B
Local nRiscoC := GetMV("MV_RISCOC") //Dias de tolerancia para atraso Risco C
Local nRiscoD := GetMV("MV_RISCOD") //Dias de tolerancia para atraso Risco D

If lRet
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+cCli)
		While SA1->(!EOF()) .And. SA1->A1_COD = cCli
			Do Case
				Case SA1->A1_RISCO $ "B"
					nVlInad := VALINAD(SA1->A1_COD,SA1->A1_LOJA,nRiscoB)
					If nVlInad > 0
						lRet := .F.
					EndIf
				Case SA1->A1_RISCO $ "C"
					nVlInad := VALINAD(SA1->A1_COD,SA1->A1_LOJA,nRiscoC)
					If nVlInad > 0
						lRet := .F.
					EndIf
				Case SA1->A1_RISCO $ "D"
					nVlInad := VALINAD(SA1->A1_COD,SA1->A1_LOJA,nRiscoD)
					If nVlInad > 0
						lRet := .F.
					EndIf
			EndCase
			If !lRet
				Exit
			EndIf
			SA1->(DbSkip())
		EndDo
	EndIf
EndIf

If !lRet //TES contidas no parametro GEN_FAT243 n�o ter�o o cr�dito bloqueado pois s�o acerto de consigna��o.
	If SC6->C6_TES $ cTES
		lRet := .T.
	EndIf
EndIf

RestArea(aArea)

Return lRet

Static Function VALINAD(cCodCli,cLojCli,nDias)
Local nRet   := 0
Local dData  := DaySub(DDATABASE,nDias) //Data a ser considerada para t�tulos em atraso
Local cQuery := ""

cQuery += "select SUM(E1_VALOR) E1_VALOR from "+RetSqlName("SE1")+" SE1 "+CRLF
cQuery += "where E1_SALDO > 0 "+CRLF
cQuery += "and E1_CLIENTE = '"+cCodCli+"' "+CRLF
cQuery += "and E1_LOJA = '"+cLojCli+"' "+CRLF
cQuery += "and D_E_L_E_T_ = ' ' "+CRLF
cQuery += "and E1_VENCREA < '"+DtoS(dData)+"' "+CRLF
cQuery += "and E1_TIPO NOT IN ('NCC','RA') "+CRLF
//cQuery += "and E1_PREFIXO IN ('') "+CRLF
//cQuery += "and E1_NATUREZ NOT IN ('30080','30070') "+CRLF

MemoWrite ("MAAVCRPR_VALINAD.sql",cQuery)
					
If Select("TRB") > 0
	dbSelectArea("TRB")
	TRB->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T.)

If TRB->(!EOF())
	If TRB->E1_VALOR > 0
		nRet := SE1->E1_VALOR
	EndIf
EndIf

Return nRet