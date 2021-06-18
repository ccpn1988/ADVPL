#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

WsService WsClien Description "Informações de Cliente"

	WsMethod PutCliente Description "Dados do Cliente"
		WsData cRet	  as String
		WsData StrCliente as StructSA1 //ARRAy

	
	WsMethod GetTitulo Description "Títulos do Cliente"
		WsData CLIENTE as String
		WsData LOJA    as String
		WsData Titulo  as Array of StructTitulo //ARRAY

//CADASTRANDO A ESTRUTURA 

		WsStruct StructTitulo
			WsData E1_NUM		as String
			WsData E1_PARCELA   as String
			WsData E1_PREFIXO   as String
			WsData E1_TIPO      as String
			WsData E1_VENCREA   as Date
			WsData E1_VALOR     as Float
			WsData E1_SALDO     as Float
		EndWsStruct

		WsStruct StructSA1
			WsData A1_COD     as String
			WsData A1_LOJA    as String
			WsData A1_NOME    as String
			WsData A1_PESSOA  as String
			WsData A1_NREDUZ  as String
			WsData A1_END     as String
			WsData A1_BAIRRO  as String
			WsData A1_TIPO    as String
			WsData A1_EST     as String
			WsData A1_ESTADO  as String
			WsData A1_CEP     as String
			WsData A1_COD_MUN as String
			WsData A1_MUN     as String
		EndWsStruct

WsMethod PutCliente WsReceive StrCliente WsSend cRet WsService WsClien
Local aDados := {} 
Local nOpc := 3
Local lMsErroAuto := .F. 

aAdd(aDados,"A1_COD    " , StrCliente:A1_COD    , NIL)
aAdd(aDados,"A1_LOJA   " , StrCliente:A1_LOJA   , NIL)
aAdd(aDados,"A1_NOME   " , StrCliente:A1_NOME   , NIL)
aAdd(aDados,"A1_PESSOA " , StrCliente:A1_PESSOA , NIL)
aAdd(aDados,"A1_NREDUZ " , StrCliente:A1_NREDUZ , NIL)
aAdd(aDados,"A1_END    " , StrCliente:A1_END    , NIL)
aAdd(aDados,"A1_BAIRRO " , StrCliente:A1_BAIRRO , NIL)
aAdd(aDados,"A1_TIPO   " , StrCliente:A1_TIPO   , NIL)
aAdd(aDados,"A1_EST    " , StrCliente:A1_EST    , NIL)
aAdd(aDados,"A1_ESTADO " , StrCliente:A1_ESTADO , NIL)
aAdd(aDados,"A1_CEP    " , StrCliente:A1_CEP    , NIL)
aAdd(aDados,"A1_COD_MUN" , StrCliente:A1_COD_MUN, NIL)
aAdd(aDados,"A1_MUN    " , StrCliente:A1_MUN    , NIL)

MSExecAuto({|x,y| Mata030(x,y)},aCliente,nOpc) //Inclusao
                    
    If lMsErroAuto
         ::cRet := MostraErro()
         //Selfie:cRet :=
 	   Else
         ::cRet := "Produto incluido com sucesso"
         //Selfie:cRet :=
    Endif	
	
Return .T.

//--------------------------------------------------------------------------------------------------------------------------		

WsMethod GetTitulo WsReceive CLIENTE,LOJA WsSend Titulo WsService WsClien
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

aSql := GetLastQuery() //  informações sobre a query executada.
//memowrite("C:\totvs 12\Microsiga\Sql.txt",aSql[2])	

dbSelectArea(cAlias)
(cAlias)->( dbGotop() )

IF Empty((cAlias)->E1_NUM)
	SetSoapFaault("Metodo não disponivel", "Dados Inválido")
	Return .F.
EndIF

While ! (cAlias)->( EOF() ) 
	aAdd(Titulo,WsClassNew("StructTitulo"))
		
	Titulo[nCount]:E1_NUM 	  := (cAlias)->E1_NUM
	Titulo[nCount]:E1_PARCELA := (cAlias)->E1_PARCELA 
	Titulo[nCount]:E1_PREFIXO := (cAlias)->E1_PREFIXO 
	Titulo[nCount]:E1_TIPO    := (cAlias)->E1_TIPO    
	Titulo[nCount]:E1_VENCREA := (cAlias)->E1_VENCREA 
	Titulo[nCount]:E1_VALOR   := (cAlias)->E1_VALOR   
	Titulo[nCount]:E1_SALDO   := (cAlias)->E1_SALDO   
	
	nCount++
	(cAlias)->(dbSkip() )
EndDo
(cAlias)->(dbCloseArea() )



	
Return .T.

