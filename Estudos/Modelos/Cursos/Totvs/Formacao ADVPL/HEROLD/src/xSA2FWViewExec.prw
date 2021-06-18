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


If (cAlias)->(MsSeek(xFilial(cAlias) + '???????') )
		oExecView:setOperation(4)
		oExecView:setTitle("Alterar")
		oExecView:setSource(cModel)
		oExecView:setButtons(aButtons)
		oExecView:openView(.T.)
		oExecView:setModal(.T.)
ELse

	oModelAux:SetOperation(3)
    oModelAux:Activate()
	oModelAux:SetValue("SA2MASTER", "A2_COD" , "X00000")
    oModelAux:SetValue("SA2MASTER", "A2_LOJA", "X0")
    oModelAux:SetValue("SA2MASTER", "A2_NOME", "EXEMPLO")
    
    oExecView:setModel(oModelAux)
    oExecView:setOperation(3)
	oExecView:setTitle("Incluir")
	oExecView:setSource(cModel)
	oExecView:setButtons(aButtons)
	
	
	oExecView:openView(.F.)
	oExecView:setModal(.F.) //Metodo que define se a View deve ser aberta na janela modal.
   
	
EndIf 	
	
	
Return 



User Function NewExecView()
    Local oModel := FWLoadModel( "MATA020M" )
    Local aButtons := {{.F.,Nil}/*Copiar*/          ,;
                   {.F.,Nil}/*Recortar*/        ,;
                   {.F.,Nil}/*Colar*/           ,;
                   {.F.,Nil}/*Calculadora*/     ,;
                   {.F.,Nil}/*Spool*/           ,;
                   {.F.,Nil}/*Imprimir*/        ,;
                   {.T.,"Salvar"  }             ,;
                   {.T.,"Cancelar"}             ,;
                   {.F.,Nil}/*WalkTrhough*/     ,;
                   {.F.,Nil}/*Ambiente*/        ,;
                   {.F.,Nil}/*Mashup*/          ,;
                   {.F.,Nil}/*Help*/            ,;
                   {.F.,Nil}/*Formulário HTML*/ ,;
                   {.F.,Nil}/*ECM*/}
    
    
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()
    
    oModel:SetValue("SA2MASTER", "A2_COD" , "X00000")
    oModel:SetValue("SA2MASTER", "A2_LOJA", "X0")
    oModel:SetValue("SA2MASTER", "A2_NOME", "EXEMPLO")
    
    FWExecView('Inclusão de atividade','MATA020M', MODEL_OPERATION_INSERT, , { || .T. } , , 20,aButtons,,,,oModel)	
Return( NIL )	