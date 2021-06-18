#include "Protheus.ch"
#include "Fileio.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELUSER   บAutor  ณMicrosiga           บ Data ณ  01/15/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xRetSupUsr()

Local aUsrRast	:= AllUsers()
Local cTemp		:= ""

nHandle := FCREATE("C:\temp\SupXUsers.log", FC_NORMAL)

For nAux := 1 To Len(aUsrRast)
	FWRITE(nHandle,aUsrRast[nAux][1][1]+";"+aUsrRast[nAux][1][2]+";"+aUsrRast[nAux][1][11]+";"+UsrFullName(aUsrRast[nAux][1][11])+";") 
	FWRITE(nHandle,CHR(13)+CHR(10))
Next

FCLOSE(nHandle)

Return nil

User Function xRetXNUs()

Local aModulos	:= RetModName()  
Local aUsrRast	:= AllUsers()  
Local aGrpRast	:= {}
Local aNives	:= {}
Local cNivel	:= ""

Private aAcesso	:= {}
Private aRet	:= {}
Private aUser	:= {}

RpcSetType(2)
RpcSetEnv("00","1022") 
/*
Aadd(aUsrRast,"000119")//Cilene 
Aadd(aUsrRast,"000208")//Tatiane 
Aadd(aUsrRast,"000006")//Roseli 
Aadd(aUsrRast,"000020")//Fatima 
Aadd(aUsrRast,"000167")//Patricia 
Aadd(aUsrRast,"000211")//Patricia 
Aadd(aUsrRast,"000077")//Monica 
Aadd(aUsrRast,"000060")//Cely 
Aadd(aUsrRast,"000004")//Cris 
Aadd(aUsrRast,"000101")//Yuri 
Aadd(aUsrRast,"000214")//Maira 
Aadd(aUsrRast,"000184")//Cassia 
Aadd(aUsrRast,"000012")//Alessandra 
Aadd(aUsrRast,"000217")//Alessandra 
Aadd(aUsrRast,"000011")//Cirana 
Aadd(aUsrRast,"000093")//Carolina 
*/
//Aadd(aUsrRast,"000218")//cleuto

nHandle := FCREATE("\UserXMenu.log", FC_NORMAL)

For nAuxFc := 1 To Len(aUsrRast)
	
	If aUsrRast[nAuxFc][1][17]
		loop
	EndIf
	
	For nAuxMod := 1 To Len(aModulos)
		                                       
		If !(AllTrim(aModulos[nAuxMod][2]) $ "SIGAFAT#SIGAFIN#SIGAFIS#SIGACOM#SIGACTB#SIGAGPE#SIGAEST#")
			Loop
		EndIf
		
		For nMnu := 1 To Len(aUsrRast[nAuxFc][3])   
			
			If Left(aUsrRast[nAuxFc][3][nMnu],2) == StrZero(aModulos[nAuxMod][1],2)
				FWRITE(nHandle,aUsrRast[nAuxFc][1][1]+"|"+aUsrRast[nAuxFc][1][2]+"|"+aModulos[nAuxMod][2]+"|"+substr(aUsrRast[nAuxFc][3][nMnu],4,50)) 
				FWRITE(nHandle,CHR(13)+CHR(10)) 			
			EndIf
			
		Next nMnu
		/*
		PswOrder(1)
		PswSeek( aUsrRast[1][1][1], .T. )  
		aUser	:= PswRet()[1]
		aNives	:= {}		
		aAcesso := FWGetMnuAccess (aUsrRast[1][1][1], aModulos[nAuxMod][1] )
		lLoop	:= .T.
		nPosAtu	:= 1
		nPosAnt	:= 1
		
		If Len(aAcesso) < 3 .OR. !aAcesso[3]
			Loop
		EndIF
		FWRITE(nHandle,aUsrRast[1][1][1]+"|"+aUsrRast[1][1][2]+"|"+aAcesso[1]+"|"+aAcesso[2]) 
		FWRITE(nHandle,CHR(13)+CHR(10)) 		
		*/		
  
		
	Next nAuxMod
	
Next nAuxFc

FCLOSE(nHandle)

nHandle := FCREATE("\GruposXMenu.log", FC_NORMAL)

