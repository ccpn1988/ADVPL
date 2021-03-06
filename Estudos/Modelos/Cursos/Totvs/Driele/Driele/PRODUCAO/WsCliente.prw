#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

WsService xWsCliente Description "Informa??es dos Cliente"
	WsMethod GetTitulo Description "Titulo do Cliente"
	WsData CLIENTE as String
	Wsdata LOJA as String
	Wsdata Titulo as Array of StrucTitulo //Array
	
	WsStruct StrucTitulo
		WsData E1_NUM  as String
		WsData E1_PARCELA as String
		WsData E1_PREFIXO as String
		WsData E1_TIPO    as String
		WsData E1_VENCREA as Date
		WsData E1_VALOR  as Float
		WsData E1_SALDO  as Float
	EndWsStruct

WsMethod GetTitulo WsReceive CLIENTE, LOJA WsSend Titulo wsService xWsCliente
		
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
	
	aSql := GetLastQuery() //  informa??es sobre a query executada.
	
	
	dbSelectArea(cAlias)
	(cAlias)->( dbGotop() )
	
		
If Empty ((cAlias)->E1_NUM)
    SetSoapFault ("Metodo n?o disponivel","Dados Invalido")
    Return .F.
Endif   
	
	While ! (cAlias)->(EOF() )
	
	aAdd (Titulo, WsClassNew("StrucTitulo"))
	
	Titulo[nCount]:E1_NUM     :=(cAlias)->E1_NUM
	Titulo[nCount]:E1_PARCELA :=(cAlias)->E1_PARCELA
	Titulo[nCount]:E1_PREFIXO :=(cAlias)->E1_PREFIXO
	Titulo[nCount]:E1_TIPO    :=(cAlias)->E1_TIPO
	Titulo[nCount]:E1_VENCREA :=(cAlias)->E1_VENCREA 
	Titulo[nCount]:E1_VALOR   :=(cAlias)->E1_VALOR
	Titulo[nCount]:E1_SALDO   :=(cAlias)->E1_SALDO
	 
	nCount++
	
	(cAlias)->(dbSkip())
	Enddo
	
	(cAlias)->(DbCloseArea())
 	
Return .T.

