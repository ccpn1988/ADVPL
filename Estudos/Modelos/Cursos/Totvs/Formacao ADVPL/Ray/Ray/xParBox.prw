#Include 'Protheus.ch'

User Function xParBox()

	Local aRet := {}
	Local aParambox := {}
	Local i := 0
	
	aAdd(aParambox,{1,"Produto",Space(15),"","","SB1","",0,.T.})
	
	If ParamBox(aParamBox,"Teste Parâmetros...",@aRet)
	   For i:=1 To Len(aRet)
	      MsgInfo(aRet[i],"Opção escolhida")
	   Next 
	Endif 
	
Return

