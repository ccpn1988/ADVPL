#Include 'Protheus.ch'
//consumir o serviço
User Function xQualquerNome()

Local OWs := WSXWSDATADF():New()

if oWs:GETDATA('12')
   MsgInfo(oWs:dGETDATARESULT)
Else
   Msginfo(GetWscError())
   Msginfo(GetWscError(2))
   Msginfo(GetWscError(3))
Endif

Return

