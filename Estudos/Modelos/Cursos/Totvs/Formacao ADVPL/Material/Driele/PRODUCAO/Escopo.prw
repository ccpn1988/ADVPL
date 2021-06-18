#include "Protheus.ch"

User Function xEscopo()

Local   cLocal     :=  "Só pode ser Vista na função que foi criada"
Static  cStatic     :=  "Pode ser vista no PRW, mais não pode alterar o seu valor"
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
