#include "Protheus.ch"

User Function xEscopo()

Local   cLocal     :=  "S� pode ser Vista na fun��o que foi criada"
Static  cStatic     :=  "Pode ser vista no PRW, mais n�o pode alterar o seu valor"
Private cPrivate   :=  "Pode ser vista em outro PRW"
Public  cPublic    :=  "Pode ser vista em qualquer parte da Thread"

//Escopo()
//U_xPrivate()
//U_XFor()

Return

Static Function escopo() //Pode Isso?

       Msginfo(clocal)
       Msginfo(cStatic)
       Msginfo(cPrivate)
       Msginfo(cPublic)

return


//--< fim de arquivo >----------------------------------------------------------------------
