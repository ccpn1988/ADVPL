#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function CUSTOMERVENDOR //FORNECEDOR 
Local oObj		:= PARAMIXB[1]
Local cIdPonto  := PARAMIXB[2]
Local cIdModel  := PARAMIXB[3]

If cIdPonto =='FORMPOS' .AND. cIdModel =="SA2MASTER"
	If oObj:GetValue("A2_EST") == RJ
	Help(NIL, NIL, "UF", NIL, "N�o temos opera��o nesse estado",; 
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurar outro endere�o"})
		Return .F.
	EndIf
EndIf
	MsgInfo(cIdPonto)
	Return .T.