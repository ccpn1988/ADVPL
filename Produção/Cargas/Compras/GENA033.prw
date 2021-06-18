#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA033   ºAutor  ³HELIMAR TAVARES     º Data ³  29/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ROTINA PARA REPLICAR A TES NA ENTRADA NA NOTA FISCAL, APOS º±±
±±º          ³ DIGITACAO DA PRE-NOTA                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


USER FUNCTION GENA033
	Local aAreaSF4	:= SF4->(GetArea())
	LOCAL oGET001
	LOCAl cTES := SPACE(3)
	LOCAl oSAY001
	LOCAl nOPC := 0    
	LOCAL nPOSTES  := GdFieldPos("D1_TES")//ASCAN(aHEADER,{|X|ALLTRIM(UPPER(X[2])) == "D1_TES"})
	LOCAL nPOSCTA  := GdFieldPos("D1_CONTA") //ASCAN(aHEADER,{|X|ALLTRIM(UPPER(X[2])) == "D1_CONTA"})
	LOCAL nAUX
	
	STATIC oDLG001

	DEFINE MSDIALOG oDLG001 TITLE "Informe a TES" FROM 000, 000  TO 150, 150 COLORS 0, 16777215 PIXEL

	@ 031, 008 SAY oSAY001 PROMPT "TES" SIZE 027, 007 OF oDLG001 COLORS 0, 16777215 PIXEL
    @ 030, 036 MSGET oGET001 VAR cTES SIZE 027, 010   OF oDLG001 COLORS 0, 16777215 F3 "SF4" PIXEL  
    @ 060, 039 BUTTON oBTN001 PROMPT "OK" SIZE 028, 009 OF oDLG001 ACTION {||(nOPC := 1),CLOSE(oDLG001)} PIXEL

  	ACTIVATE MSDIALOG oDLG001 CENTERED 
  	
  	IF nOPC == 1
		FOR nAUX :=1 TO LEN(aCOLS)
			aCOLS[nAUX,nPOSTES] := cTES
			
			MaFisLoad("IT_TES","",nAUX)
			MaFisAlt("IT_TES",aCols[nAUX,nPOSTES],nAUX)
			MaFisToCols(aHeader,aCols,nAUX,"MT100")

			IF SF4->F4_CODIGO <> cTES
				SF4->(DBSetOrder(1))
				SF4->(DbSeek( xFilial("SF4")+cTES ))
			ENDIF

			IF nPOSCTA > 0                                             
   				aCols[nAUX][nPOSCTA] := SF4->F4_XCONTA
			ENDIF
		NEXT			 		
	ENDIF       
	RestArea(aAreaSF4)  
RETURN