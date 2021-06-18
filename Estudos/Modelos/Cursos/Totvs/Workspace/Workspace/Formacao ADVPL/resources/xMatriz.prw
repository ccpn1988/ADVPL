#Include 'Protheus.ch'

User Function xMatriz()
//	Local aMatriz	:= {}
	Local aMatriz2	:= Array(2,3)
	Local x,y 		:= 0
	Local cMsg 		:= ""
	
	aMatriz2[1,1]	:= "Maria"
	aMatriz2[1,2]	:= 30
	aMatriz2[1,3]	:= "F"
	
	aMatriz2[2,1]	:= "Ana"
	aMatriz2[2,2]	:= 42
	aMatriz2[2,3]	:= "F"
	
	aAdd(aMatriz2, {"Bruno  ",48,"M"} )
	aAdd(aMatriz2, {"Antonio",32,"M"} )
	aAdd(aMatriz2, {"João   ",48,"M"} )
	aAdd(aMatriz2, {"José   ",26,"M"} )
	
	/* TESTE EXIBIR 1 POR 1 NA TELA */
	For x := 1 To Len(aMatriz2)
		MsgInfo("Nome: " + aMatriz2[x,1] + CRLF + ;
				"Idade: " + cValToChar( aMatriz2[x,2] ) + CRLF + ;
				"Sexo: " + Iif(aMatriz2[x,3]=="M","Masculino","Feminino"),;
				"TESTE 1 POR 1" )
	Next x
	
	/* TESTE VALIDAÇÃO POR IDADE */
	cMsg := ""
	For x := 1 To Len(aMatriz2)
		If aMatriz2[x,2] == 48
			cMsg += ("Nome: " + aMatriz2[x,1] + CRLF + ;
					 "Idade: " + cValToChar( aMatriz2[x,2] ) + CRLF + ;
					 "Sexo: " + Iif(aMatriz2[x,3]=="M","Masculino","Feminino") + CRLF +CRLF)
		EndIf
	Next x
	MsgInfo(cMsg,"TESTE POR IDADE")
	
	/* TESTE COM PERFUMARIA */
	cMsg := ""
	For x := 1 To Len(aMatriz2)
		For y := 1 To Len(aMatriz2[x])
			Do Case
				Case y == 1
					cMsg += "Nome:  " + aMatriz2[x][y] + CHR(9)
				Case y == 2
					cMsg += "Idade: " + cValToChar(aMatriz2[x][y]) + CHR(9)
				OtherWise
					cMsg += "Sexo:  " + Iif(aMatriz2[x][y] == "M","Masculino","Feminino" ) + CRLF + CRLF
			EndCase
		Next y
	Next x
		
	MsgInfo(cMsg,"TESTE COM PERFUMARIA")
	
	/*TESTE COM BLOCO DE CODIGOS*/
	cMsg := ""
	nPos := aScan(aMatriz2,{|X| X[2] == 48 } )
	If nPos > 0
		cMsg += cValToChar(nPos) + " - " + aMatriz2[nPos][1] + " - " + ;
				cValToChar(aMatriz2[nPos,2]) + " - " + ;
				Iif(aMatriz2[nPos][3] == "M","Masculino","Feminino" ) + CHR(13)
	EndIf
	
	MsgInfo(cMsg,"TESTE COM BLOCO DE CODIGOS")
	
	/* TESTE ASORT COM PERFUMARIA */
	cMsg := ""
	//aSort( <aDados>, <nInicio>, <nCont>     , <bOrdem>            )
	aSort(   aMatriz2,          ,Len(aMatriz2),{ |X,Y| cValToChar(X[2])+X[1] <  cValToChar(Y[2])+Y[1] } ) 
	
	For x := 1 To Len(aMatriz2)
		For y := 1 To Len(aMatriz2[x])
			Do Case
				Case y == 1
					cMsg += "Nome:  " + aMatriz2[x][y] + CHR(9)
				Case y == 2
					cMsg += "Idade: " + cValToChar(aMatriz2[x][y]) + CHR(9)
				OtherWise
					cMsg += "Sexo:  " + Iif(aMatriz2[x][y] == "M","Masculino","Feminino" ) + CRLF + CRLF
			EndCase
		Next y
	Next x
		
	MsgInfo(cMsg,"TESTE ASORT IDADE/NOME")
	
Return