#Include 'Protheus.ch'

User Function Escopo()

Local cLocal := "S� pode ser vista na fun��o que foi criada"
Static cStatic := "S� pode ser vista no PRW, mas n�o pode alterar o seu valor"
Private cPrivate := "Pode ser vista em outro PRW"
Public cPublic := "Pode ser vista em qualquer Thread"

escopo()
U_xPrivate()
/*S� funciona dentro de onde foi criada*/
msgInfo(cLocal)

Return

static Function escopo()

msgInfo(cStatic)


Return
