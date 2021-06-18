#include "TOTVS.CH"
#INCLUDE "Protheus.ch" 
#include "tbiconn.ch"
#include "topconn.ch"
#include "Fileio.ch"

// Parametros
#DEFINE MV_FILE	1
#DEFINE MV_ARMORI	2
#DEFINE MV_ARMDES	3
#DEFINE MV_SEPARA	4
#DEFINE MV_PARCIAL 5
#DEFINE MV_OBSERV	6

// Layout arquivo
#DEFINE LAY_PROD	1
#DEFINE LAY_QTD	2
#DEFINE LAY_OK		3
#DEFINE LAY_LEN	2
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA030   บAutor  ณMicrosiga           บ Data ณ  11/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina customizada para automatizar a transaferencia entre  บฑฑ
ฑฑบ          ณarmazens.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gen.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function GENA030()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aSays		:= {}
Local cCadastro	:= "Trasnferencia de Armazem"
Local aRet 		:= {}
Local aButtons	:= {}
Local cTabFre	:= ""

Private nOpcA	:= 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta tela principal                                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD(aSays,OemToAnsi("Esta rotina tem o objetivo realizar transferencias entre armazens       "		))
	AADD(aSays,OemToAnsi(" utilizando arquivo CSV para input dos dados.                  "				))
	AADD(aSays,OemToAnsi(""																				))
	AADD(aSays,OemToAnsi(""																				))
	AADD(aSays,OemToAnsi("Especifico Grupo Gen." 									   					))
	AADD(aButtons, { 5,.T.,{|o|	ParamBox({;
												{06,"Arq.CSV Origem"		,Space(150),"",".T.",".T.",80,.F.,"*.XLS/*.XLSX",Space(150),GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE},;
												{01,"Armazem Origem"		,CriaVar("D2_LOCAL",.F.)	,PesqPict("SD3","D2_LOCAL"),".T.",""/*F3*/,"",20,.T.},;
												{01,"Armazem Destino"		,CriaVar("D2_LOCAL",.F.)	,PesqPict("SD3","D2_LOCAL"),".T.",""/*F3*/,"",20,.T.},;
												{01,"Separador Logico"		,";"	,"",".T.","","",40,.T.},;
												{02,"Permite Sld.Parcial"	,1	,{" ","1=Sim","2=Nใo"},80,".T.",.T.,".T."},;
												{11,"Observa็ใo	"		," ",".T.",".T.",.T.};
							 				},cCadastro,@aRet,,,,,,,,.T.,.T.)}})

	AADD(aButtons, { 1,.T.,{|o| nOpcA:= 1,o:oWnd:End(),FechaBatch()	}})
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End(),FechaBatch()				}})

	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA <> 1
		Return
	EndIf

	If Len(aRet) == 0
		Aviso("Parametros","Digite os paramentros antes de confirmar a Rotina",{"Abandonar"})
		Return
	Else
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Seleciona o arquivo                                                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Empty(aRet[MV_FILE]) .Or. !File(aRet[MV_FILE])
			Aviso("Inconsist๊ncia","Nใo consegui encontrar o arquivo informado!",{"Ok"},,"Aten็ใo:")
			Return nil
		Endif		
		
		Processa({|| lContinua := LeExcel(aRet[MV_FILE],aRet[MV_ARMORI],aRet[MV_ARMDES],aRet[MV_SEPARA],aRet[MV_OBSERV],aRet[MV_PARCIAL] == "1") },"Processando...")
				
	EndIf

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA030   บAutor  ณMicrosiga           บ Data ณ  11/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function LeExcel(cFile,cArmOri,cArmDes,cSepara,cObserv,lPermParc) 

Local lRet	 	:= .T.
Local nTotReg	:= 0 
Local nLinha	:= 0
Local aLinha	:= {}
Local aDados	:= {} 
Local aLog		:= {}
Local lContinua	:= .T.
Local cIDDCF	:= AllTrim(SuperGetMv("GEN_IDDCF",.F.,"N"))
Local nAux		:= 0

Private cxObserv	:= cObserv // cxObserv utilizada no ponto de entrada MA261TRD3

ProcRegua(0)
IncProc("Lendo arquivo..")

