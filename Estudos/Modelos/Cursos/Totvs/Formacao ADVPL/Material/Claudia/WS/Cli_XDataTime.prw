#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
///client
/* ===============================================================================
WSDL Location    http://localhost:8099/ws/XWSDATADF.apw?WSDL
Gerado em        06/29/19 14:00:30
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _RGQQZSI ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSXWSDATADF
------------------------------------------------------------------------------- */

WSCLIENT WSXWSDATADF

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETDATA

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cX                        AS string
	WSDATA   cGETDATARESULT            AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSXWSDATADF
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20171213 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSXWSDATADF
Return

WSMETHOD RESET WSCLIENT WSXWSDATADF
	::cX                 := NIL 
	::cGETDATARESULT     := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSXWSDATADF
Local oClone := WSXWSDATADF():New()
	oClone:_URL          := ::_URL 
	oClone:cX            := ::cX
	oClone:cGETDATARESULT := ::cGETDATARESULT
Return oClone

// WSDL Method GETDATA of Service WSXWSDATADF

WSMETHOD GETDATA WSSEND cX WSRECEIVE cGETDATARESULT WSCLIENT WSXWSDATADF
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETDATA xmlns="http://localhost:8099/">'
cSoap += WSSoapValue("X", ::cX, cX , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETDATA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8099/GETDATA",; 
	"DOCUMENT","http://localhost:8099/",,"1.031217",; 
	"http://localhost:8099/ws/XWSDATADF.apw")

::Init()
::cGETDATARESULT     :=  WSAdvValue( oXmlRet,"_GETDATARESPONSE:_GETDATARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



