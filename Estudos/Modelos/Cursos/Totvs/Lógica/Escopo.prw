#Include 'Protheus.ch'

User Function Escopo()
	local clocal := "S� pode ser vista na fun��o que foi criada"
	private cprivate := "Pode ser vista em outro PRW"
	static cstatic := "S� pode ser vista no .PRW, mas n�o pode alterar seu valor"
	public cpublic := "Pode ser vista em qualquer parte da Thread"
	escopo() 
	U_xPRIVATE()
Return

static function escopo() 

Msginfo(cstatic)
Msginfo(cprivate)
Msginfo(cpublic)

return
/*
local
static
private
public*/
