/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2015/12/15/vd-advpl-015/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zCadPessoa
Fun��o que testa a classe Pessoa
@author Atilio
@since 13/12/2015
@version 1.0
	@example
	u_zCadPessoa()
/*/

User Function zCadPessoa()
	Local oPessoa
	Local cNome		:= "Jos�"
	Local dNascimento	:= sToD("19850712")
	
	//Instanciando o objeto atrav�s da classe Pessoa
	oPessoa := zPessoa():New(cNome, dNascimento)
	
	//Chamando um m�todo da classe
	oPessoa:MostraIdade()
Return
