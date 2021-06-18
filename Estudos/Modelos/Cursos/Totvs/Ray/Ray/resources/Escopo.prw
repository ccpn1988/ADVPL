#Include 'Protheus.ch'

User Function Escopo()

Local cLocal := "Só pode ser vista na função que foi criada"
Static cStatic := "Pode ser vista no PRW, mas não pode alterar seu valor"
Private cPrivate := "Pode ser vista em outro PRW"
Public cPublic := "Pode ser vista em qualquer parte da Thread"

escopo()

xPrivate()

Msginfo(clocal)

Return

Static function escopo() //pode isso?

Msginfo(cstatic)


return
