#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TBICONN.CH"

#DEFINE P_FILIAL	1
#DEFINE P_FORNECE	2
#DEFINE P_OBRASNF	3
#DEFINE P_OBRASTR	4
#DEFINE P_LOJA		5
#DEFINE P_TRANSP	6
#DEFINE P_TIPO		7

#DEFINE P_IDOBRA	1
#DEFINE P_SALDO	2
#DEFINE P_RECZZ8	3
#DEFINE P_TPID		4
#DEFINE P_LOCAL	5
#DEFINE P_OK		6
#DEFINE P_MSG		7
#DEFINE P_SLD01	8
#DEFINE P_OK2		9
#DEFINE P_DTPUBLI	10
#DEFINE P_QTDPRES	11
#DEFINE P_RECNOB2	12


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA061   ºAutor  ³Telso Carneiro      º Data ³  11/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ rotina de carga de saldo em obra digitais                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function GENA061()

Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50  

Conout("GENA061 - Iniciando Job - carga de obras digitais - "+Time()+".")

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENA061 - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("GENA061 - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

While !LockByName("GENA061",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENA061 - Não foi possível executar a carga de obras digiatsi neste momento pois a função GENA061 já esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

U_GENA061A()

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("GENA061 - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("GENA061",.T.,.T.,.T.)

Conout("GENA061 - Finalizando Job - carga de obras digitais - "+Time()+".")

Return nil  


/*/{Protheus.doc} GENA061A

@author Telso Carneiro
@since 01/11/2016
@version undefined
@type function
/*/

User Function GENA061A()

Local cAliasSB2 := GetNextAlias()
Local cInIDTPPU	:= SuperGetMv("GEN_FAT134",.f.,"14") 
Local aEmail    := {}
Local cFilAna   := ""
Local cMAtriz   := "1022"
Local cTpPubNFe	:= SuperGetMv("GEN_FAT126",.f.,"14#")
Local aTpPubNFe	:= Separa(cTpPubNFe,"#")
Local nMvSaMin	:= Val(SuperGetMv("GEN_FAT129",.f.,"100")) //saldo mínimo obras digitais
Local nMvSaRec	:= Val(SuperGetMv("GEN_FAT130",.f.,"200")) //saldo recarga obras digitais
Local cMvClDe	:= GetMv("GEN_FAT017") //Contém o cliente que será utilizado para realizar as movimentações na empresa Matriz
Local cMvLjDe	:= GetMv("GEN_FAT018") //Contém a Loja que será utilizado as movimentações na empresa Matriz
Local nAuxSB2   := 0
Local aGerSld   := {}
Local aLogAux	:= {}
Local cToEmail	:= SuperGetMv("GEN_FAT131",.f.,"cleuto.lima@grupogen.com.br")
Local atam_cp   := TAMSX3("B2_QATU")
Local nTam_cp1  := atam_cp[1]
Local nTam_cp2  := atam_cp[2]

cInIDTPPU := '%'+FormatIn(cInIDTPPU,"#")+'%'

BeginSQL Alias cAliasSB2
	%noparser%
	
	column B2MSALDO as Numeric(nTam_cp1,nTam_cp2)
	column B2FSALDO as Numeric(nTam_cp1,nTam_cp2)
	column B5_XDTPUBL as Date

	SELECT SB2.B2_FILIAL,
		  SB2.B2_COD,  
		  (SB2.B2_QATU-(SB2.B2_RESERVA+SB2.B2_QEMP)) B2MSALDO,
		  DECODE(SB1.B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022',' ') FILSALDO,
		  (SB2A.B2_QATU-(SB2A.B2_RESERVA+SB2A.B2_QEMP)) B2FSALDO,
		  CASE WHEN SB2A.B2_QATU IS NULL 
		            THEN 1
		        WHEN (SB2A.B2_QATU-(SB2A.B2_RESERVA+SB2A.B2_QEMP)) <> (SB2.B2_QATU-(SB2.B2_RESERVA+SB2.B2_QEMP))  
		            THEN 1 
		        ELSE 0 END DIFSALDO,
		  SB2.R_E_C_N_O_ RECNOSB2,
		  SB1.B1_XIDTPPU,
		  SB1.B1_PROC,
		  SB1.B1_LOJPROC,
		  SB1.B1_DESC,
		  ( SELECT MAX(SB5.B5_XDTPUBL) FROM %table:SB5% SB5 WHERE SB5.B5_FILIAL = %xFilial:SB5% AND SB5.B5_COD = SB1.B1_COD AND SB5.%notdel% ) B5_XDTPUBL 		  		  
		FROM %table:SB2% SB2		
			JOIN %table:SB1% SB1
			ON SB1.B1_FILIAL = %xFilial:SB1% AND
				SB1.B1_COD = SB2.B2_COD AND			   
				SB1.B1_XIDTPPU IN %exp:cInIDTPPU% AND
				SB1.B1_PROC IN ('0380795','0380796','0380794','031811 ','0378128') AND
				SB1.%notdel%
			LEFT JOIN %Table:SB2% SB2A
			ON  SB2A.B2_FILIAL   = DECODE(SB1.B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022') AND
				SB2A.B2_COD      = SB2.B2_COD AND
			    SB2A.%notdel%    			   			   
	WHERE SB2.B2_FILIAL = %exp:cMAtriz% 
			AND SB2.B2_LOCAL = '01' 
			AND (SB2.B2_QATU-(SB2.B2_RESERVA+SB2.B2_QEMP)) < %exp:nMvSaMin% 
			AND TRIM(B1_XSITOBR) IN ('102')
		   	AND B1_ISBN        <> ' '
		   	AND B1_COD NOT     IN ('0112205', '0112207', '0112197', '0112208', '0112209', '0112202', '0112204','0112199','0112206', '0112200', '0112201', '0112130', '0112203', '1010010', '0005999', '0613246')
		   	AND B1_GRUPO NOT   IN (' ', '9999')
		  	AND SB2.%notdel%  	
	ORDER BY FILSALDO,B2_COD
EndSQL

While (cAliasSB2)->(!EOF())

	cFilOri	:= (cAliasSB2)->FILSALDO
	
	//Desbalanceamento de Saldo prepara o e-mail e nao processa o saldo
	If (cAliasSB2)->DIFSALDO == 1 
		Aadd(aEmail,{cFilOri,(cAliasSB2)->B1_XIDTPPU,AllTrim((cAliasSB2)->B2_COD),AllTrim((cAliasSB2)->B1_DESC),;
					 cValToChar((cAliasSB2)->B2MSALDO),cValToChar((cAliasSB2)->B2FSALDO)})
		(cAliasSB2)->(DbSkip())
		Loop
	EndIf		
		
	//Separa para processar os saldos		
	nPosFor := aScan(aGerSld, {|x| AllTrim(x[P_FORNECE])+AllTrim(x[P_LOJA]) == AllTrim((cAliasSB2)->B1_PROC)+AllTrim((cAliasSB2)->B1_LOJPROC) } )
	If nPosFor == 0
		Aadd(aGerSld,Array(7))
		nPosFor	:= Len(aGerSld)

		SA2->(DbsetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+(cAliasSB2)->B1_PROC+(cAliasSB2)->B1_LOJPROC))
		
		aGerSld[nPosFor][P_FILIAL]	:= AllTrim(cFilOri)
		aGerSld[nPosFor][P_FORNECE]	:= AllTrim(SA2->A2_COD)
		aGerSld[nPosFor][P_OBRASNF]	:= {}
		aGerSld[nPosFor][P_OBRASTR]	:= {}			
		aGerSld[nPosFor][P_LOJA]	:= AllTrim(SA2->A2_LOJA)
		aGerSld[nPosFor][P_TRANSP]	:= AllTrim(SA2->A2_TRANSP)
		aGerSld[nPosFor][P_TIPO] 	:= AllTrim(SA2->A2_TIPO)					
	EndIf
    
	nPosAuxTp	:= 0
	If aScan(aTpPubNFe, {|x| AllTrim(x) == AllTrim((cAliasSB2)->B1_XIDTPPU) } ) > 0
		nPosAuxTp := P_OBRASNF
	Else	
		nPosAuxTp := P_OBRASTR
	EndIf
	
	Aadd(aGerSld[nPosFor][nPosAuxTp], Array(12) )
	nPosObra	:= Len(aGerSld[nPosFor][nPosAuxTp])
	
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_IDOBRA]	:= AllTrim((cAliasSB2)->B2_COD)	
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_OK]		:= !((cAliasSB2)->B2MSALDO < nMvSaMin) 		
    aGerSld[nPosFor][nPosAuxTp][nPosObra][P_MSG]		:= ""
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_SLD01]		:= (cAliasSB2)->B2FSALDO 
    aGerSld[nPosFor][nPosAuxTp][nPosObra][P_OK2]		:= .F. 
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_DTPUBLI]	:= (cAliasSB2)->B5_XDTPUBL 
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_QTDPRES]	:= (nMvSaRec-(cAliasSB2)->B2MSALDO)
		
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_SALDO]	    := nMvSaRec 
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_TPID]		:= (cAliasSB2)->B1_XIDTPPU
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_LOCAL]		:= "01"
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_MSG]		:= ""	
	aGerSld[nPosFor][nPosAuxTp][nPosObra][P_RECNOB2]   := (cAliasSB2)->RECNOSB2
	
	(cAliasSB2)->(DbSkip())
