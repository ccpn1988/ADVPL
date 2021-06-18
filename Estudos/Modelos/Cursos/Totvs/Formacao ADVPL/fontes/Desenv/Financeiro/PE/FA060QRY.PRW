
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA060QRY  ºAutor  ³Cleuto Lima - Loop  º Data ³  21/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para inclusão de filtro na query de        º±±
±±º          ³titulos do fonte FINA060 para bordero de contas a receber   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Gen                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
02/06/2016 - Rafael Leite - Inserido getarea SE1, pergunta 03 e tratamento na query para MV_PAR03.
*/


User Function FA060QRY()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cFiltro	:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local _aSE1		:= SE1->(GetArea())

cPerg := "GENFA060"
PutSx1(cPerg, "01", "Natureza De"	 , "Natureza De"	, "Natureza De"	, "mv_ch1", "C", tamsx3("E1_NATUREZ")[1], 0, 0, "G", "", "SED", "", "", "MV_PAR01","","","",""	 ,"","","","","","","","","","","","")
PutSx1(cPerg, "02", "Natureza Até"	 , "Natureza Até"	, "Natureza Até", "mv_ch2", "C", tamsx3("E1_NATUREZ")[1], 0, 0, "G", "", "SED", "", "", "MV_PAR02","","","","ZZZZZ","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Cliente Boleto?", "a"            	, "a"			, "mv_ch3", "C", 1, 0, 0, "C", "", "", "", "", "MV_PAR03","Sim","Sim","Sim","1","Nao","Nao","Nao","","","","","","","","","")
Pergunte(cPerg,.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³26923 - filtrar titulos de acordo com cadastro do cliente campo ³
//³Boleto Email Sim/Não.                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cFiltro += " E1_NATUREZ BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "+cQuebra

cFiltro += " EXISTS ("
cFiltro += " SELECT * FROM "+RetSqlName("SA1")+" SA1 "+cQuebra
cFiltro += " WHERE A1_FILIAL = '"+xFilial("SA1")+"' "+cQuebra
cFiltro += " AND A1_COD = E1_CLIENTE "+cQuebra
cFiltro += " AND A1_LOJA = E1_LOJA "+cQuebra

If MV_PAR03 == 1
	cFiltro += " AND SA1.A1_BLEMAIL = '1' "+cQuebra
Endif

cFiltro += " AND SA1.D_E_L_E_T_ = ' ' "+cQuebra

cFiltro += ") "+cQuebra

RestArea(_aSE1)

Return cFiltro