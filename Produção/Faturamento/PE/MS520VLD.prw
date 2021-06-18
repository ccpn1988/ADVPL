#include "Protheus.ch"

/*
Fonte: MS520VLD

Descrição: Ponto de entrada para validar a exclusão do documento de saida    

Localização: Documento de entrada -> Exclusão -> Antes de gravar a exclusão

Data: 03/07/2015

Autor: Erica Vieites  

*/
user function MS520VLD

local _lret := .F.

If GetMv("GEN_FAT081")
	If Empty(SF2->F2_XDTEXPD)
		_lret := .T.
	Else
		_lret := .F.
		MsgStop("Nota fiscal já expedida. Não será possível fazer a exclusão.")
	Endif
Else
	_lret := .T.
Endif

If _lret
	If cFilant $ "7001" .AND. AllTrim(SF2->F2_SERIE) == "3"
		If Select("TMP_APURA") > 0
			TMP_APURA->(DbCloseArea())
		EndIf				
		BeginSql Alias "TMP_APURA"
			select to_char(max(data),'YYYYMMDD') PERIODO from forum.gen_apuracao
		EndSql
		TMP_APURA->(DbGoTop())
		If TMP_APURA->(!EOF())
			If StoD(TMP_APURA->PERIODO) >= SF2->F2_EMISSAO
				_lret := .F.
				If "SCHEDULE" $ upper(alltrim(GetEnvServer()))
					Conout("Não é possível excluir a nota fiscal pois já houve apuração de DA em "+DtoC(StoD(TMP_APURA->PERIODO))+". Nota: "+SF2->F2_DOC+" - "+SF2->F2_SERIE)
				Else
					MsgStop("Não é possível excluir a nota fiscal pois já houve apuração de DA em "+DtoC(StoD(TMP_APURA->PERIODO))+". Nota: "+SF2->F2_DOC+" - "+SF2->F2_SERIE)
				EndIf				
			EndIf
		EndIf
		TMP_APURA->(DbCloseArea())
	EndIf	
EndIf 

return _lret