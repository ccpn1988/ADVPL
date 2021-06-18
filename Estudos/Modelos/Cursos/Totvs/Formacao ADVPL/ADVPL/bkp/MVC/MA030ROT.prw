#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MA030ROT()
	Local aMenu	:= {}
	aAdd( aMenu, {"Teste", "U_xCadSA1MSG", 0, 1 } )
	
Return aMenu

User Function xCadSA1MSG()

	MsgInfo("Exemplo ponto de entrada: 'MA030ROT'" + CRLF + ;
			"Nome: " + SA1->A1_NOME ) 

Return

User Function M030DEL()
	Local aAreaSA1	:= SA1->(GetArea()) // Guardando a area da tabela --> ALIAS,ORDEM,RECNO
	Local lRet	:= .T.
	
	dbGoTo(5)
	
	MsgInfo("Pegadinha do Malandro","Exemplo M030DEL")
	
	RestArea(aAreaSA1)
	
Return lRet


User Function MT110LOK()
	Local lRet	:= .T.
	Local nObs	:= aScan(aHeader,{|X| Trim(x[2]) == "C1_OBS"})
	
	If ! aCols[N,Len(aHeader)+1]
		If Empty(aCols[N,nObs])
			MsgInfo("Informar o campo Observação")
			lRet := .F.
		EndIf
	EndIf
	
Return lRet


User Function MT110TOK()
	Local lRet	:= .F.
	Local nObs	:= aScan(aHeader,{|X| Trim(x[2]) == "C1_OBS"})
	
	For x := 1 To Len(aCols)
		If ! aCols[x,Len(aHeader)+1]
			If Empty(aCols[x,nObs])
				MsgInfo("Informar o campo Observação")
				lRet := .F.
			EndIf
		EndIf
	Next x
	
	MsgInfo("TESTE")

Return lRet