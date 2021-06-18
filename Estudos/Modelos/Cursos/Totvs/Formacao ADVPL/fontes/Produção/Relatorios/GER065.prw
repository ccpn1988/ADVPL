#include "protheus.ch"
#include "topconn.ch"

/*/

DESCRICAO: RELATORIO AVALIACAO DA COLOCACAO DE NOVIDADES E NE

ALTERACOES:
07/03/2017 - Desenvolvimento do fonte

/*/

User Function GER065

Local oReport
Local cPerg := "GER065"

//Cria grupo de perguntas
f001(cPerg) 

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: f001

Descricao: Cria grupo de perguntas

Parametros:
- cPar1 - codigo do grupo de perguntas
------------------------------------------------------------------------------------------------

*/
Static Function f001(cPerg)

Local cItPerg	:= "00"
Local cMVCH 	:= "MV_CH0"
Local cMVPAR 	:= 'MV_PAR00"
Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}
Local cTitPer 	:= ""     

//---------------------------------------MV_PAR01--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório preenchimento.    ")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório preenchimento.    ")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão até:", "Dt Emissão até:" ,"Dt Emissão até:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------  
cCpoPer := "B1_COD"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Produto ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SB1IMP"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2
//Local oSection3

//Declaracao do relatorio
oReport := TReport():New("GER065","GER065 - AVALIAÇÃO DA COLOCAÇÃO DE NOVIDADES E NE",cPerg,{|oReport| PrintReport(oReport)},"GER065 - AVALIAÇÃO DA COLOCAÇÃO DE NOVIDADES E NE")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Produto","")

//Celulas da secao
TRCell():New(oSection1,"B1_ISBN"		,"","ISBN",,15)
TRCell():New(oSection1,"B1_DESC"   		,"","Descrição",,60)
TRCell():New(oSection1,"B5_XDTPUBL"		,"","Dt. Publicação",,10)
TRCell():New(oSection1,"CATEGORIA" 		,"","Categoria",,15)
TRCell():New(oSection1,"TIRAGEM"		,"","Tiragem",'@E 999,999,999',10,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"OFERTA"			,"","Ofertas",'@E 999,999,999',10,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"ESTOQUE"		,"","Estoque","@E 999,999,999",10,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"ESTOQUECSG"		,"","Estoque Consig.","@E 999,999,999",10,,,"RIGHT",,"RIGHT")

//Secao do relatorio
oSection2 := TRSection():New(oReport,"Clientes","")
	
//Celulas da secao
TRCell():New(oSection2,"RAIZ"		,"","Raiz CNPJ",,10)
TRCell():New(oSection2,"A1_NOME"   	,"","Cliente (Conceito Grupo - Raiz CNPJ)",,50)
TRCell():New(oSection2,"A1_EST"    	,"","UF",,5)
TRCell():New(oSection2,"TIPOCLI" 	,"","Tipo Cliente",,20)
TRCell():New(oSection2,"VENDEDOR"	,"","Vendedor",,20)
TRCell():New(oSection2,"QTDE" 		,"","Qtde Venda",'@E 999,999,999',15,,,,,"RIGHT")
TRCell():New(oSection2,"LIQ"		,"","Líq.Venda","@E 999,999,999.99",15,,,,,"RIGHT")
TRCell():New(oSection2,"QTDE_CSG"	,"","Qtde Consig",'@E 999,999,999',15,,,,,"RIGHT")
TRCell():New(oSection2,"LIQ_CSG"	,"","Vlr.Consig","@E 999,999,999.99",15,,,,,"RIGHT")
/*                      
//Secao do relatorio
oSection3 := TRSection():New(oReport,"Clientes não compraram","")
	
//Celulas da secao
TRCell():New(oSection3,"RAIZ"		,"","Raiz CNPJ",,10)
TRCell():New(oSection3,"A1_NOME"   	,"","Clientes canal livreiro não bloqueados que compram obras da área e que não compraram essa obra (Conceito Grupo - Raiz CNPJ)",,80)
TRCell():New(oSection3,"TIPOCLI" 	,"","Tipo Cliente",,20)
TRCell():New(oSection3,"VENDEDOR"	,"","Vendedor",,20)
*/                      
Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local _cQuery1  := ""
Local _cQuery2  := ""
Local _cQuery3  := ""
Local _cAlias1	:= GetNextAlias()            
Local _cAlias2	:= GetNextAlias()            
Local _cAlias3	:= GetNextAlias()            
Local _xLin     := 0

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
_cTab   := GETMV("GEN_FAT064")

If MV_PAR03 = " "
	MsgInfo('É necessário informar um produto!')
