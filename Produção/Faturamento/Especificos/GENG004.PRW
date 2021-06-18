#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENG004  ºAutor  ³ Joni Fujiyama       º Data ³  30/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa que inclui a transportadora caso o tipo de frete   º±±
±±º          ³for igual CIF.													 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//************************************************************************************************//
User Function GENG004()
//************************************************************************************************//

Local aArea	:= GetArea()
Local aAreaSA1	:= GetArea("SA1")
Local aAreaSA4	:= GetArea("SA4")
Local lRet 	:= .T.

// Verifica se o Frete é do Tipo CIF
IF M->C5_TPFRETE == "C"

	DBSELECTAREA("SA1")
	DBSETORDER(1)
	
	// Busca o cliente 
	IF DBSEEK ( XFILIAL ( "SA1" ) + M->C5_CLIENTE + M->C5_LOJACLI )
	
		DBSELECTAREA("SA4")
		DBSETORDER(1)		
		
		// Verifica se o campo da transportadora está vazio
		IF !EMPTY(SA1->A1_TRANSP)

			// Busca a transportadora
			IF DBSEEK ( XFILIAL ( "SA4" ) + SA1->A1_TRANSP )
		
				M->C5_TRANSP := A4_COD
			
			ELSE
		
				MSGBOX("Transportadora não cadastrada")
		
			ENDIF

		ELSE
		
			MSGBOX("O campo transportadora está em branco")
		
		ENDIF
				
	ELSE
	
		MSGBOX("Cliente não cadastrado")
		
	ENDIF

ENDIF

GETDREFRESH()

RestArea(aAreaSA4)
RestArea(aAreaSA1)
RestArea(aArea)

Return lRet
