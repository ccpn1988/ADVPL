/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPE10MENU º Autor ³Cleuto Lima         º Data ³  09/04/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada no cadastro de autonomos para manipular o º±±
±±º          ³artoina.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GPE10MENU 


Local aAreaSX3	:= SX3->(GetArea())

If IsInCallStack("Gpea265")
	/*
	Cleuto - 09/04/2018
	Vivaz - 41690 - Error log cadastro de autonomos
	
	ponto de entrada utilizado para forçar que os campos a seguir sejam apresentados na tela de cadastro de autonomos e com isso evitar o error log enquanto a TOTVS não envia uma correção
	
	*/
	aSraSx3 := FWSX3Util():GetAllFields( "SRA", .T. )
	//SX3->(DbSetOrder(2))
	//SX3->(Dbseek("RA_CARGO"))
	nCampo := nCampo + 1
	nPSx3Sra	:= Ascan(aSraSx3,"RA_CARGO")
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )	
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )
	
	//SX3->(Dbseek("RA_HRSMES"))
	nPSx3Sra	:= Ascan(aSraSx3,"RA_HRSMES")
	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )
	
	//SX3->(Dbseek("RA_PERICUL"))
	nPSx3Sra	:= Ascan(aSraSx3,"RA_PERICUL")
	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	

	//SX3->(Dbseek("RA_INSMAX"))
	nPSx3Sra	:= Ascan(aSraSx3,"RA_INSMAX")
	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
		
	//SX3->(Dbseek("RA_SALARIO"))
	nCampo := nCampo + 1
	nPSx3Sra	:= Ascan(aSraSx3,"RA_SALARIO")
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
		
	//SX3->(Dbseek("RA_DCARGO"))
	nCampo := nCampo + 1
	nPSx3Sra	:= Ascan(aSraSx3,"RA_DCARGO")		
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	

	//SX3->(Dbseek("RA_RACACOR"))
	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )	
	//SX3->(Dbseek("RA_CPAISOR"))
	nCampo := nCampo + 1
	nPSx3Sra	:= Ascan(aSraSx3,"RA_CPAISOR")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
			
	//SX3->(Dbseek("RA_NACIONC"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_NACIONC")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
	
	//SX3->(Dbseek("RA_SEXO"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_SEXO")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
	
	//SX3->(Dbseek("RA_GRINRAI"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_GRINRAI")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
		
	//SX3->(Dbseek("RA_NASC"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_NASC")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	

	
	//SX3->(Dbseek("RA_LOGRNUM"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_LOGRNUM")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	

	
	//SX3->(Dbseek("RA_LOGRTP"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_LOGRTP")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
	
	//SX3->(Dbseek("RA_LOGRDSC"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_LOGRDSC")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
	
	//SX3->(Dbseek("RA_ESTADO"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_ESTADO")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
	
	//SX3->(Dbseek("RA_CODMUN"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_CODMUN")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
	
	//SX3->(Dbseek("RA_CEP"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_CEP")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
	
	//SX3->(Dbseek("RA_RGEXP"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_RGEXP")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )	
		
	//SX3->(Dbseek("RA_CODMUNN"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_CODMUNN")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )		

	//SX3->(Dbseek("RA_CPAISOR"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_CPAISOR")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )		

	//SX3->(Dbseek("RA_NATURAL"))
		nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_NATURAL")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )		
 
	//SX3->(Dbseek("RA_DEPTO"))
	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_DEPTO")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )		

	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_PIS")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )		

	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_RGEXP")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )		

	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_DTRGEXP")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )		

	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_RGORG")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )		
	
	nCampo := nCampo + 1
	//Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(SX3->X3_USADO),"X"," ")+"]"+Space(5)+SX3->X3_CAMPO+Space(3)+STRZERO(SX3->X3_TAMANHO,3)+STRZERO(SX3->X3_DECIMAL,2)+ strzero(nAgrup,2)+ Strzero(nCampo,3) )
	nPSx3Sra	:= Ascan(aSraSx3,"RA_ORGEMRG")			
	Aadd(aDicioT, FWSX3Util():GetDescription( aSraSx3[nPSx3Sra] )+Space(14)+CHR(179)+"["+If (X3USO(Posicione("SX3",2,aSraSx3[nPSx3Sra],"X3_USADO")),"X"," ")+"]"+Space(5)+aSraSx3[nPSx3Sra]+Space(3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[1],3)+STRZERO(TamSx3(aSraSx3[nPSx3Sra])[2],2)+strzero(nAgrup,2)+ Strzero(nCampo,3) )		
	
EndIf

RestArea(aAreaSX3)
Return nil                        