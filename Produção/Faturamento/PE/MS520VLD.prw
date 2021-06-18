#include "Protheus.ch"

/*
Fonte: MS520VLD

Descri��o: Ponto de entrada para validar a exclus�o do documento de saida    

Localiza��o: Documento de entrada -> Exclus�o -> Antes de gravar a exclus�o

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
		MsgStop("Nota fiscal j� expedida. N�o ser� poss�vel fazer a exclus�o.")
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
					Conout("N�o � poss�vel excluir a nota fiscal pois j� houve apura��o de DA em "+DtoC(StoD(TMP_APURA->PERIODO))+". Nota: "+SF2->F2_DOC+" - "+SF2->F2_SERIE)
				Else
					MsgStop("N�o � poss�vel excluir a nota fiscal pois j� houve apura��o de DA em "+DtoC(StoD(TMP_APURA->PERIODO))+". Nota: "+SF2->F2_DOC+" - "+SF2->F2_SERIE)
				EndIf				
			EndIf
		EndIf
		TMP_APURA->(DbCloseArea())
	EndIf	
EndIf 

return _lret