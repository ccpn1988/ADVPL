/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xGenSXE   ºAutor  ³Cleuto e Arthur Limaº Data ³  30/11/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função generica responsavel por criar numeros sequenciais   º±±
±±º          ³com base na getsx8num e validar se a numeração é valida     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Projeto Gestão de Obras                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xGenSXE(cAliasSXE,cFieldSXE,nIndexSXE)

Local aArea		:= GetArea()
Local aAreaSXe	:= (cAliasSXE)->(GetArea())
Local cRet		:= ""
Local nQtdAux	:= 0

cRet := GetSX8Num(cAliasSXE,cFieldSXE,NIL,nIndexSXE)
(cAliasSXE)->(DbSetOrder(nIndexSXE))
While (cAliasSXE)->(DbSeek( xFilial(cAliasSXE) + cRet )) 
	ConfirmSX8()
	cRet := GetSX8Num(cAliasSXE,cFieldSXE,NIL,nIndexSXE)
	(cAliasSXE)->(DbSkip())
	nQtdAux++
	IF Mod(nQtdAux,100) == 0
		U_GenSendMail(,,,"noreply@grupogen.com.br","desenvolvimento@grupogen.com.br",oemtoansi("xGenSXE - controle de numeração em loop"),"Possível loop na rotina "+FunName()+chr(13)+chr(10)+;
		"Alias "+cAliasSXE+", campo "+cFieldSXE,,,.F.)			
	ENDIF
EndDo

RestArea(aAreaSXe)
RestArea(aArea)

Return cRet
