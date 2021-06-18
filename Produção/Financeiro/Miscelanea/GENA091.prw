#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#Include "Report.ch"

#DEFINE N_NUM		03
#DEFINE N_PARCELA	04
#DEFINE N_VALBRU   12
#DEFINE N_OPERA    16
#DEFINE N_MSG      19
#DEFINE N_OK	    20
#DEFINE N_ZZ9REC   21
#DEFINE N_PEDIDO	23
#DEFINE N_ZZ9SIT	24
#DEFINE N_SE1REC	27
#DEFINE N_STXADM	28
#DEFINE N_CODCLI	34
#DEFINE N_LOJCLI	35
#DEFINE N_NOMCLI	05
#DEFINE N_SIZE     35

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENA091  บAutor  ณBruno Parreira      บ Data ณ  17/06/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ JOB para realizar a baixa dos titulos site.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA091(aParam)
Local lEmp    := Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nLimite := 50
Local nx := 0

Default aParam	:= {"1","00","1022","",""}

Conout("GENA091 - Iniciando Job - Rotina de baixa automatica dos titulos site."+Time()+".")

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENA091 - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("GENA091 - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF

While !LockByName("GENA091",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENA091 - Nใo foi possํvel executar a baixa dos titulos pois a fun็ใo GENA091 jแ esta sendo executada por outro processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

ProcBaixa()

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("GENA091 - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("GENA091",.T.,.T.,.T.)

Conout("GENA091 - Finalizando Job - baixa titulos site - "+Time()+".")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENA091  บAutor  ณBruno Parreira      บ Data ณ  17/06/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ JOB para realizar a baixa dos titulos site.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ProcBaixa()
Local cQuery   := ""
Local nDiasTol := 2
Local dDtDeE1  := SuperGetMV("GEN_FIN018",.F.,"01/09/2019") //Data inicial para considerar a baixa dos titulos site
Local dDtAteE1 := SuperGetMV("GEN_FIN019",.F.,"01/09/2019") //DaySub(dDatabase,nDiasTol)
Local aDados   := {}
Local cEmail   := SuperGetMV("GEN_FIN020",.F.,"cobranca@grupogen.com.br;bruno.parreira@grupogen.com.br;")
Local cAssunto := ""
Local cMsg     := ""
Local lMail    := .F.

Local cArquivo	:= "SITE_"+DtoS(CtoD(dDtAteE1))+"_"+StrTran(Time(),":","")+".xls"
Local oExcel 	:= FWMSEXCEL():New()
Local cPath		:= "\workflow\Anexos\Baixas\" //Diretorio de gravacao de arquivos
Local cSheet	:= "Baixas com inconsist๊ncia"
Local cTable	:= "Tํtulos baixados com inconist๊ncia entre Protheus x AccesStage"
Local cSheet2	:= "Inconsist๊ncias consolidadas"
Local cTable2	:= "Baixas com inconsist๊ncias consolidadas por NSU"
Local cSheet3	:= "Tํtulos nใo encontrados"
Local cTable3	:= "Tํtulos nใo encontrados nos arquivos da AccessStage (Tabela ZZ9)"
Local cSheet4	:= "Operadora Inconsistente"
Local cTable4	:= "Titulos nใo baixados devido a incosist๊ncia na Operadora"
Local cSheet5	:= "Erros de processamento"
Local cTable5	:= "Titulos nใo baixados devido a erro no momento da baixa ou gera็ใo do tํtulo AB- (taxas)"
Local cSheet6	:= "Pagamentos nใo encontrados"
Local cTable6	:= "Pagamentos AccesStage nใo encontrados no Protheus"
Local cSituac  	:= ""
Local cDtMax    := DtoC(DaySub(DDataBase,1))
Local cDtMin    := DtoC(FirstDate(CtoD(cDtMax)))

WFForceDir(cPath)

oExcel:AddworkSheet(cSheet)
oExcel:AddTable(cSheet,cTable)

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )
oExcel:AddColumn(cSheet,cTable,"Titulo"    ,1,1)
oExcel:AddColumn(cSheet,cTable,"Prefixo"   ,1,1)
oExcel:AddColumn(cSheet,cTable,"Parcela"   ,1,1)
oExcel:AddColumn(cSheet,cTable,"NSU"       ,1,1)
oExcel:AddColumn(cSheet,cTable,"Cliente"   ,1,1)
oExcel:AddColumn(cSheet,cTable,"Loja"      ,1,1)
oExcel:AddColumn(cSheet,cTable,"Nome"      ,1,1)
oExcel:AddColumn(cSheet,cTable,"Emissใo"   ,1,1)
oExcel:AddColumn(cSheet,cTable,"Vencimento",1,1)
oExcel:AddColumn(cSheet,cTable,"Valor"     ,3,3)
oExcel:AddColumn(cSheet,cTable,"Pedido"    ,1,1)
oExcel:AddColumn(cSheet,cTable,"Operadora" ,1,1)
oExcel:AddColumn(cSheet,cTable,"Vlr.Access",3,3)
oExcel:AddColumn(cSheet,cTable,"Msg"       ,1,1)

oExcel:AddworkSheet(cSheet2)
oExcel:AddTable(cSheet2,cTable2)

oExcel:AddColumn(cSheet2,cTable2,"NSU"       ,1,1)
oExcel:AddColumn(cSheet2,cTable2,"Parcela"   ,1,1)
oExcel:AddColumn(cSheet2,cTable2,"Dt.Venda"  ,1,1)
oExcel:AddColumn(cSheet2,cTable2,"Dt.Cr้dito",1,1)
oExcel:AddColumn(cSheet2,cTable2,"Vlr. Protheus (A)",3,3)
oExcel:AddColumn(cSheet2,cTable2,"Vlr. AccesStage (B)",3,3)
oExcel:AddColumn(cSheet2,cTable2,"Diferen็a (A-B)",3,3)

oExcel:AddworkSheet(cSheet3)
oExcel:AddTable(cSheet3,cTable3)

oExcel:AddColumn(cSheet3,cTable3,"Titulo"    ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"Prefixo"   ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"Parcela"   ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"NSU"       ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"Cliente"   ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"Loja"      ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"Nome"      ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"Emissใo"   ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"Vencimento",1,1)
oExcel:AddColumn(cSheet3,cTable3,"Valor"     ,3,3)
oExcel:AddColumn(cSheet3,cTable3,"Pedido"    ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"Operadora" ,1,1)
oExcel:AddColumn(cSheet3,cTable3,"Msg"       ,1,1)

oExcel:AddworkSheet(cSheet4)
oExcel:AddTable(cSheet4,cTable4)

oExcel:AddColumn(cSheet4,cTable4,"Titulo"    ,1,1)
oExcel:AddColumn(cSheet4,cTable4,"Prefixo"   ,1,1)
oExcel:AddColumn(cSheet4,cTable4,"Parcela"   ,1,1)
oExcel:AddColumn(cSheet4,cTable4,"NSU"       ,1,1)
oExcel:AddColumn(cSheet4,cTable4,"Cliente"   ,1,1)
oExcel:AddColumn(cSheet4,cTable4,"Loja"      ,1,1)
oExcel:AddColumn(cSheet4,cTable4,"Nome"      ,1,1)
oExcel:AddColumn(cSheet4,cTable4,"Emissใo"   ,1,1)
oExcel:AddColumn(cSheet4,cTable4,"Vencimento",1,1)
oExcel:AddColumn(cSheet4,cTable4,"Valor"     ,3,3)
oExcel:AddColumn(cSheet4,cTable4,"Pedido"    ,1,1)
oExcel:AddColumn(cSheet4,cTable4,"Operadora" ,1,1)

oExcel:AddworkSheet(cSheet5)
oExcel:AddTable(cSheet5,cTable5)

oExcel:AddColumn(cSheet5,cTable5,"Titulo"    ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"Prefixo"   ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"Parcela"   ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"NSU"       ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"Cliente"   ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"Loja"      ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"Nome"      ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"Emissใo"   ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"Vencimento",1,1)
oExcel:AddColumn(cSheet5,cTable5,"Valor"     ,3,3)
oExcel:AddColumn(cSheet5,cTable5,"Pedido"    ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"Operadora" ,1,1)
oExcel:AddColumn(cSheet5,cTable5,"Msg"       ,1,1)

oExcel:AddworkSheet(cSheet6)
oExcel:AddTable(cSheet6,cTable6)

oExcel:AddColumn(cSheet6,cTable6,"NSU"       ,1,1)
oExcel:AddColumn(cSheet6,cTable6,"Parcela"   ,1,1)
oExcel:AddColumn(cSheet6,cTable6,"Dt.Venda"  ,1,1)
oExcel:AddColumn(cSheet6,cTable6,"Dt.Credito",1,1)
oExcel:AddColumn(cSheet6,cTable6,"Vlr.Bruto" ,3,3)
oExcel:AddColumn(cSheet6,cTable6,"Vlr.Liquid",3,3)
oExcel:AddColumn(cSheet6,cTable6,"Operadora" ,1,1)

cQuery += "Select * from ( "+CRLF
cQuery += "SELECT ZZ9.R_E_C_N_O_ RECZZ9,ZZ9_NSU,ZZ9_PARCEL,ZZ9_SITUAC,ZZ9_VALBRU,ZZ9_LIGPAG,ZZ9_SALDO,ZZ9_DTVEND,ZZ9_DTCRED,ZZ9_OPERA,NVL(utl_raw.cast_to_varchar2(ZZ9_MSG),' ') ZZ9_MSG, "+CRLF
cQuery += "       NVL(E1_FILIAL,' ') AS E1_FILIAL,SE1.R_E_C_N_O_ SE1REC,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_EMISSAO,E1_VENCREA,E1_VALOR,E1_SALDO,E1_BAIXA,E1_DOCTEF,UPPER(E1_XOPERA) AS E1_XOPERA, "+CRLF
cQuery += "       (select C6_XPEDWEB from "+RetSqlName("SC6")+" SC6 where C6_NOTA = E1_NUM and C6_SERIE = E1_PREFIXO and SC6.D_E_L_E_T_ = ' ' and ROWNUM = 1 group by C6_XPEDWEB) AS PEDWEB, "+CRLF
cQuery += "       NVL(AE_XIDOPER,' ') AS AE_XIDOPER,UPPER(AE_DESC) AS AE_DESC,A1_COD,A1_LOJA,A1_NOME, "+CRLF
cQuery += "       (SELECT COUNT(*) from "+RetSqlName("SE1")+" SE1_1 where SE1_1.E1_FILIAL = SE1.E1_FILIAL AND SE1_1.E1_NUM = SE1.E1_NUM AND SE1_1.E1_PREFIXO = SE1.E1_PREFIXO AND SE1_1.D_E_L_E_T_ = ' ') AS PARCELAS "+CRLF
cQuery += "FROM "+RetSqlName("ZZ9")+" ZZ9 "+CRLF
cQuery += "LEFT JOIN "+RetSqlName("SE1")+" SE1 "+CRLF
cQuery += "ON E1_FILIAL IN ('1001','1022')  "+CRLF
cQuery += "AND TO_NUMBER(nvl(TRIM(regexp_replace( regexp_replace(regexp_replace(TRIM(SE1.E1_DOCTEF),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(ZZ9.ZZ9_NSU),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) "+CRLF
cQuery += "AND NVL(TRIM(E1_PARCELA),'A') = TRIM(ZZ9.ZZ9_PARCEL) "+CRLF
cQuery += "AND SE1.E1_TIPO = 'NF' "+CRLF 
cQuery += "AND SE1.D_E_L_E_T_ <> '*'  "+CRLF
cQuery += "AND SE1.E1_NATUREZ = '30080'  "+CRLF
cQuery += "AND SE1.E1_DOCTEF <> ' ' "+CRLF
cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 "+CRLF 
cQuery += "ON A1_COD = E1_CLIENTE "+CRLF 
cQuery += "AND A1_LOJA = E1_LOJA "+CRLF 
cQuery += "AND SA1.D_E_L_E_T_ = ' '  "+CRLF
cQuery += "LEFT JOIN "+RetSqlName("SAE")+" SAE "+CRLF 
cQuery += "ON AE_COD = ZZ9_OPERA "+CRLF
cQuery += "AND SAE.D_E_L_E_T_ = ' '  "+CRLF
cQuery += "WHERE ZZ9_FILIAL = '    ' "+CRLF
cQuery += "AND ZZ9.D_E_L_E_T_ <> '*'  "+CRLF
cQuery += "AND ZZ9.ZZ9_TIPO = '11'  "+CRLF
cQuery += "AND ZZ9_DTCRED BETWEEN '"+DtoS(CtoD(dDtDeE1))+"' AND '"+DtoS(cToD(dDtAteE1))+"' "+CRLF
cQuery += "UNION ALL "+CRLF
cQuery += "SELECT 0 AS RECZZ9,' ' AS ZZ9_NSU,' ' AS ZZ9_PARCEL,' ' AS ZZ9_SITUAC,0 AS ZZ9_VALBRU,0 AS ZZ9_LIGPAG,0 AS ZZ9_SALDO,' ' AS ZZ9_DTVEND,' ' AS ZZ9_DTCRED,' ' AS ZZ9_OPERA,' ' AS ZZ9_MSG, "+CRLF
cQuery += "       E1_FILIAL,SE1.R_E_C_N_O_ SE1REC,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_EMISSAO,E1_VENCREA,E1_VALOR,NVL(E1_SALDO,0) AS E1_SALDO,E1_BAIXA,E1_DOCTEF,UPPER(E1_XOPERA) AS E1_XOPERA, "+CRLF
cQuery += "       (select C6_XPEDWEB from "+RetSqlName("SC6")+" SC6 where C6_NOTA = E1_NUM and C6_SERIE = E1_PREFIXO and SC6.D_E_L_E_T_ = ' ' and ROWNUM = 1 group by C6_XPEDWEB) AS PEDWEB, "+CRLF
cQuery += "       NVL(AE_XIDOPER,' ') AS AE_XIDOPER,UPPER(AE_DESC) AS AE_DESC,A1_COD,A1_LOJA,A1_NOME, "+CRLF
cQuery += "       (SELECT COUNT(*) from "+RetSqlName("SE1")+" SE1_1 where SE1_1.E1_FILIAL = SE1.E1_FILIAL AND SE1_1.E1_NUM = SE1.E1_NUM AND SE1_1.E1_PREFIXO = SE1.E1_PREFIXO AND SE1_1.D_E_L_E_T_ = ' ') AS PARCELAS "+CRLF
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "+CRLF
cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1  "+CRLF
cQuery += "ON A1_COD = E1_CLIENTE  "+CRLF
cQuery += "AND A1_LOJA = E1_LOJA  "+CRLF
cQuery += "AND SA1.D_E_L_E_T_ = ' '  "+CRLF
cQuery += "LEFT JOIN "+RetSqlName("SAE")+" SAE "+CRLF 
cQuery += "ON UPPER(AE_DESC) = UPPER(E1_XOPERA) "+CRLF
cQuery += "AND SAE.D_E_L_E_T_ = ' '  "+CRLF
cQuery += "WHERE E1_FILIAL IN ('1001','1022') "+CRLF 
cQuery += "AND SE1.E1_TIPO = 'NF '  "+CRLF
cQuery += "AND SE1.D_E_L_E_T_ <> '*' "+CRLF 
cQuery += "AND SE1.E1_NATUREZ = '30080' "+CRLF
cQuery += "AND SE1.E1_SALDO > 0  "+CRLF
cQuery += "AND SE1.E1_DOCTEF <> ' ' "+CRLF
cQuery += "AND SE1.E1_VENCREA BETWEEN '"+DtoS(CtoD(dDtDeE1))+"' AND '"+DtoS(cToD(dDtAteE1))+"' "+CRLF
cQuery += "AND NOT EXISTS (SELECT * FROM "+RetSqlName("ZZ9")+" ZZ9 where TO_NUMBER(nvl(TRIM(regexp_replace( regexp_replace(regexp_replace(TRIM(SE1.E1_DOCTEF),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) = TO_NUMBER(nvl(TRIM( regexp_replace( regexp_replace(regexp_replace(TRIM(ZZ9.ZZ9_NSU),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') ),0)) AND NVL(TRIM(SE1.E1_PARCELA),'A') = TRIM(ZZ9.ZZ9_PARCEL) AND ZZ9_FILIAL = '    ' AND ZZ9.D_E_L_E_T_ <> '*' AND ZZ9.ZZ9_TIPO = '11') "+CRLF
cQuery += ") Z where E1_SALDO > 0 OR E1_SALDO IS NULL "+CRLF
cQuery += "order by E1_XOPERA,ZZ9_NSU "+CRLF

Conout("GENA091 - Executando Query da rotina. "+Time())

MemoWrite("GENA091.sql",cQuery)

If Select("TRB") > 0
	dbSelectArea("TRB")
	TRB->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)

DbSelectArea("TRB")

Conout("GENA091 - Populando array que serแ processado pela rotina de baixa. "+Time())

If TRB->(!EOF())
	While TRB->(!EOF())	
		//Verifica se existe titulo SE1 referente ao NSU da ZZ9
		If Empty(TRB->E1_FILIAL)
			oExcel:AddRow(cSheet6,cTable6,{;
			TRB->ZZ9_NSU,;
			TRB->ZZ9_PARCEL,;
			DtoC(StoD(TRB->ZZ9_DTVEND)),;
			DtoC(StoD(TRB->ZZ9_DTCRED)),;
			TRB->ZZ9_VALBRU,;
			TRB->ZZ9_LIGPAG,;
			AllTrim(TRB->AE_DESC);
			})
			
			lMail := .T.
			
			TRB->(DbSkip())
			Loop
		EndIf
		
		//Verifica se nao existe ZZ9 para o SE1
		If TRB->RECZZ9 = 0 //Empty(TRB->RECZZ9)
			oExcel:AddRow(cSheet3,cTable3,{;
			TRB->E1_NUM,;
			TRB->E1_PREFIXO,;
			TRB->E1_PARCELA,;
			TRB->E1_DOCTEF,;
			TRB->A1_COD,;
			TRB->A1_LOJA,;
			TRB->A1_NOME,;
			DtoC(StoD(TRB->E1_EMISSAO)),;
			DtoC(StoD(TRB->E1_VENCREA)),;
			TRB->E1_VALOR,;
			TRB->PEDWEB,;
			AllTrim(TRB->E1_XOPERA),;
			"Tํtulo nใo encontrado nos arquivos da AccessStage";
			})
			
			lMail := .T.
			
			TRB->(DbSkip())
			Loop
		EndIf
		
		//Verifica se a Operadora cadastrada no titulo existe.
		DbSelectArea("SAE")
		DbOrderNickName("IDOPERA")
		If Empty(AllTrim(TRB->AE_XIDOPER)) .Or. !DbSeek(xFilial("SAE")+AllTrim(TRB->AE_XIDOPER))
			oExcel:AddRow(cSheet4,cTable4,{;
			TRB->E1_NUM,;
			TRB->E1_PREFIXO,;
			TRB->E1_PARCELA,;
			TRB->E1_DOCTEF,;
			TRB->A1_COD,;
			TRB->A1_LOJA,;
			TRB->A1_NOME,;
			DtoC(StoD(TRB->E1_EMISSAO)),;
			DtoC(StoD(TRB->E1_VENCREA)),;
			TRB->E1_VALOR,;
			TRB->PEDWEB,;
			TRB->E1_XOPERA;
			})
			
			lMail := .T.
			
			TRB->(DbSkip())
			Loop
		EndIf
		
		cSituac := TRB->ZZ9_SITUAC
		
		//Reprocessa situacao da ZZ9 quando a mesma for diferente de 2 - consistente
		If !(AllTrim(TRB->ZZ9_SITUAC) $ "2") .And. TRB->RECZZ9 > 0  
			Conout("Reprocessa Status Sit: "+TRB->ZZ9_SITUAC+" Filial: "+TRB->E1_FILIAL+" Prefixo: "+TRB->E1_PREFIXO+" Titulo: "+TRB->E1_NUM+" Parcela: "+TRB->E1_PARCELA)
			U_GENMF03H(.T.,TRB->RECZZ9) //Rotina de reprocessamento de situacao ZZ9
			
			DbSelectArea("ZZ9")
			ZZ9->(DbGoto(TRB->RECZZ9))
			cSituac := ZZ9->ZZ9_SITUAC		
		EndIf
		
		Aadd(aDados,Array(N_SIZE))
		nLin := Len(aDados)
		
		aDados[nLin][N_NUM]     := TRB->E1_NUM
		aDados[nLin][N_PARCELA] := TRB->E1_PARCELA
		aDados[nLin][N_VALBRU]  := TRB->ZZ9_VALBRU
		aDados[nLin][N_OPERA]   := AllTrim(TRB->AE_XIDOPER)
		aDados[nLin][N_OK]	    := .T.
		aDados[nLin][N_ZZ9REC]  := TRB->RECZZ9
		aDados[nLin][N_PEDIDO]  := TRB->PEDWEB
		aDados[nLin][N_ZZ9SIT]  := cSituac
		aDados[nLin][N_SE1REC]  := TRB->SE1REC
		//aDados[nLin][N_STXADM]  := TRB->E1_SALDO*(TRB->TAXA/100)
		aDados[nLin][N_CODCLI]  := TRB->A1_COD
		aDados[nLin][N_LOJCLI]  := TRB->A1_LOJA
		aDados[nLin][N_NOMCLI]  := TRB->A1_NOME
		aDados[nLin][N_MSG]     := TRB->ZZ9_MSG

		TRB->(DbSkip())
	EndDo
	
	If Len(aDados) > 0
		Conout("GENA091 - Executando a rotina GENMF03C para baixar os tํtulos incluํdos no array. "+Time())
		U_GENMF03C(aDados,.T.,@oExcel,@lMail,cSheet,cSheet2,cSheet4,cSheet5,cTable,cTable2,cTable4,cTable5)
	EndIf

EndIf

PutMV("GEN_FIN018",cDtMin)
PutMV("GEN_FIN019",cDtMax)

If lMail // .Or. lMail2
	Conout("GENA091 - Ativa excel email")

	oExcel:Activate()
	oExcel:GetXMLFile(cPath+cArquivo)
	
	If File(cPath+cArquivo)
		cAssunto := "Relat๓rio de inconsist๊ncias na baixa automแtica de tํtulos site"
		cMsg     := "Foram encontradas inconsist๊ncias na baixa automแtica de tํtulos site. Verificar relat๓rio em anexo."
		Conout("GENA091 - Enviando email")
		U_GenSendMail(,,,"noreply@grupogen.com.br",cEmail,oemtoansi(cAssunto),cMsg,cPath+cArquivo,,.F.)
	EndIf
EndIf

TRB->(DbCloseArea())

Return