Else	
	_cQuery1 := " SELECT B1_COD, B1_ISBN, B1_DESC, STOC(B5_XDTPUBL) AS B5_XDTPUBL, DECODE(BM_XCATEG, 'D', 'DID - ', 'P', 'PROF - ', 'I', 'INT.GER - ') || DECODE(TO_NUMBER(TRIM(B5_XTIPINC)), '1', 'ON', '2', 'NE') AS CATEGORIA,
	_cQuery1 += "        D1_QUANT AS TIRAGEM, D2_QUANT AS OFERTA, EST.QTDE AS ESTOQUE, EST.QTDECONSIG AS ESTOQUECSG, EST.QTDETOTAL AS ESTOQUEDISP
	_cQuery1 += "   FROM " + RetSqlName("SB1") + " SB1
	_cQuery1 += "   INNER JOIN " + RetSqlName("SB5") + " SB5 ON B1_COD = B5_COD
	_cQuery1 += "   LEFT JOIN " + RetSqlName("SBM") + " SBM ON B1_GRUPO = BM_GRUPO
	_cQuery1 += "   LEFT JOIN (SELECT D2_COD, SUM(D2_QUANT) AS D2_QUANT
	_cQuery1 += "                FROM " + RetSqlName("SD2")
	_cQuery1 += "               WHERE D2_COD = '"+MV_PAR03+"'
	_cQuery1 += "                 AND D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'" 
	_cQuery1 += "                 AND D2_TES IN ('516','517','518','519')
	_cQuery1 += "                 AND D2_FILIAL = '" + xFilial("SD2") + "'"
	_cQuery1 += "                 AND D_E_L_E_T_ = ' ' 
    _cQuery1 += "               GROUP BY D2_COD) SD2 ON B1_COD = D2_COD
	_cQuery1 += "   LEFT JOIN (SELECT D1_COD, SUM(D1_QUANT) AS D1_QUANT
	_cQuery1 += "                FROM " + RetSqlName("SD1") + " SD1
	_cQuery1 += "               INNER JOIN " + RetSqlName("SB1") + " SB1 ON D1_COD = B1_COD
	_cQuery1 += "               WHERE D1_COD = '"+MV_PAR03+"'
	_cQuery1 += "                 AND D1_DTDIGIT <= '" + _cParm2 + "'" 
	_cQuery1 += "                 AND D1_TES IN ('004','104')
	_cQuery1 += "                 AND D1_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022')
	_cQuery1 += "                 AND SD1.D_E_L_E_T_ = ' ' 
	_cQuery1 += "                 AND B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery1 += "                 AND SB1.D_E_L_E_T_ = ' '
    _cQuery1 += "               GROUP BY D1_COD) SD1 ON B1_COD = D1_COD
	_cQuery1 += "  LEFT JOIN (SELECT B2_COD, SUM(QTDE) QTDE, SUM(QTDECONSIG) QTDECONSIG, SUM(QTDE+QTDECONSIG) QTDETOTAL
	_cQuery1 += "               FROM (SELECT B2_COD, B2_QATU QTDE, 0 QTDECONSIG
	_cQuery1 += "                       FROM " + RetSqlName("SB2")
	_cQuery1 += "                      WHERE B2_FILIAL = '1022'
	_cQuery1 += "                        AND B2_LOCAL = '01'
	_cQuery1 += "                        AND B2_COD = '"+MV_PAR03+"'
 	_cQuery1 += "                        AND D_E_L_E_T_ = ' '
	_cQuery1 += "                     UNION ALL
	_cQuery1 += "                     SELECT B6_PRODUTO, 0, SUM(B6_SALDO)
	_cQuery1 += "                       FROM " + RetSqlName("SB6")
	_cQuery1 += "                      WHERE B6_FILIAL = '1022'
	_cQuery1 += "                        AND B6_LOCAL = '01'
	_cQuery1 += "                        AND B6_TIPO = 'E'
	_cQuery1 += "                        AND B6_PRODUTO = '"+MV_PAR03+"'
	_cQuery1 += "                        AND D_E_L_E_T_  = ' '
	_cQuery1 += "                      GROUP BY B6_PRODUTO)
	_cQuery1 += "              GROUP BY B2_COD) EST ON B1_COD = EST.B2_COD
	_cQuery1 += "  WHERE B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery1 += "    AND SB1.D_E_L_E_T_ = ' '
	_cQuery1 += "    AND B1_COD = '"+MV_PAR03+"'
	_cQuery1 += "    AND B5_FILIAL = '" + xFilial("SB5") + "'"
	_cQuery1 += "    AND SB5.D_E_L_E_T_ = ' '
	_cQuery1 += "    AND BM_FILIAL = '" + xFilial("SBM") + "'"
	_cQuery1 += "    AND SBM.D_E_L_E_T_ = ' '
	
	If Select(_cAlias1) > 0
		dbSelectArea(_cAlias1)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery1), _cAlias1, .F., .T.)
	
	Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
		oReport:IncMeter()
	
		oSection1:Init()     
		
		oSection1:Cell("B1_ISBN"):SetValue((_cAlias1)->B1_ISBN)
		oSection1:Cell("B1_DESC"):SetValue((_cAlias1)->B1_DESC)
		oSection1:Cell("B5_XDTPUBL"):SetValue((_cAlias1)->B5_XDTPUBL)
		oSection1:Cell("CATEGORIA"):SetValue((_cAlias1)->CATEGORIA)
		oSection1:Cell("TIRAGEM"):SetValue((_cAlias1)->TIRAGEM)
		oSection1:Cell("OFERTA"):SetValue((_cAlias1)->OFERTA)
		oSection1:Cell("ESTOQUE"):SetValue((_cAlias1)->ESTOQUE)
		oSection1:Cell("ESTOQUECSG"):SetValue((_cAlias1)->ESTOQUECSG)
	
		oSection1:PrintLine()
	
		(_cAlias1)->(dbSkip())		
	EndDo
	oSection1:Finish()
         
	DbSelectArea(_cAlias1)
	DbCloseArea()
	
	_cQuery2 := " SELECT ' ' AS RAIZ,
	_cQuery2 += "        ' ' AS A1_NOME,
	_cQuery2 += "        ' ' AS A1_EST,
	_cQuery2 += "        ' ' AS TIPOCLI,
	_cQuery2 += "        ' ' AS VENDEDOR,
	_cQuery2 += "        SUM(FAT.QTDE) AS QTDE,
	_cQuery2 += "        SUM(FAT.LIQUIDO) AS LIQ,
	_cQuery2 += "        NVL(SUM(CSG.B6_SALDO),0) QTDE_CSG,
	_cQuery2 += "        NVL(SUM(CSG.B6_SALDO * DA1.DA1_PRCVEN * (1 - (SZ2.Z2_PERCDES / 100))),0) LIQ_CSG
	_cQuery2 += "    FROM (SELECT PRODUTO, CLIENTE, LOJA, SUM(QTDE) QTDE, SUM(LIQUIDO) LIQUIDO
	_cQuery2 += "            FROM (SELECT D2_COD PRODUTO, D2_CLIENTE CLIENTE, D2_LOJA LOJA, NVL(SUM(D2_QUANT),0) QTDE, NVL(SUM(D2_VALBRUT),0) LIQUIDO
	_cQuery2 += "                    FROM GER_SD2
	_cQuery2 += "                   WHERE D2_FILIAL  = '" + xFilial("SD2") + "'"
	_cQuery2 += "                     AND D2_COD = '"+MV_PAR03+"'
	_cQuery2 += "                     AND D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'" 
	_cQuery2 += "                   GROUP BY D2_COD, D2_CLIENTE, D2_LOJA
	_cQuery2 += "                  UNION ALL
	_cQuery2 += "                  SELECT D1_COD, D1_FORNECE, D1_LOJA, NVL(SUM(D1_QUANT),0)*(-1), NVL(SUM(D1_TOTAL - D1_VALDESC),0)*(-1)
	_cQuery2 += "                    FROM GER_SD1 SD1
	_cQuery2 += "                   WHERE D1_FILIAL  = '" + xFilial("SD1") + "'"
	_cQuery2 += "                     AND D1_COD = '"+MV_PAR03+"'
	_cQuery2 += "                     AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'" 
	_cQuery2 += "                   GROUP BY D1_COD, D1_FORNECE, D1_LOJA)
	_cQuery2 += "           GROUP BY PRODUTO, CLIENTE, LOJA) FAT
	_cQuery2 += "    LEFT JOIN (SELECT B6_CLIFOR, B6_LOJA, B6_PRODUTO, SUM(B6_SALDO) B6_SALDO
	_cQuery2 += "                 FROM " + RetSqlName("SB6")
	_cQuery2 += "                WHERE B6_FILIAL  = '" + xFilial("SB6") + "'"
	_cQuery2 += "                  AND B6_TIPO    = 'E'
	_cQuery2 += "                  AND B6_PODER3  = 'R'
	_cQuery2 += "                  AND B6_TPCF    = 'C'
	_cQuery2 += "                  AND D_E_L_E_T_ = ' '
	_cQuery2 += "                GROUP BY B6_CLIFOR, B6_LOJA, B6_PRODUTO) CSG
	_cQuery2 += "      ON FAT.CLIENTE = CSG.B6_CLIFOR
	_cQuery2 += "     AND FAT.LOJA = CSG.B6_LOJA
	_cQuery2 += "     AND FAT.PRODUTO = CSG.B6_PRODUTO
	_cQuery2 += "    LEFT JOIN " + RetSqlName("SA1") + " SA1
	_cQuery2 += "      ON FAT.CLIENTE = SA1.A1_COD
	_cQuery2 += "     AND FAT.LOJA = SA1.A1_LOJA
	_cQuery2 += "     AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
	_cQuery2 += "     AND SA1.D_E_L_E_T_ = ' ' 
	_cQuery2 += "    LEFT JOIN " + RetSqlName("DA1") + " DA1
	_cQuery2 += "      ON FAT.PRODUTO = DA1.DA1_CODPRO
	_cQuery2 += "     AND DA1.DA1_CODTAB = '" + _cTab + "'" 
	_cQuery2 += "     AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "'"
	_cQuery2 += "     AND DA1.D_E_L_E_T_ = ' '
	_cQuery2 += "    LEFT JOIN " + RetSqlName("SB1") + " SB1
	_cQuery2 += "      ON FAT.PRODUTO = SB1.B1_COD
	_cQuery2 += "     AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
	_cQuery2 += "     AND SB1.D_E_L_E_T_ = ' '
	_cQuery2 += "    LEFT JOIN " + RetSqlName("SZ2") + " SZ2
	_cQuery2 += "      ON SZ2.Z2_CLASSE  = SB1.B1_GRUPO
	_cQuery2 += "     AND SZ2.Z2_TIPO    = SA1.A1_XTPDES
	_cQuery2 += "     AND SZ2.Z2_FILIAL  = '" + xFilial("SZ2") + "'"
	_cQuery2 += "     AND SZ2.D_E_L_E_T_ = ' '
	_cQuery2 += " UNION ALL
	_cQuery2 += " SELECT DECODE(F.RAIZ, '99999999', '  ', F.RAIZ) AS RAIZ,
	_cQuery2 += "        DECODE(F.RAIZ, '99999999', 'CONSUMIDOR FINAL', C.A1_NOME) AS A1_NOME,
	_cQuery2 += "        DECODE(F.RAIZ, '99999999', '  ', C.A1_EST) AS A1_EST,
	_cQuery2 += "        C.X5_DESCRI AS TIPOCLI,
	_cQuery2 += "        C.A3_NOME AS VENDEDOR,
	_cQuery2 += "        F.QTDE,
	_cQuery2 += "        F.LIQ,
	_cQuery2 += "        F.QTDE_CSG,
	_cQuery2 += "        F.LIQ_CSG
	_cQuery2 += "    FROM (SELECT DECODE(TRIM(SA1.A1_XCANALV), '3', '99999999',DECODE(NVL(SUBSTR(SA1.A1_CGC,1,1),' '),' ',FAT.CLIENTE||FAT.LOJA,SUBSTR(SA1.A1_CGC,1,8))) RAIZ,
	_cQuery2 += "                 SUM(FAT.QTDE) AS QTDE,
	_cQuery2 += "                 SUM(FAT.LIQUIDO) AS LIQ,
	_cQuery2 += "                 NVL(SUM(CSG.B6_SALDO),0) QTDE_CSG,
	_cQuery2 += "                 NVL(SUM(CSG.B6_SALDO) * DA1.DA1_PRCVEN * (1 - (SZ2.Z2_PERCDES / 100)),0) LIQ_CSG
	_cQuery2 += "            FROM (SELECT PRODUTO, CLIENTE, LOJA, SUM(QTDE) QTDE, SUM(LIQUIDO) LIQUIDO
	_cQuery2 += "                    FROM (SELECT D2_COD PRODUTO, D2_CLIENTE CLIENTE, D2_LOJA LOJA, NVL(SUM(D2_QUANT),0) QTDE, NVL(SUM(D2_VALBRUT),0) LIQUIDO
	_cQuery2 += "                            FROM GER_SD2
	_cQuery2 += "                           WHERE D2_FILIAL  = '" + xFilial("SD2") + "'"
	_cQuery2 += "                             AND D2_COD = '"+MV_PAR03+"'
	_cQuery2 += "                             AND D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'" 
	_cQuery2 += "                           GROUP BY D2_COD, D2_CLIENTE, D2_LOJA
	_cQuery2 += "                          UNION ALL
	_cQuery2 += "                          SELECT D1_COD, D1_FORNECE, D1_LOJA, NVL(SUM(D1_QUANT),0)*(-1), NVL(SUM(D1_TOTAL - D1_VALDESC),0)*(-1)
	_cQuery2 += "                            FROM GER_SD1 SD1
	_cQuery2 += "                           WHERE D1_FILIAL  = '" + xFilial("SD1") + "'"
	_cQuery2 += "                             AND D1_COD = '"+MV_PAR03+"'
	_cQuery2 += "                             AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'" 
	_cQuery2 += "                           GROUP BY D1_COD, D1_FORNECE, D1_LOJA)
	_cQuery2 += "                   GROUP BY PRODUTO, CLIENTE, LOJA) FAT
	_cQuery2 += "            LEFT JOIN (SELECT B6_CLIFOR, B6_LOJA, B6_PRODUTO, SUM(B6_SALDO) B6_SALDO
	_cQuery2 += "                         FROM " + RetSqlName("SB6")
	_cQuery2 += "                        WHERE B6_FILIAL  = '" + xFilial("SB6") + "'"
	_cQuery2 += "                          AND B6_TIPO    = 'E'
	_cQuery2 += "                          AND B6_PODER3  = 'R'
	_cQuery2 += "                          AND B6_TPCF    = 'C'
	_cQuery2 += "                          AND D_E_L_E_T_ = ' '
	_cQuery2 += "                        GROUP BY B6_CLIFOR, B6_LOJA, B6_PRODUTO) CSG
	_cQuery2 += "              ON FAT.CLIENTE = CSG.B6_CLIFOR
	_cQuery2 += "             AND FAT.LOJA = CSG.B6_LOJA
	_cQuery2 += "             AND FAT.PRODUTO = CSG.B6_PRODUTO
	_cQuery2 += "            LEFT JOIN " + RetSqlName("SA1") + " SA1
	_cQuery2 += "              ON FAT.CLIENTE = SA1.A1_COD
	_cQuery2 += "             AND FAT.LOJA = SA1.A1_LOJA
	_cQuery2 += "             AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
	_cQuery2 += "             AND SA1.D_E_L_E_T_ = ' ' 
	_cQuery2 += "            LEFT JOIN " + RetSqlName("DA1") + " DA1
	_cQuery2 += "              ON FAT.PRODUTO = DA1.DA1_CODPRO
	_cQuery2 += "             AND DA1.DA1_CODTAB = '" + _cTab + "'" 
	_cQuery2 += "             AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "'"
	_cQuery2 += "             AND DA1.D_E_L_E_T_ = ' '
	_cQuery2 += "            LEFT JOIN " + RetSqlName("SB1") + " SB1
	_cQuery2 += "              ON FAT.PRODUTO = SB1.B1_COD
	_cQuery2 += "             AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
	_cQuery2 += "             AND SB1.D_E_L_E_T_ = ' '
	_cQuery2 += "            LEFT JOIN " + RetSqlName("SZ2") + " SZ2
	_cQuery2 += "              ON SZ2.Z2_CLASSE  = SB1.B1_GRUPO
	_cQuery2 += "             AND SZ2.Z2_TIPO    = SA1.A1_XTPDES
	_cQuery2 += "             AND SZ2.Z2_FILIAL  = '" + xFilial("SZ2") + "'"
	_cQuery2 += "             AND SZ2.D_E_L_E_T_ = ' '
	_cQuery2 += "           GROUP BY DECODE(TRIM(SA1.A1_XCANALV), '3', '99999999',DECODE(NVL(SUBSTR(SA1.A1_CGC,1,1),' '),' ',FAT.CLIENTE||FAT.LOJA,SUBSTR(SA1.A1_CGC,1,8))), DA1.DA1_PRCVEN, SZ2.Z2_PERCDES) F
	_cQuery2 += "    INNER JOIN (SELECT RAIZ, MIN(A1_COD) A1_COD, MIN(A1_LOJA) A1_LOJA
	_cQuery2 += "                  FROM (SELECT A.A1_COD, A.A1_LOJA, DECODE(TRIM(A.A1_XCANALV), '3', '99999999',DECODE(NVL(SUBSTR(A1_CGC,1,1),' '),' ',A1_COD||A1_LOJA,SUBSTR(A1_CGC,1,8))) RAIZ
	_cQuery2 += "                          FROM (SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_CGC, SA1.A1_XCANALV, N.LIQUIDO         
	_cQuery2 += "                                  FROM (SELECT CLIENTE, LOJA, SUM(LIQUIDO) LIQUIDO
	_cQuery2 += "                                          FROM (SELECT D2_COD PRODUTO, D2_CLIENTE CLIENTE, D2_LOJA LOJA, NVL(SUM(D2_QUANT),0) QTDE, NVL(SUM(D2_VALBRUT),0) LIQUIDO
	_cQuery2 += "                                                  FROM GER_SD2
	_cQuery2 += "                                                 WHERE D2_FILIAL  = '" + xFilial("SD2") + "'"
	_cQuery2 += "                                                   AND D2_COD = '"+MV_PAR03+"'
	_cQuery2 += "                                                   AND D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'" 
	_cQuery2 += "                                                 GROUP BY D2_COD, D2_CLIENTE, D2_LOJA
	_cQuery2 += "                                                UNION ALL
	_cQuery2 += "                                                SELECT D1_COD, D1_FORNECE, D1_LOJA, NVL(SUM(D1_QUANT),0)*(-1), NVL(SUM(D1_TOTAL - D1_VALDESC),0)*(-1)
	_cQuery2 += "                                                  FROM GER_SD1 SD1
	_cQuery2 += "                                                 WHERE D1_FILIAL  = '" + xFilial("SD1") + "'"
	_cQuery2 += "                                                   AND D1_COD = '"+MV_PAR03+"'
	_cQuery2 += "                                                   AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'" 
	_cQuery2 += "                                                 GROUP BY D1_COD, D1_FORNECE, D1_LOJA)
	_cQuery2 += "                                         GROUP BY CLIENTE, LOJA) N
	_cQuery2 += "                                  JOIN " + RetSqlName("SA1") + " SA1 ON N.CLIENTE = SA1.A1_COD AND N.LOJA = SA1.A1_LOJA) A,
	_cQuery2 += "                               (SELECT DECODE(TRIM(SA1.A1_XCANALV), '3', '99999999',DECODE(NVL(SUBSTR(A1_CGC,1,1),' '),' ',A1_COD||A1_LOJA,SUBSTR(A1_CGC,1,8))) RAIZ, MAX(LIQUIDO) LIQUIDO
	_cQuery2 += "                                  FROM (SELECT CLIENTE, LOJA, SUM(LIQUIDO) LIQUIDO
	_cQuery2 += "                                          FROM (SELECT D2_COD PRODUTO, D2_CLIENTE CLIENTE, D2_LOJA LOJA, NVL(SUM(D2_QUANT),0) QTDE, NVL(SUM(D2_VALBRUT),0) LIQUIDO
	_cQuery2 += "                                                  FROM GER_SD2
	_cQuery2 += "                                                 WHERE D2_FILIAL  = '" + xFilial("SD2") + "'"
	_cQuery2 += "                                                   AND D2_COD = '"+MV_PAR03+"'
	_cQuery2 += "                                                   AND D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'" 
	_cQuery2 += "                                                 GROUP BY D2_COD, D2_CLIENTE, D2_LOJA
	_cQuery2 += "                                                UNION ALL
	_cQuery2 += "                                                SELECT D1_COD, D1_FORNECE, D1_LOJA, NVL(SUM(D1_QUANT),0)*(-1), NVL(SUM(D1_TOTAL - D1_VALDESC),0)*(-1)
	_cQuery2 += "                                                  FROM GER_SD1 SD1
	_cQuery2 += "                                                 WHERE D1_FILIAL  = '" + xFilial("SD1") + "'"
	_cQuery2 += "                                                   AND D1_COD = '"+MV_PAR03+"'
	_cQuery2 += "                                                   AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'" 
	_cQuery2 += "                                                 GROUP BY D1_COD, D1_FORNECE, D1_LOJA)
	_cQuery2 += "                                         GROUP BY CLIENTE, LOJA) N
	_cQuery2 += "                                  JOIN " + RetSqlName("SA1") + " SA1 ON N.CLIENTE = SA1.A1_COD AND N.LOJA = SA1.A1_LOJA
	_cQuery2 += "                                 GROUP BY DECODE(TRIM(SA1.A1_XCANALV), '3', '99999999',DECODE(NVL(SUBSTR(A1_CGC,1,1),' '),' ',A1_COD||A1_LOJA,SUBSTR(A1_CGC,1,8)))) B
	_cQuery2 += "                         WHERE DECODE(TRIM(A1_XCANALV), '3', '99999999',DECODE(NVL(SUBSTR(A1_CGC,1,1),' '),' ',A1_COD||A1_LOJA,SUBSTR(A1_CGC,1,8))) = B.RAIZ
	_cQuery2 += "                         GROUP BY A.A1_COD, A.A1_LOJA, DECODE(TRIM(A.A1_XCANALV), '3', '99999999',DECODE(NVL(SUBSTR(A1_CGC,1,1),' '),' ',A1_COD||A1_LOJA,SUBSTR(A1_CGC,1,8)))
	_cQuery2 += "                        HAVING MAX(A.LIQUIDO) = MAX(B.LIQUIDO))
	_cQuery2 += "                 GROUP BY RAIZ) CG
	_cQuery2 += "      ON F.RAIZ = CG.RAIZ
	_cQuery2 += "    LEFT JOIN (SELECT A1_COD, A1_LOJA, A1_NOME, A1_EST, X5_DESCRI, A3_NOME
	_cQuery2 += "                 FROM " + RetSqlName("SA1") + " SA1
	_cQuery2 += "                 LEFT JOIN " + RetSqlName("SX5") + " SX5
	_cQuery2 += "                   ON A1_XTIPCLI = X5_CHAVE
	_cQuery2 += "                  AND X5_TABELA = 'TP'
	_cQuery2 += "                  AND X5_FILIAL  = '" + xFilial("SX5") + "'"
	_cQuery2 += "                  AND SX5.D_E_L_E_T_ = ' ' 
	_cQuery2 += "                 LEFT JOIN " + RetSqlName("SA3") + " SA3
	_cQuery2 += "                   ON A1_VEND = A3_COD
	_cQuery2 += "                  AND A3_FILIAL  = '" + xFilial("SA3") + "'"
	_cQuery2 += "                  AND SA3.D_E_L_E_T_ = ' ' ) C
	_cQuery2 += "      ON CG.A1_COD = C.A1_COD
	_cQuery2 += "     AND CG.A1_LOJA = C.A1_LOJA
	_cQuery2 += "  WHERE LIQ <> 0
	_cQuery2 += "  ORDER BY LIQ DESC

	If Select(_cAlias2) > 0
		dbSelectArea(_cAlias2)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery2), _cAlias2, .F., .T.)

	oReport:SkipLine(1)
	oSection2:Init()
	
	Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()        
		oReport:IncMeter()

		oSection2:SetHeaderSection(.T.)

		oSection2:Cell("RAIZ"):SetValue((_cAlias2)->RAIZ)
		oSection2:Cell("A1_NOME"):SetValue((_cAlias2)->A1_NOME)
 		oSection2:Cell("A1_EST"):SetValue((_cAlias2)->A1_EST)
		oSection2:Cell("TIPOCLI"):SetValue((_cAlias2)->TIPOCLI)
		oSection2:Cell("VENDEDOR"):SetValue((_cAlias2)->VENDEDOR)
		oSection2:Cell("QTDE"):SetValue((_cAlias2)->QTDE)
		oSection2:Cell("LIQ"):SetValue((_cAlias2)->LIQ)
		oSection2:Cell("QTDE_CSG"):SetValue((_cAlias2)->QTDE_CSG)
		oSection2:Cell("LIQ_CSG"):SetValue((_cAlias2)->LIQ_CSG)
	
		If _xLin == 0
			oReport:ThinLine()
			oSection2:PrintLine()
			oReport:ThinLine()
		Else
			oSection2:PrintLine()
		EndIf
		
		_xLin++		

		(_cAlias2)->(dbSkip())		
	EndDo
	oSection2:Finish()  

	DbSelectArea(_cAlias2)
	DbCloseArea()
