#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MA030ROT()
	Local aMenu := {}
	AADD( aMenu, {"Teste", "U_xCadSa1Msg", 0, 1})

Return aMenu

User Function xCadSa1Msg()
	MsgInfo("Exemplo ponto de entrada: 'MA030ROT'" + CRLF + ;
			"Nome: " + SA1->A1_NOME)
Return


//----------------------------------------------------------------------
User Function M030DEL()
	Local aAreaSa1 := SA1->(GetArea())//Guardando a area da tabela | ALIAS, ORDEM, RECNO
	Local lRet := .T.
	
//	dbGoTo(5)
	
	MsgInfo("Pegadinha do Malandro","Exemplo M030DEL")
	
	RestArea(aAreaSa1) //Restaura as configurações salvas anteriormente
Return lRet

//----------------------------------------------------------------------

User Function MT110TOK()
/*	
	Local	lRet := .T.
	Local nObs := aScan(aHeader,{|x| Trim(x[2])=="C1_OBS"})
	For x := 1 To len(aCols)
		If ! aCols[x,Len(aHeader)+1]
			
			If Empty(aCols[x,nObs])
				MsgInfo("Informar o campo Observação")
				lRet := .F.
			Endif
		endif
	Next x
	MsgInfo("TESTE")*/
Return(lRet)
//----------------------------------------------------------------------

User Function MT110LOK()
/*	
	Local	lRet := .T.
	Local nObs := aScan(aHeader,{|x| Trim(x[2])=="C1_OBS"})
	For x := 1 To len(aCols)
		If ! aCols[x,Len(aHeader)+1]
			
			If Empty(aCols[x,nObs])
				MsgInfo("Informar o campo Observação")
				lRet := .F.
			Endif
		endif
	Next x
	MsgInfo("TESTE")*/
Return(lRet)
//----------------------------------------------------------------------
