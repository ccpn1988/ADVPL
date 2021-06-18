#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GENG005 ºAutor  ³ Joni Fujiyama       º Data ³  30/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa que verifica se a transportadora está bloqueada,	  º±±
±±º          ³se existe o fornecedor na transportadora.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENG005()

Local aArea	:= GetArea()
Local aAreaSA4	:= SA4->( GetArea() )
Local lRet 	:= .T.

lAmbPrd := upper(alltrim(GetEnvServer())) $ "PRODUCAO-" //ambientes de "producao"

DBSELECTAREA("SA4")
DBSETORDER(1)

If lAmbPrd
	
	//Busca a Transportadora
	If dbSeek(XFILIAL("SA4")+M->C5_TRANSP)
		// Verifica se a transportadora está bloqueada
		If FieldPos("A4_MSBLQL") > 0 .and. SA4->A4_MSBLQL = "1"
			MSGBOX("Transportadora Bloqueada","Atenção")
			lRet := .F.
		Else
			// Verifica se a ipo de frete e CIF
			IF M->C5_TPFRETE == "C"
				// Verifica se o campo Fornecedor na Transportadora está vazio
				IF EMPTY(SA4->A4_XFORNEC)
					MSGBOX("A transportadora selecionada está cadastrada sem código de fornecedor. Quando o pedido de venda tem frete tipo CIF é obrigatório que a transportadora esteja cadastrada com um fornecedor.")
					lRet := .F.
				ENDIF
			Endif
		ENDIF
	ELSE
		MSGBOX("Transportadora não cadastrada")
		lRet := .F.
	ENDIF

Endif

GETDREFRESH()

RestArea(aAreaSA4)
RestArea(aArea)

Return lRet