For nAuxFc := 1 To Len(aGrpRast)
	For nAuxMod := 1 To Len(aModulos)
		                                       
		If !(AllTrim(aModulos[nAuxMod][2]) $ "SIGAFAT#SIGAFIN#SIGAFIS#SIGACOM#SIGACTB#SIGAGPE#SIGAEST#")
			Loop
		EndIf
		
		For nMnu := 1 To Len(aGrpRast[nAuxFc][2])   
			
			If Left(aGrpRast[nAuxFc][2][nMnu],2) == StrZero(aModulos[nAuxMod][1],2)
				FWRITE(nHandle,aGrpRast[nAuxFc][1][1]+"|"+aGrpRast[nAuxFc][1][2]+"|"+aModulos[nAuxMod][2]+"|"+substr(aGrpRast[nAuxFc][2][nMnu],4,50)) 
				FWRITE(nHandle,CHR(13)+CHR(10)) 			
			EndIf
			
		Next nMnu
		/*
		PswOrder(1)
		PswSeek( aUsrRast[1][1][1], .T. )  
		aUser	:= PswRet()[1]
		aNives	:= {}		
		aAcesso := FWGetMnuAccess (aUsrRast[1][1][1], aModulos[nAuxMod][1] )
		lLoop	:= .T.
		nPosAtu	:= 1
		nPosAnt	:= 1
		
		If Len(aAcesso) < 3 .OR. !aAcesso[3]
			Loop
		EndIF
		FWRITE(nHandle,aUsrRast[1][1][1]+"|"+aUsrRast[1][1][2]+"|"+aAcesso[1]+"|"+aAcesso[2]) 
		FWRITE(nHandle,CHR(13)+CHR(10)) 		
		*/		
  
		
	Next nAuxMod
	
Next nAuxFc

FCLOSE(nHandle)

Return nil

User Function xRelUser()

Local aModulos	:= RetModName()
Local aUsrRast	:= {}//AllUsers()//{}
Local aNives	:= {}
Local cNivel	:= ""

Private aAcesso	:= {}
Private aRet	:= {}
Private aUser	:= {}

RpcSetType(2)
RpcSetEnv("00","1022") 
/*
Aadd(aUsrRast,{{"000055"}})//deize
Aadd(aUsrRast,{{"000344"}})//bruno
Aadd(aUsrRast,{{"000309"}})//rosane
Aadd(aUsrRast,{{"000077"}})//tatiana
Aadd(aUsrRast,{{"000246"}})//ibiapina
Aadd(aUsrRast,{{"000114"}})//erica 
Aadd(aUsrRast,{{"000221"}})//isabel
Aadd(aUsrRast,{{"000089"}})//thiago monteiro
Aadd(aUsrRast,{{"000105"}})//vanir
Aadd(aUsrRast,{{"000164"}})//marcos malhao
Aadd(aUsrRast,{{"000119"}})//aline
Aadd(aUsrRast,{{"000155"}})//cristinao
Aadd(aUsrRast,{{"000242"}})//edvaldo
Aadd(aUsrRast,{{"000060"}})//pacheco
Aadd(aUsrRast,{{"000013"}})//alexandre diogenes
Aadd(aUsrRast,{{"000220"}})//cida
Aadd(aUsrRast,{{"000241"}})//thiago pacheco
Aadd(aUsrRast,{{"000069"}})//luciana
Aadd(aUsrRast,{{"000180"}})//diego.garcia
*/
Aadd(aUsrRast,{{"000220"}})//cida
Aadd(aUsrRast,{{"000241"}})//thiago pacheco
//Aadd(aUsrRast,{{"000089"}})//thiago monteiro
//Aadd(aUsrRast,{{"000105"}})//vanir

For nAuxFc := 1 To Len(aModulos)

	For nAuxMod := 1 To Len(aUsrRast)
        
		aRet	:= {}
		
		//If !(AllTrim(aModulos[nAuxFc][2]) $ "SIGAGPE#SIGAATF#SIGAFAT#SIGAFIN#SIGAFIS#SIGACOM#SIGACTB#SIGAEST#")
		If !(AllTrim(aModulos[nAuxFc][2]) $ "SIGAGPE#")
			Loop
		EndIf
		
		PswOrder(1)
		PswSeek( aUsrRast[nAuxMod][1][1], .T. )  
		//aUser	:= PswRet()[1]
		aUser	:= PswRet()
		If !(Len(aUser) >= 1)
			Loop
		Else
			aUser	:= aUser[1]	
		EndIf
		
		aNives	:= {}		
		aAcesso := FWGetMnuAccess (aUsrRast[nAuxMod][1][1], aModulos[nAuxFc][1] )
		lLoop	:= .T.
		nPosAtu	:= 1
		nPosAnt	:= 1
		
		If Len(aAcesso) < 3 .OR. !aAcesso[3]
			Loop
		EndIF
				
		For nAuxMn := 1 To Len(aAcesso[4])
		
			SubNivel( aAcesso[4][nAuxMn], @cNivel )
		
		Next nAuxMn
		
		GeraExcel(aRet,aUser[4],strtran(AllTrim(aModulos[nAuxFc][3]),"/"," "))
		
	Next nAuxMod
		
