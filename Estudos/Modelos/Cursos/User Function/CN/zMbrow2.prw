// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : zMbrow2.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 16/05/2019 | caio.neves        | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} zMbrow2
Manutenção de dados em ZZ2-TIPOS DE DESPESAS.

@author    caio.neves
@version   11.3.10.201812061821
@since     16/05/2019
/*/
//------------------------------------------------------------------------------------------

/*------------------------------------------------------------------------------------------
Notas sobre aRotina.
A lista multidimensional aRotina contém as definicoes das opcoes dísponiveis ao usuario.
Cada elemento indica uma opção e possue o formato:
private aRotina := {;
{<DESCRICAO>,<ROTINA>,0,<TIPO>}[,...];
}
Onde:
<DESCRICAO> - Descricao da opcao do menu
<ROTINA>    - Rotina a ser executada. Deve estar entre aspas duplas e pode ser
uma das funcoes pre-definidas do sistema (AXPESQUI, AXVISUAL, AXINCLUI, AXALTERA e
AXDELETA) ou a chamada de um EXECBLOCK. Ao utilizar a funcao AXDELETA, deve-se
declarar a variavel CDELFUNC, contendo uma expressao logica que define se o usuario
pode ou nao excluir o registro. Exemplos:
private cDelFunc := 'ExecBlock("TESTE")'
Ou
private cDelFunc := '.T.'
Ao utilizar chamada de EXECBLOCKs, as aspas simples devem estar SEMPRE por fora.
<TIPO>      - Identifica o tipo de rotina que sera executada. Podendo ser:
1, identifica rotina de pesquisa (não permite alterações)
3, identifica rotina de inclusao, esta sera chamada continuamente ao final do
processamento, ate o acionamento de <ESC>
4, identifica rotina de alteração, geralmente ao se usar uma chamada de EXECBLOCK

A declaracao padrão de aRotina (abaixo), fará com que MBROWSE comporte-se como AXCADASTRO.
private cDelFunc  := ".T."
private aRotina := {;
{ "Pesquisar"    ,"AxPesqui" , 0, 1},;
{ "Visualizar"   ,"AxVisual" , 0, 2},;
{ "Incluir"      ,"AxInclui" , 0, 3},;
{ "Alterar"      ,"AxAltera" , 0, 4},;
{ "Excluir"      ,"AxDeleta" , 0, 5};
}

Notas sobre a função MBROWSE.
Sintaxe: mBrowse(<nLin1>,<nCol1>,<nLin2>,<nCol2>,<Alias>,<aCampos>,<cCampo>)
Onde:
>nLin1>,...,<nCol2> - Coordenadas dos cantos aonde o browse sera exibido.
Para seguir o padrao da AXCADASTRO use sempre 6,1,22,75.
Na plataforma Windows, o browse sera exibi do sempre na janela ativa. Caso nenhuma
esteja ativa no momento, ele sera exibido na janela do proprio SIGAADV.
>Alias>                  - Alias do arquivo a ser exibido.
>aCampos>                - Lista multidimensional com os campos a serem exibidos
no browse. Se nao informado, todos os campos definidos no dicionario de dados serão
exibidos. Para arquivos de trabalho, faz-se obrigatório.
Cada elemento, indica uma coluna e possue o formato:
private aCampos := {
{<CAMPO>,<DESCRICAO>}[,...];
}
Onde:
<CAMPO>           - Nome do campo
<DESCRICAO>       - Título da coluna
<cCampo>                  - Nome do campo (entre aspas) que sera usado como ""flag"".
Se o campo estiver preenchido, o registro ficara em destaque.
------------------------------------------------------------------------------------------*/

user function zMbrow2()
//-- variáveis -------------------------------------------------------------------------

//Trabalho/apoio

//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	private cDelFunc := ".T." // Operacao: EXCLUSAO
	private cCadastro := "TIPOS DE DESPESAS" //Título das operações
	
	private aRotina := {;
						{ "Pesquisar"    ,"AxPesqui" , 0, 1},;
						{ "Visualizar"   ,"AxVisual" , 0, 2},;
						{ "Incluir"      ,"AxInclui" , 0, 3},;
						{ "Alterar"      ,"AxAltera" , 0, 4},;
						{ "Excluir"      ,"AxDeleta" , 0, 5};
						}
						
//-- procedimentos ---------------------------------------------------------------------

chkFile("ZZ2")
dbSelectArea("ZZ2")
ZZ2->(dbSetOrder(1))

mBrowse( 6, 1, 22, 75, "ZZ2")

//-- encerramento ----------------------------------------------------------------------

return

//-------------------------------------------------------------------------------------------
// Gerado pelo assistente de código do TDS tds_version em 16/05/2019 as 14:58:24
//-- fim de arquivo--------------------------------------------------------------------------

