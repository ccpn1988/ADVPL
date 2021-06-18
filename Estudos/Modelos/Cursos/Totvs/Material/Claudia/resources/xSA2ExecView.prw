#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function xSA2ExecView()

//rpcSetEnv{"99","01"}

oModel := FwLoadModel('MATA020')
dbselectarea('SA2')
DBGOTO(5)

//oModel:SetOperation(3)
//oModel:Activate()

FWExecView('Inclusao por FWExecView','VIEWDEF.MATA020M', 4, , { || .T. }) //,,,/*aButtons*/,/*bCancel*/,/*OperatId*/, )
//FWExecModalView([ cTitulo ], <cPrograma >, [ nOperation ], [ bOk ], [ bCancel ], [ nWidth ], <nHeigth >)-> NIL

Return