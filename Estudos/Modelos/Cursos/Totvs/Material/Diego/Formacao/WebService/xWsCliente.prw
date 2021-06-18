#Include 'Protheus.ch'
#INCLUDE "APWEBSRV.CH"

WsService xWsCliente Description "Informa��es dos Clientes"
	
	WsMethod PutCliente Description "Inmcluir um Cliente"
	WsData cRet as String
	WsData StrCliente as StructSA1 //Array de Informa��es
	/*as Array of - S� quando usamos uma Array - Para receber os Dados*/
			
	WsMethod getTitulo Description "Titulo do Cliente"
	WsData Cliente as String
	WsData Loja as String
	WsData Titulo as Array of StructTitulo //Array de Informa��es
	
	WsStruct StructTitulo
 		WsData E1_NUM as String
		WsData E1_PARCELA as String
		WsData E1_PREFIXO as String
		WsData E1_TIPO as String
		WsData E1_VENCREA as Date
		WsData E1_VALOR as Float
		WsData E1_SALDO as Float
	EndWsStruct		
			
	WsStruct StructSA1
		WsData A1_COD  	 as String
		WsData A1_LOJA   as String
		WsData A1_NOME   as String
		WsData A1_PESSOA as String
		WsData A1_NREDUZ as String
		WsData A1_END  	 as String
		WsData A1_TIPO   as String
		WsData A1_EST  	 as String
		WsData A1_ESTADO as String
		WsData A1_MUN  	 as String
	EndWsStruct
	
WsMethod PutCliente WsReceive StrCliente WsSend cRet WsService xWsCliente
	Local aDados := {}
	Local nOpc   := 3 // Incluir
	Private lMsErroAuto := .F.
	
	/*FUN��O PARA SIMULAR ABERTURA DO SISTEMA*/
	RpcSetEnv("99","01")
	
	//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" 
	aDados:= {{"A1_COD"   ,StrCliente:A1_COD	     ,NIL},;
             {"A1_LOJA"   ,StrCliente:A1_LOJA  		 ,NIL},;
             {"A1_NOME"   ,StrCliente:A1_NOME    	 ,Nil},;
             {"A1_PESSOA" ,StrCliente:A1_PESSOA      ,Nil},;
             {"A1_NREDUZ" ,StrCliente:A1_NREDUZ      ,Nil},;
             {"A1_END"    ,StrCliente:A1_END		 ,Nil},;
             {"A1_TIPO"   ,StrCliente:A1_TIPO   	 ,Nil},;
             {"A1_EST"	  ,StrCliente:A1_EST   		 ,Nil},;
             {"A1_ESTADO" ,StrCliente:A1_ESTADO		 ,Nil},;
             {"A1_MUN"    ,StrCliente:A1_MUN   		 ,Nil}}

	MSExecAuto({|x,y| Mata030(x,y)},aDados,nOpc)

	If lMsErroAuto
		MostraErro()
	Else
		Alert("Produto Incluido com sucesso!!!!")
	Endif
Return .T.
		
WsMethod GetTitulo WsReceive Cliente, Loja WsSend Titulo WsService xWsCliente
Local aDados := {} 
Local cAlias := GetNextAlias()
Local nCont := 1

BeginSql Alias cAlias
 	column E1_VENCREA as Date
 	
	Select E1_NUM,
		   E1_PARCELA,
	       E1_PREFIXO,
	       E1_TIPO,
	       E1_VENCREA,
	       E1_VALOR,
	       E1_SALDO
	From %Table:SE1% SE1
			Where E1_FILIAL = %xFILIAL:SE1%
			AND E1_CLIENTE  = %EXP:Cliente%
			AND E1_LOJA     = %EXP:Loja%
			AND E1_SALDO   >  0
			AND %notDel%
EndSql 

aSql := GetLastQuery() //  informa��es sobre a query executada.
memowrite("C:\Material\Sql.txt", aSql[2])

dbSelectArea(cAlias)
(cAlias)->(dbGotop())

if Empty((cAlias)->E1_NUM)
	setSoapFault("Metodo n�o dispon�vel","Dados Inv�lidos" )
	Return .F.
EndIf

While!(cAlias)->(EOF()) 	
	aAdd(Titulo,WSClassNew("StructTitulo"))
		Titulo[nCont]:E1_NUM 	 := (cAlias)->E1_NUM
		Titulo[nCont]:E1_PARCELA := (cAlias)->E1_PARCELA
		Titulo[nCont]:E1_PREFIXO := (cAlias)->E1_PREFIXO
		Titulo[nCont]:E1_TIPO 	 := (cAlias)->E1_TIPO
		Titulo[nCont]:E1_VENCREA := (cAlias)->E1_VENCREA
		Titulo[nCont]:E1_VALOR 	 := (cAlias)->E1_VALOR
		Titulo[nCont]:E1_SALDO 	 := (cAlias)->E1_SALDO
	nCont++
	(cAlias)->(dbskip())
 EndDo

(cAlias)->(dbclosearea())

Return .T.