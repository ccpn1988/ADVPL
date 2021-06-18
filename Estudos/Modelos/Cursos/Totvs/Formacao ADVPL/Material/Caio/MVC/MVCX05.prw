#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function xSA2ExecView()
oModel := FWLoadModel('MATA020')

dbSelectArea('SA2')
dbGoto(5)

//CHAMANDO A VIEW DO XCUSTOMERVENDOR
FWExecView('Inclusao por FWExecView','VIEWDEF.MATA020M', 4, , {}

Return
