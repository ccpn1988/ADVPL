#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

//http://tdn.totvs.com/display/public/PROT/TReport
//http://tdn.totvs.com/pages/releaseview.action?pageId=415715475
//http://tdn.totvs.com/pages/releaseview.action?pageId=6815207
//https://www.blogadvpl.com/funcao-auxiliar-getlastquery/
//http://tdn.totvs.com/display/tec/MemoWrite
//http://tdn.totvs.com/pages/viewpage.action?pageId=24347039
//http://tdn.totvs.com/display/public/PROT/TRCell


User function TReport1()
	
	Local oReport
	Local cAlias := GetNextAlias() //ALIAS DISPONIVEL
	
	//Apresenta a tela de impressão para o usuário configurar o relatório.
	//http://tdn.totvs.com/display/public/PROT/PrintDialog
	OReport := RptStruc(cAlias)
	OReport:printDialog()
	
Return

//MONTANDO A CONSULTA
Static Function RPrint(oReport,cAlias)
	
	Local oSecao1	:= oReport:Section(1)
	
	//INICIALIZANDO A QUERY
	oSecao1:BeginQuery() 
	
	BeginSQL Alias cAlias
	
		SELECT
			B1_FILIAL FILIAL, B1_COD CODIGO, B1_DESC DESCRICAO, B1_TIPO TIPO, B1_ATIVO ATIVO
				FROM %Table:SB1% SB1
					WHERE B1_FILIAL =%xFILIAL:SB1%
					AND B1_MSBLQL <> '1'
					AND SB1.%notDel%
				GROUP BY B1_FILIAL, B1_COD, B1_DESC, B1_TIPO, B1_ATIVO	
	
	EndSQL
	
	//Pega as informações da última query
	aRetSql := GetLastQuery()//
	
	//Permite escrever e salvar um arquivo texto.
	//aRetSQL[2]- query executada
	memowrite("I:\sql.txt",aRetSql[2])
	
	//FINALIZANDO A QUERY
	oSecao1:EndQuery()
	
	//SetMeter ->Define o limite da régua de progressão do relatório
	//RecCount ->Determina a quantidade de registros existentes no arquivo.
	oReport:SetMeter((cAlias)->(RecCount()))
	
	//Impressão
	oSecao1:Print()
	
Return

//Estrutura do Relatório
Static Function  RptStruc(cAlias)

	Local cTitulo := "RCTI SB1"
	Local cHelp	  := "Permite Imprimir relatório de Produto"
	Local oReport 
	Local oSection1
	
	//Instanciando a classe TReport
	//http://tdn.totvs.com/display/public/PROT/TReport	
	//TReport():New( <cReport> , <cTitle> , <uParam> , <bAction> , <cDescription> , <lLandscape> , <uTotalText> , <lTotalInLine> , <cPageTText> , <lPageTInLine> , <lTPageBreak> , <nColSpace> ) 	   
	
	oReport := TReport():New("TReport1", cTitulo,/**/,{|oReport|RPrint(oReport,cAlias)},cHelp)

	//Seção do Relatório
	//http://tdn.totvs.com/display/public/PROT/TRSection
	//TRSection():New( <oParent> , <cTitle> , <uTable> , <aOrder> , <lLoadCells> , <lLoadOrder> , <uTotalText> , <lTotalInLine> , <lHeaderPage> , <lHeaderBreak> , <lPageBreak> , <lLineBreak> , <nLeftMargin> , <lLineStyle> , <nColSpace> , <lAutoSize> , <cCharSeparator> , <nLinesBefore> , <nCols> , <nClrBack> , <nClrFore> , <nPercentage> )
	
	oSection1 := TRSection():New(oReport,"Produtos", {"SB1"},{"B1_FILIAL","B1_COD"})
	
	//http://tdn.totvs.com/display/public/PROT/TRCell
	//TRCell():New( <oParent> , <cName> , <cAlias> , <cTitle> , <cPicture> , <nSize> , <lPixel> , <bBlock> , <cAlign> , <lLineBreak> , <cHeaderAlign> , <lCellBreak> , <nColSpace> , <lAutoSize> , <nClrBack> , <nClrFore> , <lBold> ) 
	
	TRCell():New(oSection1,"FILIAL","SB1","FILIAL")
	TRCell():New(oSection1,"CODIGO","SB1","CODIGO")
	TRCell():New(oSection1,"DESCRICAO","SB1","DESCRICAO")
	TRCell():New(oSection1,"TIPO","SB1","TIPO")
	TRCell():New(oSection1,"ATIVO","SB1","ATIVO")
		
	/*SEM ALIAS DOS CAMPOS
	TRCell():New(oSection1,"B1_FILIAL","SB1","FILIAL")
	TRCell():New(oSection1,"B1_COD","SB1","CODIGO")
	TRCell():New(oSection1,"B1_DESC","SB1","DESCRICAO")
	TRCell():New(oSection1,"B1_TIPO","SB1","TIPO")
	TRCell():New(oSection1,"B1_ATIVO","SB1","ATIVO")*/

	
Return (oReport)
