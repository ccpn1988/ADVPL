/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2019/09/26/funcao-que-converte-um-arquivo-do-ixblog-transformando-em-um-excel-para-analise-dos-dados/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zLog2Excel
Fun��o que converte um arquivo gerado com IXBLOG em uma planilha para an�lise
@author Atilio
@since 29/08/2018
@version 1.0
@param cArquivo, characters, Caminho do arquivo a ser analisado
@type function
@sample u_zLog2Excel("C:\spool\administrador_461090.txt")
/*/

User Function zLog2Excel(cArquivo)
	Local aArea      := GetArea()
	Default cArquivo := ""

	//Se tiver conte�do e o arquivo existir, chama o processamento
	If ! Empty(cArquivo) .And. File(cArquivo)
		Processa({|| fProcessa(cArquivo)}, "Processando")
	EndIf

	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fProcessa                                                    |
 | Desc:  Fun��o que processa o arquivo e gera um arquivo do Excel     |
 *---------------------------------------------------------------------*/

Static Function fProcessa(cArquivo)
	Local aArea       := GetArea()
	Local oFile
	Local aLinhas     := {}
	Local nAtual      := 0
	Local cLinAtu     := ""
	Local aExport     := {}
	Local nPosSeq     := 1 //Sequencia
	Local nPosDe      := 2 //From
	Local nPosExe     := 3 //ExecBlock
	Local nPosIn      := 4 //Time In
	Local nPosOut     := 5 //Time Out
	Local nPosDif     := 6 //Diferen�a de Tempo
	Local oFWMsExcel
	Local oExcel
	Local cArqExport  := GetTempPath()+'zLog2Excel_'+dToS(Date())+'_'+StrTran(Time(), ':', '-')+'.xml'
	Local cWorkSheet  := "Log"
	Local cTable      := ""

	//Definindo o arquivo a ser lido
	oFile := FWFileReader():New(cArquivo)

	//Se o arquivo pode ser aberto
	If (oFile:Open())

		//Se n�o for fim do arquivo
		If ! (oFile:EoF())
			//Definindo o tamanho da r�gua
			aLinhas := oFile:GetAllLines()
			ProcRegua(Len(aLinhas))
			
			//M�todo GoTop n�o funciona, deve fechar e abrir novamente o arquivo
			oFile:Close()
			oFile := FWFileReader():New(cArquivo)
			oFile:Open()

			//Enquanto houver linhas a serem lidas
			While (oFile:HasLine())
			
				//Incrementando a r�gua
				nAtual++
				IncProc("Analisando linha " + cValToChar(nAtual) + " de " + cValToChar(Len(aLinhas)) + "...")
				
				//Buscando o texto da linha atual
				cLinAtu := oFile:GetLine()

				//Se o trecho cont�m IXBLOG TYPE, � uma nova linha
				If Upper("IXBLOG Type") $ Upper(cLinAtu)
					aAdd(aExport, {;
						0,;  //Sequencia
						"",; //From
						"",; //ExecBlock
						"",; //Time In
						"",; //Time Out
						"";  //Diferen�a de Tempo
					})
					
					//Define o tamanho da linha
					aExport[Len(aExport)][nPosSeq] := Len(aExport)
				
				//Atualiza tempo de entrada
				ElseIf Upper("Time In") $ Upper(cLinAtu)
					aExport[Len(aExport)][nPosIn] := Alltrim(SubStr(cLinAtu, At(':', cLinAtu) + 1, Len(cLinAtu)))
					
				//Atualiza tempo de saída
				ElseIf Upper("Time Out") $ Upper(cLinAtu)
					aExport[Len(aExport)][nPosOut] := Alltrim(SubStr(cLinAtu, At(':', cLinAtu) + 1, Len(cLinAtu)))
				
				//Atualiza a fun��o chamadora
				ElseIf Upper("ExecBlock") $ Upper(cLinAtu)
					aExport[Len(aExport)][nPosExe] := Alltrim(SubStr(cLinAtu, At(':', cLinAtu) + 1, Len(cLinAtu)))
				
				//Atualiza a origem
				ElseIf Upper("From") $ Upper(cLinAtu)
					aExport[Len(aExport)][nPosDe] := Alltrim(SubStr(cLinAtu, At(':', cLinAtu) + 1, Len(cLinAtu)))
				
				EndIf
			EndDo
			
			//Se tiver dados a serem gerados
			If Len(aExport) > 0
				//Agora percorre os dados, e atualiza a diferen�a de tempo
				ProcRegua(Len(aExport))
				For nAtual := 1 To Len(aExport)
					IncProc("Atualizando totais - " + cValToChar(nAtual) + " de " + cValToChar(Len(aLinhas)) + "...")
					
					aExport[nAtual][nPosDif] := ElapTime(aExport[nAtual][nPosIn], aExport[nAtual][nPosOut])
				Next
				
				ProcRegua(0)
				IncProc("Gerando o arquivo...")
				
				//Cria a planilha do excel
				oFWMsExcel := FWMSExcel():New()
				oFWMsExcel:AddworkSheet(cWorkSheet)
				oFWMsExcel:AddTable(cWorkSheet, cTable)
				
				//Adiciona as colunas
				oFWMsExcel:AddColumn(cWorkSheet, cTable, "Sequência",           1, 1)
				oFWMsExcel:AddColumn(cWorkSheet, cTable, "Origem (From)",       1, 1)
				oFWMsExcel:AddColumn(cWorkSheet, cTable, "Fun��o (ExecBlock)",  1, 1)
				oFWMsExcel:AddColumn(cWorkSheet, cTable, "Tempo Inicial",       1, 1)
				oFWMsExcel:AddColumn(cWorkSheet, cTable, "Tempo Final",         1, 1)
				oFWMsExcel:AddColumn(cWorkSheet, cTable, "Diferen�a de Tempo",  1, 1)
				
				//Adiciona todas as linhas no arquivo
				For nAtual := 1 To Len(aExport)
					oFWMsExcel:AddRow(cWorkSheet, cTable, aExport[nAtual])
				Next
				
				//Ativando o arquivo e gerando o xml
				oFWMsExcel:Activate()
				oFWMsExcel:GetXMLFile(cArqExport)
			
				//Abrindo o excel e abrindo o arquivo xml
				oExcel := MsExcel():New()
				oExcel:WorkBooks:Open(cArqExport)
				oExcel:SetVisible(.T.)
				oExcel:Destroy()
				
			EndIf
		EndIf

		//Fecha o arquivo e finaliza o processamento
		oFile:Close()
	EndIf

	RestArea(aArea)
Return