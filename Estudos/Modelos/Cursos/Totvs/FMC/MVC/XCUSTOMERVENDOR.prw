#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function CUSTOMERVENDOR
	Local oObj		:= PARAMIXB[1] 
    Local cIdPonto	:= PARAMIXB[2]
	Local cIdModel	:= PARAMIXB[3]
	
	If cIdPonto == 'FORMPOS' .AND. cIdModel == 'SA2MASTER'
		If oObj:GetValue("A2_EST") == "RJ"
			Help(NIL,NIL,"Unidade Federativa",NIL,"Não temos operação nesse estado", ;
				 1,0,NIL,NIL,NIL,NIL,NIL,{"Procurar outra empresa"})
			Return .F.
		EndIf
	EndIf

Return .T.