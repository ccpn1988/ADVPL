#Include 'Protheus.ch'

User Function xMatriz()
	
	Local cMsg := ""
	Local aMatriz := {}
	private aMatriz2 := Array(2,3)

	
	aMatriz2[1,1] := "Maria"
	aMatriz2[1,2] := 30
	aMatriz2[1,3] := "F"
	
	aMatriz2[2,1] := "ANA"
	aMatriz2[2,2] := 42
	aMatriz2[2,3] := "F"
	
	aAdd(aMatriz2, {"Bruno" ,25,"M" })
	aAdd(aMatriz2, {"Antonio" ,32,"M" })
	aAdd(aMatriz2, {"João" ,48,"M" })
	aAdd(aMatriz2, {"José" ,26,"M" })
	
	xSortMatriz(2)
	
	For x = 1 to len(aMatriz2)
		For y = 1 to len(aMatriz2[x])
			cMsg += UPPER(LTRIM(cValToChar(aMatriz2[x,y]))) + ';' + chr(9)
		Next
		cMsg += CHR(13)
	Next
	
	MsgInfo(cMsg)

	xFindMatriz(48)
	
Return

//---------------------------------------

Static function xFindMatriz(cBusca)
	For x = 1 to len(aMatriz2)
		For y = 1 to len(aMatriz2[x])
//			nPos := aScan(aMatriz2[x],;
//				{|y| UPPER(LTRIM(cValToChar(y))) == UPPER(LTRIM(cValToChar(cBusca)))})
			if UPPER(ALLTRIM( cValToChar(aMatriz2[x,y]))) == UPPER(ALLTRIM(cValToChar(cBusca)))
				MsgInfo("O achei em: " + chr(13) + "Linha: " + cValToChar(x) +;
					chr(13) + "Coluna: " + cValtoChar(y))
				Break
			endif
		Next
	Next
	Msginfo("não achei nada!!!")
Return

//---------------------------------------

Static function xSortMatriz(nIndice)
	aSort(aMatriz2,,, {|x, y| x[nIndice] < y[nIndice]})
Return