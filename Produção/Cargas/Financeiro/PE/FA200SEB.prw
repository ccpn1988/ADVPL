
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA200SEB  ºAutor  ³Cleuto Lima         º Data ³  26/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na rotnia FINA200.PRX para validar o       º±±
±±º          ³posicionamento do titulo.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                         

User Function FA200SEB()

Local nTamPre  		:= TamSX3("E1_PREFIXO")[1]
Local nTamNum  		:= TamSX3("E1_NUM")[1]
Local nTamPar  		:= TamSX3("E1_PARCELA")[1]
Local nTamTit		:= nTamPre+nTamNum+nTamPar
Local lFWCodFil 	:= FindFunction("FWCodFil")
Local lGestao   	:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
Local lNewIndice	:= FaVerInd()  //Verifica a existencia dos indices de IDCNAB sem filial
Local cFilFwSE1 	:= IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("SE1") , xFilial("SE1") )

If SEE->EE_CODIGO == "033"
	cEspecie	:= Substr(cTipo,1,3)
	
	If DDataBase <= CtoD("31/12/2017")
		If (mv_par13 == 2 .And. lNewIndice) .And. !Empty( cFilFwSE1 )
			//Busca por IdCnab (sem filial)
			SE1->(dbSetOrder(19)) // IdCnab
			SE1->(MsSeek(Substr(cNumTit,1,10)))
		Else
			//Busca por IdCnab
			SE1->(dbSetOrder(16)) // Filial+IdCnab
			SE1->(MsSeek(xFilial("SE1")+	Substr(cNumTit,1,10)))
		Endif
	
		//Se nao achou, utiliza metodo antigo (titulo)
		If SE1->(!Found())
			SE1->(dbSetOrder(1))
			// Busca por chave antiga como retornado pelo banco
			dbSeek(xFilial("SE1")+Substr(cNumTit,1,nTamTit)+cEspecie)
		EndIf
	
		//Se nao achou, utiliza metodo antigo (titulo)
		If SE1->(!Found())
			SE1->(dbSetOrder(1))
			// Busca por chave antiga como retornado pelo banco
			If dbSeek(xFilial("SE1")+Substr("0  "+cNumTit,1,nTamTit)+cEspecie)
				If Left(cNumTit,3) <> "0  "
					cNumTit := Left("0  "+cNumTit,15)
				EndIf
			Endif
		EndIf
	EndIf
ElseIf SEE->EE_CODIGO == "021"	
	cEspecie	:= Substr(cTipo,1,3)
	//Se nao achou, utiliza metodo antigo (titulo)
	If SE1->(!Found())
		SE1->(dbSetOrder(1))
		// Busca por chave antiga como retornado pelo banco
		SE1->(dbSeek(xFilial("SE1")+Substr(cNumTit,1,nTamTit)+cEspecie))
	EndIf						
EndIf

If Type("lProcessa") == "L"
	Return lProcessa
EndIf

Return .T.