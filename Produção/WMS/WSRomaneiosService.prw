#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://??.?.?.???:8080/integracaoDeposito/jws/WSRomaneios.jws?wsdl
Gerado em        07/29/16 15:42:09
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function WSWSRomaneiosService ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSRomaneiosService
------------------------------------------------------------------------------- */

WSCLIENT WSWSRomaneiosService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD consultaStatusRomaneio

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cidPedido                 AS string
	WSDATA   cconsultaStatusRomaneioReturn AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSRomaneiosService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20151103] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSRomaneiosService
Return

WSMETHOD RESET WSCLIENT WSWSRomaneiosService
	::cidPedido          := NIL 
	::cconsultaStatusRomaneioReturn := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSRomaneiosService
Local oClone := WSWSRomaneiosService():New()
	oClone:_URL          := ::_URL 
	oClone:cidPedido     := ::cidPedido
	oClone:cconsultaStatusRomaneioReturn := ::cconsultaStatusRomaneioReturn
Return oClone

// WSDL Method consultaStatusRomaneio of Service WSWSRomaneiosService

WSMETHOD consultaStatusRomaneio WSSEND cidPedido WSRECEIVE cconsultaStatusRomaneioReturn WSCLIENT WSWSRomaneiosService
Local cSoap 	:= "" , oXmlRet
Local cIpProd	:= SuperGetMv("GEN_IPPRDT",.f.,"")
Local cIpTst	:= SuperGetMv("GEN_IPTSTT",.f.,"10.3.0.72:8080")
Local cTpServ	:= SuperGetMv("GEN_TPWSWM",.f.,"TESTE")
Local cIp		:= ""

BEGIN WSMETHOD

cSoap += '<q1:consultaStatusRomaneio xmlns:q1="http://www.w3.org/2001/XMLSchema">'
cSoap += WSSoapValue("idPedido", ::cidPedido, cidPedido , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:consultaStatusRomaneio>"

If cTpServ == "PRODUCAO"
	cIp := cIpProd
Else
	cIp := cIpTst
EndIf

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"",; 
	"RPCX","http://"+cIp+"/integracaoDeposito/jws/WSRomaneios.jws",,,; 
	"http://"+cIp+"/integracaoDeposito/jws/WSRomaneios.jws")   
		
::Init()
::cconsultaStatusRomaneioReturn :=  WSAdvValue( oXmlRet,"_CONSULTASTATUSROMANEIORETURN","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



