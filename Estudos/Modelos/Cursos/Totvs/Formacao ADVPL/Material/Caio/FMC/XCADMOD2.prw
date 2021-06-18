#Include 'Protheus.ch'

User Function XCADMOD2() // o Nome da função principal tem que ser exatamente igual ao nome do fonte - conceito MVC
	
	Local oBrowse	:= FwmBrowse():New()
	
	oBrowse:SetAlias("SZ0")	// Qual tabela vou usar
	oBrowse:SetDescription("Modelo 2 Cadastro de sucata") //Qual a descrição do meu browse
	
	oBrowse:AddLegend("Z0_ATIVO == 'S'","BR_MARRON","Ativo"	 )	//Adiciona legenda
	oBrowse:AddLegend("Z0_ATIVO == 'N'","BR_PINK"	,"Desativado")	//Adiciona legenda
	
	oBrowse:Activate()	// Ativa o OBJETO

Return

Static Function MenuDef()
	Local aRotina	:= {}

	aRotina := 	{;
				{ "Pesquisar"	, "AxPesqui"	, 0, 1},;
				{ "Visualizar"	, "U_MDL02SZ0"	, 0, 2},;
				{ "Incluir"		, "U_MDL02SZ0"	, 0, 3},;
				{ "Alterar"		, "U_MDL02SZ0"	, 0, 4},;
				{ "Exlcuir"		, "U_MDL02SZ0"	, 0, 5},;
				{ "Legenda"		, "U_LEGSZ0"	, 0, 7};
				}
				
Return (aRotina)