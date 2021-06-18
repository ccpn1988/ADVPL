#Include 'Protheus.ch'

User Function xQualquerNome()
Local oWs := WSXWSDATA():New()

If oWs:GETDATA ('12')
   MsgInfo(oWs:dGETDATARESULT)
   Else
    MsgInfo(GETWscError())
    MsgInfo(GETWscError(2))
    MsgInfo(GETWscError(3)) 
Endif   

Return

