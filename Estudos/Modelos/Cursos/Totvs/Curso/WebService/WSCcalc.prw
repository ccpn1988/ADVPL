#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://dneonline.com/calculator.asmx?wsdl
Gerado em        12/01/18 08:43:45
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _NOBJIMR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCalculator
------------------------------------------------------------------------------- */

WSCLIENT WSCalculator

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD Add       //Metodo para utilizar no fonte para tratar o webservice
	WSMETHOD Subtract  //Metodo para utilizar no fonte para tratar o webservice
	WSMETHOD Multiply  //Metodo para utilizar no fonte para tratar o webservice
	WSMETHOD Divide    //Metodo para utilizar no fonte para tratar o webservice

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nintA                     AS int
	WSDATA   nintB                     AS int
	WSDATA   nAddResult                AS int
	WSDATA   nSubtractResult           AS int
	WSDATA   nMultiplyResult           AS int
	WSDATA   nDivideResult             AS int

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCalculator
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20171213 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCalculator
Return

WSMETHOD RESET WSCLIENT WSCalculator
	::nintA              := NIL 
	::nintB              := NIL 
	::nAddResult         := NIL 
	::nSubtractResult    := NIL 
	::nMultiplyResult    := NIL 
	::nDivideResult      := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCalculator
Local oClone := WSCalculator():New()
	oClone:_URL          := ::_URL 
	oClone:nintA         := ::nintA
	oClone:nintB         := ::nintB
	oClone:nAddResult    := ::nAddResult
	oClone:nSubtractResult := ::nSubtractResult
	oClone:nMultiplyResult := ::nMultiplyResult
	oClone:nDivideResult := ::nDivideResult
Return oClone

// WSDL Method Add of Service WSCalculator

WSMETHOD Add WSSEND nintA,nintB WSRECEIVE nAddResult WSCLIENT WSCalculator
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<Add xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("intA", ::nintA, nintA , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("intB", ::nintB, nintB , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Add>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/Add",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://dneonline.com/calculator.asmx")

::Init()
::nAddResult         :=  WSAdvValue( oXmlRet,"_ADDRESPONSE:_ADDRESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Subtract of Service WSCalculator

WSMETHOD Subtract WSSEND nintA,nintB WSRECEIVE nSubtractResult WSCLIENT WSCalculator
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<Subtract xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("intA", ::nintA, nintA , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("intB", ::nintB, nintB , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Subtract>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/Subtract",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://dneonline.com/calculator.asmx")

::Init()
::nSubtractResult    :=  WSAdvValue( oXmlRet,"_SUBTRACTRESPONSE:_SUBTRACTRESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Multiply of Service WSCalculator

WSMETHOD Multiply WSSEND nintA,nintB WSRECEIVE nMultiplyResult WSCLIENT WSCalculator
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<Multiply xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("intA", ::nintA, nintA , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("intB", ::nintB, nintB , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Multiply>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/Multiply",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://dneonline.com/calculator.asmx")

::Init()
::nMultiplyResult    :=  WSAdvValue( oXmlRet,"_MULTIPLYRESPONSE:_MULTIPLYRESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Divide of Service WSCalculator

WSMETHOD Divide WSSEND nintA,nintB WSRECEIVE nDivideResult WSCLIENT WSCalculator
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<Divide xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("intA", ::nintA, nintA , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("intB", ::nintB, nintB , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Divide>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/Divide",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://dneonline.com/calculator.asmx")

::Init()
::nDivideResult      :=  WSAdvValue( oXmlRet,"_DIVIDERESPONSE:_DIVIDERESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



