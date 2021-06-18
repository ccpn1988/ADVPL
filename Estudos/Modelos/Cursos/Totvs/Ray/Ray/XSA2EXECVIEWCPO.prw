#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function xSA2ExecView()

	oModelX	:= FwLoadModel('MATA020')
	oModelX:SetOperation(3)
	oModelX:Activate()

	oField := oModelX:GetModel(/*"MATA020_SA2"*/)
	
	oField:SetValue("A2_COD" ,"XXXX"  )
	oField:SetValue("A2_LOJA","01"    )
	oField:SetValue("A2_NOME","HEROLD")

	FWExecView('Inclusao por FWExecView','MATA020M', MODEL_OPERATION_INSERT, , { || .T. },,,/*aButtons*/,/*bCancel*/,/*cOperatId*/,/*cTollBar*/,oModelX)

/* variable is not an object  on FWFORMVIEW:GETMODELSTRUCT(FWFORMVIEW.PRW)
	 03/01/2018 17:40:20 line : 1161*/

Return