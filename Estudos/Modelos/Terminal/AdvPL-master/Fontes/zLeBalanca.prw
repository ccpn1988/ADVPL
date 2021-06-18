//Bibliotecas
#Include "Protheus.ch"

//Constantes
#Define MAX_BUFFER     22     //M�ximo de caracter por linha (buffer)
#Define MSECONDS_WAIT  5000   //Tempo de espera

/*/{Protheus.doc} zTstBalan
Fun��o para testar a integra��o com balan�as
@author Atilio
@since 07/04/2018
@version 1.0
@type function
/*/

User Function zTstBalan()
	Local nPesoRet := 0
	
	nPesoRet := u_zLeBalanca("TOLEDO")
	
	Alert("Peso Lido: "+cValToChar(nPesoRet))
Return nPesoRet

/*/{Protheus.doc} zLeBalanca
Fun��o para fazer uma integra��o com balan�a via AdvPL
@author Atilio
@since 07/04/2018
@version 1.0
@param cMarca, characters, Marca da balan�a que ser� lida
@type function
@obs O fonte original foi criado em 2013, depois foi adaptado por Wallace Freitas em 2015, e agora est� sendo reescrito em 2018
	As marcas testadas foram:
	- Toledo
	- L�der
	- Jundia�
	- Confian�a
	
	Foi usado como base, o artigo dispon�vel em http://advpl-protheus.blogspot.com.br/2013/09/integracao-protheus-x-balanca-via.html
@example u_zLeBalanca("TOLEDO")
/*/

