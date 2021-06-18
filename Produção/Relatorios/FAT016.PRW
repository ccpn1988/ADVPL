#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: FAT016

DESCRICAO: FAT016 - FATURAMENTO KROTON


/*/

User Function FAT016

Local oReport
Local cPerg := "FAT016"

//Cria grupo de perguntas
f001(cPerg) 

//Carrega grupo de perguntas
If Pergunte(cPerg,.T.)

	oReport := ReportDef(cPerg)
	oReport:PrintDialog()
Endif

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
cTpoCpo := "D"
cTitPer := "Data "                                               
nTamPer := 8                                                                              
cTpoPer := "G"

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH , cTpoCpo, nTamPer, 0, 0, cTpoPer,"", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1

_cAno   := YEAR2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

//Declaracao do relatorio
oReport := TReport():New("FAT016","FAT016 - Faturamento Kroton - Vendas Mensais em Valores (R$)",cPerg,{|oReport| PrintReport(oReport)},"FAT016 - Faturamento Kroton - Vendas Mensais em Valores (R$)",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

oReport:NDEVICE := 4

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Canal/Tipo","")


//Celulas da secao
TRCell():New(oSection1,"CHAVE"	,"","")
TRCell():New(oSection1,"A1_XCANALV"	,"SA1","Canal Venda"	,,20)
TRCell():New(oSection1,"A1_XTIPCLI"	,"SA1","Vendedor"		,,20)

oSection1:Cell("CHAVE"):Hide() 

//Secao do relatorio
oSection2 := TRSection():New(oSection1,"FAT016 - Faturamento Kroton - Vendas Mensais em Valores (R$)","") 

//Celulas da secao
TRCell():New(oSection2,"Z7_DESC" 	    ,"","Área")
TRCell():New(oSection2,"LIQUIDO"		,"",_cAno+" YTD R$","@E 999,999,999.99",6,,,,,"RIGHT")
TRCell():New(oSection2,"LIQUIDO_AA"		,"",_cAnoAnt+" YTD R$","@E 999,999,999.99",6,,,,,"RIGHT")
TRCell():New(oSection2,"VLRJAN_AA"		,"","Jan"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRFEV_AA"		,"","Fev"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRMAR_AA"		,"","Mar"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRABR_AA"		,"","Abr"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRMAI_AA"		,"","Mai"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRJUN_AA"		,"","Jun"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRJUL_AA"		,"","Jul"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRAGO_AA"		,"","Ago"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRSET_AA"		,"","Set"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLROUT_AA"		,"","Out"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRNOV_AA"		,"","Nov"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRDEZ_AA"		,"","Dez"+_cAnoAnt+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRJAN"			,"","Jan"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRFEV"			,"","Fev"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRMAR"			,"","Mar"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRABR"			,"","Abr"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRMAI"			,"","Mai"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRJUN"			,"","Jun"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRJUL"			,"","Jul"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRAGO"			,"","Ago"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRSET"			,"","Set"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLROUT"			,"","Out"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRNOV"			,"","Nov"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 
TRCell():New(oSection2,"VLRDEZ"			,"","Dez"+_cAno+" R$","@E 999,999,999.99",6,,,,,"RIGHT") 


oBreak := TRBreak():New(oSection1,oSection1:Cell("CHAVE"),"Total do Canal/Tipo",.f.)

//Totalizadores
TRFunction():New(oSection2:Cell("LIQUIDO")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("LIQUIDO_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.) 
TRFunction():New(oSection2:Cell("VLRJAN_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRFEV_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRMAR_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRABR_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRMAI_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRJUN_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRJUL_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)         
TRFunction():New(oSection2:Cell("VLRAGO_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRSET_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLROUT_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRNOV_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRDEZ_AA")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRJAN")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRFEV")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRMAR")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRABR")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRMAI")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRJUN")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRJUL")	,NIL,"SUM",,,,,.T.,.T.,.F.)         
TRFunction():New(oSection2:Cell("VLRAGO")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRSET")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLROUT")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRNOV")	,NIL,"SUM",,,,,.T.,.T.,.F.)
TRFunction():New(oSection2:Cell("VLRDEZ")	,NIL,"SUM",,,,,.T.,.T.,.F.)


//Faz a impressao do totalizador em linha
oSection2:SetTotalInLine(.f.)
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
04/07/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)       
Local oSection2 := oReport:Section(1):Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cQuery	:= ""     
Local xCanal    := ""
 
_cParm1 := DTOS(LASTDATE(MV_PAR01))
_cAno   := YEAR2STR(MV_PAR01)
_cMes   := MONTH2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

If AnoMes(MV_PAR01) >= AnoMes(Date())
	MsgInfo('Esse relatório é mês fechado, informe uma data anterior ao mês corrente!')
Else	
	_cQuery += " SELECT XTP.X5_DESCRI||XZ2.X5_DESCRI CHAVE, XTP.X5_DESCRI A1_XTIPCLI, XZ2.X5_DESCRI A1_XCANALV,
	_cQuery += "	    SZ7.Z7_DESC Z7_DESC,
	_cQuery += "        SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "        	'02', VLRJAN+VLRFEV,
	_cQuery += "       		'03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "        	'04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "        	'05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "        	'06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "        	'07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "        	'08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "        	'09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "        	'10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "        	'11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "        	'12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDO,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "           '02', VLRJAN+VLRFEV,
	_cQuery += "           '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "           '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "           '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "           '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "           '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "           '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "           '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "           '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "           '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "           '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDO_AA,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRJAN, 0)) VLRJAN_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRFEV, 0)) VLRFEV_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRMAR, 0)) VLRMAR_AA,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRABR, 0)) VLRABR_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRMAI, 0)) VLRMAI_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRJUN, 0)) VLRJUN_AA,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRJUL, 0)) VLRJUL_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRAGO, 0)) VLRAGO_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRSET, 0)) VLRSET_AA,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLROUT, 0)) VLROUT_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRNOV, 0)) VLRNOV_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRDEZ, 0)) VLRDEZ_AA,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', VLRJAN, 0)) VLRJAN,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 2 THEN VLRFEV ELSE 0 END, 0)) VLRFEV,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 3 THEN VLRMAR ELSE 0 END, 0)) VLRMAR,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 4 THEN VLRABR ELSE 0 END, 0)) VLRABR,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 5 THEN VLRMAI ELSE 0 END, 0)) VLRMAI,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 6 THEN VLRJUN ELSE 0 END, 0)) VLRJUN,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 7 THEN VLRJUL ELSE 0 END, 0)) VLRJUL,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 8 THEN VLRAGO ELSE 0 END, 0)) VLRAGO,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 9 THEN VLRSET ELSE 0 END, 0)) VLRSET,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 10 THEN VLROUT ELSE 0 END, 0)) VLROUT,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 11 THEN VLRNOV ELSE 0 END, 0)) VLRNOV,
	_cQuery += "         SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 12 THEN VLRDEZ ELSE 0 END, 0)) VLRDEZ
	_cQuery += "  FROM DBA_EGK.VENDAMESCLIENTE_OBRA VMCO
	_cQuery += "    INNER JOIN TOTVS.SB5000 SB5 ON TO_NUMBER(TRIM(SB5.B5_COD)) = VMCO.IDOBRA     
	_cQuery += "     LEFT JOIN TOTVS.SZ7000 SZ7  ON SZ7.Z7_AREA   = SB5.B5_XAREA 
	_cQuery += "     LEFT JOIN " + RetSqlName("SA1") + " SA1 ON VMCO.A1_COD = SA1.A1_COD AND VMCO.A1_LOJA = SA1.A1_LOJA    
    _cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ2 ON XZ2.X5_CHAVE = SA1.A1_XCANALV 
	_cQuery += "   AND XZ2.X5_TABELA = 'Z2'
	_cQuery += "   AND XZ2.X5_FILIAL = '" + xFilial("SX5") + "'"
	_cQuery += "   AND XZ2.D_E_L_E_T_ = ' '	
	_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XTP ON XTP.X5_CHAVE = SA1.A1_XTIPCLI 
	_cQuery += "   AND XTP.X5_TABELA = 'TP'
	_cQuery += "   AND XTP.X5_FILIAL = '" + xFilial("SX5") + "'"
	_cQuery += "   AND XTP.D_E_L_E_T_ = ' '
	_cQuery += "  WHERE VMCO.ANO  IN ('"+ _cAnoAnt+"','"+ _cAno+"')
	_cQuery += "    AND VMCO.A1_CGC IN ('33005265000131','33005265000212','33005265000484','33005265000565','33005265000646','33005265000727','33005265001537','37464740000199','03766998000128','05137801000117', '02987778000161','02866163000187','02719825000196','05161540000170','02078252000169','04492733000141','02959800000160','03395289000183','03395289000264','05103128000102', '07612042000122','03062543000121','03062543000202','03568170000165','03812746000198','24771792000166','24771792000247','14793478000120','14793478000988','14793478000805', '14793478001526','14793478001445','14793478000554','14793478000716','14793478000635','14793478001283','02734954000153','02734954000234','02800026000140','03106437000100', '03106437000283','03239470000109','03239470000281','03239470000443','03239470000958','03239470001091','03239470001415','03239470001768','03239470001849','03239470001920', '03239470002144','03239470002225','03239470002306','03239470003205','03239470003892','03239470004279','03239470004350',
    _cQuery += "                        '03239470004783','03239470004864','03239470003620', '03239470003701','03239470004430','03239470001687','03239470002900','03239470003035','03239470003973','03239470004007','03239470004198','03239470004511','03239470004600', '03239470004945','03239470005089','03239470005321','03239470005674','03239470005755','03456737000101','03780878000185','03818379000130','03818379000300','03818379000563', '03818379000644','03818379000725','03818379000806','03818379000997','03818379001020','03818379001535','03818379000482','03818379001373','03818379001454','03818379001616', '03818379001292','03818379001101','03818379001705','04812026000195','04812026000276','04812026000357','05220480000110','05356755000147','05356755000309','05356755000228', '05356755000490','05478567000191','05478567000272','05478567000353','05478567000515','05478567000787','05478567000434','05478567000604','05478567000868','05478567000949', '07659308000192','08235595000176','08235595000257','08235595000338','09177477000111',
    _cQuery += "	 					'09177477000200','20150207000150','20150207002446','20150207002527','27356740000111', '27356740000464','30766455000183','38733648000140','38733648000492','38733648001383','38733648001464','38733648003750','38733648001898','38733648002002','38733648002193', '38733648002355','38733648002274','38733648001626','38733648001707','38733648003165','38733648002517','38733648003246','38733648003084','38733648002789','38733648002940', '38733648003327','38733648002860','38733648003599','38733648003670','38733648002606','38733648003408','38733648003831','38733648004218','38733648004137','38733648003912', '38733648004056','38733648004307','38733648004480','38733648004560','38733648002436','38733648004641','38733648004722','38733648004803','38733648004994','38733648005028', '38733648005109','38733648005290','38733648005370','38733648005451','38733648005532','38733648005613','38733648005702','38733648005885','38733648005966','38733648006008', '38733648006180','38733648006261','38733648006342',
    _cQuery += "						'38733648006423','38733648006504','38733648006695','36031664000165','06070599000116','04937617000199','04361470000131', '10527519000186','08971469000180','04310392000146','04310392000227','04310392001207','04310392001460','04310392000812','04310392001622','04310392001118','04310392000499', '04310392002190','04310392000570','04310392002432','04310392002351','04310392002513','04310392002009','04310392001975','04310392000731','04310392000650','04310392001037', '04310392001894','04310392000901','04310392002270','04310392001541','04310392002432','04310392000308','04310392001380','04310392001703','04310392002432','04310392004729', '10299604000134','05808792014522','30084263000430','30084263000359','30084263000600','30084263000510','50933761000174','14698185000164','14511609000130','15300826000143', '05792739000105','05792739000288','05792739000369','05808792000220','05808792000653','05808792001030','05808792000815','05808792000734','05808792000572','05808792000300', '05808792000149',
    _cQuery += "						'05808792000904','05808792001110','05808792001200','05808792001463','05808792001978','05808792001382','05808792002192','05808792001625','05808792002001', '05808792001706','05808792002788','05808792002435','05808792003326','05808792003164','05808792007585','05808792007747','05808792001897','05808792002273','05808792002354', '05808792002516','05808792007828','05808792002940','05808792003407','05808792003598','05808792002869','05808792007402','05808792003750','05808792004055','05808792003911', '05808792006503','05808792006937','05808792006775','05808792006422','05808792008042','05808792006856','05808792006694','05808792004721','05808792005370','05808792006007', '05808792007313','05808792008204','05808792004136','05808792005027','05808792005108','05808792003679','05808792004560','05808792005450','05808792004306','05808792004640', '05808792004217','05808792004489','05808792010020','05808792000149','05808792007666','05808792003245','05808792004993','05808792004802','05808792005884',
    _cQuery += "						'05808792005965', '05808792005299','05808792005531','05808792008395','05808792005612','05808792007909','05808792005701','05808792008980','05808792003083','05808792008476','05808792009367', '05808792008638','05808792008719','05808792009014','05808792009286','05808792009103','05808792009448','05808792009529','05808792009790','05808792012589','05808792010101', '05808792010292','05808792010373','05808792010454','05808792011000','05808792011183','05808792011345','05808792012821','05808792010705','05808792012074','05808792010888', '05808792011264','05808792012902','05808792012660','05808792012406','05808792012740','05808792012317','05808792012236','05808792013046','05808792013127','05808792013208', '05808792013399','01894432000156','01894432000318','01894432000407','01894432000580','01894432000660','01894432000741','01894432000903','03042939000107','03819722000160', '05031740000109','05859349000105','05859349000288','07162848000166','09221172000160','09572401000190','10601146000146',
    _cQuery += "						'17073302000192')
	_cQuery += "   GROUP BY XZ2.X5_DESCRI,XTP.X5_DESCRI,SZ7.Z7_DESC
	_cQuery += "   ORDER BY XZ2.X5_DESCRI,XTP.X5_DESCRI,VLRJAN_AA+VLRFEV_AA+VLRMAR_AA+VLRABR_AA+VLRMAI_AA+VLRJUN_AA+VLRJUL_AA+VLRAGO_AA+VLRSET_AA+VLROUT_AA+VLRNOV_AA+VLRDEZ_AA+VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ DESC


	If Select(_cAlias1) > 0
		dbSelectArea(_cAlias1)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)
	
	Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()   
		xCanal := (_cAlias1)->A1_XTIPCLI
		oReport:IncMeter()
	
	    oSection1:Init()  
	                         
	
	
		oSection1:Cell("A1_XCANALV"):SetValue((_cAlias1)->A1_XCANALV)
		oSection1:Cell("A1_XTIPCLI"):SetValue((_cAlias1)->A1_XTIPCLI)
		oSection1:Cell("CHAVE"):SetValue((_cAlias1)->CHAVE)
		
		oSection1:PrintLine()
		
	    Do While !(_cAlias1)->(eof()) .And. (_cAlias1)->A1_XTIPCLI = xCanal .And. !oReport:Cancel() 
		
		oSection2:Init()
		oSection2:SetHeaderSection(.T.)  
	                         
	
	
		oSection2:Cell("Z7_DESC"):SetValue((_cAlias1)->Z7_DESC)
		oSection2:Cell("LIQUIDO"):SetValue((_cAlias1)->LIQUIDO)
		oSection2:Cell("LIQUIDO_AA"):SetValue((_cAlias1)->LIQUIDO_AA)
		oSection2:Cell("VLRJAN_AA"):SetValue((_cAlias1)->VLRJAN_AA)
		oSection2:Cell("VLRFEV_AA"):SetValue((_cAlias1)->VLRFEV_AA)
		oSection2:Cell("VLRMAR_AA"):SetValue((_cAlias1)->VLRMAR_AA)
		oSection2:Cell("VLRABR_AA"):SetValue((_cAlias1)->VLRABR_AA)
		oSection2:Cell("VLRMAI_AA"):SetValue((_cAlias1)->VLRMAI_AA)
		oSection2:Cell("VLRJUN_AA"):SetValue((_cAlias1)->VLRJUN_AA)
		oSection2:Cell("VLRJUL_AA"):SetValue((_cAlias1)->VLRJUL_AA)
		oSection2:Cell("VLRAGO_AA"):SetValue((_cAlias1)->VLRAGO_AA)
		oSection2:Cell("VLRSET_AA"):SetValue((_cAlias1)->VLRSET_AA)
		oSection2:Cell("VLROUT_AA"):SetValue((_cAlias1)->VLROUT_AA)
		oSection2:Cell("VLRNOV_AA"):SetValue((_cAlias1)->VLRNOV_AA)
		oSection2:Cell("VLRDEZ_AA"):SetValue((_cAlias1)->VLRDEZ_AA)
		oSection2:Cell("VLRJAN"):SetValue((_cAlias1)->VLRJAN)
		oSection2:Cell("VLRFEV"):SetValue((_cAlias1)->VLRFEV)
		oSection2:Cell("VLRMAR"):SetValue((_cAlias1)->VLRMAR)
		oSection2:Cell("VLRABR"):SetValue((_cAlias1)->VLRABR)
		oSection2:Cell("VLRMAI"):SetValue((_cAlias1)->VLRMAI)
		oSection2:Cell("VLRJUN"):SetValue((_cAlias1)->VLRJUN)
		oSection2:Cell("VLRJUL"):SetValue((_cAlias1)->VLRJUL)
		oSection2:Cell("VLRAGO"):SetValue((_cAlias1)->VLRAGO)
		oSection2:Cell("VLRSET"):SetValue((_cAlias1)->VLRSET)
		oSection2:Cell("VLROUT"):SetValue((_cAlias1)->VLROUT)
		oSection2:Cell("VLRNOV"):SetValue((_cAlias1)->VLRNOV)
		oSection2:Cell("VLRDEZ"):SetValue((_cAlias1)->VLRDEZ)
	                                                                 
		oSection2:PrintLine()
	
		(_cAlias1)->(dbSkip())		
	EndDo 
		oSection2:Finish()
	EndDo
	oSection1:Finish() 
	oSection2:Finish()	         

	DbSelectArea(_cAlias1)
	DbCloseArea()
Endif
	
Return(.t.)