EndDo
(cAliasSB2)->(DbCloseArea())

//Processa os Saldos 
For nAuxSB2 := 1 To Len(aGerSld)
	dProcInter 	:= dDataBase
	cFilOri    	:= aGerSld[nAuxSB2][P_FILIAL]
	cCodCli 	:= aGerSld[nAuxSB2][P_FORNECE] 
	cLojCli 	:= aGerSld[nAuxSB2][P_LOJA]
	_cTrpPv		:= aGerSld[nAuxSB2][P_TRANSP]
	_cTipPv 	:= aGerSld[nAuxSB2][P_TIPO]
						
	If Len(aGerSld[nAuxSB2][P_OBRASNF]) > 0
		GerSldNFe(cFilOri,dProcInter,aGerSld[nAuxSB2][P_OBRASNF],cCodCli,cLojCli,cMvClDe,cMvLjDe,_cTrpPv,_cTipPv,/*_cVenPv*/,P_OBRASNF,@aLogAux)
	EndIf	
	If Len(aGerSld[nAuxSB2][P_OBRASTR]) > 0
		GerSldNFe(cFilOri,dProcInter,aGerSld[nAuxSB2][P_OBRASTR],cCodCli,cLojCli,cMvClDe,cMvLjDe,_cTrpPv,_cTipPv,/*_cVenPv*/,P_OBRASTR,@aLogAux)			
	EndIf
	
