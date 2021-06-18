#Include 'Protheus.ch'

User Function Escopo()
	local clocal := "Só pode ser vista na função que foi criada"
	private cprivate := "Pode ser vista em outro PRW"
	static cstatic := "Só pode ser vista no .PRW, mas não pode alterar seu valor"
	public cpublic := "Pode ser vista em qualquer parte da Thread"
	escopo() 
	
Return

static function escopo() 

Msginfo(cstatic,"STATIC FUNC")
Msginfo(cprivate,"PRIVATE FUNC")
Msginfo(cpublic,"PUBLIC FUNC")

return
/*
local
static
private
public*/
