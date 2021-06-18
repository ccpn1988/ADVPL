#Include 'Protheus.ch'

User Function Escopo()

Local cLocal := "Só pode ser vista na função que foi criada"
Static cStatic := "Só pode ser vista no PRW, mas não pode alterar o seu valor"
Private cPrivate := "Pode ser vista em outro PRW"
Public cPublic := "Pode ser vista em qualquer Thread"

escopo()
U_xPrivate()
/*Só funciona dentro de onde foi criada*/
msgInfo(cLocal)

Return

static Function escopo()

msgInfo(cStatic)


Return