Next nAuxSB2

//Envia o e-mail
aSort(aEmail,,,{|x,y| x[1] < y[1]})
If Len(aEmail) > 0
	EnvEmails(cToEmail,aEmail)
EndIF

Return


/*/{Protheus.doc} GerSldNFe
//TODO Descrição auto-gerada.
@author Telso
@since 08/11/2016
@version undefined
@param cFilOri, characters, descricao
@param dProcInter, date, descricao
@param aObras, array, descricao
@param cFornece, characters, descricao
@param cLojafor, characters, descricao
@param cMvClDe, characters, descricao
@param cMvLjDe, characters, descricao
@param _cTrpPv, , descricao
@param _cTipPv, , descricao
@param _cVenPv, , descricao
@param nTpSaldo, numeric, descricao
@param aLogAux, array, descricao
@type function
/*/
Static Function GerSldNFe(cFilOri,dProcInter,aObras,cFornece,cLojafor,cMvClDe,cMvLjDe,_cTrpPv,_cTipPv,_cVenPv,nTpSaldo,aLogAux)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Varaiveis da rotina.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cSerie		:= "0  "
//Local cTes			:= "001"		
Local aSF1Gen		:= {}
Local aSD1Itens		:= {}
Local aSD1Orig		:= {}
Local aItemOri		:= {}
Local aSC6Aux		:= {}
Local aSC5Gen		:= {}
Local aSC6Gen		:= {}
Local nAuxIt		:= 0
Local nVUnit		:= 0.01
Local cItemAux		:= StrZero(0,TamSX3("D1_ITEM")[1])
Local cItC6Aux		:= StrZero(0,TamSX3("C6_ITEM")[1])
Local cItemOri		:= StrZero(0,TamSX3("D1_ITEM")[1])
Local _cMvTbPr 		:= GetMv("GEN_FAT015") //Contém a tabela de preço usado no pedido de vendas na empresa Matriz e Origem
Local aSaldos		:= {}
Local aObrasAux		:= {}
Local _cLogPd		:= GetMv("GEN_FAT016") //Contém o caminho que será gravado o log de erro
Local cTesIntCia	:= GetMv("GEN_COM011") 
Local cTesSOri		:= "820"

Local _cServ 		:= GETMV("GEN_FAT027") //Contém o Ip do servidor para realizar as mudanças de ambiente
Local _nPort  		:= GETMV("GEN_FAT028") //Contém a porta para realizar as mudanças de ambiente
Local _cAmb  		:= GETMV("GEN_FAT029") //Contém o ambiente a ser utilizado para realizar as mudanças de filial
Local lSldOri		:= .T.
Local _cNotaImp		:= ""
Local nColProd		:= 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³verifico se existe obra sem saldo no 01 da origem para ser enviada ³
//³para o Gen                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEval(aObras, {|x| lSldOri := IIF( !x[P_OK] , .F. , lSldOri ) } ) 

