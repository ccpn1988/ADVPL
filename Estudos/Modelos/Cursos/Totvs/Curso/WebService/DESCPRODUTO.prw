#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:90/ws/PRODUTOO.apw?WSDL
Gerado em        12/01/18 12:51:37
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _MEQKMYM ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSPRODUTOO
------------------------------------------------------------------------------- */

WSCLIENT WSPRODUTOO

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETPRODU

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCPROD                    AS string
	WSDATA   cGETPRODURESULT           AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSPRODUTOO
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20171213 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSPRODUTOO
Return

WSMETHOD RESET WSCLIENT WSPRODUTOO
	::cCPROD             := NIL 
	::cGETPRODURESULT    := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSPRODUTOO
Local oClone := WSPRODUTOO():New()
	oClone:_URL          := ::_URL 
	oClone:cCPROD        := ::cCPROD
	oClone:cGETPRODURESULT := ::cGETPRODURESULT
Return oClone

// WSDL Method GETPRODU of Service WSPRODUTOO

WSMETHOD GETPRODU WSSEND cCPROD WSRECEIVE cGETPRODURESULT WSCLIENT WSPRODUTOO
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETPRODU xmlns="http://localhost:90/">'
cSoap += WSSoapValue("CPROD", ::cCPROD, cCPROD , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETPRODU>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:90/GETPRODU",; 
	"DOCUMENT","http://localhost:90/",,"1.031217",; 
	"http://localhost:90/ws/PRODUTOO.apw")

::Init()
::cGETPRODURESULT    :=  WSAdvValue( oXmlRet,"_GETPRODURESPONSE:_GETPRODURESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