User Function zLeBalanca(cMarca)
	Local nPesoRet
	Local cPorta    := ""
	Local cVelocid  := ""
	Local cParidade := "" 
	Local cBits     := ""
	Local cStopBits := ""
	Local cFluxo    := ""
	Local nTempo    := ""
	Local cConfig   := ""
	Local lRet      := .T.
	Local nH        := 0
	Local cBuffer   := ""
	Local nPosFim   := 0
	Local nPosIni   := 0
	Local nX        := 0
	Local cPesoLido := ""
    Default cMarca  := ""
    
    //Se houver marca
    If ! Empty(cMarca)
    	cMarca := Upper(Alltrim(cMarca))
    	
    	//Pegando a porta padr�o da balan�a
    	cPorta    := SuperGetMV("MV_X_PORTA",.F.,"COM1")
    	
	    //Modelo Confian�a
		If (cMarca=="CONFIANCA")
			cVelocid  := SuperGetMV("MV_X_VELOC", .F., "9600")   //Velocidade
			cParidade := SuperGetMV("MV_X_PARID", .F., "n")      //Paridade
			cBits     := SuperGetMV("MV_X_BITS",  .F., "8")      //Bits
			cStopBits := SuperGetMV("MV_X_SBITS", .F., "1")      //Stop Bit
			cFluxo    := SuperGetMV("MV_X_FLUXO", .F., "")       //Controle de Fluxo
			nTempo    := SuperGetMV("MV_X_TEMPO", .F., 5)        //Tempo
			
		//Jundia�
		ElseIf (cMarca == "JUNDIAI")
			cVelocid  := SuperGetMV("MV_X_VELOC", .F., "9600")   //Velocidade
			cParidade := SuperGetMV("MV_X_PARID", .F., "n")      //Paridade
			cBits     := SuperGetMV("MV_X_BITS",  .F., "8")      //Bits
			cStopBits := SuperGetMV("MV_X_SBITS", .F., "0")      //Stop Bit
			cFluxo    := SuperGetMV("MV_X_FLUXO", .F., "")       //Controle de Fluxo
			nTempo    := SuperGetMV("MV_X_TEMPO", .F., 5)        //Tempo
			
		//Toledo
		ElseIf (cMarca == "TOLEDO")
			cVelocid  := SuperGetMV("MV_X_VELOC", .F.,"4800")    //Velocidade
			cParidade := SuperGetMV("MV_X_PARID", .F.,"N")       //Paridade
			cBits     := SuperGetMV("MV_X_BITS",  .F.,"8")       //Bits
			cStopBits := SuperGetMV("MV_X_SBITS", .F.,"1")       //Stop Bit
			cFluxo    := SuperGetMV("MV_X_FLUXO", .F.,"")        //Controle de Fluxo
			nTempo    := SuperGetMV("MV_X_TEMPO", .F.,5)         //Tempo
		
		//L�der
		ElseIf (cMarca == "LIDER")
			cVelocid  := SuperGetMV("MV_X_VELOC", .F.,"4800")    //Velocidade
			cParidade := SuperGetMV("MV_X_PARID", .F.,"N")       //Paridade
			cBits     := SuperGetMV("MV_X_BITS",  .F.,"8")       //Bits
			cStopBits := SuperGetMV("MV_X_SBITS", .F.,"1")       //Stop Bit
			cFluxo    := SuperGetMV("MV_X_FLUXO", .F.,"")        //Controle de Fluxo
			nTempo    := SuperGetMV("MV_X_TEMPO", .F.,5)         //Tempo
		
		//Qualquer balan�a que utilize porta serial
		Else
			cVelocid  := SuperGetMV("MV_X_VELOC", .F.,"9600")    //Velocidade
			cParidade := SuperGetMV("MV_X_PARID", .F.,"n")       //Paridade
			cBits     := SuperGetMV("MV_X_BITS",  .F.,"8")       //Bits
			cStopBits := SuperGetMV("MV_X_SBITS", .F.,"1")       //Stop Bit
			cFluxo    := SuperGetMV("MV_X_FLUXO", .F.,"")        //Controle de Fluxo
			nTempo    := SuperGetMV("MV_X_TEMPO", .F.,5)         //Tempo
		EndIf
	    
		//Se a marca da balan�a for LIDER
		If cMarca == "LIDER"
			//Montando a configura��o (Porta:Velocidade,Paridade,Bits,Stop)
			cConfig := cPorta+":"+cVelocid+","+cParidade+","+cBits+","+cStopBits
				
			//Guarda resultado se houve abertura da porta
			lRet := MSOpenPort(@nH,cConfig)
			
			//Se n�o conseguir abrir a porta, mostra mensagem e finaliza
			If !lRet
		    	MsgStop("<b>Falha</b> ao conectar com a porta serial. Detalhes:"+;
		    			"<br><b>Porta:</b> "		+cPorta+;
		    			"<br><b>Velocidade:</b> "	+cVelocid+;
		    			"<br><b>Paridade:</b> "		+cParidade+;
		    			"<br><b>Bits:</b> "			+cBits+;
		    			"<br><b>Stop Bits:</b> "	+cStopBits,"Aten��o")
		    				
			Else
				//Realiza a leitura
				For nX := 1 To 50
					//Obtendo o tempo de espera antes de iniciar a leitura da balan�a	
					Sleep(nTempo)
					MSRead(nH,@cBuffer)
					
					//Se a linha retornada for igual ao tamanho limite, encerra o la�o
					If Len(AllTrim(cBuffer)) == MAX_BUFFER
						Exit
					EndIf
				Next nX	
				
				//Verifica onde come�a o "E" e diminui 1 caracter
				nPosFim := At("E", cBuffer) - 1
				
				//Obtendo apenas o peso da balan�a
				cPesoLido := StrTran(AllTrim(SubStr(cBuffer,2,nPosFim)),".","")
			EndIf
			
			//Encerra a conex�o com a porta
			MSClosePort(nH,cConfig)
		
		//Se for a Toledo
		ElseIf cMarca == "TOLEDO"
			//Montando a configura��o (Porta:Velocidade,Paridade,Bits,Stop)
			cConfig := cPorta+":"+cVelocid+","+cParidade+","+cBits+","+cStopBits
			
			//Guarda resultado se houve abertura da porta
			lRet := MSOpenPort(@nH,cConfig)
			lOk  := .T.
			
			//Se n�o conseguir abrir a porta, tenta mais uma vez, remapeando
			If ! lRet
				//For�a o fechamento e abertura da porta novamente
				WaitRun("NET USE "+cPorta+": /DELETE")
				WaitRun("NET USE "+cPorta+" ")
				
				lOk := MSOpenPort(@nH,cConfig)
				
				If !lOk
			    	MsgStop("<b>Falha</b> ao conectar com a porta serial. Detalhes:"+;
			    			"<br><b>Porta:</b> "		+cPorta+;
			    			"<br><b>Velocidade:</b> "	+cVelocid+;
			    			"<br><b>Paridade:</b> "		+cParidade+;
			    			"<br><b>Bits:</b> "			+cBits+;
			    			"<br><b>Stop Bits:</b> "	+cStopBits,"Aten��o")
		    	EndIf
			EndIf
			
			If lOk
				//Inicializa balan�a
				MsWrite(nH,CHR(5))
				nTaman := 16
				
				//Realiza a leitura
				For nX := 1 To 50
					//Obtendo o tempo de espera antes de iniciar a leitura da balan�a e realiza a leitura	
					Sleep(nTempo)
					MSRead(nH,@cBuffer)
					
					//Obtendo os caracteres inciais
					cBuffer := AllTrim(SubStr(AllTrim(cBuffer),1,nTaman))
					
					//Se a linha retornada for igual ao tamanho limite
					If Len(AllTrim(cBuffer)) >= nTaman
						Exit
					EndIf
				Next nX	
				
				
				//Verifica onde come�a o "q" e soma 2 espa�os
				nPosIni := At("q",cBuffer)+2
	
				//Obtendo apenas o peso da balan�a
				cPesoLido := SubStr(cBuffer,nPosIni,nPosIni+3)
			EndIf
			
			//Encerra a conex�o com a porta
			MSClosePort(nH,cConfig)
		EndIf	
		
		//Converte o peso obtido para inteiro e o atribui a variavel de retorno
		nPesoRet := Val(cPesoLido)
		
	//Outras balan�as
	Else
		//Montando a configura��o (Porta:Velocidade,Paridade,Bits,Stop)
		cConfig := cPorta+":"+cVelocid+","+cParidade+","+cBits+","+cStopBits
	
		//Guarda resultado se houve abertura da porta
		lRet := msOpenPort(@nH,cConfig)
	
		//Se n�o conseguir abrir a porta, mostra mensagem e finaliza
		If(!lRet)
			//Se for barra, tentar na confian�a, depois na jundiai
	    	MsgStop("<b>Falha</b> ao conectar com a porta serial. Detalhes:"+;
	    			"<br><b>Porta:</b> "		+cBPorta+;
	    			"<br><b>Velocidade:</b> "	+cBVeloc+;
	    			"<br><b>Paridade:</b> "		+cBParid+;
	    			"<br><b>Bits:</b> "			+cBBits+;
	    			"<br><b>Stop Bits:</b> "	+cBStop,"Aten��o")
	    	cLido := 0
		EndIf
	
		//Se estiver OK
		If lRet
			If (cMarca == "JUNDIAI" .Or. cMarca == "CONFIANCA")
				//Mandando mensagem para a porta COM
				msWrite(nH,Chr(5))
				Sleep(nTempo)
	
				//Pegando o tempo final
				cSegNor:=Time()
				cSegAcr:=SubStr(Time(),1,5)+":"+cValToChar(Val(SubStr(Time(),7,2)) + nTempo)
	
				If (cMarca == "JUNDIAI")
					//Enquanto os tempos forem diferentes
					While(cSegNor != cSegAcr)
						//Lendo os dados
						msRead(nH,@cBuffer)
	
						//Se n�o estiver em branco
					    if(!Empty(cBuffer))
					    	cLido := Alltrim(cBuffer)
					    EndIf
	
					    //Atualizando o tempo
						cSegNor:=SubStr(cSegNor,1,5)+":"+cValToChar(Val(SubStr(cSegNor,7,2)) + 1)
					EndDo
					
				//Sen�o, se for confian�a, enquanto o tamanho for menor, ler o conte�do
				ElseIf (cMarca == "CONFIANCA")
					cLido := ''
					nCont := 1
					
					//Enquanto os tempos forem diferentes
					While(Len(cLido) < 16)
						//Lendo os dados
						msRead(nH,@cBuffer)
						Sleep(200)
	
						//Somando o valor lido com o buffer
					    cLido += cBuffer
	
					    //Aumentando o contador
					    nCont++
					    If nCont >= 30
					    	If MsgYesNo('Houve <b>30 tentativas</b> de ler o peso, deseja parar?','Aten��o')
					    		cLido:=Space(17)
					    		Exit
					    	Else
					    		nCont := 1
					    	EndIf
					    EndIf
	
					EndDo
				EndIf
	
				cLido   := Upper(cLido)
				nPosFim := (At('K',cLido) - 1)

				//Pegando a Posi��o Inicial
				For nAux:=1 To Len(cLido)
					//Se o caracter atual estiver contido no intervalo de 0 a 9 e ponto
					If(SubStr(cLido,nAux,1) $ '0123456789.')
						nPosIni:=nAux
						Exit
					EndIf
				Next
				
				nPesoRet := Val(cLido)
			EndIf
		EndIf
		
		msClosePort(nH,cConfig)
	EndIf
	
