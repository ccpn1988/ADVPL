/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DPCTB102GRºAutor  ³Rafael Lima         º Data ³  22/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada utilizado apos a gravação dos dados da    º±±
±±º          ³ tabela de lançamento.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DPCTB102GR

Local 	aArea	:= GetArea()
Local 	aVet	:= ParamIxb 
local	cMailx

//Local 	lRet	:= .T.

If Inclui .or. Altera
	
	//Alert("Entrei no If")
	
	PswOrder(1)
	PswSeek(__cUserId,.T.)
	aUser := PswRet(1) //traz o email
	
	If !Empty(aUser[1,14])
		cMailx := ALLTRIM(aUser[1,14])  
		Alert(ALLTRIM(aUser[1,14]))
	//	lRet := .T.
	Else
		Alert("Favor informar email no cadastro do seu usuário para recebimento do Aviso de Liberação da conta.")
	//	lRet := .F.
	Endif
	
	DbSelectArea("CT2")
	RecLock("CT2", .F.)
	CT2->CT2_XUSER  := __cUserId 
	CT2->CT2_XEMAIL := cMailx
	MsUnLock()
	
EndIf
//Dispara o wf para liberação para efetivação
//U_APVA002(aVet)
	
RestArea(aArea)
	
Return
