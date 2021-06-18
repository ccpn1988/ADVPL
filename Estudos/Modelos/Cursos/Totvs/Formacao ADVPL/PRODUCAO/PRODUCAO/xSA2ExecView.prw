#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function xSA2ExecView()

oModel := FwLoadModel('MATA020')

dbselectArea('SA2')
dbgoto(5)

FWExecView('Inclusao por FWExecView','VIEWDEF.MATA020M', 4, ,{ || .T. } )

Return  

