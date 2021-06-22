/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/06/13/funcao-retorna-se-usuario-tem-acesso-filial-em-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zUsrFil
Fun��o que valida se o usu�rio tem acesso a filial
@author Atilio
@since 20/01/2017
@version undefined
@type function
	@param cCodUsr, characters, C�digo do usu�rio pesquisado (por default, vem o c�digo do usu�rio logado)
	@param cCodEmp, characters, C�digo da empresa / grupo de empresas (por default, vem o c�digo da empresa / grupo atual)
	@param cCodFil, characters, C�digo da filial (por default, vem o c�digo da filial atual)
	@example u_zUsrFil("000001", "01", "02")
	u_zUsrFil("000001", "01", "0201")
	@obs Fun��o desenvolvida com ajuda de Gabriel Cisneiro
/*/

User Function zUsrFil(cCodUsr, cCodEmp, cCodFil)
	Local lRet      := .F.
	Local aUsuarios := AllUsers()
	Local aUsrAux   := {}
	Local nLinEnc   := 0
	Local nPosFil   := 0
	Default cCodUsr := RetCodUsr()
	Default cCodEmp := cEmpAnt
	Default cCodFil := cFilAnt
	
	//Encontra o usu�rio
	nLinEnc:= aScan(aUsuarios, {|x| x[1][1] == cCodUsr })
	
	//Caso encontre o usu�rio
	If nLinEnc > 0
		aUsrAux := aClone(aUsuarios[nLinEnc][2][6])
		
		//Agora procura pela empresa + filial nos acessos 
		nPosFil := aScan(aUsrAux, {|x| x == cCodEmp + cCodFil })
		
		//Se encontrou a filial ou tem acesso a todas, o retorno ser� verdadeiro
		If nPosFil > 0 .Or. "@" $ aUsrAux[1]
			lRet := .T.
		EndIf
	EndIf
	
Return lRet