/*
	_cQuery3 := " SELECT CLI.RAIZ, SA1.A1_NOME, SX5.X5_DESCRI AS TIPOCLI, SA3.A3_NOME AS VENDEDOR
	_cQuery3 += "   FROM (SELECT DISTINCT SUBSTR(A1_CGC,1,8) RAIZ
	_cQuery3 += "           FROM GER_SD2 SD2
	_cQuery3 += "          INNER JOIN " + RetSqlName("SA1") + " SA1
	_cQuery3 += "             ON D2_CLIENTE = A1_COD
	_cQuery3 += "            AND D2_LOJA = A1_LOJA
	_cQuery3 += "          WHERE D2_FILIAL = '" + xFilial("SD2") + "'"
	_cQuery3 += "            AND D2_COD IN (SELECT B5_COD 
	_cQuery3 += " 		                    FROM " + RetSqlName("SB5")
	_cQuery3 += " 						   WHERE B5_XAREA IN (SELECT B5_XAREA
	_cQuery3 += "                                                FROM " + RetSqlName("SB5")
	_cQuery3 += " 											  WHERE B5_COD = '"+MV_PAR03+"'
	_cQuery3 += "                                                 AND B5_FILIAL = '" + xFilial("SB5") + "'"
	_cQuery3 += " 												AND D_E_L_E_T_ = ' ')
	_cQuery3 += "                              AND B5_FILIAL = '" + xFilial("SB5") + "'"
	_cQuery3 += "                              AND D_E_L_E_T_ = ' ')
	_cQuery3 += "            AND TRIM(SA1.A1_XCANALV) = '1'
	_cQuery3 += "            AND SA1.A1_MSBLQL = '2'
	_cQuery3 += "            AND SA1.A1_CGC <> ' '
	_cQuery3 += "            AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	_cQuery3 += "            AND SA1.D_E_L_E_T_ = ' '
	_cQuery3 += "         MINUS
	_cQuery3 += "         SELECT DISTINCT SUBSTR(SA1.A1_CGC,1,8) RAIZ
	_cQuery3 += "           FROM (SELECT PRODUTO, CLIENTE, LOJA, SUM(QTDE) QTDE, SUM(LIQUIDO) LIQUIDO
	_cQuery3 += "                   FROM (SELECT D2_COD PRODUTO, D2_CLIENTE CLIENTE, D2_LOJA LOJA, NVL(SUM(D2_QUANT),0) QTDE, NVL(SUM(D2_VALBRUT),0) LIQUIDO
	_cQuery3 += "                           FROM GER_SD2
	_cQuery3 += "                          WHERE D2_FILIAL  = '" + xFilial("SD2") + "'"
	_cQuery3 += "                            AND D2_COD = '"+MV_PAR03+"'
	_cQuery3 += "                            AND D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
	_cQuery3 += "                          GROUP BY D2_COD, D2_CLIENTE, D2_LOJA
	_cQuery3 += "                         UNION ALL
	_cQuery3 += "                         SELECT D1_COD, D1_FORNECE, D1_LOJA, NVL(SUM(D1_QUANT),0)*(-1), NVL(SUM(D1_TOTAL - D1_VALDESC),0)*(-1)
	_cQuery3 += "                           FROM GER_SD1 SD1
	_cQuery3 += "                          WHERE D1_FILIAL  = '" + xFilial("SD1") + "'"
	_cQuery3 += "                            AND D1_COD = '"+MV_PAR03+"'
	_cQuery3 += "                            AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
	_cQuery3 += "                          GROUP BY D1_COD, D1_FORNECE, D1_LOJA)
	_cQuery3 += "                  GROUP BY PRODUTO, CLIENTE, LOJA) FAT
	_cQuery3 += "           JOIN " + RetSqlName("SA1") + " SA1
	_cQuery3 += "             ON FAT.CLIENTE = SA1.A1_COD
	_cQuery3 += "            AND FAT.LOJA = SA1.A1_LOJA
	_cQuery3 += "            AND TRIM(SA1.A1_XCANALV) <> '3'
	_cQuery3 += "            AND SA1.A1_CGC <> ' '
	_cQuery3 += "            AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
	_cQuery3 += "            AND SA1.D_E_L_E_T_ = ' ') CNC
	_cQuery3 += "  INNER JOIN (SELECT SUBSTR(A1_CGC,1,8) AS RAIZ, MIN(A1_COD) A1_COD, MIN(A1_LOJA) A1_LOJA
	_cQuery3 += "                FROM " + RetSqlName("SA1")
	_cQuery3 += "               WHERE TRIM(A1_XCANALV) = '1'
	_cQuery3 += "                 AND A1_CGC <> ' '
	_cQuery3 += "                 AND A1_MSBLQL = '2'
	_cQuery3 += "                 AND A1_FILIAL  = '" + xFilial("SA1") + "'"
	_cQuery3 += "                 AND D_E_L_E_T_ = ' '
	_cQuery3 += "               GROUP BY SUBSTR(A1_CGC,1,8)) CLI
	_cQuery3 += "     ON CNC.RAIZ = CLI.RAIZ
	_cQuery3 += "  INNER JOIN " + RetSqlName("SA1") + " SA1
	_cQuery3 += "     ON CLI.A1_COD = SA1.A1_COD
	_cQuery3 += "    AND CLI.A1_LOJA = SA1.A1_LOJA
	_cQuery3 += "    AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	_cQuery3 += "    AND SA1.D_E_L_E_T_ = ' '
	_cQuery3 += "   LEFT JOIN " + RetSqlName("SX5") + " SX5
	_cQuery3 += "     ON SA1.A1_XTIPCLI = SX5.X5_CHAVE
	_cQuery3 += "    AND SX5.X5_TABELA = 'TP'
	_cQuery3 += "    AND SX5.X5_FILIAL = '" + xFilial("SX5") + "'"
	_cQuery3 += "    AND SX5.D_E_L_E_T_ = ' '
	_cQuery3 += "   LEFT JOIN " + RetSqlName("SA3") + " SA3
	_cQuery3 += "     ON SA1.A1_VEND = SA3.A3_COD
	_cQuery3 += "    AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"
	_cQuery3 += "    AND SA3.D_E_L_E_T_ = ' '
	_cQuery3 += "  ORDER BY RAIZ
				
	If Select(_cAlias3) > 0
		dbSelectArea(_cAlias3)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery3), _cAlias3, .F., .T.)
	
	oReport:SkipLine(1)
	oReport:ThinLine()
	oReport:SkipLine(1)

	oSection3:Init()
	
	Do While !(_cAlias3)->(eof()) .And. !oReport:Cancel()        
		oReport:IncMeter()

		oSection3:SetHeaderSection(.T.)

		oSection3:Cell("RAIZ"):SetValue((_cAlias3)->RAIZ)
		oSection3:Cell("A1_NOME"):SetValue((_cAlias3)->A1_NOME)
		oSection3:Cell("TIPOCLI"):SetValue((_cAlias3)->TIPOCLI)
		oSection3:Cell("VENDEDOR"):SetValue((_cAlias3)->VENDEDOR)
	
		oSection3:PrintLine()

		(_cAlias3)->(dbSkip())		
	EndDo
	oSection3:Finish()  

	DbSelectArea(_cAlias3)
	DbCloseArea()
*/
EndIf	

Return(.t.)