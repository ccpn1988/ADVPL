#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'


//RELATÓRIO TREPORT EM TXT

User function RELTXT()


If MsgYesNo("Deseja gerar o arquivo?", "Atenção")
	
	Processa({||MntQry() },, "Processando....")//http://tdn.totvs.com/pages/releaseview.action?pageId=6815094
	MsAguarde({|| GeraArq() },,"O arquivo TXT está sendo gerado....")//https://www.blogadvpl.com/tela-para-processamento-msaguarde/
Else
	Alert("Operação Cancelada!!")
EndIf


	
Return

Static Function MntQry()

Local aArea 	:= GetArea()
Local _cAlias   := GetNextAlias()
Local cWhere	:= "%B1_MSBLQL != '1' AND B1_TIPO = ' '%"

	/*cQuery := " SELECT B1_FILIAL, B1_COD, B1_DESC" + CRLF
	cQuery += " FROM " + RetSqlName("SB1") + " SB1 " + CRLF
	cQuery += " WHERE D_E_L_E_T_ = ' ' " 
	//retornar uma query modificada de acordo a escrita adequada para o banco de dados em uso
	//http://tdn.totvs.com/display/public/PROT/ChangeQuery
	//http://tdn.totvs.com/pages/viewpage.action?pageId=23889335
	//http://tdn.totvs.com/display/tec/DBUseArea
	//http://tdn.totvs.com/display/tec/TCGenQry
	cQuery := ChangeQuery(cQuery) 
		dbUseArea(.T.,"TOPCONN",TCGENQRY(NIL,NIL,cQuery), 'TMP' , .F., .T.) 
		*/
	
	BeginSql Alias "_cAlias"
		
		SELECT
			B1_FILIAL,
			B1_COD,
			B1_DESC
		FROM
			%table:SB1% SB1
		WHERE
			B1_FILIAL = %xFILIAL:SB1%
			AND %Exp:cWhere%
			AND SB1.%notDel%
	
	ENDSQL
	
	//Pega as informações da última query
	aRetSql := GetLastQuery()//
	
	//Permite escrever e salvar um arquivo texto.
	//aRetSQL[2]- query executada
	memowrite("I:\sql.txt",aRetSql[2])
	
	RestArea(aArea)
	
Return

//FUNÇÃO PARA GERAR ARQUIVO TXT

Static Function GeraArq(_cAlias)

Local cDir := "I:\"
Local cArq := "ADVPLI.txt"
Local nHandle := FCreate(cDir+cArq) //CRIA O ARQUIVO TXT - http://tdn.totvs.com/display/tec/FCreate


	IF nHandle < 0
		Alert("Erro ao criar o aquivo" + cArq)
	Else
	
		/*For nLinha := 1 To 200
			FWrite(nHandle,"Gravando a linha " + StrZero(nlinha,3)+ CRLF) //http://tdn.totvs.com/display/tec/FWrite
		Next nLinha*/
			
		While _cAlias->(!EOF())
			FWrite(nHandle,_cAlias->(B1_FILIAL)+ " | " + _cAlias->(B1_COD)+ " | " + _cAlias->(B1_DESC) +   CRLF)
			_cAlias->(dbSkip())
		EndDo
			
			FClose(nHandle)
			_cAlias->(dbCloseArea())
			
	EndIf
	
		IF FILE("I:\\ADVPL.txt")
			MsgInfo("Arquivo Criado com Sucesso!")
		Else
			MsgAlert("Arquivo não gerado!","ALERTA")
		EndIF
		
Return

 