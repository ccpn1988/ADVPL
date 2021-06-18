#Include 'Protheus.ch'
#Include 'ApWEBSRV.ch'

WsService XWsCliente Description "Informa��es dos Cliente"
	
	
	WsMethod PUTCliente Description "Incluir novo cliente"
		WsData cRet   as String 
		WsData StrCliente as  StructSA1 // Array
	
//----------------------------------------------------------------------------------------------------------	
	WsMethod GetTitulo Description "Titulo do Cliente"
		WsData CLIENTE as String
		WsData LOJA as String
		WsData Titulo as Array of StructTitulo // Array 
		
		WsStruct StructTitulo
			WsData E1_NUM      as String
			WsData E1_PARCELA  as String
			WsData E1_PREFIXO  as String
			WsData E1_TIPO     as String
			WsData E1_VENCREA  as date
			WsData E1_VALOR    as Float
			WsData E1_SALDO    as Float
		EndWsStruct	
		
	 WsStruct StructSA1
			WsData A1_COD     as String
			WsData A1_LOJA    as String
			WsData A1_NOME    as String
			WsData A1_PESSOA  as String
			WsData A1_NREDUZ  as String
			WsData A1_END     as String
			WsData A1_TIPO    as String
			WsData A1_EST     as String
			WsData A1_ESTADO  as String
			WsData A1_MUN     as String
		 EndWsStruct
//----------------------------------------------------------------------------------------------------------
WsMethod PUTCliente WsReceive StrCliente WsSend cRet WsService XWsCliente
//Exercicio fazer o execauto do cadastro de cliente
  
  Private lMsErroAuto := .F.
    
  aAdd(aDados,"A1_COD"     ,   StrCliente:A1_COD,    Nil)
  aAdd(aDados,"A1_LOJA"    ,   StrCliente:A1_LOJA,   Nil)
  aAdd(aDados,"A1_NOME"    ,   StrCliente:A1_NOME,   Nil)
  aAdd(aDados,"A1_PESSOA"  ,   StrCliente:A1_PESSOA, Nil)
  aAdd(aDados,"A1_NREDUZ"  ,   StrCliente:A1_NREDUZ, Nil)
  aAdd(aDados,"A1_END"     ,   StrCliente:A1_END,    Nil)
  aAdd(aDados,"A1_TIPO"    ,   StrCliente:A1_TIPO,   Nil)
  aAdd(aDados,"A1_EST"     ,   StrCliente:A1_EST,    Nil)
  aAdd(aDados,"A1_ESTADO"  ,   StrCliente:A1_ESTADO, Nil)
  aAdd(aDados,"A1_MUN"     ,   StrCliente:A1_MUN,    Nil)

  MSExecAuto({|x,y| Mata030(x,y)},aDados,3)

  if lMsErroAuto
	 MostraErro()
	 ::cRet := MostraErro()
	 //Self:cRet := MostraErro()
	 lRet := .f.
  Else
	 Alert("Cliente cadastrado com sucesso!!!!")
  Endif
  
  
  //Self:cRet := "Teste"
	
Return .T.
//----------------------------------------------------------------------------------------------------------
WsMethod GetTitulo WsReceive CLIENTE,LOJA WsSend Titulo WsService XWsCliente 
Local aDados := {} 
Local cAlias := GetNextAlias()
Local nCount := 1

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
			AND E1_CLIENTE  = %EXP:CLIENTE%
			AND E1_LOJA     = %EXP:LOJA%
			AND E1_SALDO   >  0
			AND %notDel%

EndSql 

aSql := GetLastQuery() //  informa��es sobre a query executada.
memowrite("c:\material\Sql.txt",aSql[2])	

dbSelectArea(cAlias)
(cAlias)->( dbGotop() )

If Empty((cAlias)->E1_NUM)
	 SetSoapFault( "Metodo n�o dispon�vel", "Dados Invalido" )
	Return .F.
Endif

While ! (cAlias)->( EOF() ) 
	aAdd(Titulo, WsClassNew("StructTitulo"))

	 Titulo[nCount]:E1_NUM     := (cAlias)->E1_NUM
	 Titulo[nCount]:E1_PARCELA := (cAlias)->E1_PARCELA 	
	 Titulo[nCount]:E1_PREFIXO := (cAlias)->E1_PREFIXO 
	 Titulo[nCount]:E1_TIPO    := (cAlias)->E1_TIPO    
	 Titulo[nCount]:E1_VENCREA := (cAlias)->E1_VENCREA 
	 Titulo[nCount]:E1_VALOR   := (cAlias)->E1_VALOR   
	 Titulo[nCount]:E1_SALDO   := (cAlias)->E1_SALDO   
	
	nCount++
	(cAlias)->( dbSkip() )
Enddo

(cAlias)->( DbCloseArea() )

Return .T.