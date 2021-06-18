#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'



User Function xFWViewExec()
Local cModel := 'MATA020M'
Local CALIAS := 'SA2'
Local oModelAux := FWLoadModel( cModel )
Local oExecView := FWViewExec():New()
Local aButtons := {{.F.,Nil}/*/Copiar/*/          ,;
                   {.F.,Nil}/*/Recortar/*/        ,;
                   {.F.,Nil}/*/Colar/*/           ,;
                   {.F.,Nil}/*/Calculadora/*/     ,;
                   {.F.,Nil}/*/Spool/  */         ,;
                   {.F.,Nil}         ,;
                   {.T.,"Salvar"  }             ,;
                   {.T.,"Cancelar"}             ,;
                   {.F.,Nil}      ,;
                   {.F.,Nil}        ,;
                   {.F.,Nil}           ,;
                   {.F.,Nil}            ,;
                   {.F.,Nil}  ,;
                   {.F.,Nil} } 
dbSelectArea(cAlias)
(cAlias)->(dbSetOrder(1))

If (cAlias)->(MsSeek(xFilial(cAlias) + '000104') )
	oExecView:setOperation(4)
	oExecView:setTitle("Alterar")
	oExecView:setSource(cModel)
	oExecView:setButtons(aButtons)
	oExecView:openView(.T.)
	oExecView:setModal(.T.)
EndIf	
	