If !lSldOri
	CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
	PORT  _nPort           								;   //Porta de conexão do servidor
	ENVIRONMENT _cAmb       							;   //Ambiente do servidor
	EMPRESA cEmpAnt          							;   //Empresa de conexão
	FILIAL  cFilOri          							;   //Filial de conexão
	TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que serão abertas
	MODULO  "SIGAFAT"               					//Módulo de conexão
		
	If ValType(_oServer) == "O"
		
		_oServer:CallProc("RPCSetType", 2)
		
		If nTpSaldo == P_OBRASNF
			aObrasAux := _oServer:CallProc("U_GENA058B",aObras,dProcInter,cFornece,cLojafor)
		ElseIf nTpSaldo == P_OBRASTR
			aObrasAux := _oServer:CallProc("U_GENA058E",aObras,dProcInter,cFornece,cLojafor)	
		EndIf	
	 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realizando a nova conexão para entrar na empresa e filial correta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Fecha a Conexao com o Servidor
		RESET ENVIRONMENT IN SERVER _oServer
		CLOSE RPCCONN _oServer
		FreeObj(_oServer)
		_oServer := Nil
		
	EndIf
Else
	aObrasAux := aClone(aObras)	
EndIf

Return nil

/*/{Protheus.doc} EnvEmails
@author Telso
@since 08/01/2016
@version 6
@param cMail, characters, descricao
@type function
/*/
Static Function EnvEmails(cMail,aEmail)   

Local cMensagem := ""
Local nX 		:= 1
Local nY 		:= 1
Local Op 		
Local cFilEma   := ""

cFilEma := aEmail[1,1]
For nY := 1 To Len(aEmail)

	cMensagem := '<tr>'
	cMensagem += '	<td width="6%"  class="TableRowBlueDarkMini" align="center"><b>Filial</b></td>'
	cMensagem += '	<td width="2%" class="TableRowBlueDarkMini" align="center"><b>Obra</b></td>'
	cMensagem += '	<td width="8%" class="TableRowBlueDarkMini" align="center"><b>Codígo</b></td>'
	cMensagem += '	<td width="60%" class="TableRowBlueDarkMini" align="center"><b>Desc.</b></td>'
	cMensagem += '	<td width="12%" class="TableRowBlueDarkMini" align="center"><b>Saldo Matriz</b></td>'
	cMensagem += '	<td width="27%" class="TableRowBlueDarkMini" align="center"><b>Saldo Filial</b></td>'
	cMensagem += '</tr>'	
	For nX := nY To Len(aEmail)
		If cFilEma != aEmail[nX,1]  
			cFilEma := aEmail[nX,1]
			Exit
		EndIf
		cMensagem += '<tr>'
		cMensagem += '	<td width="6%" class="TableRowWhiteMini2" align="left">'+aEmail[nX,1]+'</td>'
		cMensagem += '	<td width="2%" class="TableRowWhiteMini2" align="left">'+aEmail[nX,2]+'</td>'
		cMensagem += '	<td width="8%" class="TableRowWhiteMini2" align="left">'+aEmail[nX,3]+'</td>'
		cMensagem += '	<td width="60%" class="TableRowWhiteMini2" align="left">'+aEmail[nX,4]+'</td>'
		cMensagem += '	<td width="12%" class="TableRowWhiteMini2" align="center">'+aEmail[nX,5]+'</td>'
		cMensagem += '	<td width="27%" class="TableRowWhiteMini2" align="center">'+aEmail[nX,6]+'</td>'
		cMensagem += '</tr>'
	Next	
	nY := nX	
		  
	If !Empty(cMail)
	
		Op:= TWFProcess():New("avsaldo", "Desbalanceamento de Saldo nas Obra")
		Op:NewTask("avsaldo", "/html/avisosaldo.htm")
		
		Op:cSubject := "Desbalanceamento de Saldo nas Obras"
		Op:cTo		:= cMail
		Op:cCC		:= ""
		Op:cBCC     := ""
		oP:bReturn 	:= ""
		
		oP:oHtml:ValByName("M0_NOME",SM0->M0_NOME)
		oP:oHtml:ValByName("emissao",dDatabase)
		oP:oHtml:ValByName("table",cMensagem)
		
		oP:Start()
		oP:Finish()
	
	EndIf
	
Next
return(.t.)  