#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050ALT  ºAutor  ³FLORENCE FRANCA     º Data ³  25/01/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida os tipos de pagamentos conforme informado no 		  º±±
±±º          ³ parametro MV_XINFPGT (valor da validação TED/DOC)no 		  º±±     
±±º          ³ momento da alteração		  								  º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FA050ALT Contas a Pagar                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FA050ALT()

Local lRet := .T.
Local cParam := 0
   
cParam := GETMV("MV_XINFPGT")        

If (M->E2_XFORPGT $ "41|43")  .and. M->E2_TIPO <> "DAE"
	If (M->E2_VALOR <= GETMV("MV_XINFPGT"))          
		MsgBox("Não é permitido a inclusão de títulos do tipo TED para valores MENORES de "+str(cParam)+".","Atenção") 
		lRet := .F.                
	EndIf
EndIf	   

If (M->E2_XFORPGT == '03') .and. M->E2_TIPO <> "DAE"
	If (M->E2_VALOR > GETMV("MV_XINFPGT"))
		MsgBox("Não é permitido a inclusão de títulos do tipo DOC para valores MAIORES de "+str(cParam)+".","Atenção")
		lRet := .F.	  	
	EndIf                              
EndIf
                      
Return(lRet)