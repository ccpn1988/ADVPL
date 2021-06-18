#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:90/ws/HORARIO_DF.apw?WSDL
Gerado em        12/01/18 10:45:23
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _KWSNPMM ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSHORARIO_DF
------------------------------------------------------------------------------- */

WSCLIENT WSHORARIO_DF  

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETHORARIO

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCID                      AS string
	WSDATA   cGETHORARIORESULT         AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSHORARIO_DF
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.131227A-20171213 NG] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSHORARIO_DF
Return

WSMETHOD RESET WSCLIENT WSHORARIO_DF
	::cCID               := NIL 
	::cGETHORARIORESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSHORARIO_DF
Local oClone := WSHORARIO_DF():New()
	oClone:_URL          := ::_URL 
	oClone:cCID          := ::cCID
	oClone:cGETHORARIORESULT := ::cGETHORARIORESULT
Return oClone

// WSDL Method GETHORARIO of Service WSHORARIO_DF

WSMETHOD GETHORARIO WSSEND cCID WSRECEIVE cGETHORARIORESULT WSCLIENT WSHORARIO_DF
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETHORARIO xmlns="http://localhost:90/">'
cSoap += WSSoapValue("CID", ::cCID, cCID , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GETHORARIO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:90/GETHORARIO",; 
	"DOCUMENT","http://localhost:90/",,"1.031217",; 
	"http://localhost:90/ws/HORARIO_DF.apw")

::Init()
::cGETHORARIORESULT  :=  WSAdvValue( oXmlRet,"_GETHORARIORESPONSE:_GETHORARIORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



