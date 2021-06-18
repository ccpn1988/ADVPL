#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

//Não utiliza os campos Function

WsService PRODUTOO Description "Informar a descricao do produto" //WsService - substitui o User Function

	WsMethod GetProdu Description "Descricao do Produto" //Cria o metodo GetHorario
	WsMethod GetListProdu Description "Cadastro do Produto" //Cria o metodo GetListProdu
	WsMethod PutProduto Description "Insert cadastro do Produto" //Cria o metodo PutProduto

		WsData cProd    as String //Cria a variavel cProd como string
		WsData cDesc    as String //Cria a variavel cDesc como string
		
		WsData RetSB1   as Array of TABELASB1
		
		WsData aInpSB1  as TABELASB1
		WsData Mensagem as String

EndWsService //EndWsService - substitui o Return

//Comandos para retornar varios dados de uma tabela
WsStruct TABELASB1
WsData B1_COD      as String
WsData B1_DESC     as String
WsData B1_UM       as String
WsData B1_LOCPAD   as String
WsData B1_TIPO     as String
WsData B2_SALDO    as Float
EndWsStruct

//-----------------------------------------------------------------------------------------

WsMethod PutProduto WsReceive aInpSB1 WsSend Mensagem WsService PRODUTOO 
Local aVetor := {}
Local lMsErroAuto := .F.

//Exercicio - Fazer a gravação dados na tabela SB1 via execAuto
//Possui exemplo no projeto

//DbSelectArea("SB1")    

	aVetor := { {"B1_COD"   ,::aInpSB1:B1_COD   , nil },;
		        {"B1_DESC"  ,::aInpSB1:B1_DESC  , nil },;
		        {"B1_UM"    ,::aInpSB1:B1_UM    , nil },;
		        {"B1_LOCPAD",::aInpSB1:B1_LOCPAD, nil },;
		        {"B1_ORIGEM", "1"               , nil },;
		        {"B1_TIPO"  ,::aInpSB1:B1_TIPO  , nil } }
		      //{B2_SALDO ,::aInpSB1:B2_SALDO  } }
		
MSExecAuto({|x,y| Mata010(x,y)},aVetor,3)

If lMsErroAuto
	
	::Mensagem := "Erro"
	
Else

	::Mensagem := "Gravado com sucesso"
	
EndIf


Return .T.

//-----------------------------------------------------------------------------------------

WsMethod GetListProdu WsReceive cProd WsSend RetSB1 WsService PRODUTOO //Nun utilizar o NULLPARAM fora da sua rede
Local lRet := .T.
Local cAlias := GetNextAlias() //GetNextAlias() - retorna uma area generia para a tabela

BeginSql Alias cAlias

	COLUMN B2_SALDO as Numeric(10,2)
	Select B1_COD,
	       B1_DESC,
	       B1_UM,
	       B1_LOCPAD,
	       B1_TIPO,
	       (B2_QATU - B2_RESERVA - B2_QEMP) as B2_SALDO
	From %TABLE:SB1% SB1 Left join %TABLE:SB2% SB2 ON B1_COD = B2_COD AND B2_FILIAL = %xFilial:SB2% and SB2.%NotDel%
		Where B1_FILIAL = %xFilial:SB1%
		  and B1_MSBLQL <> '1'
		  and SB1.%NotDel%
		 
EndSql

DbSelectArea(cAlias) 
DbGoTop()

nCount := 1
While ! EOF()

	aAdd(RetSB1, WsClassNew("TABELASB1")) //WsClassNew - Nova estrutura
	
		RetSB1[nCount]:B1_COD    := (cAlias)->B1_COD
	    RetSB1[nCount]:B1_DESC   := (cAlias)->B1_DESC
	    RetSB1[nCount]:B1_UM     := (cAlias)->B1_UM
	    RetSB1[nCount]:B1_LOCPAD := (cAlias)->B1_LOCPAD
	    RetSB1[nCount]:B1_TIPO   := (cAlias)->B1_TIPO
	    RetSB1[nCount]:B2_SALDO  := (cAlias)->B2_SALDO
	
	nCount++
	DbSkip()
	
EndDo

Return lRet

//-----------------------------------------------------------------------------------------

WsMethod GetProdu WsReceive cProd WsSend cDesc WsService PRODUTOO
Local lRet := .F.

DbSelectArea("SB1")
dbSetOrder(1)

	If MsSeek(xFilial("SB1")+cProd)
	
	::cDesc := SB1->B1_DESC //:: - Retorna o objeto
	lRet := .T.
	
	Else
	    
	    //Trata a mensagem de erro ao informa um valor invalido
	                //Titulo - Mensagem
		SetSoapFault("Token","Informar um token valido") //Define os valores default do soap
		
	EndIf
	
Return .T.