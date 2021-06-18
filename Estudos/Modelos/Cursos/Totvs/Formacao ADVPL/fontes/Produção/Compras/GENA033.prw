#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA033   บAutor  ณHELIMAR TAVARES     บ Data ณ  29/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ROTINA PARA REPLICAR A TES NA ENTRADA NA NOTA FISCAL, APOS บฑฑ
ฑฑบ          ณ DIGITACAO DA PRE-NOTA                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


USER FUNCTION GENA033
	LOCAL oGET001
	LOCAl cTES := SPACE(3)
	LOCAl oSAY001
	LOCAl nOPC := 0    
	LOCAL nPOS
	LOCAL nPOSTES  := ASCAN(aHEADER,{|X|ALLTRIM(UPPER(X[2])) == "D1_TES"})
	LOCAL I
	
	STATIC oDLG001

	DEFINE MSDIALOG oDLG001 TITLE "Informe a TES" FROM 000, 000  TO 150, 150 COLORS 0, 16777215 PIXEL

	@ 031, 008 SAY oSAY001 PROMPT "TES" SIZE 027, 007 OF oDLG001 COLORS 0, 16777215 PIXEL
    @ 030, 036 MSGET oGET001 VAR cTES SIZE 027, 010   OF oDLG001 COLORS 0, 16777215 F3 "SF4" PIXEL  
    @ 060, 039 BUTTON oBTN001 PROMPT "OK" SIZE 028, 009 OF oDLG001 ACTION {||(nOPC := 1),CLOSE(oDLG001)} PIXEL

  	ACTIVATE MSDIALOG oDLG001 CENTERED 
  	
  	IF nOPC == 1
		FOR I :=1 TO LEN(aCOLS)
			aCOLS[I,nPOSTES] := cTES
			
			MaFisLoad("IT_TES","",I)
			MaFisAlt("IT_TES",aCols[I,nPOSTES],I)
			MaFisToCols(aHeader,aCols,I,"MT100")
		NEXT				 		
	ENDIF         
RETURN