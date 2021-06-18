/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA020TOK  ºAutor  ³Florence França     º Data ³  01/18/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para obrigar informar o CPF  e dados 	  º±±
±±º          ³bancarios se o fornecedor for pessoa física                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cadastro de Fornecedor                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MA020TOK

Local aArea := GetArea()
Local lRet := .T.

//**** Obriga o Preenchimento dos dados bancários ***********************************************

If ( M->A2_TIPO="F" ).and.(alltrim(M->A2_BANCO) != '000')
	If ( Empty(M->A2_CGC) .or. Empty(M->A2_BANCO) .or. Empty(M->A2_AGENCIA) .or. Empty(M->A2_NUMCON))
		lRet := .F.
		
		IF upper(alltrim(GetEnvServer())) $ "SCHEDULE"
			AutoGrLog( "MA020TOK - Para Pessoa Física é obrigatório o preenchimento do CPF e dos dados Bancarios!: "+DtoC(DDataBase)+" "+Time() )		
		EndIf
		
		Alert("Para Pessoa Física é obrigatório o preenchimento do CPF e dos dados Bancarios!")
	EndIf
EndIf
//***********************************************************************************************

IF lRet .AND. ISINCALLSTACK( "U_GENA100" )

	cMsgAux := ""

	IF Empty(M->A2_NREDUZ)
		cMsgAux += "Campo: "+TitSX3("A2_NREDUZ")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_NOME)
		cMsgAux += "Campo: "+TitSX3("A2_NOME")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_DTNASC)
		cMsgAux += "Campo: "+TitSX3("A2_DTNASC")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XESTADO)
		cMsgAux += "Campo: "+TitSX3("A2_XESTADO")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF

	IF Empty(M->A2_XCODMUN) .AND. M->A2_XESTADO <> "EX"
		cMsgAux += "Campo: "+TitSX3("A2_XCODMUN")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_CEP)
		cMsgAux += "Campo: "+TitSX3("A2_CEP")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_END)
		cMsgAux += "Campo: "+TitSX3("A2_END")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XCODFUN)
		cMsgAux += "Campo: "+TitSX3("A2_XCODFUN")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	/*
	IF Empty(M->A2_NUMDEP)
		cMsgAux += "Campo: "+TitSX3("A2_NUMDEP")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	*/
	IF Empty(M->A2_END)
		cMsgAux += "Campo: "+TitSX3("A2_END")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XPIS) .AND. M->A2_XESTADO <> "EX"
		cMsgAux += "Campo: "+TitSX3("A2_XPIS")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XNACION)
		cMsgAux += "Campo: "+TitSX3("A2_XNACION")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XRG) .AND. M->A2_XESTADO <> "EX"
		cMsgAux += "Campo: "+TitSX3("A2_XRG")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_END)
		cMsgAux += "Campo: "+TitSX3("A2_END")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XCODMUN) .AND. M->A2_XESTADO <> "EX"
		cMsgAux += "Campo: "+TitSX3("A2_XCODMUN")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XNACION)
		cMsgAux += "Campo: "+TitSX3("A2_XNACION")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XDRGEXP) .AND. M->A2_XESTADO <> "EX"
		cMsgAux += "Campo: "+TitSX3("A2_XDRGEXP")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XOREMRG) .AND. M->A2_XESTADO <> "EX"
		cMsgAux += "Campo: "+TitSX3("A2_XOREMRG")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XCODFUN)
		cMsgAux += "Campo: "+TitSX3("A2_XCODFUN")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XSEXO)
		cMsgAux += "Campo: "+TitSX3("A2_XSEXO")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF
	IF Empty(M->A2_XRACACO)
		cMsgAux += "Campo: "+TitSX3("A2_XRACACO")[1]+" deve ser preenchido!"+Chr(13)+Chr(10)
		lRet := .F.
	ENDIF

	IF !Empty(cMsgAux)
		MsgStop("os campos a seguir são obrigatorios: "+Chr(13)+Chr(10)+cMsgAux)
	ENDIF

ENDIF

RestArea(aArea)
Return lRet
