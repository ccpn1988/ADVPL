#Include 'Protheus.ch'
#Include 'TBICONN.CH''

User Function xExecAuto()

	Local aDados		:= {}
	Local nOpc			:= 3	// Incluir
	Private	lMsErroAuto := .F.
	
	RpcSetEnv("99","01")
	//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST"

				//SB1->B1_FILIAL	:=	aDados[1]
				//SB1->B1_COD		:=	aDados[2]
				//SB1->B1_DESC	:=	aDados[3]
				//SB1->B1_LOCPAD	:=	aDados[4]
				//SB1->B1_GRUPO	:=	aDados[5]
				//SB1->B1_UM		:=	aDados[6]
				//SB1->B1_TIPO	:=	aDados[7]
	
	aDados	:={	{"B1_COD"	,"100007604"	,NIL},;
				{"B1_DESC"	,"PRODUTO TESTE",NIL},;
				{"B1_TIPO"	,"PA"			,NIL},;
				{"B1_UM"	,"UN"			,NIL},;
				{"B1_LOCPAD","01"			,NIL},;
				{"B1_GRUPO"	,""				,NIL}	}

	MsExecAuto({|x,y| Mata010(x,y)},aDados,nOpc)
	
	If lMsErroAuto
		MostraErro()
	Else
		Alert("Produto Incluído com sucesso!!!!")
	EndIf

	
Return

