#INCLUDE "PROTHEUS.CH"

USER FUNCTION TMSPRINTER03()

	PRIVATE cData := dtoc(Date())
	PRIVATE cTime := time()

	PRIVATE cTitulo    := "Impressão - Relatório de produtos"
	PRIVATE oPrn       := oDlg := NIL
	PRIVATE oArial07   := NIL
	PRIVATE oArial09B  := NIL
	PRIVATE oArial14B  := NIL
	Private nPag       := 0
	PRIVATE nLinIni1   := 000, nColIni1:= 000, nLinFim1:= 200, nColFim1:= 100

	//Criando as fontes para o relatorido
	DEFINE FONT oArial10  NAME "Arial" SIZE 0,10 OF oPrn
	DEFINE FONT oArial10B NAME "Arial" SIZE 0,10 OF oPrn BOLD
	DEFINE FONT oArial12B NAME "Arial" SIZE 0,12 OF oPrn BOLD
	DEFINE FONT oArial20B NAME "Arial" SIZE 0,16 OF oPrn BOLD

	//Iniciando o Objeto TmsPrint 
	oPrn := TMSPrinter():New(cTitulo)

	//relatório como retrato               
	oPrn:SetPortrait()

	// Gerando as definições do Cabeçario do relatorio
	MeuCabec()

// Gerando as definições das linhas do relatorio
	Itens()

// Encerrando o relatorio esperando algum metodo de visualização ou impressão 
	oPrn:EndPage()

	
// Criando um Dialog
	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
		@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL
	 
		@ 015,017 SAY "Esta rotina tem por objetivo imprimir" OF oDlg PIXEL Size 150,010 FONT oArial20B COLOR CLR_HBLUE
		@ 030,017 SAY "Exemplo de Relatorio TMSPRINT:"        OF oDlg PIXEL Size 150,010 FONT oArial20B COLOR CLR_HBLUE
		@ 045,017 SAY "Cadastro de produto" 						   OF oDlg PIXEL Size 150,010 FONT oArial20B COLOR CLR_HBLUE
	 
	 //opções de visualização do relatorio.
	 
		@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
		@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
		@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL
 
	ACTIVATE MSDIALOG oDlg CENTERED

Return( NIL )

//----------------------------------------------------------------------------------

STATIC FUNCTION itens()

	Local nCont := 0
	Local nLin := 300
	Local cTipo := " "
	Local cAliasSB1 := GetNextAlias()
	Local aRetSql := {}
//Fazendo um Select no banco
	BeginSQL Alias cAliasSB1
		   
		SELECT B1_COD,
            B1_DESC,
            B1_UM,
            B1_TIPO
     FROM %Table:SB1% SB1
     WHERE B1_FILIAL =  %xFilial:SB1%
		AND %NotDel%     
		ORDER BY B1_TIPO,B1_UM

	EndSQL
	
	// Retorno do banco
	aRetSql := GetLastQuery()
//[1] cAlias - Alias usado para abrir o cursor.
//[2] cQuery - Query executada.
//[3] aCampos - Array de campos com critério de conversão especificados.
//[4] lNoParser - Caso verdadeiro (.T.), não foi utilizada a função ChangeQuery() na string original |%noparser%  .
//[5] nTimeSpend - Tempo, em segundos, utilizado para abertura do cursor.



	// Ponteiro na primeiro resgistro da tabela
	(cAliasSB1)->(dbGoTop())
	
	// Capiturando o Unidade de Medida para fazer a quebra
	ctipo := (cAliasSB1)->B1_UM
	
	While (cAliasSB1)->(!EOF())// (cAliasSB1)->(<COMANDO>)
		
		// Verificando se a quantidade de registro excedeu o tamanho da pagina 
		If nLin > 2000
		// Encerrando a pagina para criar um nova pagina 
			oPrn:EndPage()
		
		//Gerando o cabec da nova pagina
		 
			meucabec()
			nLin := 300
		
		Endif
		
		// Criando as linhas do relatorio	
		oPrn:Say(nLin,0020,(cAliasSB1)->B1_COD , oArial10 )
		oPrn:Say(nLin,0250,(cAliasSB1)->B1_DESC, oArial10 )
		oPrn:Say(nLin,1040,(cAliasSB1)->B1_UM  , oArial10 )
		oPrn:Say(nLin,1240,(cAliasSB1)->B1_TIPO, oArial10 )
		
		// contador
		nCont++
		
		// Fazendo calculo da linha 
		nLin := nLin + 50
		
		
		(cAliasSB1)->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		
		// Verificando se mudou a unidade de medida para fazer a quebra
		if cTipo <> (cAliasSB1)->B1_UM
			
			nLin := nLin + 50
		
			oPrn:Say(nLin,0020,"Total por Unidade : "+cTipo + " - " + cValtochar(nCont), oArial10B , , CLR_RED)
		
			nCont := 0
		// capturando a unidade de medida para fazer a quebra
			cTipo := (cAliasSB1)->B1_UM
		
			nLin := nLin + 150
			
		Endif
		
	Enddo

	(cAliasSB1)->(dbCloseArea())

Return( NIL )

//----------------------------------------------------------------------------------------------------------------------

Static function meucabec()

	nPag++
	//Criando uma pagina em branco
	oPrn:StartPage()
	
	//Imagem no relatorio
	oPrn:SayBitmap(nLinIni1,nColIni1,"\system\LGMID.PNG",nLinFim1,nColFim1+45)
	
	oPrn:Say(0020,0600,"RELATÓRIO DO CADASTRO DE PRODUTO",oArial20B)
	
	oPrn:Say(0100,1040,"DATA:",oArial12B)
	oPrn:Say(0100,1240,cData  ,oArial12B)
	
	oPrn:Say(0100,1500,"HORA:",oArial12B)
	oPrn:Say(0100,1700,cTime  ,oArial12B)
	
	oPrn:Say(0100,1900,"PAGINA:"       ,oArial12B)
	oPrn:Say(0100,2100,cvaltochar(nPag),oArial12B)
	
	oPrn:Line(0150,0000,0150,3000)
	
	oPrn:Say(0200,0020,"Cod.Produto", oArial10b)
	oPrn:Say(0200,0250,"Produto"    , oArial10b)
	oPrn:Say(0200,1040,"Unidade"    , oArial10b)
	oPrn:Say(0200,1240,"Tipo"       , oArial10b)
	
	oPrn:Line(0250,0000,0250,3000)

Return( NIL )

