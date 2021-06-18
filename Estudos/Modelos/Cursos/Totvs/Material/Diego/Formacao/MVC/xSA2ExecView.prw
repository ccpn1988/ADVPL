#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function xSa2ExecView()
	/*EXECUTAR INICIALIZA��O PADRAO*/
	//rpcSetEnv("99","01")
	oModel:=FwLoadModel('MATA020')
	
	/*ABRE POSICIONAMENTO PARA CARREGAR A ROTINA APENAS PARA UMA OPERA��O*/
	DbSelectArea('SA2')
	dbgoto(5)
	
	/*CARREGA O MODELO MANIPULANDO O DADO - SEGUE ALGUMA OPERA��O QUE PRECISA SER VERIFICADA*/
	FWExecView('Inclusao por FWExecView','MATA020M', 4 , , { || .T. })

Return (NIL)