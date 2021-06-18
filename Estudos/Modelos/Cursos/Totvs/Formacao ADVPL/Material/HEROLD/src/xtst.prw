#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User function xTst()
Local cValor := "1.234,56"

RpcSetEnv("99","01")

dbSelectArea("SZ0")
RecLock("SZ0",.F.)
	SZ0->Z0_VALOR := Val(cValor)
MsUnLock()


cValor := Val(cValor) + 10 

MsgInfo(SZ1->Z1_VALOR)







Return( NIL )



