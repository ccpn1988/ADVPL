//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} zRotAuto
Exemplo de ExecAuto utilizando MVC (inclus?o na ZZ1)
@type function
@author Atilio
@since 24/10/2016
@version 1.0
	@example
	u_zRotAuto()
/*/

User Function zRotAuto()
	Local aArea         := GetArea()
	Local aDados        := {}
	Private aRotina     := StaticCall(zModel1, MenuDef)
	Private oModel      := StaticCall(zModel1, ModelDef)
	Private lMsErroAuto := .F.
	
	//Adicionando os dados do ExecAuto
	aAdd(aDados, {"ZZ1_DESC", "ROT AUTO", Nil})
	
	//Chamando a inclus?o - Modelo 1
	lMsErroAuto := .F.
	FWMVCRotAuto(	oModel,;                        //Model
					"ZZ1",;                         //Alias
					MODEL_OPERATION_INSERT,;        //Operacao
					{{"FORMZZ1", aDados}})          //Dados
	
	//Se tiver mais de um Form, deve se passar dessa forma:
	// {{"ZZ2MASTER", aAutoCab}, {"ZZ3DETAIL", aAutoItens}})
	
	//Se houve erro no ExecAuto, mostra mensagem
	If lMsErroAuto
		MostraErro()
	
	//Sen?o, mostra uma mensagem de inclus?o	
	Else
		MsgInfo("Registro incluido!", "Aten??o")
	EndIf
	
	RestArea(aArea)
Return