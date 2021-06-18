#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MA030ROT()
Local aMenu := {}
AADD( aMenu, {"Teste"  , "U_xCadSA1MSG"     , 0, 1    } )

Return aMenu



User Function xCadSA1MSG(cAlias,nRec,nopc)

MsgInfo("Exemplo ponto de entrada: 'MA030ROT'" + CRLF + ;
         "Nome: " + SA1->A1_NOME )


Return

User Function M030DEL()
Local aAreaSA1 := SA1->(GetArea()) // Guardando a area da tabela| ALIAS,ORDEM,RECNO
Local lRet := .T.

	dbGoto(5) //Recno
	
	msginfo("Pegadinha do Malando","Exemplo M030DEL")
	
RestArea(aAreaSA1) 
Return lRet


User Function MT110LOK()
Local lRet := .T.
Local nObs :=  AScan(aHeader,{|x| Trim(x[2])=="C1_OBS"})

		If ! aCols[N,Len(aHeader)+1]
		
			If Empty(aCols[N,nObs])
				msginfo("informar o campo Observação")
				lRet := .F.
			Endif
			
		Endif
	
Return(lRet)