nHdl 	:= FT_FUSE(cFile)
FT_FGOTOP()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processa a leitura do arquivo texto                  				ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !FT_FEOF()
        
	nLinha++
    cBuffer := Alltrim(FT_FREADLN())
    
    IncProc("Lendo arquivo.. linha "+StrZero(nLinha,4))
        
    If Empty(cBuffer)
    	FT_FSKIP()
    	Loop
    EndIF
    
    aLinha  := Separa(cBuffer,cSepara,.T.)
    
    If Len(aLinha) <> LAY_LEN
    	Aadd(aLog, "Linha "+StrZero(nLinha,4)+" layout invalido!" )
    	FT_FSKIP()
    	Loop    	
    EndIF
    
    Aadd(aDados, Array(LAY_LEN+1))
    
    aDados[Len(aDados)][LAY_PROD]	:= aLinha[LAY_PROD]
    aDados[Len(aDados)][LAY_QTD]	:= Val(aLinha[LAY_QTD])
    aDados[Len(aDados)][LAY_OK]		:= .F.
            
    //Aadd(aDados, aClone(aLinha) )
    	
	FT_FSKIP()
EndDo

FT_FUSE()

IncProc("Validando informa็๕es")

For nAux := 1 To Len(aDados)
	IF Mod(aDados[nAux][LAY_QTD],1) > 0
		Aadd(aLog, "Linha "+StrZero(nAux,4)+" Produto "+ALLTRIM(aDados[nAux][LAY_PROD])+" com quantidade fracionada ("+cValToChar(aDados[nAux][LAY_QTD])+")." )
	ENDIF
Next

IF Len(aLog) > 0
	MsgAlert("Processo nใo serแ executado!"+Chr(13)+Chr(10)+"Existem registros com quantidade fracionada!")
	ViewLog(aLog)	
	Return nil
ENDIF

DbSelectArea("SB1")
DbSelectArea("SB2")
SB2->(DbSetOrder(1))

For nAux := 1 To Len(aDados)
	
	cQuery := " SELECT B1_COD
	cQuery += " FROM " + RetSqlName("SB1")
	cQuery += " WHERE D_E_L_E_T_ = ' '
	cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'"
	cQuery += " AND (B1_ISBN	= '" + ALLTRIM(aDados[nAux][LAY_PROD]) + "'"
	cQuery += " OR B1_CODBAR	= '" + ALLTRIM(aDados[nAux][LAY_PROD]) + "' "
	cQuery += " OR B1_COD	= '" + ALLTRIM(aDados[nAux][LAY_PROD]) + "')"
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	If Select("ACHOUSB1") > 0
		ACHOUSB1->(dbCloseArea())
	EndIf
		
	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "ACHOUSB1", .F., .T.)	
	
	ACHOUSB1->(DbGoTop())
	
	IF ACHOUSB1->(EOF())
		Aadd(aLog, "Linha "+StrZero(nAux,4)+" Produto "+ALLTRIM(aDados[nAux][LAY_PROD])+" nใo localizado!" )
		Loop
	Else
		SB1->(DbSeek(xFilial("SB1")+ACHOUSB1->B1_COD))	
	EndIF
	
	cChaveB2	:= xFilial("SB2")+SB1->B1_COD+cArmOri
	
	SB2->(DbSetOrder(1))	
	If SB2->(DbSeek(cChaveB2))
	   //	If !(SB2->B2_QATU >= aDados[nAux][LAY_QTD])
			If !(SB2->(B2_QATU-(B2_RESERVA+B2_QEMP)) >= aDados[nAux][LAY_QTD])
			  //	If SB2->B2_QATU > 0
			  If SB2->(B2_QATU-(B2_RESERVA+B2_QEMP)) > 0
				If lPermParc       
				  //	Aadd(aLog,"Linha:"+StrZero(nAux,4)+" ,Obra "+AllTrim(SB1->B1_COD)+" ("+AllTrim(SB1->B1_ISBN)+") atendida parcialmente, Qtd. Solicitada.: "+AllTrim(Str(aDados[nAux][LAY_QTD]))+", Qtd.Atendida.:"+AllTrim(Str(SB2->B2_QATU)))
					Aadd(aLog,"Linha:"+StrZero(nAux,4)+" ,Obra "+AllTrim(SB1->B1_COD)+" ("+AllTrim(SB1->B1_ISBN)+") atendida parcialmente, Qtd. Solicitada.: "+AllTrim(Str(aDados[nAux][LAY_QTD]))+", Qtd.Atendida.:"+AllTrim(Str(SB2->(B2_QATU-(B2_RESERVA+B2_QEMP)))))
				  //	aDados[nAux][LAY_QTD]	:= SB2->B2_QATU 
				  	aDados[nAux][LAY_QTD]	:= SB2->(B2_QATU-(B2_RESERVA+B2_QEMP))
				Else
					Aadd(aLog,"Linha:"+StrZero(nAux,4)+" ,Obra "+SB1->B1_COD+" ("+AllTrim(SB1->B1_ISBN)+" - "+AllTrim(SB1->B1_DESC)+") "+" nใo possui saldo suficiente em estoque.")
				EndIF	
			Else
				Aadd(aLog,"Linha:"+StrZero(nAux,4)+" ,Obra "+SB1->B1_COD+" ("+AllTrim(SB1->B1_ISBN)+" - "+AllTrim(SB1->B1_DESC)+") "+" nใo possui saldo em estoque.")
				Loop
			EndIf
    	EndIf
	Else
		Aadd(aLog,"Linha:"+StrZero(nAux,4)+" ,Obra "+SB1->B1_COD+" ("+AllTrim(SB1->B1_ISBN)+" - "+AllTrim(SB1->B1_DESC)+") nใo localizada no armazem "+cArmOri)
		Loop
	EndIf
	
	aDados[nAux][LAY_PROD]	:= SB1->B1_COD
	aDados[nAux][LAY_OK]	:= .T.
	
