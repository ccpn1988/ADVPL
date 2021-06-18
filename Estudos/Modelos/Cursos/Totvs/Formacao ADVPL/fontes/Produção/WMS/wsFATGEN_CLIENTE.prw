#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://??.?.?.???:8070/wsfatgen/WSFATGEN.apw?WSDL
Gerado em        08/05/16 13:42:36
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function WSWSFATGEN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSFATGEN
------------------------------------------------------------------------------- */

WSCLIENT WSWSFATGEN

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD WSCANCROMA
	WSMETHOD WSCORTEPED
	WSMETHOD WSGERANFE

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cWS_PARAMETRO             AS string
	WSDATA   cWSCANCROMARESULT         AS string
	WSDATA   cWSCORTEPEDRESULT         AS string
	WSDATA   cWSGERANFERESULT          AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSFATGEN
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20151103] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSFATGEN
Return

WSMETHOD RESET WSCLIENT WSWSFATGEN
	::cWS_PARAMETRO      := NIL 
	::cWSCANCROMARESULT  := NIL 
	::cWSCORTEPEDRESULT  := NIL 
	::cWSGERANFERESULT   := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSFATGEN
Local oClone := WSWSFATGEN():New()
	oClone:_URL          := ::_URL 
	oClone:cWS_PARAMETRO := ::cWS_PARAMETRO
	oClone:cWSCANCROMARESULT := ::cWSCANCROMARESULT
	oClone:cWSCORTEPEDRESULT := ::cWSCORTEPEDRESULT
	oClone:cWSGERANFERESULT := ::cWSGERANFERESULT
Return oClone

// WSDL Method WSCANCROMA of Service WSWSFATGEN

WSMETHOD WSCANCROMA WSSEND cWS_PARAMETRO WSRECEIVE cWSCANCROMARESULT WSCLIENT WSWSFATGEN
Local cSoap := "" , oXmlRet

Local cIpProd	:= SuperGetMv("GEN_IPPROD",.f.,"")
Local cIpTst	:= SuperGetMv("GEN_IPTEST",.f.,"10.3.0.72:8070")
Local cTpServ	:= SuperGetMv("GEN_TPWSWM",.f.,"TESTE")
Local cIpAux	:= IIF( cTpServ == "PRODUCAO" , cIpProd , cIpTst )


BEGIN WSMETHOD

cSoap += '<WSCANCROMA xmlns="http://'+cIpAux+'/">'
cSoap += WSSoapValue("WS_PARAMETRO", ::cWS_PARAMETRO, cWS_PARAMETRO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSCANCROMA>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://"+cIpAux+"/WSCANCROMA",; 
	"DOCUMENT","http://"+cIpAux+"/",,"1.031217",; 
	"http://"+cIpAux+"/wsfatgen/WSFATGEN.apw")

::Init()
::cWSCANCROMARESULT  :=  WSAdvValue( oXmlRet,"_WSCANCROMARESPONSE:_WSCANCROMARESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method WSCORTEPED of Service WSWSFATGEN

WSMETHOD WSCORTEPED WSSEND cWS_PARAMETRO WSRECEIVE cWSCORTEPEDRESULT WSCLIENT WSWSFATGEN
Local cSoap := "" , oXmlRet

Local cIpProd	:= SuperGetMv("GEN_IPPROD",.f.,"")
Local cIpTst	:= SuperGetMv("GEN_IPTEST",.f.,"10.3.0.72:8070")
Local cTpServ	:= SuperGetMv("GEN_TPWSWM",.f.,"TESTE")
Local cIpAux	:= IIF( cTpServ == "PRODUCAO" , cIpProd , cIpTst )

BEGIN WSMETHOD

cSoap += '<WSCORTEPED xmlns="http://'+cIpAux+'/">'
cSoap += WSSoapValue("WS_PARAMETRO", ::cWS_PARAMETRO, cWS_PARAMETRO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSCORTEPED>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://"+cIpAux+"/WSCORTEPED",; 
	"DOCUMENT","http://"+cIpAux+"/",,"1.031217",; 
	"http://"+cIpAux+"/wsfatgen/WSFATGEN.apw")

::Init()
::cWSCORTEPEDRESULT  :=  WSAdvValue( oXmlRet,"_WSCORTEPEDRESPONSE:_WSCORTEPEDRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method WSGERANFE of Service WSWSFATGEN

WSMETHOD WSGERANFE WSSEND cWS_PARAMETRO WSRECEIVE cWSGERANFERESULT WSCLIENT WSWSFATGEN
Local cSoap := "" , oXmlRet

Local cIpProd	:= SuperGetMv("GEN_IPPROD",.f.,"")
Local cIpTst	:= SuperGetMv("GEN_IPTEST",.f.,"10.3.0.72:8070")
Local cTpServ	:= SuperGetMv("GEN_TPWSWM",.f.,"TESTE")
Local cIpAux	:= IIF( cTpServ == "PRODUCAO" , cIpProd , cIpTst )

BEGIN WSMETHOD

cSoap += '<WSGERANFE xmlns="http://'+cIpAux+'/">'
cSoap += WSSoapValue("WS_PARAMETRO", ::cWS_PARAMETRO, cWS_PARAMETRO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSGERANFE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://"+cIpAux+"/WSGERANFE",; 
	"DOCUMENT","http://"+cIpAux+"/",,"1.031217",; 
	"http://"+cIpAux+"/wsfatgen/WSFATGEN.apw")

::Init()
::cWSGERANFERESULT   :=  WSAdvValue( oXmlRet,"_WSGERANFERESPONSE:_WSGERANFERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



