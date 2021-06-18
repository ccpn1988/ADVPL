#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8099/ws/XWSDATAATUAL.apw?WSDL
Gerado em        06/29/19 14:00:16
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _HEOLQAD ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSXWSDATAATUAL
------------------------------------------------------------------------------- */

WSCLIENT WSXWSDATAATUAL

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETDATAATUAL
	WSMETHOD GETHORARIO

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCENVIO                   AS string
	WSDATA   dGETDATAATUALRESULT       AS date
	WSDATA   cGETHORARIORESULT         AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSXWSDATAATUAL
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20171213 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSXWSDATAATUAL
Return

WSMETHOD RESET WSCLIENT WSXWSDATAATUAL
	::cCENVIO            := NIL 
	::dGETDATAATUALRESULT := NIL 
	::cGETHORARIORESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSXWSDATAATUAL
Local oClone := WSXWSDATAATUAL():New()
	oClone:_URL          := ::_URL 
	oClone:cCENVIO       := ::cCENVIO
	oClone:dGETDATAATUALRESULT := ::dGETDATAATUALRESULT
	oClone:cGETHORARIORESULT := ::cGETHORARIORESULT
Return oClone

// WSDL Method GETDATAATUAL of Service WSXWSDATAATUAL

WSMETHOD GETDATAATUAL WSSEND cCENVIO WSRECEIVE dGETDATAATUALRESULT WSCLIENT WSXWSDATAATUAL
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETDATAATUAL xmlns="http://localhost:8099/">'
cSoap += WSSoapValue("CENVIO", ::cCENVIO, cCENVIO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETDATAATUAL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8099/GETDATAATUAL",; 
	"DOCUMENT","http://localhost:8099/",,"1.031217",; 
	"http://localhost:8099/ws/XWSDATAATUAL.apw")

::Init()
::dGETDATAATUALRESULT :=  WSAdvValue( oXmlRet,"_GETDATAATUALRESPONSE:_GETDATAATUALRESULT:TEXT","date",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETHORARIO of Service WSXWSDATAATUAL

WSMETHOD GETHORARIO WSSEND cCENVIO WSRECEIVE cGETHORARIORESULT WSCLIENT WSXWSDATAATUAL
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETHORARIO xmlns="http://localhost:8099/">'
cSoap += WSSoapValue("CENVIO", ::cCENVIO, cCENVIO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETHORARIO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8099/GETHORARIO",; 
	"DOCUMENT","http://localhost:8099/",,"1.031217",; 
	"http://localhost:8099/ws/XWSDATAATUAL.apw")

::Init()
::cGETHORARIORESULT  :=  WSAdvValue( oXmlRet,"_GETHORARIORESPONSE:_GETHORARIORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



