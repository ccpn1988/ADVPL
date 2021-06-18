#Include 'Protheus.ch'

User Function F200FIM()


If Select("TMPFI0") > 0
	DbSelectarea("TMPFI0")
	DbcloseArea()          
EndIf

BeginSql Alias "TMPFI0"
	%noparser%
	Select Max(R_E_C_N_O_) R_E_C_N_O_ FROM %table:FI0% FI0
	where FI0.%notdel%
EndSql

If !TMPFI0->(Eof())
	
	DbSelectArea("FI0")
	DbSetOrder(1)
	DbGoTo(TMPFI0->R_E_C_N_O_)
	
	cFilArq:= FI0->FI0_FILIAL
	cIdArq := FI0->FI0_IDARQ
	
	RecLock("FI0",.F.)
	DbDelete()
	MsUnlock()
	
	DbSelectArea("FI1")
	DbSetOrder(1)
	If !DbSeek(cFilArq+cIdArq)
		While !FI1->(EOF()) .And. FI1->FI1_FILIAL+FI1->FI1_IDARQ = cFilArq+cIdArq
			RecLock("FI1",.F.)
			DbDelete()
			MsUnlock()
			FI1->(DbSkip())
		EndDo
	Else
		Alert("Arquivo Processado!!!")                                                                  
	EndIF
	
EndIf

If Select("TMPFI0") > 0
	DbSelectarea("TMPFI0")
	DbcloseArea()          
EndIf

Return
