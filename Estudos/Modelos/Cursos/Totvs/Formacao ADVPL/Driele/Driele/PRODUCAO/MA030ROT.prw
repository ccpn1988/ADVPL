#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MA030ROT ()
	
	Local aMenu:={}
	AADD (aMenu,{"TESTE",  "U_xCadSA1MSG"             ,0,1 } )
	
Return aMenu

User Function xCadSA1MSG ()
	MsgInfo ("Exemplo o ponto de entrada: 'MA030ROT'" + CRLF + ;
		"Nome:" + SA1->A1_NOME)
	
Return

//========================================================================================
//========================================================================================
User Function M030DEL()
	Local aAreaSA1 := SA1->(GetArea()) //Guardando a area da taebla | alias, ordem, recno
	Local lRet := .T.
	
	MsgInfo ("Pegadinha do Malandro","Exemplo M030DEL")
	
	RestArea(aAreaSA1)
Return lRet

//========================================================================================
//========================================================================================

User Function MT110OK()
	Local lRet := .T.
	Local nObs := Ascan (aHeader, {|x| Trim(x[2])=="C1_OBS"})
	For x:= 1 To len(aCols)
		If ! aCols [x, len (aHeader)+1]
			If Empty (aCols [x, nObs])
				MsgInfo ("Informar o Campo Observação")
				lret := .F.
			EndIf
		EndIf
	Next x
Return lRet


//========================================================================================
//========================================================================================

User Function MT11LOK()
	Local lRet := .T.
	Local nObs := Ascan (aHeader, {|x| Trim(x[2])=="C1_OBS"})
	
		If ! aCols [N, len (aHeader)+1]
			If Empty (aCols [N, nObs])
				MsgInfo ("Informar o Campo Observação")
				lret := .F.
			EndIf
		EndIf
Return lRet
