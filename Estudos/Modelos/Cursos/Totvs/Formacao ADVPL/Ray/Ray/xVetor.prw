#Include 'Protheus.ch'

User Function xVetor()

	Local aVar := {}
	Local aVar := {"A","C","D","B","F","H","G"}
	Local cMsg := ""
	Local cDia := 'Quinta'
	
	Private aSemana := Array(7)
	
	aSemana[1] := "Domingo"
	aSemana[2] := "Segunda"
	aSemana[3] := "Terça"
	aSemana[4] := "Quarta"
	aSemana[5] := "Quinta"
	aSemana[6] := "Sexta"
	aSemana[7] := "Sábado"


	
/*	For X = 1 to Len(aSemana)
		cMsg := cMsg + cValToChar(X) + ' - ' + aSemana[X] + CHR(13)
	Next
	
	MsgInfo(cMsg, "Dias da Semana")
*/	

/*	For x = 1 to Len(asemana)
		if UPPER(ALLTRIM(aSemana[x])) == UPPER(ALLTRIM(cDia))
			MsgInfo(cValToChar(x) + ' - ' + aSemana[x], "Dia da Semana")
			Break
		endif
	Next*/

	x := aScan(aSemana,"Quinta")
	If x > 0
		msgInfo(cValToChar(x) + " => " + aSemana[x])
	Endif

Return

//------------------------------------------------------------------
User function xParamBox()

	Local aPergs := {}
	Local cTexto := space(20)
	Local aRet := {}
	
	aAdd( aPergs, {1,"Campo Texto", cTexto, "@",'!Empty(mv_par01)',,'.T.',40,.T.})
	
	If Parambox(aPergs,"Digitar dados",aRet)
/*		nPOS := aScan(aSemana,{|x| UPPER(ALLTRIM(x)) == alltrim(upper(aRet[1]))})
		If nPos > 0
			MsgInfo(aSemana[nPos],"Dia da Semana")
*/
	Else
		MsgInfo("Operação Cancelada!")
	Endif
Return .T.