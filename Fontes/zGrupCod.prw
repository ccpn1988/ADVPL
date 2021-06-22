/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2018/06/19/funcao-para-deixar-codigo-produto-sequencial-conforme-grupo/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} zGrupCod
Fun��o que preenche o c�digo do produto conforme o grupo
@author Atilio
@since 04/04/2018
@version 1.0
@type function
@obs Passo a Passo de como fazer para funcionar:
	1. Acesse o Configurador (SIGACFG), v� na tabela SB1 e clique em Editar
	2. V� no campo Grupo (B1_GRUPO), verifique se ele est� como obrigat�rio, caso n�o esteja, deixe ele como obrigat�rio (est� na aba Uso)
	3. No modo de edi��o do campo, deixe a express�o INCLUI para ele ficar habilitado apenas na inclus�o (est� na aba Op�ões)
	4. Altere a sequência do campo, para ele vir antes do campo C�digo (B1_COD)
	5. V� no campo C�digo (B1_COD), no modo de edi��o deixe a express�o .F. para n�o deixar alterar o campo
	6. Confirme as altera�ões da tabela
	7. V� na se��o de Gatilhos, e clique para incluir um novo Gatilho. Nesse Gatilho, coloque a origem sendo o B1_GRUPO, e o destino o B1_COD, e a Regra sendo <b>u_zGrupCod()</b>
	8. Salve as altera�ões do Configurador
	9. Compile a fun��o abaixo
/*/

User Function zGrupCod()
	Local aArea   := GetArea()
	Local cCodigo := ""
	Local cGrupo  := FWFldGet("B1_GRUPO")
	Local cQryAux := ""
	Local nTamGrp := TamSX3('B1_GRUPO')[01]
	Local nTamCod := TamSX3('B1_COD')[01]
	
	//Se houver grupo
	If ! Empty(cGrupo)
		cCodigo := cGrupo + Replicate('0', nTamCod-nTamGrp)
		
		//Pegando o �ltimo c�digo (n�o foi fitraldo o DELET para manter a sequencia unica)
		cQryAux := " SELECT "                                                                        + CRLF
		cQryAux += " 	ISNULL(MAX(B1_COD), '" + cCodigo + "') AS ULTIMO "                           + CRLF
		cQryAux += " FROM "                                                                          + CRLF
		cQryAux += " 	" + RetSQLName('SB1') + " SB1 "                                              + CRLF
		cQryAux += " WHERE "                                                                         + CRLF
		cQryAux += " 	B1_FILIAL = '" + FWxFilial('SB1') + "' "                                     + CRLF
		cQryAux += " 	AND B1_GRUPO = '" + cGrupo + "' "                                            + CRLF
		cQryAux += " 	AND SUBSTRING(B1_COD, 1, " + cValToChar(nTamGrp) + ") = '" + cGrupo + "' "   + CRLF
		TCQuery cQryAux New Alias "QRY_AUX"
		
		//Define o novo c�digo, incrementando 1 no final
		cCodigo := Soma1(cCodigo)
		
		QRY_AUX->(DbCloseArea())
	EndIf
	
	RestArea(aArea)
Return cCodigo