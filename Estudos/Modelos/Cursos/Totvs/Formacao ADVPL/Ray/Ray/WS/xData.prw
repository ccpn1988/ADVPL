#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8099/ws/XDATA.apw?WSDL
Gerado em        06/29/19 13:59:43
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _HYUUFQL ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSXDATA
------------------------------------------------------------------------------- */

WSCLIENT WSXDATA

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETDATA

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cX                        AS string
	WSDATA   dGETDATARESULT            AS date

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSXDATA
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.131227A-20171213 NG] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSXDATA
Return

WSMETHOD RESET WSCLIENT WSXDATA
	::cX                 := NIL 
	::dGETDATARESULT     := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSXDATA
Local oClone := WSXDATA():New()
	oClone:_URL          := ::_URL 
	oClone:cX            := ::cX
	oClone:dGETDATARESULT := ::dGETDATARESULT
Return oClone

// WSDL Method GETDATA of Service WSXDATA

WSMETHOD GETDATA WSSEND cX WSRECEIVE dGETDATARESULT WSCLIENT WSXDATA
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETDATA xmlns="http://localhost:8099/">'
cSoap += WSSoapValue("X", ::cX, cX , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETDATA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8099/GETDATA",; 
	"DOCUMENT","http://localhost:8099/",,"1.031217",; 
	"http://localhost:8099/ws/XDATA.apw")

::Init()
::dGETDATARESULT     :=  WSAdvValue( oXmlRet,"_GETDATARESPONSE:_GETDATARESULT:TEXT","date",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



