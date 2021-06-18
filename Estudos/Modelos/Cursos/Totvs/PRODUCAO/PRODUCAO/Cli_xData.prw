#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8099/ws/XWSDATA.apw?WSDL
Gerado em        06/29/19 14:00:31
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _HNPRYMF ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSXWSDATA
------------------------------------------------------------------------------- */

WSCLIENT WSXWSDATA

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

WSMETHOD NEW WSCLIENT WSXWSDATA
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.131227A-20171213 NG] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSXWSDATA
Return

WSMETHOD RESET WSCLIENT WSXWSDATA
	::cX                 := NIL 
	::cGETDATARESULT     := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSXWSDATA
Local oClone := WSXWSDATA():New()
	oClone:_URL          := ::_URL 
	oClone:cX            := ::cX
	oClone:cGETDATARESULT := ::cGETDATARESULT
Return oClone

// WSDL Method GETDATA of Service WSXWSDATA

WSMETHOD GETDATA WSSEND cX WSRECEIVE cGETDATARESULT WSCLIENT WSXWSDATA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETDATA xmlns="http://localhost:8099/">'
cSoap += WSSoapValue("X", ::cX, cX , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETDATA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8099/GETDATA",; 
	"DOCUMENT","http://localhost:8099/",,"1.031217",; 
	"http://localhost:8099/ws/XWSDATA.apw")

::Init()
::cGETDATARESULT     :=  WSAdvValue( oXmlRet,"_GETDATARESPONSE:_GETDATARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