Next nAuxFc
/*
nHandle := FCREATE("\UserXMenu.log", FC_NORMAL)
For nAuxMn := 1 To Len(aRet)
	FWRITE(nHandle,aRet[nAuxMn]) 
	FWRITE(nHandle,CHR(13)+CHR(10))   
Next                                                                                                       
FCLOSE(nHandle)
*/

Return nil

Static Function SubNivel(aNivel,cNivel)

Local nLopAux	:= 0
Local cRet		:= ""

If Len(aNivel) == 2 .AND. ValType(aNivel[1]) == "C"	
	cNivel += "->"+aNivel[1]
	For nLopAux := 1 To Len( aNivel[2] )		
		SubNivel(aNivel[2][nLopAux] , @cNivel )	
		If nLopAux == Len( aNivel[2] )
			cNivel := Left(cNivel, Rat("->",cNivel)-1 )
		EndIf
	Next
ElseIf Len(aNivel) == 4 .AND. ValType(aNivel[1]) == "C" .AND. ValType(aNivel[3]) == "L" .AND. aNivel[3]
	Aadd(aRet, aUser[1]+"|"+aUser[2]+"|"+aUser[4]+"|"+AllTrim(aAcesso[2])+"|"+aAcesso[1]+"|"+cNivel+"|"+aNivel[1]+" ( "+aNivel[2]+" ) "  )
	//Aadd(aRet, aUser[1]+"|"+aUser[2]+"|"+aUser[4]+"|"+AllTrim(aAcesso[2])+"|"+aAcesso[1]+cNivel+"|"+aNivel[1]+"|"+aNivel[2]  )
	//cNivel := Left(cNivel, Rat("|",cNivel)-1 )
EndIf

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELUSER   บAutor  ณMicrosiga           บ Data ณ  01/15/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Acesb
Local aAllUsr	:= {}
Local aUsrRast	:= {}
Local cAcess	:= ""
Local cQuebra	:= Chr(13)+Chr(10)  
Local cUSerAux	:= ""
Local aRet		:= {}
Local cCamin	:= ""
Local cREt		:= ""

Aadd(aUsrRast,"000004")//cida
Aadd(aUsrRast,"000006")//thiago pacheco

RpcSetType(2)
RpcSetEnv("00","1022") 

//aAllUsr	:= AllUsers()

