#include "Protheus.ch"
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA070CA3  ºAutor  ³Florence Franca     º Data ³  08/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada executado no momento da baixa.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rotina FINA070	                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/       

User Function FA070CA3

LOCAL lExclusao		:= .F. //Para tratar a exclusao de baixa
Local nOpcx                    
Local cQuery := ""                          
Local nTotal     
Local ncont :=0

cQuery:= " SELECT E5_XCANCBX, E5_SEQ FROM "+RetSqlName("SE5")
cQuery+= " WHERE E5_PREFIXO = '"+SE1->E1_PREFIXO+"'"
cQuery+= " AND E5_NUMERO ='"+SE1->E1_NUM+"'"
cQuery+= " AND E5_PARCELA ='"+SE1->E1_PARCELA+"'"
cQuery+= " AND E5_TIPO ='"+SE1->E1_TIPO+"'"
cQuery+= " AND E5_CLIENTE ='"+SE1->E1_CLIENTE+"'"
cQuery+= " AND E5_LOJA ='"+SE1->E1_LOJA+"'"

TcQuery cQuery New Alias "TRBFA070"
                              
Count To nTotal

DbSelectArea("TRBFA070")
Dbgotop()            
While !TRBFA070->(EOF())        

	ncont++
	If nTotal = ncont
		
		If TRBFA070->E5_XCANCBX = "S"
			lExclusao := .T.
		Else
			Alert("Esta Operação não está permitida. Verifique se o cancelamento de baixa foi aprovado! ")
		Endif
	EndIf
	
	DbSelectArea("TRBFA070")
	DbSkip()
EndDo

     
DbSelectArea("TRBFA070")     
DbCloseArea()
     
Return lExclusao