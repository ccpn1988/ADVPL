#Include 'Protheus.ch'

User Function Escopo()

Local	cLocal		:= "S� pode ser vista na fun��o que foi criada"
Static	cStatic		:= "Pode ser vista no PRW, mas n�o pode alterar seu valor"
Private	cPrivate	:= "Pode ser vista em outro PRW" 
Public	cPublic		:= "Pode ser vista em qualquer parte da Thread"

escopo()

U_xPrivate()

MsgInfo(cLocal)

Return

Static Function escopo() //Pode isso?

MsgInfo(cStatic)
MsgInfo(cPrivate)
MsgInfo(cPublic)

Return


/*
User Function Escopo()

Local	cLocal		:= "S� pode ser vista na fun��o que foi criada"
Static	cStatic		:= "Pode ser vista no PRW, mas n�o pode alterar seu valor"
Private	cPrivate	:= "Pode ser vista em outro PRW" 
Public	cPublic		:= "Pode ser vista em qualquer parte da Thread"

escopo(@cLocal)

MsgInfo(cLocal)

Return

Static Function escopo(vcLocal) //Pode isso?

MsgInfo(vcLocal)
MsgInfo(cStatic)
MsgInfo(cPrivate)
MsgInfo(cPublic)

vcLocal := "Teste"

Return
*/