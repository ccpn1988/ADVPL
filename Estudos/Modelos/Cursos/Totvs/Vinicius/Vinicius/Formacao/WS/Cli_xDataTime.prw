#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8099/ws/XWSHORARIODF.apw?WSDL
Gerado em        06/29/19 14:00:16
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _PBRMWQD ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSXWSHORARIODF
------------------------------------------------------------------------------- */

WSCLIENT WSXWSHORARIODF

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETDATA
	WSMETHOD GETHORA

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cX                        AS string
	WSDATA   dGETDATARESULT            AS date
	WSDATA   cGETHORARESULT            AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSXWSHORARIODF
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20171213 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSXWSHORARIODF
Return

WSMETHOD RESET WSCLIENT WSXWSHORARIODF
	::cX                 := NIL 
	::dGETDATARESULT     := NIL 
	::cGETHORARESULT     := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSXWSHORARIODF
Local oClone := WSXWSHORARIODF():New()
	oClone:_URL          := ::_URL 
	oClone:cX            := ::cX
	oClone:dGETDATARESULT := ::dGETDATARESULT
	oClone:cGETHORARESULT := ::cGETHORARESULT
Return oClone

// WSDL Method GETDATA of Service WSXWSHORARIODF

WSMETHOD GETDATA WSSEND cX WSRECEIVE dGETDATARESULT WSCLIENT WSXWSHORARIODF
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETDATA xmlns="http://localhost:8099/">'
cSoap += WSSoapValue("X", ::cX, cX , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETDATA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8099/GETDATA",; 
	"DOCUMENT","http://localhost:8099/",,"1.031217",; 
	"http://localhost:8099/ws/XWSHORARIODF.apw")

::Init()
::dGETDATARESULT     :=  WSAdvValue( oXmlRet,"_GETDATARESPONSE:_GETDATARESULT:TEXT","date",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETHORA of Service WSXWSHORARIODF

WSMETHOD GETHORA WSSEND cX WSRECEIVE cGETHORARESULT WSCLIENT WSXWSHORARIODF
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETHORA xmlns="http://localhost:8099/">'
cSoap += WSSoapValue("X", ::cX, cX , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETHORA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8099/GETHORA",; 
	"DOCUMENT","http://localhost:8099/",,"1.031217",; 
	"http://localhost:8099/ws/XWSHORARIODF.apw")

::Init()
::cGETHORARESULT     :=  WSAdvValue( oXmlRet,"_GETHORARESPONSE:_GETHORARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



