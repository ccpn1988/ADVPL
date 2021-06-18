
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F401Qry5  ºAutor  ³Microsiga           º Data ³  09/15/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ponto de entrada da rotina fina401 função Fa401SqlSImp      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F401Qry5()

Local cQuery	:= ParamIxb[1]
Local cRemov	:= "OR  (A.E2_BAIXA = ' ' AND    A.E2_EMIS1 >= '"+DtoS(MV_PAR02)+"' AND    A.E2_EMIS1 <= '"+DtoS(MV_PAR03)+"' )"

//SELECT A.E2_FILIAL, A.E2_VALOR, A.E2_CODRET, A.E2_EMIS1, A.E2_FORNECE, A.E2_LOJA, A.E2_IRRF, A.E2_PREFIXO, A.E2_NUM,  A.E2_PARCELA, A.E2_TIPO, A.E2_PARCIR, A.E2_PIS, A.E2_PARCPIS, A.E2_COFINS, A.E2_CSLL,  A.E2_VENCTO, A.E2_VENCREA, A.E2_BAIXA, A.E2_NATUREZ,  A.E2_FATURA, A.E2_FATFOR, A.E2_FATLOJ, A.E2_FATPREF, A.E2_TIPOFAT,  A.R_E_C_N_O_, SA2.A2_CGC, A.E2_ISS, A.E2_INSS ,A.E2_EMISSAO, A.E2_ISS , A.E2_SALDO ,  A.E2_INSS ,  A.E2_PRINSS, A.E2_PRISS,  SA2.A2_CPFIRP, 		SA2.R_E_C_N_O_ RECNOSA2 FROM SE2000 A  JOIN SA2000 SA2 ON  SA2.A2_FILIAL = '    ' AND  A.E2_FORNECE = SA2.A2_COD AND  A.E2_LOJA = SA2.A2_LOJA AND  SA2.D_E_L_E_T_ = ' ' WHERE 	 A.E2_FILIAL = '9001' AND ( A.E2_NATUREZ NOT IN ('PCC','COFINS','CSLL')  AND  (A.E2_BAIXA >= '20160101' AND    A.E2_BAIXA <= '20161231' )  )  AND  A.E2_TIPO NOT IN ('NCC','NDF','IR-','CS-','CF-','PI-','AB-','FB-','FC-','FU-','FP-','FM-','IR-','IN-','IS-','PI-','CF-','CS-','FE-','IV-','ISS','TX ','TXA','INS','SES','INA','PR ','PA ') AND  A.E2_CODRET != ' ' AND  A.E2_DIRF = '1' AND NOT EXISTS ( SELECT	B.E2_NUM FROM SE2000 B 			        WHERE  B.E2_FILIAL = '9001' AND            				B.E2_PREFIXO = A.E2_PREFIXO AND 				B.E2_NUM = A.E2_NUM AND 				(B.E2_PARCELA = A.E2_PARCIR OR B.E2_PARCELA = A.E2_PARCPIS OR B.E2_PARCELA = A.E2_PARCCOF OR B.E2_PARCELA = A.E2_PARCSLL) AND 	  			B.E2_TIPO = 'TX ' AND 				B.E2_FORNECE = 'UNIAO' AND 				B.E2_LOJA = '00' AND 			B.D_E_L_E_T_ = ' ') AND  A.D_E_L_E_T_ = ' ' 
If 	MV_PAR01 == 4 .AND.; // pela baixa
	MV_PAR04 == 1 // pessoa fisica
	
	//cQuery := StrTran(cQuery,cRemov,'')
	
	//If Left(cFilAnt,1) == "9"   
	//	cQuery := StrTran(cQuery,"B.E2_FILIAL = '9001' AND",'')
	//EndIf
	
	cQuery += " AND A.E2_BAIXA <> ' ' AND A.E2_CODRET  NOT IN ('0422')  "
	
Else
	cQuery += "AND 1 <> 1"		
EndIf

WfForceDir("\dirf_2017\"+cFilAnt+"\")
MemoWrite("\dirf_2017\"+cFilAnt+"\"+DtoS(DDataBase)+"_F401Qry5_"+StrTran(Time(),":","")+".sql",cQuery)

Return cQuery
