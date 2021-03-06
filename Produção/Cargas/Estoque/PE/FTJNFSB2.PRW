#include "protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FTJNFSB2  �Autor  �CLEUTO LIMA         � Data �  18/05/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Este ponto de entrada � executado ao termino do JOB de     ���
���          � atualiza��o de estoques dos documentos de sa�da. Ele       ���   
���          � permite ao desenvolvedor realizar algumas opera��es de     ���
���          � complemento ao job.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FTJNFSB2()

//Local aPedidos  := ParamIXB[1]
//Local aNota     := ParamIXB[2]
Local cUpdSB2   := ""

cUpdSB2 += " UPDATE "+RetSqlName("SB2")+" SB2 SET B2_QTNP = 0 "
cUpdSB2 += " WHERE B2_FILIAL = '1022'
cUpdSB2 += " AND B2_LOCAL = '01'
cUpdSB2 += " AND B2_QTNP > 0
cUpdSB2 += " AND SB2.D_E_L_E_T_ <> '*'
cUpdSB2 += " AND EXISTS(
cUpdSB2 += "   SELECT 1 FROM "+RetSqlName("ZZL")+" ZZL
cUpdSB2 += "   WHERE ZZL_FILIAL = ' '
cUpdSB2 += "   AND ZZL_COD = B2_COD
cUpdSB2 += "   AND ZZL.D_E_L_E_T_ <> '*'
cUpdSB2 += " )

Begin Transaction
    If TCSqlExec(cUpdSB2) < 0
        cMsg := "Falha ao tentar limpar o campo B2_QTNP"+chr(13)+chr(10)+TCSQLError()
        Disarmtransaction()
        U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("Protheus FTJNFSB2 - Limpeza do campo B2_QTNP"),cMsg,,,.F.)
    EndIf
End Transaction

Return nil