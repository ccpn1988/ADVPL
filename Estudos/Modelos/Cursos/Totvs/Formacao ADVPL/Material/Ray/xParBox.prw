#Include 'Protheus.ch'

User Function xParBox()

	Local aRet := {}
	Local aParambox := {}
	Local i := 0
	
	aAdd(aParambox,{1,"Produto",Space(15),"","","SB1","",0,.T.})
	
	If ParamBox(aParamBox,"Teste Par�metros...",@aRet)
	   For i:=1 To Len(aRet)
	      MsgInfo(aRet[i],"Op��o escolhida")
	   Next 
	Endif 
	
Return

