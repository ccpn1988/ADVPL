#include 'protheus.ch'
#include 'parmtype.ch'

//POSICIONE(cAlia>, nOrde>, cChav>, cCampo)


user function xIndi()
Local aArea := SB1->(GetArea())
Local cMsg := ""
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())

	cMsg := Posicione('SB1',;
						1,;
						FWxFilial('SB1') + '0000001',;
						'B1_DESC')//RETORNO
		MsgInfo("A descrição do produto: "+ cMsg)
		
		RestArea(aArea)

return

