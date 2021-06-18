#Include 'Protheus.ch'
#Include 'TBICONN.ch'

User Function xExecAuto()

	Local aDados := {}
	Local nOpc   := 3 // Incluir
	Private lMsErroAuto := .F.
	
	/*FUNÇÂO PARA SIMULAR ABERTURA DO SISTEMA*/
	RpcSetEnv("99","01")
	
	//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" 

	aDados:= {{"B1_COD"   ,"X100007604"     ,NIL},;
             {"B1_DESC"  ,"PRODUTO TESTE" ,NIL},;
             {"B1_TIPO"  ,"PA"            ,Nil},;
             {"B1_UM"    ,"UN"            ,Nil},;
             {"B1_LOCPAD","01"            ,Nil},;
             {"B1_GRUPO" ,""             ,Nil}}

	MSExecAuto({|x,y| Mata010(x,y)},aDados,nOpc)

	If lMsErroAuto
		MostraErro()
	Else
		Alert("Produto Incluido com sucesso!!!!")
	Endif

Return

