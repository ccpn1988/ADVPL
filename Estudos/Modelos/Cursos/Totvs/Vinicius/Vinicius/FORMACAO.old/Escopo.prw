#Include 'Protheus.ch'

User Function Escopo()
Local cLocal	:= "S� pode ser vista na fun��o que foi criada"
Static cStatic	:= "pode ser vista no PRW, mas n�o pode alterar seu valor"
Private cPrivate	:="Pode ser vista em outro PRW"
Public cPublic	:= "Pode ser vista em qualquer parte da Thread"

escopo()
U_xPrivate()

MsgInfo(cLocal)

Return

Static Function escopo() //Pode isso?

MsgInfo(cStatic)


return