Next
IncProc("Gerando transferencia...")
nProc	:= 0	
For nAux := 1 To Len(aDados)
        
	If !aDados[nAux][LAY_OK]
		Loop
	EndIF
	
	SB1->(Dbseek(xFilial("SB1")+aDados[nAux][LAY_PROD]))
	
	aTransfer	:= {}	
	cNumDoc		:= NextNumero("SD3",2,"D3_DOC",.T.)
	aTransfer	:= {{cNumDoc,DDataBase}}		
	cProduto	:= SB1->B1_COD
	cLocOri		:= cArmOri
	nQuant		:= aDados[nAux][LAY_QTD]
	cLocDes		:= cArmDes

	If cIDDCF == "S"
		AADD(aTransfer,{SB1->B1_COD,;		//1-PRODUTO ORIGEM
							SB1->B1_DESC,;	//2-DESCRICAO ORIGEM
	                      	    SB1->B1_UM,;	//3-UM ORIGEM
	                      	    cLocOri,;		//4-ARMAZEM DE ORIGEM
	                            " ",;			//5-ENDERECO ORIGEM
	                      	    SB1->B1_COD,;	//6-PRODUTO DESTINO
	                      	    SB1->B1_DESC,;	//7-DESCRICAO DESTINO
	                      	    SB1->B1_UM,;	//8-UM DESTINO
	                      	    cLocDes,;		//9-ARMAZEM DESTINO
	                            " ",;			//10-ENDERECO DESTINO
	                            " ",;			//11-NUMERO DE SERIE
	                      	    " ",;			//12-LOTE
	                      	    " ",;			//13-SUB-LOTE
	                      	    CtoD("  /  /  "),;			//14-VALIDADE
	                      	    0,;				//15-POTENCIA
	                      	    nQuant,;		//16-QUANTIDADE
	                      	    ConvUm(SB1->B1_COD,nQuant,0,2),; //17-QUANTIDADE SEGUNDA UM
	                      	    Space(10),;		//18-ESTORNADO
	                      	    "      " 		/*cNumDoc*/,; //19-SEQUENCIA
	                      	    " ",; 			//20-LOTE DESTINO
	                      	    CtoD("  /  /  "),; 			//21-VALIDADE DESTINO
	                      	    Space(10),;//D3_ITEMGRD
	                      	    Space(03),;//D3_IDDCF
	                      	    Space(30);//D3_OBSERVA
	                      	    })
	Else
		AADD(aTransfer,{SB1->B1_COD,;		//1-PRODUTO ORIGEM
							SB1->B1_DESC,;	//2-DESCRICAO ORIGEM
	                      	    SB1->B1_UM,;	//3-UM ORIGEM
	                      	    cLocOri,;		//4-ARMAZEM DE ORIGEM
	                            " ",;			//5-ENDERECO ORIGEM
	                      	    SB1->B1_COD,;	//6-PRODUTO DESTINO
	                      	    SB1->B1_DESC,;	//7-DESCRICAO DESTINO
	                      	    SB1->B1_UM,;	//8-UM DESTINO
	                      	    cLocDes,;		//9-ARMAZEM DESTINO
	                            " ",;			//10-ENDERECO DESTINO
	                            " ",;			//11-NUMERO DE SERIE
	                      	    " ",;			//12-LOTE
	                      	    " ",;			//13-SUB-LOTE
	                      	    CtoD("  /  /  "),;			//14-VALIDADE
	                      	    0,;				//15-POTENCIA
	                      	    nQuant,;		//16-QUANTIDADE
	                      	    ConvUm(SB1->B1_COD,nQuant,0,2),; //17-QUANTIDADE SEGUNDA UM
	                      	    Space(10),;		//18-ESTORNADO
	                      	    "      " 		/*cNumDoc*/,; //19-SEQUENCIA
	                      	    " ",; 			//20-LOTE DESTINO
	                      	    CtoD("  /  /  "),; 			//21-VALIDADE DESTINO
	                      	    Space(10),;//D3_ITEMGRD
	                      	    Space(30);//D3_OBSERVA
	                      	    })	
	EndIf	                      	    
 
	DbSelectArea("SB2")
	SB2->(dbSetOrder(1))
	If !SB2->(dbSeek(xFilial("SB2")+cProduto+cLocDes)) //.And. MsgYesNo("Nใo existe registro para este produto no almoxarifado de destino! Deseja criar ?")
		RecLock("SB2",.T.)
		SB2->B2_FILIAL := xFilial("SB2")
		SB2->B2_COD    := cProduto
		SB2->B2_LOCAL  := cLocDes
		MsUnLock()
	EndIf	 
	
	lMsHelpAuto := .T. // Se .t. direciona as msgs de help para o arq. de log.
	lMsErroAuto := .F. // Nessecario a criacao, pois sera atualizado quando houver alguma inconsistencia nos parametros
		          
	MSExecAuto({|x,y| Mata261(x,y)},aTransfer,3)
	
	If lMsErroAuto
		aDados[nAux][LAY_OK] := .F.
		MostraErro(nil,FunName()+"_"+cNumDoc+".log")
		Aadd(aLog,"Linha:"+StrZero(nAux,4)+" ,Obra "+SB1->B1_COD+" ("+AllTrim(SB1->B1_ISBN)+" - "+AllTrim(SB1->B1_DESC)+") Erro ao gerar documento transferencia : "+cNumDoc+", arquivo de log "+FunName()+"_"+cNumDoc+".log")
	Else
		nProc++
	EndIf

