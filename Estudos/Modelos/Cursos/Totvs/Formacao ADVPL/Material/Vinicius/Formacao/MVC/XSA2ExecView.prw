#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function xSA2ExecView()

oModel := FwLoadModel('MATA020')

DbSelectArea('SA2')
DbGoto(5)
FWExecView('Inclusao por FWExecView','MATA020M', 4, , { || .T. })

Return