Return nPesoRet

/*
Abaixo o Fonte Original, escrito em 2013:

/*---------------------------------------------------------------------------------------------*
 | Autor: Daniel Atilio                                                                        |
 | Data:  01/10/2013                                                                           |
 | Desc:  Fun��o que l� a porta serial e retorna a string obtida                               |
 | Ref.:  http://advpl-protheus.blogspot.com.br/2013/09/integracao-protheus-x-balanca-via.html |
 *---------------------------------------------------------------------------------------------* /

//Bibliotecas
#Include "Protheus.ch"
#Include "RwMake.ch"

//Fun��os que l� a porta serial e retorna a string lida
//lTipo    == .F.              -> Ir� retornar a string completa
//lTipo    == .T.              -> Ir� retornar somente o valor num�rico
//cBalanca == 'NOME_BALANCA'
//cTipoVar == 'N'              -> retorna apenas n�mero (Val)
//cCom     == 'PORTA_CONEXAO'
User Function LeSerial(lTipo,cBalanca,cTipoVar,cCom)
	Local cLido:=""
	Local cCfg :=""//"COM1:4800,n,8,1"
	Local nH:=0
	Local lRet:=.F.
	Local cSegAcr:=""
	Local cSegNor:=""
	Local cBuffer:=""
	Local lTipo := .F.
	Local nPeso

	Private cBPorta := cCom	//Porta
	Private cBVeloc			//Velocidade
	Private cBParid			//Paridade
	Private cBBits			//Bits
	Private cBStop			//Stop Bit
	Private cBContr			//Controle de Fluxo
	Private cBTempo			//Tempo
	Private cPeso := ""

	//Par�metros, utilizados na Confian�a (modelo 312-E)
	If (cBalanca=="CONFIANCA")
		If Empty(cBPorta)
			cBPorta := SuperGetMV("MV_X_CPOR",.F.,"COM1")	//Porta
		EndIf
		cBVeloc := SuperGetMV("MV_X_CVEL",.F.,"9600")	//Velocidade
		cBParid := SuperGetMV("MV_X_CPAR",.F.,"n")		//Paridade
		cBBits  := SuperGetMV("MV_X_CBIT",.F.,"8")		//Bits
		cBStop  := SuperGetMV("MV_X_CSTO",.F.,"1")		//Stop Bit
		cBContr := SuperGetMV("MV_X_CCON",.F.,"")		//Controle de Fluxo
		cBTempo := SuperGetMV("MV_X_CTEM",.F.,"5")		//Tempo
	ElseIf (cBalanca == "JUNDIAI")
		If Empty(cBPorta)
			cBPorta := SuperGetMV("MV_X_JPOR",.F.,"COM4")	//Porta
		EndIf
		cBVeloc := SuperGetMV("MV_X_JVEL",.F.,"9600")	//Velocidade
		cBParid := SuperGetMV("MV_X_JPAR",.F.,"n")		//Paridade
		cBBits  := SuperGetMV("MV_X_JBIT",.F.,"8")		//Bits
		cBStop  := SuperGetMV("MV_X_JSTO",.F.,"0")		//Stop Bit
		cBContr := SuperGetMV("MV_X_JCON",.F.,"")		//Controle de Fluxo
		cBTempo := SuperGetMV("MV_X_JTEM",.F.,"5")		//Tempo
	ElseIf (cBalanca == "TOLEDO")
		If Empty(cBPorta)
			cBPorta := SuperGetMV("MV_X_TPOR",.F.,"COM3")	//Porta
		EndIf
		cBVeloc := SuperGetMV("MV_X_TVEL",.F.,"4800")	//Velocidade
		cBParid := SuperGetMV("MV_X_TPAR",.F.,"S")		//Paridade
		cBBits  := SuperGetMV("MV_X_TBIT",.F.,"7")		//Bits
		cBStop  := SuperGetMV("MV_X_TSTO",.F.,"1")		//Stop Bit
		cBContr := SuperGetMV("MV_X_TCON",.F.,"")		//Controle de Fluxo
		cBTempo := SuperGetMV("MV_X_TTEM",.F.,"5")		//Tempo
	//Qualquer balan�a que utilize porta serial
	Else
		If Empty(cBPorta)
			cBPorta := SuperGetMV("MV_X_BPOR",.F.,"COM1")	//Porta
		EndIf
		cBVeloc := SuperGetMV("MV_X_BVEL",.F.,"9600")	//Velocidade
		cBParid := SuperGetMV("MV_X_BPAR",.F.,"n")		//Paridade
		cBBits  := SuperGetMV("MV_X_BBIT",.F.,"8")		//Bits
		cBStop  := SuperGetMV("MV_X_BSTO",.F.,"1")		//Stop Bit
		cBContr := SuperGetMV("MV_X_BCON",.F.,"")		//Controle de Fluxo
		cBTempo := SuperGetMV("MV_X_BTEM",.F.,"5")		//Tempo

		cLido := 0
		lTipo := .T. 									//N�o passa pela leitura
	EndIf

	//Montando a configura��o (Porta:Velocidade,Paridade,Bits,Stop)
	cCfg:=cBPorta+":"+cBVeloc+","+cBParid+","+cBBits+","+cBStop

	//Guarda resultado se houve abertura da porta
	lRet := msOpenPort(@nH,cCfg)

	//Se n�o conseguir abrir a porta, mostra mensagem e finaliza
	If(!lRet)
		//Se for barra, tentar na confian�a, depois na jundiai
    	MsgStop("<b>Falha</b> ao conectar com a porta serial. Detalhes:"+;
    			"<br><b>Porta:</b> "		+cBPorta+;
    			"<br><b>Velocidade:</b> "	+cBVeloc+;
    			"<br><b>Paridade:</b> "		+cBParid+;
    			"<br><b>Bits:</b> "			+cBBits+;
    			"<br><b>Stop Bits:</b> "	+cBStop,"Aten��o")
    	cLido := 0
	EndIf

	//Se estiver em branco o conte�do
	If !lTipo .And. lRet
		If (cBalanca == "JUNDIAI" .Or. cBalanca == "CONFIANCA")
			//Mandando mensagem para a porta COM
			msWrite(nH,Chr(5))
			If(cBalanca == "JUNDIAI") //Jundiai, 200 milissegundos. Confian�a, 500
				Sleep(200)
			ElseIf(cBalanca == "CONFIANCA")
				Sleep(500)
			EndIf

			//Pegando o tempo final
			cSegNor:=Time()
			cSegAcr:=SubStr(Time(),1,5)+":"+cValToChar(Val(SubStr(Time(),7,2)) + Val(cBTempo))

			If (cBalanca == "JUNDIAI")
				//Enquanto os tempos forem diferentes
				While(cSegNor!=cSegAcr)
					//Lendo os dados
					msRead(nH,@cBuffer)

					//Se n�o estiver em branco
				    if(!Empty(cBuffer))
				    	cLido:=Alltrim(cBuffer)
				        //Exit
				    EndIf

				    //Atualizando o tempo
					cSegNor:=SubStr(cSegNor,1,5)+":"+cValToChar(Val(SubStr(cSegNor,7,2)) + 1)
				EndDo
			//Sen�o, se for confian�a, enquanto o tamanho for menor, ler o conte�do
			ElseIf (cBalanca == "CONFIANCA")
				cLido := ''
				nCont := 1
				//Enquanto os tempos forem diferentes
				While(Len(cLido) < 16)
					//Lendo os dados
					msRead(nH,@cBuffer)
					sleep(200)

					//Somando o valor lido com o buffer
				    cLido+=cBuffer

				    //Aumentando o contador
				    nCont++
				    If nCont >= 30
				    	If MsgYesNo('Houve <b>30 tentativas</b> de ler o peso, deseja parar?','Aten��o')
				    		cLido:=Space(17)
				    		Exit
				    	Else
				    		nCont := 1
				    	EndIf
				    EndIf

				EndDo
			EndIf

			//Se for a Jundiai
			If (cBalanca == "JUNDIAI")
				SoPeso2(@cLido)
			ElseIf (cBalanca == "CONFIANCA")
				SoPeso(@cLido)
				//Alert(cLido)
			EndIf

			//Se estiver em branco, retorna erro
			If Empty(cLido)
				cLido="ERRO NA LEITURA"
			EndIf

			cLido:=StrTran(cLido,',','.')

			//Se o retorno for num�rico
			If cTipoVar == 'N'
				cLido  := Val(cLido)
			Else
				__nVal := Val(cLido)
				cLido  := cValToChar(__nVal)
			EndIf
			cLido := Int(cLido)
		ElseIf (cBalanca == "TOLEDO")
			For nX := 1 To 50
				Sleep(100)
				MSRead(nH,@cBuffer)
				//If(!Empty(cBuffer))
				If(Len(cBuffer) == 16)
					cPeso += cValToChar(cBuffer)
					Exit
				EndIf
			Next nX
			nPosIni := At("`",cPeso)
			nPosIni := nPosIni+2
			cPeso   := SubStr(cPeso,nPosIni,6)

			MSClosePort(nH,cCfg)
			If !Empty(cPeso)
				nPeso := Val(cPeso)/100
				nPeso := Round(nPeso,0)
				cLido := nPeso
			Else
				nPeso:=0
				cLido := nPeso
			EndIf
		EndIf
	EndIf

	msClosePort(nH,cCfg)

Return cLido

//Fun��o que retorna somente o peso lido da String
Static Function SoPeso(cVar)
	Local nPosIni := 0
	Local nPosFim := 0
	Local nAux	  := 0

	//Pegando a Posi��o Final, se tiver k min�sculo, ser� a posi��o, dele, sen�o o mai�sculo
	nPosFim:=Iif(('k' $ cVar),(At('k',cVar) - 1),(At('K',cVar) - 1))

	//Pegando a Posi��o Inicial
	For nAux:=1 To Len(cVar)
		//Se o caracter atual estiver contido no intervalo de 0 a 9 e ponto
		If(SubStr(cVar,nAux,1) $ '0123456789.')
			nPosIni:=nAux
			Exit
		EndIf
	Next
	//Pegando somente o valor
	cVar:=SubStr(cVar,nPosIni,nPosFim-nPosIni)
Return

//Fun��o que retorna somente o peso lido da String
Static Function SoPeso2(cVar)
	Local nPosIni := 0
	Local nPosFim := 0
	Local nAux	  := 0

	//Alert("'"+cVar+"'")

	//Pegando a Posi��o Final, se tiver k min�sculo, ser� a posi��o, dele, sen�o o mai�sculo
	nPosFim:=Iif(('k' $ cVar),(At('k',cVar) - 1),(At('K',cVar) - 1))

	//Pegando a Posi��o Inicial
	For nAux:=1 To Len(cVar)
		//Se o caracter atual estiver contido no intervalo de 0 a 9 e ponto
		If(SubStr(cVar,nAux,1) $ '0123456789.')
			nPosIni:=nAux
			Exit
		EndIf
	Next

	//Pegando somente o valor
	cVar:=SubStr(cVar,nPosIni,nPosFim-nPosIni+1)
	//Alert("'"+cVar+"'")
Return
*/