Next

If Len(aLog) <> 0
	MsgAlert("Processo finalizado!"+Chr(13)+Chr(10)+"Registros processados "+StrZero(Len(aDados),4)+", transferencias realizadas "+StrZero(nProc,4)+" !"+Chr(13)+Chr(10)+" Foram encontradas Inconisistencias durante o processo, a seguir serแ apresentado um relat๓rio com estas inconisistencias!")
	ViewLog(aLog)
	IF MsgYesNo("Gera arquivo com itens nใo processados?")
		
		cFileDest := AllTrim(cGetFile("Arquivo Texto|*.CSV|*.TXT|Todos os Arquivos|*.*", OemToAnsi("Selecione o local e nome para salvar o arquivo."),0,"SERVIDOR",.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE))
		nHandle := FCreate(cFileDest)		
		If !(nHandle > 0)
			MsgAlert("Falha ao criar o arquivo.")
			Return nil
		EndIF
		
		For nAux := 1 To Len(aDados)
			If aDados[nAux][LAY_OK]
				Loop
			EndIF		
			FWrite(nHandle, aDados[nAux][LAY_PROD] )
			FWrite(nHandle, ";" )
			FWrite(nHandle, AllTrim(Str(aDados[nAux][LAY_QTD])) )
			FClose(nHandle)
		Next
		
		MsgAlert("Arquivo gerado com sucesso em "+cFileDest+"!")
		
	EndIF
Else
	MsgAlert("Processo finalizado - Registros processados"+StrZero(Len(aDados),4)+", transferencias realizadas "+StrZero(nProc,4)+" !"	)
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA030   บAutor  ณMicrosiga           บ Data ณ  11/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewLog(aLog)

Local oReport

oReport := reportDef(aLog)
oReport:printDialog()

Return

Static function ReportDef(aLog)

local oReport
local cTitulo	:= "Log de processamento"
local cPerg		:= ""

oReport := TReport():New(FunName(), cTitulo, cPerg , {|oReport| PrintReport(oReport,aLog)})

oReport:SetLandScape()

oReport:SetTotalInLine(.F.)

oReport:ShowHeader()

oSection0 := TRSection():New(oReport,"Mensagens",{""})

TRCell():New(oSection0,"LOG"  ,,"Log",,300)

return (oReport)


Static Function PrintReport(oReport,aLog)

Local oSection0 := oReport:Section(1)
Local nx		:= 0

For nx:=1 To Len(aLog)
 
 oReport:IncMeter()
 
 oSection0:Init()
 
 oSection0:Cell("LOG"):SetValue(aLog[nx])
 
 oSection0:PrintLine()      
  
Next nx

oSection0:Finish()

Return 
