#Include 'Protheus.ch'
User Function xCNPJ()
IF MSGYESNO("DESEJA EXECUTAR A ROTINA?")
	U_CNPJ()
	MSGINFO("CLIENTE " + SA1->A1_NOME + CRLF +;
			SA1->A1_CGC )
END IF
RETURN()
//---------------------------------------------------------------------
User Function CNPJ()
DBSELECTAREA("SA1")
DBSETORDER(3)
IF MSSEEK(XFILIAL("SA1") + '03338610002646') 
RECLOCK("SA1",.F.)
	SA1->A1_NOME := "CONSULTA"
MSUNLOCK()
ENDIF

Return()

