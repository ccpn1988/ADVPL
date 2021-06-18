#include "PROTHEUS.ch"

User Function xtReport_SQL()

Local oReport
	//Criando o grupo de pergunta
	CriaPerg()
	
	//Carregando os dados da pergunta
    Pergunte("XCLIVEND",.F.)

	//Chando a Função para criar a estrutura do relatorio	
	oReport := ReportDef()
  
	//Imprimindo o Relatorio
	oReport:PrintDialog()
Return( Nil )
//***********************************************************************************************************************************

Static Function ReportDef()

Local oReport
Local oSection
Local oBreak

// Criando a o Objeto

oReport := TReport():New("ClinteXVendedor","Relatorio de Clientes X Vendedor","XCLIVEND",{|oReport| PrintReport(oReport)},"Relatorio de visitas de vendedores nos clientes")
oReport:SetLandscape() 
oSection := TRSection():New(oReport,"Dados dos Clientes",{"SA1"},{"UF","A1_COD"} )

	TRCell():New(oSection,"A1_COD"    ," SA1","Cliente")
	TRCell():New(oSection,"A1_LOJA"   , "SA1")
	TRCell():New(oSection,"A1_NOME"   , "SA1")
	TRCell():New(oSection,"A1_END"    , "SA1")
	TRCell():New(oSection,"A1_CEP"    , "SA1")
	TRCell():New(oSection,"A1_CONTATO", "SA1")
	TRCell():New(oSection,"A1_TEL"    , "SA1")
	TRCell():New(oSection,"A1_EST"    , "SA1")

// Quebra por Vendedor
//oBreak := TRBreak():New(oSection,oSection:Cell("A1_VEND"),"Sub Total Vendedores")     
//Fazendo a contagem por codigo
// TRFunction():New(oSection:Cell("A1_COD"   ), NIL, "COUNT", oBreak)

Return ( oReport )

//*******************************************************************************************

Static Function PrintReport(oReport)
Local aOrder   := oReport:GetOrder()
Local oSection := oReport:Section(1)
Local cPart := ""



oSection:BeginQuery()

	cPart := "% AND A1_COD >= '" + MV_PAR01 + "' "
	cPart += "  AND A1_COD <= '" + MV_PAR02 + "' %"
	
BeginSql alias "QRYSA1"

	SELECT A1_COD, 
				 A1_LOJA, 
				 A1_NOME, 
				 A1_VEND, 
				 A1_ULTVIS, 
				 A1_TEMVIS, 
				 A1_TEL, 
				 A1_CONTATO, 
				 A1_EST 
	FROM   %TABLE:SA1% SA1 
	WHERE  A1_FILIAL = %XFILIAL:SA1% 
	AND    A1_MSBLQL <> '1' 
	AND    SA1.%NOTDEL%
	
	%exp:cPart%
	
	ORDER BY A1_VEND
	
EndSql

aRetSql := GetLastQuery()

memowrite("C:\sql.txt",aRetSql[2])

oSection:EndQuery()

oSection:Print()

QRYSA1->(dbCloseArea())

Return( Nil )

//=====================================================================================================================

Static Function CriaPerg()

cPerg:= "XCLIVEND"


_nPerg 	:= 1

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(cPerg)
	DO WHILE ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(cPerg)
		_nPerg := _nPerg + 1
		DBSKIP()
	ENDDO
ENDIF

aRegistro:= {}
//          Grupo/Ordem/Pergunt      /SPA/ENG/Variavl/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/Pyme/GRPSXG/HELP/PICTURE
aAdd(aRegistro,{cPerg,"01","Cliente de?" ,"","","mv_ch1","C",tamSx3("A1_COD")[1],00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
aAdd(aRegistro,{cPerg,"02","Cliente ate?","","","mv_ch2","C",tamSx3("A1_COD")[1],00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})


IF Len(aRegistro) >= _nPerg
	For i:= _nPerg  to Len(aRegistro)
		Reclock("SX1",.t.)
		For j:=1 to FCount()
			If J<= LEN (aRegistro[i])
				FieldPut(j,aRegistro[i,j])
			Endif
		Next
		MsUnlock()
	Next
EndIf


Return()



