#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FTJNFSB2  ºAutor  ³CLEUTO LIMA         º Data ³  18/05/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada é executado ao termino do JOB de     º±±
±±º          ³ atualização de estoques dos documentos de saída. Ele       º±±   
±±º          ³ permite ao desenvolvedor realizar algumas operações de     º±±
±±º          ³ complemento ao job.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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