For nAuxFc := 1 To Len(aUsrRast)

	aArray := {}
	PswOrder(1)
	If PswSeek( aUsrRast[nAuxFc], .T. )  
	   aArray := PswRet() // Retorna vetor com informa็๕es do usuแrio
	EndIf

	cUSerAux := aArray[1][1]+"|"+aArray[1][4]+"|"
		
	For nAuxMen := 1 To Len(aArray[3])
					
		cFilMenu := SubStr( aArray[3][nAuxMen] , At("\",aArray[3][nAuxMen])+1 , Len(aArray[3][nAuxMen]) )
		
		If File(cFilMenu)
			
			// Abre o arquivo
			nHandle := FT_FUse(cFilMenu)
			// Se houver erro de abertura abandona processamento
			if nHandle = -1  
				return
			endif
			// Posiciona na primeria linha
			FT_FGoTop()
			// Retorna o n๚mero de linhas do arquivo
			nLast := FT_FLastRec()
			
			While !FT_FEOF()   
				
				cLine  := FT_FReadLn() // Retorna a linha corrente
				
				If Upper('Title lang="pt"') $ StrTran(Upper(AllTrim(StrTran(StrTran(cLine,'</Title>',''),'	',''))),cQuebra,"")
					cCamin	+= ">"+StrTran(StrTran(StrTran(StrTran(cLine,'<Title lang="pt">',""),'</Title>',''),'	',''),cQuebra,"")
				ElseIf '/Me' $ cLine	
					cCamin := Left(cCamin, Rat(">",cCamin)-1 )
				EndIf	
				
				If "<Function>" $ cLine
					Aadd(aRet, cUSerAux+aUsrRast[nAuxFc]+"|"+cFilMenu+"|"+cCamin+"|" ) 
					//cREt+=cUSerAux+aUsrRast[nAuxFc]+"|"+cFilMenu+"|"+cCamin+"|"+cquebra					
				EndIf
				
				FT_FSKIP()
			End
			// Fecha o Arquivo
			FT_FUSE()
			
		EndIf

	Next

Next
//MemoWrite("\logdeacesso.log",cREt)

nHandle := FCREATE("\UserXMenu.log", FC_NORMAL)
For nAuxMn := 1 To Len(aRet)
	FWRITE(nHandle,aRet[nAuxMn]) 
	FWRITE(nHandle,CHR(13)+CHR(10))   
Next                                                                                                       
FCLOSE(nHandle)

Return nil     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXRELUSER  บAutor  ณMicrosiga           บ Data ณ  10/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function GeraExcel(aRet,cUser,cModu,cLider)

Local cSheet	:= "Acessos"
Local cTable	:= "Acessos"

Local cArquivo	:= cModu+" - "+cUser+".xls"
Local oExcel 		:= FWMSEXCEL():New()
Local cPath		:= "C:\temp\MenusGens\" //GetTempPath()+"MenusGen\" //Diretorio de gravacao de arquivos
Local lMail		:= .F.
Local aItem		:= {}
Local nAuxHr	:= 0 
Local nAuxAc	:= 0

Default cLider	:= ""

//If !ApOleClient( 'MsExcel' )
//	MsgAlert( 'MsExcel nao instalado' )
//	Return
//EndIf

oExcel:AddworkSheet(cSheet)
oExcel:AddTable (cSheet,cTable)

oExcel:AddworkSheet("Instru็๕es")
oExcel:AddTable ("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL")
/*
oExcel:AddColumn("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL","Modulo" ,1,3)
oExcel:AddColumn("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL","Lํder de processo" ,1,3)
oExcel:AddColumn("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL","Usuแrio chave" ,1,3)
oExcel:AddColumn("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL","Menu" ,1,3)
oExcel:AddColumn("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL","Instru็๕es" ,1,3)
*/

oExcel:AddColumn("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL","Info" ,1,3)
oExcel:AddColumn("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL","Instru็๕es" ,1,3)

oExcel:AddRow("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL",{"Modulo",cModu})
oExcel:AddRow("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL",{"Lํder de processo",cLider})
oExcel:AddRow("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL",{"Usuแrio chave",cUser})
oExcel:AddRow("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL",{"Menu",StrTokArr(aRet[1],"|")[4]})
oExcel:AddRow("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL",{"Instru็๕es",'Efetue os testes da rotina, conforme Menu.'})
oExcel:AddRow("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL",{" ",'Para cada rotina informe a coluna Situa็ใo com as op็๕es Ok, Erro ou Nใo utilizado.'})
oExcel:AddRow("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL",{" ",'Caso informe "Erro" ้ obrigat๓rio preencher a coluna observa็ใo com o erro encontrado.'})

/*
oExcel:AddRow("Instru็๕es","GEN | GRUPO EDITORIAL NACIONAL",{;
cModu,;
cLider,;
cUser,;
StrTokArr(aRet[1],"|")[4],;
'Efetue os testes da rotina, conforme Menu.'+Chr(13)+Chr(10)+'Para cada rotina informe a coluna Situa็ใo com as op็๕es Ok, Erro ou Nใo utilizado.'+Chr(13)+Chr(10)+'Caso informe "Erro" ้ obrigat๓rio preencher a coluna observa็ใo com o erro encontrado.';
})
*/

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )
//oExcel:AddColumn(cSheet,cTable,"Codigo" ,1,3)
//oExcel:AddColumn(cSheet,cTable,"Usuario" ,1,3)
//oExcel:AddColumn(cSheet,cTable,"Nome" ,1,3)
//oExcel:AddColumn(cSheet,cTable,"Menu" ,1,3)
//oExcel:AddColumn(cSheet,cTable,"Modulo" ,1,3)

oExcel:AddColumn(cSheet,cTable,"Menu" ,1,3)
oExcel:AddColumn(cSheet,cTable,"Rotina" ,1,3)  
oExcel:AddColumn(cSheet,cTable,"Situa็ใo" ,1,3)                                
oExcel:AddColumn(cSheet,cTable,"Observa็ใo" ,1,3)

For nAuxUsr := 1 To Len(aRet) 
	aItem	:= Array(4)
	
	aRet[nAuxUsr]	:= StrTokArr(aRet[nAuxUsr],"|")
	
	For nAuxMn	:= 6 To Len(aRet[nAuxUsr])
		aItem[nAuxMn-5]	:= Strtran(aRet[nAuxUsr][nAuxMn],"->&","")
	Next
		
	oExcel:AddRow(cSheet,cTable,aClone(aItem))
	
Next	

oExcel:Activate()
oExcel:GetXMLFile(cPath+cArquivo)

FreeObj(oExcel)

Return nil   
