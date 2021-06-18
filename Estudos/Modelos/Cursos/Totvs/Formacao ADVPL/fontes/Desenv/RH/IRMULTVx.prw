#INCLUDE "PROTHEUS.CH"

Static LIRMULTV		:= .F.
Static nOrdemMult	:= 0
/*
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������Ŀ��
���Fun��o	 � IRMULTV	� Autor � Ricardo Duarte Costa			  � Data � 24/08/04 ���
�����������������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula o rateio de multiplos vinculos para a folha pagto, 			���
���          � adiantamento, ferias, rescisao, 13o salario e complemento  			���
���          � do 13o salario.                                            			���
�����������������������������������������������������������������������������������Ĵ��
���Parametros� cRot - Indica o calculo que esta sendo executado.		  			���
�����������������������������������������������������������������������������������Ĵ��
��� 		ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.			  			���
�����������������������������������������������������������������������������������Ĵ��
���Programador � Data	� BOPS 			 �  Motivo da Alteracao			  		  	���
�����������������������������������������������������������������������������������Ĵ��
���Jonatas     �26/03/08�140078			 �Ajuste para nao excluir do aPd verbas de  ���
���            �--------�------		     �semanas anteriores p/ calculo de INSS/IR. ���
���Renata      �29/10/08�00000004492/2008�Ajuste da funcao fProporc() na apuracao   ���
���            �--------�------  		 �dos percentuais para rateio s/base de irf ���
���            �--------�------  		 �alterando de 2 para 7 casas decimais.     ���
���Renata      �29/10/08�00000005702/2008�Ajuste em fVerCpf() para proporcionalizar ���
���            �--------�------  		 �o valor do INSS qdo for autonomos com cat.���
���            �--------�------  		 �para sefip diferentes, e dif. de 15	    ���
���Jonatas     �28/01/09�00000001442/2009�Ajuste para nao excluir do aPd verbas de  ���
���            �--------�------  		 �semanas anteriores qdo. a matricula nao   ���
���            �--------�------  		 �tem movimento no semana a ser calculada.  ���
���Jonatas     �24/09/09�00000018224/2009�Adaptacao da rotina para tratamento do    ���
���            �--------�    			 �calculo de dissidio retroativo.           ���
���Renata      �26/11/09�00000025441/2009�Ajuste no fVerCPF, p/tratar os prolabores ���
���            �--------�                �como multiplos vinculos, apenas com prola-���
���            �--------�                �bore, assim como e feito com os autonomos ���
���Renata      �27/11/09�00000025441/2009�Ajuste funcao nafVerCpf() para no casos de���
���            �--------�                �autonomo testar apenas se a categoria     ���
���            �--------�                �atual � a mesma da anterior.              ���
���Renata Elena�05/12/09�00000027144/2009�Tratamento de Item Contabil e Classe de   ���
���            �--------�           	 �Valores no Padrao.                        ���
���Jonatas     �21/01/10�00000027869/2009�Inclusao de roteiros p/ montagem do array ���
���            �--------�                �aSalProf utilizado no salario-familia.    ���
���Marcelo     �01/04/10�00000007383/2010�Ajuste para checar se foram carregadas as ���
���            �--------�                �informacoes do professor.                 ���
���Marcelo     �05/05/10�00000009849/2010�Ajuste em fSomaCPF() para somar tambem as ���
���            �--------�                �horas quando existir registros iguais.    ���
���Renata      �01/07/10�00000014534/2010�Incluido tratamento p\utilizar o aSvSlPro ���
���            �--------�                �apenas quando for multiplos vinculos.     ���
���Renata      �03/08/10�00000017619/2010�Incluido condicao p\utilizar o aSvSlPro   ���
���            �--------�                �apenas quando for multiplos vinculos e    ���
���            �--------�                �array nao estiver em branco			    ���
���Mauricio MR �06/08/10�00000017937/2010�Ajuste para somente calcular o arredonda- ���
���            �--------�          		 �se o valor de arredondamento (MV_ARREDAD) ���
���            �--------�          		 �nao for nulo.							  	���
���Mauricio MR �10/09/10�00000020690/2010�Ajuste para atender a gestao corporativa. ���
��|Luis Ricardo|17/09/10|00000020143/2010|Ajustes na pesquisa do Funcionario no SRA ���
��|Cinalli     |        |                |para identificar se a data da demissao eh ���
��|            |        |                |compativel com Mes e Ano de competencia.  ���
��|            |        |                |No caso da data da geracao ser anterior ao���
��|            |        |                |periodo de competencia, este funcionario  ���
��|            |        |                |nao entrava em nenhum calculo da folha.   ���
���Renata      �07/10/10�00000019576/2010�Ajuste no fVerCpf p/permitir o tratamento ���
���            �        �                �de multiplos vinculos p/todas categ, com  ���
���            �        �                �excessao do prolabore e autonomo cat 15.  ���
���            �        �                �Inclusao da funcao fcInssAut no roteiro   ���
���            �        �          		 �"RFP", p/calculo inss autonomo qdo tem 	���
���            �        �         		 �a verba de base inss outras empresas 	    ���
���            �        �       	     �informada (id 288)					    ���
���Marcelo     �16/12/10�00000019514/2010�Ajuste nas funcoes fSomaCPF() e fProporc()���
���            �        �                �para considerar lancamentos pertinentes ao���
���            �        �                �calculo solicitado, e gerar Inss outras   ���
���            �        �                �empresas corretamente.                    ���
���Renata      �15/08/11�00000019299/2011�Incluido teste do campo RK_EMPCONS para   ���
���            �        �                �caso exista, acrescentar mais 2 posicoes  ���
���            �        �                �no array apdTot                           ���
���Luis Ricardo�06/09/11�00000020511/2011�Ajuste para tratar nova tabela RHH de dis-���
���Cinalli     �        �				 �sidio permanente ou manter tratamento para���
���            �        �				 �TRB caso o update 150 nao tenha sido exe- ���
���            �        �				 �cutado ainda.								���
���Luis Ricardo�21/09/11�00000024285/2011�Ajuste na funcao fVerCPF para tratar a al-���
���Cinalli     �        �				 �teracao da Matricula de Funcionario no SRA���
���            �        �				 �ao validar a Data Demissao do funcionario ���
���            �        �				 �em meses anteriores, revalidando a situa- ���
���            �        �				 �cao e o CPF da nova matricula.			���
���Mauricio MR �20/12/11�00000032708/2011�Ajuste para considerar o primeiro vinculo ���
���            �        �TEFCPY	   		 �NAO DESPREZADO para execucao do roteiro.  ���
���            �        �		   		 �Pois caso um estagiario tenha sido efetiva���
���            �        �		   		 �do, nao era calculado o INSS.             ���
���Luis Ricardo�07/03/12�00000005269/2012�Ajuste na pesquisa do CPF do Funcionario	���
���Cinalli     �        �Chamado: TEPTQU �(tabela SRA) na funcao CalcIRProcessa.	���
������������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������*/
User Function IRMULTVx(cRot)

Local aParametros	:= array(7)

Private cRet		:= " "
Private cRoteiro
Private lRecalc13o	:= .T.		// Variavel que determina se esta no calculo da folha de dezembro recalculando o 13o salario
Private lUtiMultiV	:= .F.		// Variavel que determina se funcionario possui multiplo vinculo

Private lItemClVl   := SuperGetMv( "MV_ITMCLVL", .F., "2" ) == "1"
Private lTemEmpC  	:= SRK->( FieldPos( "RK_EMPCONS" ) # 0 )    //Emprestimo Consignado.

//��������������������������������������������������������������Ŀ
//� Testa se a deve executar o IRMULTV.							 �
//����������������������������������������������������������������
If ! LIRMULTV .Or. nOrdemMult == 0
	If ( nOrdemMult	:= RetOrdem( "SRA" , "RA_CIC+RA_FILIAL+RA_MAT" , .T. ) ) <> 0
		LIRMULTV	:= .T.
	Endif
	If ! LIRMULTV
		return cRet
	endif
Endif

//��������������������������������������������������������������Ŀ
//� Testa as variaveis para o cadastro de formulas				 �
//����������������������������������������������������������������
If cRot == "132"
	If type("aTabIr13") == "U" .or. len(aTabIr13) == 0
		return cRet
	endif
else
	If type("aTabIr") == "U" .or. len(aTabIr) == 0
		return cRet
	endif
endif

If cRot == "FOL"
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 					 			  	 �
	//����������������������������������������������������������������
	aParametros[01]		:=	1					//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC			//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC			//	CPF Ate
	aParametros[04] 	:=	cSemana				//	Semana a Ser Calculada
	aParametros[05]		:=	dData_Pgto			//	Data de Pagamento
	aParametros[06] 	:=	if(cComp13="S",1,2)	//  Calc. Compl. 13o.  1=Sim/2=Nao
	aParametros[07]     :=	cCateg				//  Categorias a serem calculadas
	cRoteiro			:= "RFP"
Elseif cRot == "ADI"
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 					 			  	 �
	//����������������������������������������������������������������
	aParametros[01]		:=	2					//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC			//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC			//	CPF Ate
	aParametros[04] 	:=	cSemana				//	Semana a Ser Calculada
	aParametros[05]		:=	dData_Pgto			//	Data de Pagamento
	aParametros[06] 	:=	1					//  Calc. Compl. 13o.  1=Sim/2=Nao
	aParametros[07]     :=	cCateg				//  Categorias a serem calculadas
	cRoteiro			:= "RAD"
Elseif cRot == "132"
	//��������������������������������������������������������������Ŀ
	//� Testa as variaveis que so existem quando esta executando o	 �
	//� calculo da diferenca de 13o salario no calculo padrao da	 �
	//� folha de pagamento.											 �
	//����������������������������������������������������������������
	If type("lCompl132") == "U" .or. !lCompl132
		lRecalc13o	:= .F.
	endif
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 									 �
	//����������������������������������������������������������������
	aParametros[01]		:=	3								//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC						//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC						//	CPF Ate
	aParametros[04] 	:=	"  "							//	Semana a Ser Calculada
	aParametros[05]		:=	dData_Pgto						//	Data de Pagamento
	aParametros[06] 	:=	2								//  Calc. Compl. 13o.  1=Sim/2=Nao
	aParametros[07]     :=	"CDEGHIJMPST"					//  Categorias a serem calculadas
	cRoteiro			:= "R13"
Elseif cRot == "FER"
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 									 �
	//����������������������������������������������������������������
	aParametros[01]		:=	4								//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC						//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC						//	CPF Ate
	aParametros[04] 	:=	"  "							//	Semana a Ser Calculada
	aParametros[05]		:=	M->RH_DTRECIB					//	Data de Pagamento
	aParametros[06] 	:=	2								//  Calc. Compl. 13o.  Sim/Nao
	aParametros[07]     :=	"CDEGHIJMPST"					//  Categorias a serem calculadas
	cRoteiro			:= "RFE"
Elseif cRot == "RES"
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 									 �
	//����������������������������������������������������������������
	aParametros[01]		:=	5								//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC						//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC						//	CPF Ate
	aParametros[04] 	:=	"  "							//	Semana a Ser Calculada
	aParametros[05]		:=	M->RG_DATAHOM					//	Data de Pagamento
	aParametros[06] 	:=	2								//  Calc. Compl. 13o.  1=Sim/2=Nao
	aParametros[07]     :=	"CDEGHIJMPST"					//  Categorias a serem calculadas
	cRoteiro			:= "RRE"
Endif

U_Calcx(aParametros)

Return cRet

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o	 �CalcIRProcessa� Autor � Ricardo Duarte Costa	� Data � 24/08/04 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo do rateio de ir, inss e pensao alimenticia 			  ���
�����������������������������������������������������������������������������Ĵ��
���Parametros� aParametros - Array que contem os parametros a considerar para ���
���          �               o recalculo dos multiplos vinculos.              ���
�����������������������������������������������������������������������������Ĵ��
���Obs.      �                                                                ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
*------------------------------*
User Function Calcx(aParametros)
*------------------------------*
Local aAreaSra	:= {}	// Array para salvar o posicionamento do SRA - Cadastro de funcionarios
Local aAreaSrg	:= {}	// Array para salvar o posicionamento do SRG - Cabecalho de Rescisoes
Local aAreaSrh	:= {}	// Array para salvar o posicionamento do SRH - Cabecalho de Ferias
Local aBenef_	:= {}	// Array com as verbas dos beneficiarios de pensao alimenticia.
Local aBenef131	:= {}	// Array com as verbas dos beneficiarios de pensao alimenticia na 1a parcela do 13o salario
Local aCPF		:= {}	// Array em que ficam armazendas toadas as matriculas do CPF que esta sendo processado
Local axxx		:= {}	// Array auxiliar temporario
Local cCodAux	:= ""	// variavel que contem os codigos da verbas de pensao alimenticia do adiantamento salarial para ajuste do calculo
Local cCodPenAdt:= ""	// variavel que contem o codigo da verba de provento de pensao alimenticia do adiantamento salarial
Local cCodPensao:= ""	// Verbas de pensao a recalcular
Local cCodRecalc:= ""	// Verbas a recalcular
Local cNomeArray:= ""	// Variavel auxiliar para o processamento da proporcionalizacao dos valores entre matriculas
Local cTipo2_	:= ""	// Determina o Status das verbas que podem ser excluidas antes do recalculo.
Local cTipoPen_	:= ""	// Determina o tipo de pensao alimenticia a ser calculada
Local cTipoSRZ	:= " "	// Variavel que define o tipo de registro do resumo que sera excluido.
Local lAutonomo := .F.	// Variavel para identificar se o tratamento de multiplos vinculos sera para autonomo ou nao
Local lProlabore:= .F.	// Variavel para identificar se o tratamento de multiplos vinculos sera para prolabore ou nao
Local lCondPen	:= ""	// Determina em qual matricula deverao ser carregadas as verbas de pensao alimenticia. Tem influencia no calculo de recisao.
Local lCont		:= .T.	// Variavel que trata o retorno da execucao do roteiro de calculo
Local nElement	:= 0	// variavel de looping
Local nPos		:= 0	// Variavel de posicionamento
Local nVezes	:= 0	// Determina o numero de vezes em que buscara as verbas de pensao alimenticia a ser recalculada
Local nX        := 0	// Variavel de looping
Local nY        := 0	// Variavel de looping
Local nz		:= 0	// Varivael de looping
Local z			:= 0	// Variavel de looping
Local cNomePd	:= ""	// Variavel com o nome do array que armazena o aPdOld por funcionario
Local aDisPdOld	:= {}	// Variavel que armazena o aPdOld do funcionario corrente
Local aSvTaref	:= {}	// Variavel de backup do array aTarefas
Local aSvPaPro	:= {}	// Variavel de backup do array aParProf
Local aSvSlPro	:= {}	// Variavel de backup do array aSalProf

//��������������������������������������������������������������Ŀ
//� Define Variaveis Privadas do Programa						 �
//����������������������������������������������������������������
Private aPDTot 		:= {}	// matriz com todas as verbas de todos os funcionarios
Private aPdCorrent	:= {}	// matriz com o calculo corrente processado para ferias e rescisao.
Private aRoteiroIR	:= {}	// Array que contem os roteiros para o recalculo que devem ser executados.
Private cCPFAnt		:= ""	// Variavel que guardara o CPF Anterior para comparacao.
Private cFilMatCor	:= ""	// Variavel que guardara a Filial e Matricula corrente no caso de calculo de ferias e rescisao.

//��������������������������������������������������������������Ŀ
//� Carrega o roteiro para o calculo escolhido.					 �
//����������������������������������������������������������������
If !RotIrMultv(cRoteiro)
	return cRet
endif

//��������������������������������������������������������������Ŀ
//� Carregando as Perguntas 									 �
//����������������������������������������������������������������
cCPFDe_		:=	aParametros[02]					//	CPF De
cCPFAte_ 	:=	aParametros[03]					//	CPF Ate
cSemana		:=	aParametros[04]					//	Semana a Ser Calculada
dData_Pgto	:=	aParametros[05]					//	Data de Pagamento
cComp13_ 	:=	If(aParametros[06] = 1,'S','N')	//  Calc. Compl. 13o.  Sim/Nao
cCateg_     :=  aParametros[07]					//  Categorias a serem calculadas
Semana		:=	cSemana							//	Variavel utilizada no adiantamento
dDataPgto	:=	dData_Pgto						//	Variavel utilizada no adiantamento

// ���������������������������������������������������������������������Ŀ
// �Define todas as verbas que serao recalculadas e proporcionalizadas	 �
// �para cada tipo de recalculo FOL/FER/ADI/RES/132						 �
// �����������������������������������������������������������������������
If cRoteiro == "RFP"
	cCodRecalc	:= 'aCodFol[047,1]+","+aCodFol[043,1]+","+aCodFol[045,1]+","+aCodFol[066,1]+","+aCodFol[015,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[064,1]+","+aCodFol[167,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[065,1]+","+aCodFol[100,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[101,1]+","+aCodFol[408,1]+","+aCodFol[437,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[034,1]+","+aCodFol[221,1]+","+aCodFol[225,1]+","'
	cTipoPen_	:= "FOL"
	cTipo2_		:= "CKR"
Elseif cRoteiro == "RAD"
	cCodRecalc	:= 'aCodFol[010,1]+","+aCodFol[012,1]+","+aCodFol[008,1]+","+aCodFol[408,1]+","+aCodFol[063,1]+","'
	cTipoPen_	:=	"ADI"
	cTipo2_		:= "A"
Elseif cRoteiro == "R13"
	cCodRecalc	:= 'aCodFol[021,1]+","+aCodFol[026,1]+","+aCodFol[070,1]+","+aCodFol[071,1]+","+aCodFol[409,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[019,1]+","+aCodFol[020,1]+","+aCodFol[027,1]+","+aCodFol[169,1]+","'
	cTipoPen_	:=	"132"
	cTipo2_		:= "S"
Elseif cRoteiro == "RFE"
	cCodRecalc	:= 'aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[065,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[104,1]+","+aCodFol[102,1]+","+aCodFol[067,1]+","+aCodFol[168,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[410,1]+","+aCodFol[016,1]+","'
	cTipoPen_	:=	"FER"
	cTipo2_		:= "K"
Elseif cRoteiro == "RRE"
	cCodRecalc	:= 'aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[064,1]+","+aCodFol[066,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[408,1]+","+aCodFol[167,1]+","+aCodFol[100,1]+","+aCodFol[101,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[067,1]+","+aCodFol[070,1]+","+aCodFol[177,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[071,1]+","+aCodFol[019,1]+","+aCodFol[020,1]+","+aCodFol[169,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[409,1]+","+aCodFol[410,1]+","+aCodFol[126,1]+","+aCodFol[045,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[015,1]+","+aCodFol[016,1]+","+aCodFol[027,1]+","+aCodFol[034,1]+","'
	cTipoPen_	:=	"FOL"
	cTipo2_		:= "R"
endif

//��������������������������������������������������������������Ŀ
//� Salvo a area dos arquivos de cabecalhos de ferias e rescisao.�
//����������������������������������������������������������������
aAreaSra	:= SRA->(GetArea())
aAreaSrg	:= SRG->(GetArea())
aAreaSrh	:= SRH->(GetArea())

//��������������������������������������������������������������Ŀ
//� Salvo o aPd e a matricula corrente.							 �
//����������������������������������������������������������������
aPdCorrent		:= aClone(aPd)
cFilMatCor		:= SRA->RA_FILIAL+SRA->RA_MAT
lAutonomo		:= SRA->RA_CATFUNC =="A" 
lProlabore		:= SRA->RA_CATFUNC =="P" 

If lDissidio
	aDisPdOld		:= aClone(aPdOld)
EndIf

//�������������������������������������������������������������������������Ŀ
//� Altero a ordem do cadastro de funcionarios para RA_CIC+RA_FILIAL+RA_MAT �
//���������������������������������������������������������������������������
dbSelectArea( "SRA" )
dbsetorder(nOrdemMult)
dbseek(cCpfDe_,.T.)

Begin Sequence
	
	While !SRA->(Eof()) .and. SRA->RA_CIC <= cCpfAte_
		
		//��������������������������������������������������������������Ŀ
		//� Carrego o array aCPF com todas as matriculas encontradas.	 �
		//����������������������������������������������������������������
		aCPF		:= {}
		fVerCpf(SRA->RA_CIC,@aCPF,lAutonomo,lProlabore)

		//��������������������������������������������������������������Ŀ
		//� Testa a quantidade de matriculas encontradas para iniciar o	 �
		//� processamento.												 �
		//����������������������������������������������������������������
		nElement	:= len(aCPF)
		If nElement <= 1
			dbselectarea("SRA")
			dbskip()
			loop
		endif
		
		//��������������������������������������������������������������Ŀ
		//� Carrega os beneficiarios para a primeira matricula processada�
		//� Quando for rescisao carrega conforme a matricula corrente.   �
		//����������������������������������������������������������������
		If(cRoteiro $ "RRE,RFE",;
			SRA->(DBSEEK(aCpf[1,1]+cFilMatCor)),;
			SRA->(DBSEEK(aCpf[1,1]+aCpf[1,2]+aCpf[1,3]));
			)

		//�����������������������������������������������������������������Ŀ
		//� Determina para quais tipos de calculo deve buscar as verbas de	�
		//� alimenticia.													�
		//�������������������������������������������������������������������
		nVezes	:= 1
		If cRoteiro == "RRE"
			nVezes	:= 3
		endif

		//�����������������������������������������������������������������Ŀ
		//� Troca o conteudo de cTipoPen_ quando for um calculo de rescisao.�
		//�������������������������������������������������������������������
		For nz := 1 to nVezes
			If nVezes > 1
				If nz == 2
					cTipoPen_	:= "FER"
				elseif nz == 3
					cTipoPen_	:= "132"
				endif
			endif
			//��������������������������������������������������������������Ŀ
			//� Carrega os codigo das verbas de pensao para o recalculo.     �
			//����������������������������������������������������������������
			fBusCadBenef(@aBenef_,cTipoPen_,,.F.)
			For ny := 1 to len(aBenef_)
				If !empty(aBenef_[ny,1]) .and. aBenef_[ny,3] == 0 .and. aBenef_[ny,4] == 0
					cCodPensao	:= cCodPensao + aBenef_[ny,1] + ","
				endif
			next ny
		next nz

		//����������������������������������������������������������������Ŀ
		//� Inicia o processamento acumulando os valores de cada matricula �
		//� no array aPdTotal.											   �
		//������������������������������������������������������������������
		For z := 1 to len(aCPF)

			//��������������������������������������������������������������Ŀ
			//� Posiciona no funcionario a ser calculado          	 	     �
			//����������������������������������������������������������������
			SRA->(DBSEEK(aCpf[z,1]+aCpf[z,2]+aCpf[z,3]))

			//��������������������������������������������������������������Ŀ
			//� Limpa os arrays para a proxima matricula a processar		 �
			//����������������������������������������������������������������
			aPd 		:= {}   // Limpa a matriz do src
			aDifFer		:= {}   // Limpa a matriz de Ponteiros de Dif. Ferias
			aVarRot  	:= {}   // Limpa Array de Variaveis Roteiro
			
			//��������������������������������������������������������������Ŀ
			//� Armazenamento do aPdOld p/ apurar as diferencas de dissidio	 �
			//����������������������������������������������������������������
			cNomePd		:= "p"+aCPF[z,12]
			&(cNomePd)	:= {}

			//��������������������������������������������������������������Ŀ
			//� Carrega as Verbas do movimento para a matriz APD			 �
			//����������������������������������������������������������������
			&(cNomePd) := fCarregaPD(@aCPF,z,cCodRecalc,cCodPensao,cTipo2_)
			
			//��������������������������������������������������������������Ŀ
			//� Salva uma copia do apd carregado para esta matricula		 �
			//����������������������������������������������������������������
			cNomeArray	:= "a"+aCPF[z,12]
			&(cNomeArray) := aClone(aPd)

			//������������������������������������������������������������������Ŀ
			//� Testo se existem verbas no aPd para acumular.					 �
			//��������������������������������������������������������������������
			If Len(aPd) > 0
				//������������������������������������������������������������������Ŀ
				//� Alimenta o Array aPdTotal com os valores dos multiplos vinculos. �
				//��������������������������������������������������������������������
				fSomaCPF(@aCpf,z)
			else
				//�������������������������������������������������������������������������������������Ŀ
				//� Ajusto a posicao 8 do array aCPF para indicar que este funcionario sera desprezado e�
				//� diminuo 01 na variavel nElement para indicar quantas matriculas serao processadas.  �
				//���������������������������������������������������������������������������������������
				aCpf[z,8]	:= .F.
				nElement	:= nElement - 1
			endif
		Next z

		//���������������������������������������������������������Ŀ
		//� Ordenamos o array aCPF						            �
		//� Ordem: Acumulado + CPF + Categoria +Filial + Matricula	�
		//�����������������������������������������������������������
		aSort( aCPF ,,, { |x,y| x[7]+x[1]+x[13]+x[2]+x[3] < y[7]+y[1]+y[13]+y[2]+y[3] } )

		//��������������������������������������������������������������Ŀ
		//� Carrega os valores totais para o array do calculo			 �
		//����������������������������������������������������������������
		If Len(aPdTot) > 0 .and. nElement > 1
            //-- Garante que seja posicionado no primeiro vinculo NAO DESPREZADO
			IF ! aCPF[1,8]
				For z:=1 to Len(aCPF)
				    IF aCPF[z,8]       
		    			SRA->(DBSEEK(aCpf[z,1]+aCpf[z,2]+aCpf[z,3]))   
		    			Exit
		    		Endif
		    	Next z		
		    Else
    			SRA->(DBSEEK(aCpf[1,1]+aCpf[1,2]+aCpf[1,3]))
		    Endif

			aPd 	:= aClone(aPDTot)

		//���������������������������������������������������������������Ŀ
		//� Se nao tiver movimento mas tiver multiplos vinculos. Posiciona�
		//� na ultima matricula do CPF corrente e salta para  o   proximo �
		//� funcionario.												  �
		//�����������������������������������������������������������������
		ElseIf Len(aCpf) > 0
			aPd		:= {}
			aPdTot	:= {}
			SRA->(DBSEEK(aCpf[len(aCpf),1]+aCpf[len(aCpf),2]+aCpf[len(aCpf),3]))
			SRA->(DBSKIP())
			LOOP
		//��������������������������������������������������������������Ŀ
		//� Zera as variaveis de movimentos.							 �
		//����������������������������������������������������������������
		Else
			aPd		:= {}
			aPdTot	:= {}
			SRA->(DBSKIP())
			LOOP
		EndIf
				
		//��������������������������������������������������������������Ŀ
		//� Zera Valores das Bases que serao recalculadas				 �
		//����������������������������������������������������������������
		nInss_b   	:= nIr_b		:= nFgts_b		:= nLiquido		:= nHorasDsr	:= 0
		Assmed_b  	:= nInssf_B 	:= nIrf_b		:= nIapas13_b 	:= nIr13_b		:= 0
		nInssf_b 	:= nInss13_b	:= Adc_adt		:= Ir_ant		:= nSalfami_b 	:= 0
		Dsrtrab		:= Hrexins		:= Difer_ferias	:= Difer_adicio	:= 0
		Difer_13f 	:= Difer_Hef	:= Difer_perf	:= Difer_Ccf	:= 0
		Irpg13	  	:= Adic_sal		:= Baseir_ant	:= Abater_ir	:= nDiasLRem	:= 0
		Salaux	  	:= Aux_MATern 	:= Arred_aux	:= SalBase		:= AdtServ		:= 0
		nDiasAfas 	:= nDiasEnf		:= nValAfas 	:= nAfasFgts	:= nHorasTrab 	:= 0
		nInssSc   	:= nSalc_b		:= nBSalC      	:= nPerSalc    	:= nVInssOut	:= 0

		//��������������������������������������������������������������Ŀ
		//� Zera as variaveis do calculo de IR.                          �
		//����������������������������������������������������������������
		IR_CALC  	:= BASE_RED := VAL_DEDDEP := VAL_DEPEAL := BASE_INI := VAL_PEAL := 0
		VAL_LIQ  	:= VAL_AMSA := VAL_ASME   := VLR_RES    := VAL_ARRE := 0
		nIr 		:= 0
		cPdPesq  	:= Space(3)
		nValOutros	:= 0

		//��������������������������������������������������������������Ŀ
		//� Variaveis Privates que poderao ser utilizadas nas formulas	 �
		//����������������������������������������������������������������
		If cRoteiro == "RRE"
			Salario  := SalHora := SalDia := SalMes := nSalPg := 0.00
		Endif
		
		//�������������������������������������������������������������������������������������Ŀ
		//� Posiciona no funcionario corrente para executar o calculo da rescisao e das ferias. �
		//���������������������������������������������������������������������������������������
		If cRoteiro $"RRE,RFE"
			SRA->(dbseek(aCpf[1,1]+cFilMatCor))
		endif

		//��������������������������������������������������������������Ŀ
		//� Executa as Formulas recalculando IR/Pensao/Inss				 �
		//����������������������������������������������������������������
		nSal_fami	:= 0 					//-- Inicia a variavel para efetuar o c�lculo com Multiplos vinculos
		
		If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
			//If !type("aParProf") == "U"
			If U_GENTYPE01("aParProf") == "U"
				aSvPaPro := aClone( aParProf ) 
			EndIf
			aSvTaref	:= aClone( aTarefas )
			aSvSlPro	:= aClone( aSalProf )
		EndIf
		
		lUtiMultiV	:= .T. 
		If !ExecRote(SRA->RA_FILIAL,aRoteiroIR,@lCont,.F.)
			If !lCont
				Break
			Endif
		EndIf
		
		//����������������������������������������������������������������������Ŀ
		//� Ajusto as verba de pensao alimenticia da 1a parcela do 13o salario   �
		//� apos o calculo dos multiplos vinculos.								 �
		//������������������������������������������������������������������������
		If cRoteiro == "R13" .or. cRoteiro == "RRE"
			//����������������������������������������������������Ŀ
			//�Apaga as verbas de pensao alimenticia da 1a parcela.�
			//������������������������������������������������������
			fBusCadBenef(@aBenef131,"131",,.F.)
			For nz := 1 to len(aBenef131)
				fDelPd(aBenef131[nz,1])
			next nz
		endif

		Begin Transaction

			//��������������������������������������������������������������������Ŀ
			//� Salva o Array total para proporcionalizacao e gravacao dos valores �
			//����������������������������������������������������������������������
			aPdTot 	:= aClone(aPD)

			//��������������������������������������������������������������Ŀ
			//� Separa os Valores por Matricula e atualiza o aPd de cada uma �
			//� das matriculas calculadas.									 �
			//����������������������������������������������������������������
			fProporc(aCpf,cCodRecalc,cCodPensao)

			//��������������������������������������������������������������Ŀ
			//� Inicia a gravacao dos calculos rateados por matricula		 �
			//����������������������������������������������������������������
			For z := 1 to len(aCpf)

				//��������������������������������������������������������������Ŀ
				//� Filtro para as matriculas que participaram do movimento		 �
				//����������������������������������������������������������������
				If aCPF[z,8]

					//��������������������������������������������������������������Ŀ
					//� Posiciona no primeiro funcionario a ajustar					 �
					//����������������������������������������������������������������
					SRA->(DBSEEK(aCpf[z,1]+aCpf[z,2]+aCpf[z,3]))

					//�����������������������������������������������������������������������������������Ŀ
					//�Se estiver demitido ou nao foi acumulado nao atualizo nada pois nao posso modificar�
					//�os valores dessas matriculas.													  �
					//�������������������������������������������������������������������������������������
					If aCPF[z,4] == "5" .or. aCPF[z,7] == "2"
						loop
					endif

					//��������������������������������������������������������������Ŀ
					//� Atualiza o array que sera gravado para a matricula			 �
					//����������������������������������������������������������������
					cNomeArray	:= "a"+aCPF[z,12]
					aPd			:= aClone(&(cNomeArray))

					//��������������������������������������������������������������Ŀ
					//� Calcula o liquido atualizado.                            	 �
					//����������������������������������������������������������������
					//��������������������������������������������������������������Ŀ
					//� Folha de Pagamento											 �
					//����������������������������������������������������������������
					If cRoteiro == "RFP"
						fLiquido(aCodfol,aCodfol[47,1],nValArred,aCodfol[43,1],.T.,aCodFol[45,1],.T.)    
					//��������������������������������������������������������������Ŀ
					//� Adiantamento												 �
					//����������������������������������������������������������������
					elseif cRoteiro == "RAD"
                        VAL_ADTO	:= 0
                        IR_CALC		:= 0
						Aeval(aPd, { |X| VAL_ADTO += If(X[1]==aCodFol[007,1] .and. Semana == X[3],X[5],0) } )
						Aeval(aPd, { |X| IR_CALC  += If(X[1]==aCodFol[012,1] .and. Semana == X[3],X[5],0) } )
						CALCLIQ(VAL_ADTO,IR_CALC)
						IF nValArrAd > 0
							CALC_ARRE(@VAL_LIQ,@nValArrAd,@VAL_ARRE)
						Endif
						If VAL_ARRE > 0
							FGeraVerba(aCodfol[8,1],VAL_ARRE,0.00,SEMANA , ,"V","A",,,,.T.)
						else
							fDelPd(aCodFol[008,1],semana)
						endif
					//��������������������������������������������������������������Ŀ
					//� Ferias Normais, Coletivas ou Programadas.					 �
					//����������������������������������������������������������������
					Elseif cRoteiro == "RFE"
						nValProv := nValDesc := 0.00
						Aeval( aPd ,{ |X|  SomaInc(X,1,@nValProv, , , , , , ,aCodFol) })
						Aeval( aPd ,{ |X|  SomaInc(X,2,@nValDesc, , , , , , ,aCodFol) })
						fLiqFer()
					//��������������������������������������������������������������Ŀ
					//� Rescisoes normais ou coletivas								 �
					//����������������������������������������������������������������
					Elseif cRoteiro == "RRE"
						//����������������������������������������������������Ŀ
						//�Apaga as verbas de pensao alimenticia da 1a parcela.�
						//������������������������������������������������������
						For nz := 1 to len(aBenef131)
							fDelPd(aBenef131[nz,1])
						next nz
						nLiquido	:= 0
						nMulta		:= 0
						Salario 	:= 0
						SalHora		:= 0
						SalDia		:= 0
						SalMes		:= 0
						//��������������������������������������������������������������Ŀ
						//� Carrego o salario novamente para apurar o valor correto do	 �
						//� desconto da multa por termino antecipado do contrato de		 �
						//� experiencia.												 �
						//����������������������������������������������������������������
						fSalario(@Salario,@SalHora,@SalDia,@SalMes)
						If aScan(aPd,{|X| x[1] == aCodFol[177,1]}) > 0
							//��������������������������������������������������������������Ŀ
							//� Vencimento da 1a. data de experiencia.						 �
							//����������������������������������������������������������������
							If(	aCodfol[177,1] # Space(3) .And. aIncRes[13] = "S" .And. SRA->RA_VCTOEXP > dDataDem,;
								nMulta := ((Salario / 30) * (Sra->Ra_VctoExp - dDatadem) ) / 2,;
								nMulta := 0.00)
							//��������������������������������������������������������������Ŀ
							//� Vencimento da 2a. data de experiencia.						 �
							//����������������������������������������������������������������
							If(	aCodfol[177,1] # Space(3) .And. aIncRes[13] = "S" .And. SRA->RA_VCTOEXP < dDataDem .And. SRA->RA_VCTEXP2 > dDataDem,;
								nMulta := ((Salario / 30) * (Sra->Ra_VctExp2 - dDatadem) ) / 2,;
								"")
						endif
						nObrig	:= fLiquido(aCodfol,aCodFol[126,1],0,"",.T.,aCodFol[045,1],.T.,.F.)
						nLiq	:= nLiquido - nObrig
						IF(nMulta > 0.00 .and. nLiq > 0.00,fGeraVerba(aCodfol[177,1],Min(nLiq,nMulta)),'' )
						fLiquido(aCodfol,aCodFol[126,1],0,"",.T.,aCodFol[045,1],.T.,.T.,.T.)
					//��������������������������������������������������������������Ŀ
					//� 13o salario - 2a parcela.									 �
					//����������������������������������������������������������������
					Elseif cRoteiro == "R13"
						//����������������������������������������������������Ŀ
						//�Apaga as verbas de pensao alimenticia da 1a parcela.�
						//������������������������������������������������������
						For nz := 1 to len(aBenef131)
							fDelPd(aBenef131[nz,1])
						next nz
						fLiquido(aCodfol,aCodfol[21,1],nValArred,aCodfol[26,1],.T.,aCodfol[30,1],.F.)
					endif

					//��������������������������������������������������������������Ŀ
					//� Ordena por Verba Deletada para, se existir Chave Duplicada no�
					//� aPd, Primeiro Deletar para Depois Gravar					 �
					//����������������������������������������������������������������
					aSort( aPd ,,, { |x,y| x[9] > y[9] } )

					//���������������������������������������������������������������Ŀ
					//� Gravacao os valores recalculados nos arquivos correspondentes.�
					//�����������������������������������������������������������������
					//��������������������������������������������������������������Ŀ
					//� Folha de Pagamento											 �
					//����������������������������������������������������������������
					If cRoteiro == "RFP"
						If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
							If lDissidio
								aPdOld		:= aClone( aDisPdOld )
							Endif
							aPdCorrent	:= aClone(aPd)
						else
							If lDissidio
								cNomePd	:= "p"+aCPF[z,12]
								aPdOld	:= aClone(&(cNomePd))
								Gravafol()
							Else
								Aeval( aPD , { |X| Gravafol(X) } )
							EndIf
						endif
					//��������������������������������������������������������������Ŀ
					//� Adiantamento												 �
					//����������������������������������������������������������������
					elseIf cRoteiro == "RAD"
						If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
							aPdCorrent	:= aClone(aPd)
						else
							Aeval( aPD , { |X| GravaAdt(X) } )
						endif
					//��������������������������������������������������������������Ŀ
					//� Ferias Normais, Coletivas ou Programadas.					 �
					//����������������������������������������������������������������
					elseIf cRoteiro == "RFE"
						If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
							aPdCorrent	:= aClone(aPd)
						else
							GravaSRR(aCpf,z,&(cCodRecalc)+cCodPensao,"F")
						endif
					//��������������������������������������������������������������Ŀ
					//� Rescisoes normais ou coletivas								 �
					//����������������������������������������������������������������
					elseIf cRoteiro == "RRE"
						If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
							aPdCorrent	:= aClone(aPd)
						else
							GravaSRR(aCpf,z,&(cCodRecalc)+cCodPensao,"R")
						endif
					//��������������������������������������������������������������Ŀ
					//� 13o Salario - 2a Parcela									 �
					//����������������������������������������������������������������
					elseIf cRoteiro == "R13"
						//��������������������������������������������������������������Ŀ
						//� Se for recalculo do 13o salario limpa as verbas excluidas.	 �
						//����������������������������������������������������������������
						If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
							If lRecalc13o
								axxx := aClone(aPd)
								aPd  := {}
								For nz := 1 to len(axxx)
									if axxx[nz,9] <> "D"
										aadd(aPd,aClone(axxx[nz]))
									endif
								next nz
							endif
							//��������������������������������������������������������������Ŀ
							//� Atualizo o array apdcorrent quando a matricula processada for�
							//� a matricula corrente.										 �
							//����������������������������������������������������������������
							aPdCorrent	:= aClone(aPd)
						else
							//��������������������������������������������������������������Ŀ
							//� Se nao for o recalculo do 13o salario na folha de pagamento. �
							//� grava o novo calculo do 13o salario.						 �
							//����������������������������������������������������������������
							If ! lRecalc13o
								Aeval ( aPD , { |X| Grava132(X) } )
							endif
						endif
					endif
				endif
			next z

			//��������������������������������������������������������������Ŀ
			//� Limpa os arrays criados para armazenar os valores parciais	 �
			//� das matriculas processadas.									 �
			//����������������������������������������������������������������
			For z := 1 to len(aCpf)
				cNomeArray		:= "a"+aCPF[z,12]
				&(cNomeArray)	:= Nil                  
				cNomePd			:= "p"+aCPF[z,12]
				&(cNomePd)		:= Nil
			next z
		End Transaction                
			
		//��������������������������������������������������������������Ŀ
		//� Apos o processamento, deleta o registro de "OK", indicando   |
		//| que devera ser gerado um novo SRZ.							 |
		//����������������������������������������������������������������
		If cRoteiro == "R13" .and. !lRecalc13o
			cTipoSRZ	:= 2
		else
			cTipoSRZ	:= 1
		endif
		fDelRegSRZ(cTipoSRZ,SRA->RA_TPCONTR)

		//��������������������������������������������������������������Ŀ
		//� Posiciona na ultima matricula do mesmo CPF para continuar o	 �
		//� processamento.												 �
		//����������������������������������������������������������������
		dbSelectArea( "SRA" )
		If len(aCpf) > 0
			aSort( aCPF ,,, { |x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )
			SRA->(DBSEEK(aCpf[len(aCpf),1]+aCpf[len(aCpf),2]+aCpf[len(aCpf),3]))
		endif
		SRA->(DBSKIP())
	Enddo
	
End Sequence

//��������������������������������������������������������������Ŀ
//� Retorna o Indice Padrao e o posicionamento dos arquivos		 �
//� de funcionarios, cabecalho de ferias e rescisoes			 �
//����������������������������������������������������������������
dbSelectArea("SRA")
restarea(aAreaSRA)
dbselectarea("SRG")
restarea(aAreaSRG)
dbselectarea("SRH")
restarea(aAreaSRH)

//��������������������������������������������������������������Ŀ
//� Retorna o array corrente recalculado para que a rotina		 �
//� termine de gravar o calculo da matricula corrente.			 �
//����������������������������������������������������������������
If lDissidio	
	aPdOld	:= aClone( aDisPdOld )
EndIf

If !type("aParProf") == "U"
	aParProf	:= aClone( aSvPaPro )
EndIf

aPd			:= aClone( aPdCorrent )
aTarefas	:= aClone( aSvTaref )
aSalProf	:= If (len(aCpf) > 0 .and. !Empty( aSvSlPro ), aClone( aSvSlPro ), aSalProf)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � GravaFol � Autor � Mauro 			    � Data � 07.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava as Verbas da Matriz Calculadas no Adiantamento  	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GravaAdt(X)												  ���
��� 		 �														  	  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� X =	Matriz Multi contendo						    	  ���
���	 		 � Codigo da Verba , C.Custo, cSemana, Horas , Valor , Tipo1,;���
��� 		 � Tipo2 , Parcela										  	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	 � Generico 											  	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GravaFol(aX)
If lDissidio
	GravaDissidio(aPd,aPdOld,,aCodFol)
Else
	If aX[3] = cSemana .Or. Empty( aX[3] )
		GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aX[1],If(!eMPTY(aX[10]),aX[10],dDATA_PGTO),aX[2],;
		If(Empty(aX[3]),cSemana,aX[3] ),aX[6],aX[7],aX[4],aX[5],aX[8],aX[9],,aX[11],aX[12],aX[13],aX[14])
	Endif
EndIf
Return( NIL )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fVerCpf	�Autor  �Ricardo Duarte Costa� Data �  25/08/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Busca as Matriculas que serao processadas para os multiplos ���
���          �vinculos.                                                   ���
�������������������������������������������������������������������������͹��
���Parametros�cCpfAnt   = CPF da matricula corrente a ser pesquisado      ���
���          �aCPF      = Array para guardar todas as matriculas relacio- ���
���          �            nadas ao CPF corrente.                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sigagpe                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fVerCpf(cCpfAnt,aCPF,lAutonomo,lProlabore)

Local cSitFolha	:= ""
Local cTestaCat	:= ""
Local lCont		:= .T.
Local cCategAnt	:= SRA->RA_CATEG
Local cFilFunc	:= ""
Local cMatFunc	:= ""

If lProlabore
	cTestaCat	:= 'SRA->RA_CATFUNC $ "A*P"'
Else
	cTestaCat	:= 'SRA->RA_CATFUNC <> "P"'	    
EndIf

While lCont .and. !SRA->(EOF())

	// Atualiza variaveis de controle de processamento de funcionario demitido
	cFilFunc := SRA->RA_FILIAL
	cMatFunc := SRA->RA_MAT 

	//��������������������������������������������������������������Ŀ
	//� Busco a situacao do funcionario corrente.            		 �
	//����������������������������������������������������������������
	cSitFolha := fBuscaSituacao(SRA->RA_FILIAL,SRA->RA_MAT,dDataBase)

	//��������������������������������������������������������������Ŀ
	//� Consiste CPF nao informado ou branco. Nao serao processados. �
	//����������������������������������������������������������������
	If empty(cCpfAnt) .or. cCpfAnt = nil
		dbSelectArea("SRA")
		return
	endif
	
	//�����������������������������������������������������������������������������������������������Ŀ
	//� Consiste a Mudanca da CPF. Se mudou encerra o loop e passa para o processamento dos calculos. �
	//�������������������������������������������������������������������������������������������������
	If (cCpfAnt == SRA->RA_CIC) 

		//��������������������������������������������������������������Ŀ
		//� Verifica a categoria que esta sendo processada. Se for autono�
		//� mo, nao verifica a categoria. Se for prolabore, so incluira  �
		//� matriculas de autonomos e\ou prolabores						 �
		//����������������������������������������������������������������
		If !lAutonomo
			If !( &(cTestaCat) ) 
				dbSelectArea("SRA")
				dbSkip()
				Loop
			Endif    
		EndIf	
		
		//��������������������������������������������������������������Ŀ
		//� Autonomo categoria 15 so pode ter tratamento de multiplos    �
		//� vinculos com categoria 15 (freteiro), devido ter base de INSS�
		//� e IRF reduzida                                               �
		//����������������������������������������������������������������
 	   If	(cCategAnt == "15" .and. SRA->RA_CATEG <> "15") .or. (cCategAnt <> "15" .and. SRA->RA_CATEG == "15")
	   		dbSelectArea("SRA")
			dbSkip()
			Loop
		EndIF
		
		//��������������������������������������������������������������Ŀ
		//� N�o deve calcular folha para funcion�rios demitidos em meses �
		//� anteriores � data base. 									 �
		//����������������������������������������������������������������
		dbSelectArea( "SRG" )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			If cSitFolha == "D"
				while SRG->( ! Eof() ) .and. SRG->RG_FILIAL == SRA->RA_FILIAL .and. SRG->RG_MAT == SRA->RA_MAT
					//��������������������������������������������������������������������������Ŀ
					//� A Data da Geracao pode ser diferente da Data Base, mas se o Mes e Ano da �
					//� Data de Demissao do funcionario for IGUAL ao Mes e Ano ABERTO (cFolMes), �
					//� este funcionario DEVE entrar na folha, pois caracteriza uma demissao	 �
					//� "programada" para o mes/ano aberto com data de gravacao anterior a mesma.�
					//����������������������������������������������������������������������������
					If MesAno(SRG->RG_DTGERAR) # MesAno(dDataBase) .and. MesAno(SRG->RG_DATADEM) < cFolMes
						dbSelectArea( "SRA" )
						dbSkip()
						Loop
					Endif
					SRG->( dbSkip() )
				EndDo
			Endif
		Endif

		dbSelectArea( "SRA" )

		//�������������������������������������������������������������������������Ŀ
		//� Retorna para o inicio desta funcao para revalidar a Situacao e CPF caso	�
		//� a Matricula do Funcionario tenha mudado no SRA ao validar a data de de-	�
		//� missao em meses anteriores conforme condicao acima. Este retorno eh		�
		//� necessario para funcionarios demitidos anteriormente, que voltaram a	�
		//� trabalhar na empresa e atualmente possuem multiplos vinculos, pois		� 
		//� estava "misturando"	os dados do funcionario com situacao de demitido na	�
		//� primeira passagem com os dados ATIVOS atualmente.						�
		//���������������������������������������������������������������������������
		If SRA->( RA_FILIAL + RA_MAT ) # cFilFunc + cMatFunc
			Loop
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Atualiza o array com as matriculas dos funcionarios com      �
		//� multiplos vinculos a serem processados.      				 �
		//����������������������������������������������������������������
		aAdd(aCPF,{	cCpfAnt,		;	// 1 - CPF do funcionario
					SRA->RA_FILIAL,	;	// 2 - Filial
					SRA->RA_MAT,	;	// 3 - Matricula
					If(cSitFolha==" ","1",;
					If(cSitFolha=="A","2",;
					If(cSitFolha=="F","3",;
					If(cSitFolha=="T","4",;
					"5")))),		;	// 4 - Situacao na Folha
					SRA->RA_CATFUNC,;	// 5 - Categoria do funcionario
					0.00,			;	// 6 - Percentual de distribuicao do IR e Pensao Alimenticia e Inss
					"1",			;	// 7 - "1" indica que sera acumulado no ApdTotal e "2" indica que nao sera acumulado
					.T.,			;	// 8 - .T. indica que o APD tem movimento e .F. indica que o APD nao tem movimento e nao deve ser processado.
					ctod(""),		;	// 9 - Indica a data de geracao da rescisao ou data de pagamento das ferias para a pesquisa das verbas no arquivo SRR (Itens de ferias e rescisoes)
					0.00,			;	//10 - Percentual de distribuicao do INSS de ferias
					0.00,			;	//11 - Percentual de distribuicao da Base de Inss 
					StrZero(Len(aCPF),3), ; // 12 - Label para criar variaveis para a Filial+Matricula corrente
					If(SRA->RA_CATFUNC=="A", "1", "0" )	})	   //13 - Indica Categoria de Autonomo
					
	Else
		//��������������������������������������������������������������Ŀ
		//� Encerro o processamento do loop pois a proxima matricula nao �
		//� e do mesmo CPF a ser processado.             				 �
		//����������������������������������������������������������������
		lCont		:= .F.
		cCpfAnt		:= SRA->RA_CIC
		cCategAnt	:= SRA->RA_CATEG 
	Endif
	SRA->(DBSKIP())
Enddo

//��������������������������������������������������������������Ŀ
//� Se tiver somente uma matricula no Array, zeramos o array pois�
//� nao deve haver processamento para somente uma matricula.	 �
//����������������������������������������������������������������
If Len(aCpf) <= 1
	aCPF	:= {}
endif

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fSomaCpf	�Autor  �Ricardo Duarte Costa� Data �  25/08/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Soma todos os valores ja calculados para todas as matriculas���
���          �dos multiplos vinculos.                                     ���
�������������������������������������������������������������������������͹��
���Parametros�aCPF      = Array para guardar todas as matriculas relacio- ���
���          �            nadas ao CPF corrente.                          ���
���          �n         = indica o posicionamento no array aCPF.          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sigagpe                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fSomaCPF(aCpf,n)

Local cCodBase	:= ""		// Codigo das verbas de base e inss normal
Local cCodigo	:= ""		// Variavel auxiliar para a troca do codigo das verbas de base e inss normais
Local cCodOut	:= ""		// Codigo das verbas de base e inss de outras empresas
Local cCodPesq	:= space(3)	// Codigo da verba de base de ir que sera utilizada para determinar se deve 
							// ou nao somar esta matricula no movimento a ser recalculado.
Local nPos		:= 0		// variavel de loop
Local ny		:= 0		// variavel de loop

//��������������������������������������������������������������Ŀ
//� Define a verba que sera pesquisada para comparar a data de 	 �
//� pagamento.													 �
//����������������������������������������������������������������
If cRoteiro == "RFP" .or. cRoteiro == "RRE"
//�����������������������������Ŀ
//�Folha de Pagamento e Rescisao�
//�������������������������������
	cCodPesq	:= aCodFol[015,1]
	cCodBase	:= aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[064,1]+","
	cCodOut		:= aCodFol[288,1]+","+aCodFol[289,1]
elseif cRoteiro == "RAD"
//�����������������������������Ŀ
//�Adiantamento					�
//�������������������������������
	cCodPesq	:= aCodFol[106,1]
	cCodBase	:= aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[064,1]+","
	cCodOut		:= aCodFol[288,1]+","+aCodFol[289,1]
elseif cRoteiro == "R13"
//�����������������������������Ŀ
//�2a parcela do 13o salario	�
//�������������������������������
	cCodPesq	:= aCodFol[027,1]
	cCodBase	:= aCodFol[019,1]+","+aCodFol[020,1]+","+aCodFol[070,1]+","
	cCodOut		:= aCodFol[290,1]+","+aCodFol[291,1]
elseif cRoteiro == "RFE"
//�����������������������������Ŀ
//�Ferias						�
//�������������������������������
	// Quando a matricula estiver demitida uso outra verba de para base
	cCodPesq	:= If( aCpf[n,4]=="5" , aCodFol[396,1] , aCodFol[016,1] )
	cCodBase	:= aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[065,1]+","
	cCodOut		:= aCodFol[288,1]+","+aCodFol[289,1]
endif

//��������������������������������������������������������������Ŀ
//� Verifica se existe a verba de de base de IR para o calculo   �
//� corrente.													 �
//����������������������������������������������������������������
If (nPos := aScan( aPd ,{ |x| x[1] == cCodPesq } ) )  > 0
	//��������������������������������������������������������������Ŀ
	//� Verifica se o mes de pagamento e o mesmo para todas as matri-�
	//� culas. Se nao for,indica que esta matricula nao foi acumulada�
	//� no aPdTot. No calculo do adiantamento salarial nao incluira	 �
	//� quando estiver testando uma matricula ja demitida que teve a �
	//� sua data de homologacao posterior a data de pagto do Adto.	 �
	//����������������������������������������������������������������
	if ( mesano(aPd[nPos,10]) <> mesano(dData_Pgto) .and. !empty(aPd[nPos,10]) .and. !lDissidio ) .or. ;
	   ( aPd[nPos,10] > dData_Pgto .and. cRoteiro == "RAD" .and. aCPF[n,4] == "5")
			aCPF[n,7]	:= "2"
	endif
Else
	aCPF[n,7]	:= "2"
Endif

//��������������������������������������������������������������Ŀ
//� Somo ao array aPdTot todos os valores das verbas de todas as �
//� matriculas que estiverem sinalizadas para acumular.			 �
//����������������������������������������������������������������
For ny := 1 to len(aPd)
	//��������������������������������������������������������������Ŀ
	//� Executo somente quando a matricula for acumulada.			 �
	//����������������������������������������������������������������
	If aCPF[n,7] <> "2"
		If (nPos := aScan( aPdTot ,{ |x| x[1] == aPd[ny,1] .and. X[9] <> 'D' .and. cSemana == X[3] } ) )  > 0 .and. aPd[ny,9] <> 'D' .and. cSemana == aPd[ny,3]
			aPdTot[nPos,4] := aPdTot[nPos,4] + aPd[ny,4]
			aPdTot[nPos,5] := aPdTot[nPos,5] + aPd[ny,5]
		ElseIf aPd[ny,9] <> "D"
			If lItemClVl
				If lTemEmpC 
					aAdd(aPdTot,{aPd[ny,1],aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],aPd[ny,7],aPd[ny,8],aPd[ny,9],aPd[ny,10],aPd[ny,11],aPd[ny,12],aPd[ny,13],aPd[ny,14],"",.F. } )
				Else
					aAdd(aPdTot,{aPd[ny,1],aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],aPd[ny,7],aPd[ny,8],aPd[ny,9],aPd[ny,10],aPd[ny,11],aPd[ny,12],aPd[ny,13],aPd[ny,14]} )	
				EndIf	
			Else
				If lTemEmpC 
					aAdd(aPdTot,{aPd[ny,1],aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],aPd[ny,7],aPd[ny,8],aPd[ny,9],aPd[ny,10],aPd[ny,11],aPd[ny,12],"","","",.F. } )
				Else
					aAdd(aPdTot,{aPd[ny,1],aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],aPd[ny,7],aPd[ny,8],aPd[ny,9],aPd[ny,10],aPd[ny,11],aPd[ny,12],"","" } )					
				EndIf
			Endif
		Endif
	elseif cRoteiro <> "RAD"
	//������������������������������������������������������������������Ŀ
	//� Se a matricula nao for acumulada, fazemos o tratamento do INSS	 �
	//��������������������������������������������������������������������
		//������������������������������������������������������������������Ŀ
		//� Tratamento do INSS quando as datas de pagto estiverem diferentes �
		//� entre as matriculas do mesmo CPF. Busco os valores de inss ja	 �
		//� descontados e acumulo como Base e Inss de outras empresas.		 �
		//� Somente em casos de rescisao e quando nao tiver as verbas 288/289�
		//� informadas no movimento.										 �
		//��������������������������������������������������������������������
		//������������������������������������������������������������������Ŀ
		//� Codigos de Inss Outras Empresas									 �
		//��������������������������������������������������������������������
		If aPd[ny,1] $cCodOut
			//������������������������������������������������������������������Ŀ
			//� Ajusto os valores quando as verbas de inss de outras empresas nao�
			//� foram informadas.												 �
			//��������������������������������������������������������������������
			If (nPos := aScan( aPdTot ,{ |x| x[1] == aPd[ny,1] .and. x[9] <> 'D' .and. cSemana == x[3]  .and. x[7] $"I,G" } ) ) == 0
				If (nPos := aScan( aPdTot ,{ |x| x[1] == aPd[ny,1] .and. x[9] <> 'D' .and. cSemana == x[3] } ) ) > 0
					aPdTot[nPos,5] := aPdTot[nPos,5] + aPd[ny,5]
				Else
					If lItemClVl
						If lTemEmpC 
							aAdd(aPdTot,{aPd[ny,1],aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],if(cRoteiro=="R13","S","C"),aPd[ny,8],aPd[ny,9],aPd[ny,10],aPd[ny,11],aPd[ny,12],aPd[ny,13],aPd[ny,14],"",.F. } )
						Else
							aAdd(aPdTot,{aPd[ny,1],aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],if(cRoteiro=="R13","S","C"),aPd[ny,8],aPd[ny,9],aPd[ny,10],aPd[ny,11],aPd[ny,12],aPd[ny,13],aPd[ny,14] } )
						EndIf
					Else
						If lTemEmpC 
							aAdd(aPdTot,{aPd[ny,1],aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],if(cRoteiro=="R13","S","C"),aPd[ny,8],aPd[ny,9],aPd[ny,10],aPd[ny,11],aPd[ny,12],"","","",.F. } )
						Else
							aAdd(aPdTot,{aPd[ny,1],aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],if(cRoteiro=="R13","S","C"),aPd[ny,8],aPd[ny,9],aPd[ny,10],aPd[ny,11],aPd[ny,12],"","" } )						
						EndIf
					Endif
				Endif
			endif
		//������������������������������������������������������������������Ŀ
		//� Codigos de Inss Normal											 �
		//��������������������������������������������������������������������
		elseif aPd[ny,1] $cCodBase
			//������������������������������������������������������������������Ŀ
			//� Troco os codigos de inss normal para inss de outras empresas.	 �
			//��������������������������������������������������������������������
			If 	aPd[ny,1] == if(cRoteiro <> "R13",aCodFol[013,1],aCodFol[019,1]) .or. ;
				aPd[ny,1] == if(cRoteiro <> "R13",aCodFol[014,1],aCodFol[020,1])
				cCodigo	:= if(cRoteiro <> "R13",aCodFol[288,1],aCodFol[290,1])
			else
				cCodigo	:= if(cRoteiro <> "R13",aCodFol[289,1],aCodFol[291,1])
			endif
			//������������������������������������������������������������������Ŀ
			//� Ajusto os valores quando as verbas de inss de outras empresas nao�
			//� foram informadas.												 �
			//��������������������������������������������������������������������
			If (nPos := aScan( aPdTot ,{ |x| x[1] == cCodigo .and. x[9] <> 'D' .and. cSemana == x[3] .and. x[7] $"I,G" } ) )  == 0
				If (nPos := aScan( aPdTot ,{ |x| x[1] == cCodigo .and. x[9] <> 'D' .and. cSemana == x[3] } ) ) > 0
					aPdTot[nPos,5] := aPdTot[nPos,5] + aPd[ny,5]
				Else
					If lItemClVl
						If lTemEmpC 
							aAdd(aPdTot,{cCodigo,aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],if(cRoteiro=="R13","S","C"),aPd[ny,8]," ",aPd[ny,10],aPd[ny,11],aPd[ny,12],aPd[ny,13],aPd[ny,14],"",.F. } )
						Else
							aAdd(aPdTot,{cCodigo,aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],if(cRoteiro=="R13","S","C"),aPd[ny,8]," ",aPd[ny,10],aPd[ny,11],aPd[ny,12],aPd[ny,13],aPd[ny,14] } )
						EndIf
					Else     
						If lTemEmpC 
							aAdd(aPdTot,{cCodigo,aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],if(cRoteiro=="R13","S","C"),aPd[ny,8]," ",aPd[ny,10],aPd[ny,11],aPd[ny,12],"","","",.F. } )
						Else
							aAdd(aPdTot,{cCodigo,aPd[ny,2],aPd[ny,3],aPd[ny,4],aPd[ny,5],aPd[ny,6],if(cRoteiro=="R13","S","C"),aPd[ny,8]," ",aPd[ny,10],aPd[ny,11],aPd[ny,12],"","" } )
						EndIf
					Endif
				Endif
			endif
		endif
	endif
next ny


return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fProporc	�Autor  �Ricardo Duarte Costa� Data �  26/08/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Proporcionaliza os valores de Pensao Alimenticia/Ir/Inss    ���
�������������������������������������������������������������������������͹��
���Parametros�aCPF      = Array para guardar todas as matriculas relacio- ���
���          �            nadas ao CPF corrente.                          ���
���          �cCodRecalc- verbas normais a recalcular.                    ���
���          �cCodPensao- verbas de pensao a recalcular.                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Sigagpe                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fProporc(aCpf,cCodRecalc,cCodPensao) 

Local aAux			:= {}		// array auxiliar para tratamento das verbas excluidas em aPdTot
Local aTroca		:= {}		// array que contem as verbas correspondentes para inss de folha e 13o salario.
Local cCodPd		:= ""		// codigo da verba que esta sendo processada no loop
Local cCodBaseProp	:= if(	cRoteiro $"RFP,RRE",;
							aCodFol[015,1],;
							If(	cRoteiro=="RAD",;
								aCodFol[010,1],;
								If(	cRoteiro=="RFE",;
									aCodfol[016,1],;
									aCodFol[027,1];
									);
									);
									)
								// variavel que indica qual a verba sera utiliza como base para proporcionalizacao
Local cRefFer		:= if(	cRoteiro $"RFP,RRE",;
							"N",;
							If(	cRoteiro=="RAD",;
								"N",;
								If(	cRoteiro=="RFE",;
									"S",;
									"N";
									);
									);
									)
								// variavel que indica se as verbas a serem consideradas referem-se a ferias.
Local cRef13o		:= if(	cRoteiro $"RFP,RRE",;
							"N",;
							If(	cRoteiro=="RAD",;
								"N",;
								If(	cRoteiro=="RFE",;
									"N",;
									"S";
									);
									);
									)
								// variavel que indica se as verbas a serem considerads referem-se a 13o salario.
Local cNomeArray	:= ""		// variavel que guarda o nome do array que sera processado
Local cNomeValor	:= ""		// variavel que guarda o nome da a ser utilizado na proporcionalizacao
Local dDataIR		:= if(	cRoteiro =="RFP",;
							dData_Pgto,;
							If(	cRoteiro=="RAD",;
								dDataPgto,;
								If(	cRoteiro=="RFE",;
									dDataBase,;
									If( cRoteiro == "RRE",;
										M->RG_DATAHOM,;
										CTOD("");
										);
										);
										);
										)
								// variavel que guarda a data de pagamento para utilizacao na proporcionalizacao
Local nNomeValor	:= 0		// variavel auxiliar para a proporcionalizacao
Local _nNomeValor 	:= 0		// variavel auxiliar para a proporcionalizacao 
Local nValAux		:= 0
Local nCont			:= 0
Local nPos			:= 0		// variavel de posicionamento
Local nPos2			:= 0		// variavel de posicionamento
Local nPosTot		:= 0		// variavel de posicionamento
Local nPercParcial	:= 0		// variavel que guarda os percentuais de rateios ja definidos durante o processamento.
Local nValInss		:= 0		// variavel auxiliar para a proporcionalizacao do inss de outras empresas
Local nValorTot		:= 0		// variavel que auxiliar na definicao dos percentuais de rateio
Local _nValorTot	:= 0 		// variavel auxiliar para total 
Local nValParc		:= 0		// variavel que guarda os valores parciais rateados durante o processamento.
Local nVerbas		:= 0		// variavel que guarda a quantidade de verbas a serem processadas.
Local nx			:= 0		// variavel para loop
Local ny			:= 0		// variavel para loop
Local nz			:= 0		// variavel para loop

Local cCCAtual		:= ""		//?-Centro de Custo do Funcionario Corrente
Local nValor14		:= 0

//��������������������������������������������������������������Ŀ
//� Limpa o array aPdTot das verbas excluidas e reordena.        �
//����������������������������������������������������������������
for ny := 1 to Len(aPdTot)
	If aPdTot[ny,9] <> 'D'
		aAdd( aAux, aClone(aPdTot[ny]) )
	endif
next ny
aPdTot	:= aClone(aAux)
aAux	:= nil
aSort( aPdTot ,,, { |x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )

//������������������������������������������������������������������Ŀ
//� Pesquisa o valor total da verba de base de IR que sera utilizada �
//� para o rateio dos demais valores.								 �
//��������������������������������������������������������������������
If  SRA->RA_CATFUNC=="A" .AND. SRA->RA_CATEG == "15" .and. Type("cTransPaP") # "U"
	Aeval( aPdTot ,{ |X| IF(X[3] == cSemana                        .And. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc) + "," + cTransPaP  ) ,SomaInc(X,5,@nValorTot,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol),NIL) } ) 
	Aeval( aPdTot ,{ |X| IF(X[3] == cSemana  .and. x[1]$cTransPaP .And. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc))                      ,SomaInc(X,5,@_nValorTot,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol),NIL) } )
	nValorTot	:= nValorTot * 0.40			//-- transp.Mercadorias 
	_nValorTot	:= _nValorTot * 0.60		//-- transp.Passageiros 
	nValorTot:= nValorTot + _nValorTot
Else 
 	Aeval( aPdTot ,{ |X| IF(X[3] == cSemana  .And. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc) ),SomaInc(X,5,@nValorTot,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol,,,!lDissidio),NIL) } )
Endif

//����������������������������������������������������������������������Ŀ
//� Ordeno decrescente por Situacao na folha.							 �
//� Inicia o processamento pelas matriculas demitidas e nao acumuladas	 �
//� com a finalidade de abater os valores que nao serao rateados antes	 �
//� de efetuar o rateio definitivo para as demais matriculas			 �
//������������������������������������������������������������������������
aSort( aCPF ,,, { |x,y| x[4]+x[7] > y[4]+y[7] } )	// 1 = Ativo
													// 2 = Afastado
													// 3 = Ferias
													// 4 = Transferido
													// 5 = Demitido

//����������������������������������������������������������Ŀ
//� Processa o calculo dos percentuais para rateio s/base IR �
//������������������������������������������������������������
For ny := 1 to len(aCPF)
	//��������������������������������������������������������������Ŀ
	//� Filtro para as matriculas que participaram do movimento		 �
	//����������������������������������������������������������������
	If aCPF[ny,8]
		//��������������������������������������������������������������Ŀ
		//� Filtro para as matriculas que foram acumuladas em aPdTot	 �
		//����������������������������������������������������������������
		If aCPF[ny,7] <> "2" // somente para funcionarios acumulados em APDTOT
			cNomeArray		:= "a"+aCPF[ny,12]
			cNomeValor		:= "n"+aCPF[ny,12]
			&(cNomeValor)	:= 0
			nNomeValor		:= 0
			//�����������������������������������������������������������������������Ŀ
			//� Encontra o valor de cada matricula para apurar o percentual de rateio �
			//�������������������������������������������������������������������������
			If SRA->RA_CATFUNC=="A" .AND. SRA->RA_CATEG == "15" .and. U_GENTYPE01("cTransPaP") # "U" 
				Aeval( &(cNomeArray) ,{ |X| IF(X[3] == cSemana .And.                        !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc)+ "," + cTransPaP ),SomaInc(X,5,@nNomeValor,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol),NIL) } )
				Aeval( &(cNomeArray) ,{ |X| IF(X[3] == cSemana .And.  x[1]$ cTransPaP .and. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc)                  ),SomaInc(X,5,@_nNomeValor,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol),NIL) } )
				nNomeValor	:= nNomeValor  * 0.40 
				_nNomeValor	:= _nNomeValor * 0.60 
				nNomeValor	:= nNomeValor + _nNomeValoR 	
			Else
				Aeval( &(cNomeArray) ,{ |X| IF(X[3] == cSemana .And. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nNomeValor,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol,,,!lDissidio),NIL) } )
			Endif
			&(cNomeValor)	:= nNomeValor
			//�����������������������������������������������������������������������Ŀ
			//� Zera os valores de base para matriculas que nao tiveram adiantamento. �
			//�������������������������������������������������������������������������
			If cRoteiro=="RAD" .And. aCPF[ny,4] <> "5"
				Aeval( &(cNomeArray) ,{ |X| nValAux += IF(X[3] == cSemana .And. X[1]==aCodFol[106,1] .And. X[9] # "D" .And. (MesAno(dDataIR) == MesAno(X[10]) .Or. Empty(X[10])),X[5],0) } )
				If &(cNomeValor) == nValAux
					&(cNomeValor)	:= 0
				Endif
			Endif
			//����������������������������������������������������������������������Ŀ
			//� Se a matricula nao estiver demitida, calcula o percentual de rateio. �
			//������������������������������������������������������������������������
			If aCPF[ny,4] <> "5" // somente para funcionarios nao demitidos
				aCpf[ny,6]	:= round( (&(cNomeValor)/nValorTot*100) , 7 )
				aCpf[ny,10]	:= aCpf[ny,6]
				aCpf[ny,11]	:= aCpf[ny,6]
				If ny == len(aCPF)
					aCpf[ny,6]	:= 100 - nPercParcial
					aCpf[ny,10]	:= aCpf[ny,6]
					aCpf[ny,11]	:= aCpf[ny,6]
				else
					nPercParcial:= nPercParcial + aCpf[ny,6]
				endif
			else
			//����������������������������������������������������������������������Ŀ
			//� Se a matricula estiver demitida diminiremos o valor desta matricula	 �
			//� do total apurado de forma a encontrar o percentual correto de rateio.�
			//������������������������������������������������������������������������
				nValorTot	:= nValorTot - &(cNomeValor)
			endif
		endif
	endif
next ny

//������������������������������������������������������������������Ŀ
//� Processa o calculo dos percentuais para rateio do inss de ferias �
//� quando esta no calculo da folha e tem pelo menos 01 funcionario  �
//� em situacao de ferias.                                           �
//��������������������������������������������������������������������
Aeval(aCPF,{ |X| If(X[4]=="3",nCont += 1,"") } )	// "3" - Situacao de ferias
If cRoteiro =="RFP" .And. nCont > 0
	//-- Calculo dos percentuais em funcao da base de ir de ferias
	nValorTot	:= 0
	nPercParcial:= 0
	Aeval( aPdTot ,{ |X| IF(X[3] == cSemana .And. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nValorTot,11,"S",12,"N",nil,,aCodFol,,,!lDissidio),NIL) } )
	For ny := 1 to len(aCPF)
		//��������������������������������������������������������������Ŀ
		//� Filtro para as matriculas que participaram do movimento		 �
		//����������������������������������������������������������������
		If aCPF[ny,8]
			//��������������������������������������������������������������Ŀ
			//� Filtro para as matriculas que foram acumuladas em aPdTot	 �
			//����������������������������������������������������������������
			If aCPF[ny,7] <> "2" // somente para funcionarios acumulados em APDTOT
				cNomeArray		:= "a"+aCPF[ny,12]
				cNomeValor		:= "n"+aCPF[ny,12]
				&(cNomeValor)	:= 0
				nNomeValor		:= 0
				//�����������������������������������������������������������������������Ŀ
				//� Encontra o valor de cada matricula para apurar o percentual de rateio �
				//�������������������������������������������������������������������������
				Aeval( &(cNomeArray) ,{ |X| IF(X[3] == cSemana .And. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nNomeValor,11,"S",12,"N",nil,,aCodFol,,,!lDissidio),NIL) } )
				&(cNomeValor)	:= nNomeValor
				//����������������������������������������������������������������������Ŀ
				//� Se a matricula nao estiver demitida, calcula o percentual de rateio. �
				//������������������������������������������������������������������������
				If aCPF[ny,4] <> "5" // somente para funcionarios nao demitidos
					aCpf[ny,10]	:= round( (&(cNomeValor)/nValorTot*100) , 7 )
					if ny == len(aCPF)
						aCpf[ny,10]	:= 100 - nPercParcial
					else
						nPercParcial:= nPercParcial + aCpf[ny,10]
					endif
				else
				//����������������������������������������������������������������������Ŀ
				//� Se a matricula estiver demitida diminiremos o valor desta matricula	 �
				//� do total apurado de forma a encontrar o percentual correto de rateio.�
				//������������������������������������������������������������������������
					nValorTot	:= nValorTot - &(cNomeValor)
				endif
			endif
		endif
	next ny

	//-- Calculo dos percentuais em funcao da base de ir total
	nValorTot	:= 0
	nPercParcial:= 0
	Aeval( aPdTot ,{ |X| IF(X[3] == cSemana .And. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+aCodFol[168,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nValorTot,,,,,nil,,aCodFol,,,!lDissidio),NIL) } )
	For ny := 1 to len(aCPF)
		//��������������������������������������������������������������Ŀ
		//� Filtro para as matriculas que participaram do movimento		 �
		//����������������������������������������������������������������
		If aCPF[ny,8]
			//��������������������������������������������������������������Ŀ
			//� Filtro para as matriculas que foram acumuladas em aPdTot	 �
			//����������������������������������������������������������������
			If aCPF[ny,7] <> "2" // somente para funcionarios acumulados em APDTOT
				cNomeArray		:= "a"+aCPF[ny,12]
				cNomeValor		:= "n"+aCPF[ny,12]
				&(cNomeValor)	:= 0
				nNomeValor		:= 0
				//�����������������������������������������������������������������������Ŀ
				//� Encontra o valor de cada matricula para apurar o percentual de rateio �
				//�������������������������������������������������������������������������
				Aeval( &(cNomeArray) ,{ |X| IF(X[3] == cSemana .And. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+aCodFol[168,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nNomeValor,,,,,nil,,aCodFol,,,!lDissidio),NIL) } )
				&(cNomeValor)	:= nNomeValor
				//����������������������������������������������������������������������Ŀ
				//� Se a matricula nao estiver demitida, calcula o percentual de rateio. �
				//������������������������������������������������������������������������
				If aCPF[ny,4] <> "5" // somente para funcionarios nao demitidos
					aCpf[ny,11]	:= round( (&(cNomeValor)/nValorTot*100) , 7 )
					if ny == len(aCPF)
						aCpf[ny,11]	:= 100 - nPercParcial
					else
						nPercParcial:= nPercParcial + aCpf[ny,11]
					endif
				else
				//����������������������������������������������������������������������Ŀ
				//� Se a matricula estiver demitida diminiremos o valor desta matricula	 �
				//� do total apurado de forma a encontrar o percentual correto de rateio.�
				//������������������������������������������������������������������������
					nValorTot	:= nValorTot - &(cNomeValor)
				endif
			endif
		endif
	next ny

Endif

//��������������������������������������������������������������������������Ŀ
//� Processa a proprocionalizacao dos valores para todas as matriculas.		 �
//����������������������������������������������������������������������������
//��������������������������������������������������������������������������Ŀ
//� Determina a quantidade de verbas a ser processada						 �
//����������������������������������������������������������������������������
nVerbas		:= len(&(cCodRecalc)+cCodPensao) 
For nx := 1 to nVerbas step 4
	//��������������������������������������������������������������������������Ŀ
	//� Determina o codigo da verba a ser proporcionalizada. 					 �
	//����������������������������������������������������������������������������
	cCodPd		:= substr((&(cCodRecalc)+cCodPensao),nx,3)
	nValParc	:= 0
	//��������������������������������������������������������������������������Ŀ
	//� Proporcionaliza os valores de todas as verbas de IR/Pensao/Inss			 �
	//����������������������������������������������������������������������������
	for ny := 1 to len(aCpf)
		//��������������������������������������������������������������Ŀ
		//� Filtro para as matriculas que participaram do movimento		 �
		//����������������������������������������������������������������
		If aCPF[ny,8]
			//��������������������������������������������������������������Ŀ
			//� Filtro para as matriculas que foram acumuladas em aPdTot	 �
			//����������������������������������������������������������������
			If aCPF[ny,7] <> "2"
				cNomeArray	:= "a"+aCPF[ny,12]
				//��������������������������������������������������������������Ŀ
				//� Pesquiso a verba recalculada com o valor total em aPdTot	 �
				//����������������������������������������������������������������
				if ( nPosTot := aScan( aPdTot,{ |x| x[1] = cCodPd .and. x[3] == cSemana } ) ) > 0
					//����������������������������������������������������������������������Ŀ
					//� Pesquisa a verba no array de cada matricula.						 �
					//� Se encontrar a verba, atualiza o seu valor, horas e flag de exclusao �
					//�����������������������������������������������������������������������
					if ( nPos := aScan( &(cNomeArray),{ |x| x[1] = cCodPd .and. x[3] == cSemana } ) ) > 0
						//����������������������������������������������������������������������Ŀ
						//� Se a matricula nao estiver demitida, calcula o percentual de rateio. �
						//������������������������������������������������������������������������
						If aCPF[ny,4] <> "5"		// Diferente de demitido
							&(cNomeArray)[nPos,4]	:= aPdTot[nPosTot,4]
							If aPdTot[nPosTot,1]$aCodFol[065,1]+"*"+aCodFol[100,1]+"*"+aCodFol[101,1]+"*"+aCodFol[659,1] .And. cRoteiro $"RFP,RRE"
								&(cNomeArray)[nPos,5]	:= round( aPdTot[nPosTot,5] * aCPF[ny,10] / 100 , 2 )
							ElseIf aPdTot[nPosTot,1]$aCodFol[013,1]+"*"+aCodFol[014,1] .And. cRoteiro $"RFP,RRE"
								&(cNomeArray)[nPos,5]	:= round( aPdTot[nPosTot,5] * aCPF[ny,11] / 100 , 2 )
							Else
								&(cNomeArray)[nPos,5]	:= round( aPdTot[nPosTot,5] * aCPF[ny,6] / 100 , 2 )
							Endif
							&(cNomeArray)[nPos,9]	:= Iif(&(cNomeArray)[nPos,5]<>0," ","D")
						else
						//����������������������������������������������������������������������Ŀ
						//� Se a matricula estiver demitida diminiremos o valor desta matricula	 �
						//� do total apurado de forma a rateiar o valor total sem modificar as	 �
						//� matriculas demitidas.												 �
						//������������������������������������������������������������������������
							aPdTot[nPosTot,5]	:= aPdTot[nPosTot,5] - &(cNomeArray)[nPos,5]
						endif
					else
					//����������������������������������������������������������������������Ŀ
					//� Se nao encontrar a verba e a matricula nao estiver demitida.		 �
					//� Cria a verba no array de cada matricula.							 �
					//������������������������������������������������������������������������
						If aCPF[ny,4] <> "5"
							aSRAArea := SRA->(GetArea())
							cCCAtual := Posicione("SRA",1,aCPF[ny,2]+aCPF[ny,3],"SRA->RA_CC")
							RestArea(aSRAArea)
							If lItemClVl
        						If lTemEmpC 
 									aAdd(&(cNomeArray),{	cCodPd, cCCAtual, cSemana, aPdTot[nPosTot,4],		;
															round( aPdTot[nPosTot,5] * Iif(aPdTot[nPosTot,1]$aCodFol[065,1]+"*"+aCodFol[100,1]+"*"+aCodFol[101,1]+"*"+aCodFol[659,1] .And. cRoteiro $"RFP,RRE",aCPF[ny,10],If(aPdTot[nPosTot,1]$aCodFol[013,1]+"*"+aCodFol[014,1] .And. cRoteiro $"RFP,RRE",aCpf[ny,11],aCPF[ny,6])) / 100 , 2 ),	;
															aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
															aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
															aPdTot[nPosTot,12],aPdTot[nPosTot,13],aPdTot[nPosTot,14],"",.F. } )
								else
 									aAdd(&(cNomeArray),{	cCodPd, cCCAtual, cSemana, aPdTot[nPosTot,4],		;
															round( aPdTot[nPosTot,5] * Iif(aPdTot[nPosTot,1]$aCodFol[065,1]+"*"+aCodFol[100,1]+"*"+aCodFol[101,1]+"*"+aCodFol[659,1] .And. cRoteiro $"RFP,RRE",aCPF[ny,10],If(aPdTot[nPosTot,1]$aCodFol[013,1]+"*"+aCodFol[014,1] .And. cRoteiro $"RFP,RRE",aCpf[ny,11],aCPF[ny,6])) / 100 , 2 ),	;
															aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
															aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
															aPdTot[nPosTot,12],aPdTot[nPosTot,13],aPdTot[nPosTot,14] } )
								EndIf															
							Else
	       						If lTemEmpC 
									aAdd(&(cNomeArray),{	cCodPd, cCCAtual, cSemana, aPdTot[nPosTot,4],		;
															round( aPdTot[nPosTot,5] * Iif(aPdTot[nPosTot,1]$aCodFol[065,1]+"*"+aCodFol[100,1]+"*"+aCodFol[101,1]+"*"+aCodFol[659,1] .And. cRoteiro $"RFP,RRE",aCPF[ny,10],If(aPdTot[nPosTot,1]$aCodFol[013,1]+"*"+aCodFol[014,1] .And. cRoteiro $"RFP,RRE",aCpf[ny,11],aCPF[ny,6])) / 100 , 2 ),	;
															aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
															aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
															aPdTot[nPosTot,12],"","","",.F. } )
								Else                        
									aAdd(&(cNomeArray),{	cCodPd, cCCAtual, cSemana, aPdTot[nPosTot,4],		;
															round( aPdTot[nPosTot,5] * Iif(aPdTot[nPosTot,1]$aCodFol[065,1]+"*"+aCodFol[100,1]+"*"+aCodFol[101,1]+"*"+aCodFol[659,1] .And. cRoteiro $"RFP,RRE",aCPF[ny,10],If(aPdTot[nPosTot,1]$aCodFol[013,1]+"*"+aCodFol[014,1] .And. cRoteiro $"RFP,RRE",aCpf[ny,11],aCPF[ny,6])) / 100 , 2 ),	;
															aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
															aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
															aPdTot[nPosTot,12],"","" } )
								EndIf
							Endif
							nPos := aScan( &(cNomeArray),{ |x| x[1] = cCodPd .and. x[3] == cSemana } ) 
						endif						
					endif
					//����������������������������������������������������������������������Ŀ
					//� Acumula os valores ja rateados na variavel nValParc com a finalidade �
					//� de ajustar os totais sem deixar faltar centavos						 �
					//������������������������������������������������������������������������
					If aCPF[ny,7] == "1" .and. aCPF[ny,4] <> "5"	// Ajusta os centavos para a ultima matricula processada
						if ny == len(aCpf)
							&(cNomeArray)[nPos,5]	:= aPdTot[nPosTot,5] - nValParc
						else
							nValParc	:= nValParc + &(cNomeArray)[nPos,5]
						endif
					endif
				endif
			endif
		endif
	next ny
next nx

//���������������������������������������������������������������������������������������Ŀ
//� Processa a geracao do inss de outras empresas para folha mensal e 13o salario normal. �
//�����������������������������������������������������������������������������������������
If cRoteiro =="RFP" .or. ( cRoteiro == "R13" .and. !lRecalc13o )
	If cRoteiro == "RFP"
		//��������������������������������������������������������������������������Ŀ
		//� Contem as verbas de inss e base de inss que deverao ser geradas como     �
		//� outras empresas.														 �
		//����������������������������������������������������������������������������
		If !empty(aCodFol[288,1]) .And. !empty(aCodFol[289,1])
			aAdd( aTroca , { aCodFol[013,1]+","+aCodFol[014,1] , aCodFol[288,1] } )	// Salario de Contribuicao ate o limite e acima do limite
			aAdd( aTroca , { aCodFol[064,1]+","+aCodFol[065,1] , aCodFol[289,1] } )	// Inss s/salario e inss s/ferias
		Endif
	Elseif cRoteiro == "R13"
		//��������������������������������������������������������������������������Ŀ
		//� Contem as verbas de inss e base de inss que deverao ser geradas como     �
		//� outras empresas.														 �
		//����������������������������������������������������������������������������
		If !empty(aCodFol[290,1]) .And. !empty(aCodFol[291,1])
			aAdd( aTroca , { aCodFol[019,1]+","+aCodFol[020,1] , aCodFol[290,1] } )	// Salario de Contribuicao ate o limite 13o salario e acima do limite
			aAdd( aTroca , { aCodFol[070,1]                     , aCodFol[291,1] } )	// Inss s/13o salario
		Endif
	endif
	
	//��������������������������������������������������������������������������Ŀ
	//� Executa para todas as verbas do array aTroca.							 �
	//����������������������������������������������������������������������������
	for nx := 1 to len(aTroca) step 1
		//��������������������������������������������������������������������������Ŀ
		//� Proporcionaliza os valores de todas as verbas de Inss					 �
		//����������������������������������������������������������������������������
		for ny := 1 to len(aCpf)
			//��������������������������������������������������������������Ŀ
			//� Filtro para as matriculas que participaram do movimento		 �
			//����������������������������������������������������������������
			If aCPF[ny,8]
				//��������������������������������������������������������������Ŀ
				//� Filtro para as matriculas que foram acumuladas em aPdTot	 �
				//����������������������������������������������������������������
				If aCPF[ny,7] <> "2"
					cNomeArray	:= "a"+aCPF[ny,12]
					nValTot		:= 0
					nValInss	:= 0
					nPosTot		:= aScan( aPdTot,{ |x| x[1] $aTroca[nx,1] .and. x[3] <= cSemana .and. x[9] <> "D" } ) 
					//��������������������������������������������������������������Ŀ
					//� Pesquiso a verba recalculada com o valor total em aPdTot	 �
					//����������������������������������������������������������������
					aEval( aPdTot,{ |x| nValTot += If(x[1] $aTroca[nx,1] .and. x[3] <= cSemana .and. x[9] <> "D",x[5],0) } ) 
					If nValTot > 0
						//����������������������������������������������������������������������Ŀ
						//� Pesquisa a verba no array de cada matricula.						 �
						//� Se encontrar a verba, atualiza o seu valor, horas e flag de exclusao �
						//������������������������������������������������������������������������
						// Verba de inss de outras empresas
						nPos  		:= aScan( &(cNomeArray),{ |x| x[1] = aTroca[nx,2] .and. x[3] <= cSemana .and. x[9] <> "D" } )
						// Verba de inss normal do movimento
						aEval( &(cNomeArray),{ |x| nValInss += If(x[1] $aTroca[nx,1] .and. x[3] <= cSemana .and. x[9] <> "D",x[5],0) } )

						If nPos > 0 .and. !(&(cNomeArray)[nPos,7] $"I,G")
							//���������������������������������������������������������������������������������Ŀ
							//� Se a matricula nao estiver demitida, ajusta o valor de inss de outras empresas. �
							//�����������������������������������������������������������������������������������
							If aCPF[ny,4] <> "5"		// Diferente de demitido
								&(cNomeArray)[nPos,5]	:= (nValTot - nValInss)
							endif
						Elseif nPos == 0
							//����������������������������������������������������������������������Ŀ
							//� Se nao encontrar a verba e a matricula nao estiver demitida.		 �
							//� Cria a verba no array de cada matricula.							 �
							//������������������������������������������������������������������������
							If aCPF[ny,4] <> "5"
								aSRAArea := SRA->(GetArea())
								cCCAtual := Posicione("SRA",1,aCPF[ny,2]+aCPF[ny,3],"SRA->RA_CC")
								RestArea(aSRAArea)
								If lItemClVl                 
									If lTemEmpC
										aAdd(&(cNomeArray),{	aTroca[nx,2], cCCAtual, cSemana, aPdTot[nPosTot,4],		;
										(nValTot - nValInss),	;
										aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
										aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
										aPdTot[nPosTot,12], aPdTot[nPosTot,13], aPdTot[nPosTot,14],"",.F. } )
									
									Else
										aAdd(&(cNomeArray),{	aTroca[nx,2], cCCAtual, cSemana, aPdTot[nPosTot,4],		;
										(nValTot - nValInss),	;
										aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
										aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
										aPdTot[nPosTot,12], aPdTot[nPosTot,13], aPdTot[nPosTot,14] } )
									EndIf	
								Else            
									If lTemEmpC
										aAdd(&(cNomeArray),{	aTroca[nx,2], cCCAtual, cSemana, aPdTot[nPosTot,4],		;
										(nValTot - nValInss),	;
										aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
										aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
										aPdTot[nPosTot,12],"","","",.F. } )
									Else
										aAdd(&(cNomeArray),{	aTroca[nx,2], cCCAtual, cSemana, aPdTot[nPosTot,4],		;
										(nValTot - nValInss),	;
										aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
										aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
										aPdTot[nPosTot,12],"","" } )
									EndIf
								Endif
							endif
						endif
					endif
				endif
			endif
		next ny
	next nx
endif
				
//����������������������������������������������������������������������Ŀ
//� Para multiplos vinculos entre mensalista  x mensalista, no array do  �
//� autonomo, trocar as verbas de ID 013 e 014 (Sal Contr. ate teto inss �
//� e acima do teto), pela verba 221 (base inss prol\autonomo)			 �
//������������������������������������������������������������������������
For nz := 1 to len(aCpf)		

	cNomeArray		:= "a"+aCPF[nz,12]   // Atualiza o array que sera gravado para a matricula	

	If aCPF[nz,13] == "1" 						 //Autonomo			
		nPos := aScan( &(cNomeArray),{ |x| x[1] == aCodfol[014,1] .and. x[3] <= cSemana .and. x[9] <> "D" } )
		If nPos > 0
			nValor14 := &(cNomeArray)[nPos,5]
			&(cNomeArray)[npos,9] := 'D'
		EndIf
				
		nPos := aScan( &(cNomeArray),{ |x| x[1] == aCodfol[013,1] .and. x[3] <= cSemana .and. x[9] <> "D" } )
				
		If nPos > 0
			&(cNomeArray)[npos,1] := acodfol[221,1]
			&(cNomeArray)[npos,5] += nValor14
		EndIf
	EndIf
next nx 
return nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GravaAdt � Autor � Mauro                 � Data � 07.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava as Verbas da Matriz Calculadas no Adiantamento       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � GravaAdt(aX)                                               ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� aX =  Matriz Multi contendo                                ���
���          � Codigo da Verba , C.Custo, Semana, Horas , Valor , Tipo1 ,;���
���          � Tipo2 , Parcela                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GravaAdt(aX)

Local dDtPgt

If aX[7] == 'I' .And. Empty(ax[10]) .And. ax[1]$ aCodFol[007,1]+ aCodFol[012,1]+ aCodFol[010,1] 
	dDtPgt := dDataPgto
Elseif aX[7] # 'A'.And. PosSrv(aX[1],SRA->RA_FILIAL,"RV_ADIANTA") == 'N'
	dDtPgt := If (Ax[10] = Nil , CTOD(""), Ax[10])
Elseif Empty(aX[10]) .Or. aX[3] == Semana
	dDtPgt := dDataPgto
Else
	dDtPgt := aX[10]
Endif

GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aX[1], dDtPgt ,aX[2],aX[3],aX[6],aX[7],aX[4],aX[5],aX[8],ax[9],,aX[11])

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fProvAdi	�Autor  �Ricardo Duarte Costa� Data �  09/09/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ajusta os valores da rescisao para o calculo do Adto.       ���
�������������������������������������������������������������������������͹��
���Uso       � Sigagpe                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
static function fProvAdi()

Local aAux		:= {}
Local aTroca	:= {}
Local cCodAux	:= ""
Local nElement	:= 0
Local nPos		:= 0
Local nPos1		:= 0
Local nx		:= 0

//��������������������������������������������������������������������������Ŀ
//� Contem as verbas de IR do mes e IR do mes anterior para o recalculo do IR�
//� e pensao no calculo do adiantamento salarial.                       	 �
//����������������������������������������������������������������������������
aAdd( aTroca , { aCodFol[015,1] , aCodFol[106,1] } )	// Base de IR sobre a folha
aAdd( aTroca , { aCodFol[066,1] , aCodFol[107,1] } )	// Ir sobre a folha do mes
aAdd( aTroca , { aCodFol[107,1] , aCodFol[107,1] } )	// Ir sobre o mes anterior
aAdd( aTroca , { aCodFol[012,1] , aCodFol[107,1] } )	// Ir sobre o adiantamento

nElement	:= len(aPd)
for nx := 1 to nElement
	//��������������������������������������������������������������������������Ŀ
	//� Limpa a matriz deixando somente os codigos necessarios ao recalculo do IR�
	//� e troca os codigos de IR da rescisao por IR do mes anterior.			 �
	//����������������������������������������������������������������������������
	If ( nPos := aScan(aTroca,{|X| x[1] == aPd[nx,1] } ) ) > 0
		If mesano(dData_Pgto) == mesano(aPd[nx,10]) .or. Empty(aPd[nx,10])
			//��������������������������������������������������������������Ŀ
			//� Quando nao for a base de ir de folha na rescisao, somaremos	 �
			//� as verbas de ir (mes anterior, adiantamento, folha) que 	 �
			//� estiverem no mesmo mes de pagamento da rescisao.			 �
			//����������������������������������������������������������������
			If aTroca[nPos,1] <> aCodFol[015,1]
				If ( nPos1 := aScan(aAux,{|X| x[1] == aTroca[nPos,2] } ) ) > 0
					aAux[nPos1,5]	+= aPd[nx,5]
				else
					aAdd(aAux,Aclone(aPd[nx]))
					aAux[len(aAux),1]	:= aTroca[nPos,2]
				endif
			else
			//��������������������������������������������������������������Ŀ
			//� Quando for a base de ir de folha na rescisao.				 �
			//����������������������������������������������������������������
				aAdd(aAux,Aclone(aPd[nx]))
				aAux[len(aAux),1]	:= aTroca[nPos,2]
			endif
		endif
	endif
next nx

aPd		:= aClone(aAux)

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fCarregaPD� Autor � Ricardo Duarte Costa	� Data � 13/09/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Carrega o APD para posterior processamento.                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�aCPF      = Array para guardar todas as matriculas relacio- ���
���          �            nadas ao CPF corrente.                          ���
���          �z         = indica o posicionamento no array aCPF.          ���
���          �cCodRecalc- verbas normais a recalcular.                    ���
���          �cCodPensao- verbas de pensao a recalcular.                  ���
���          �cTipo2_   - status das verbas que devem ser considerados.   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCarregaPD(aCPF,z,cCodRecalc,cCodPensao,cTipo2_)

Local aBenef131	:= {}					// Array com os dados de pensao alimenticia para a 1a parcela do 13o salario
Local aPdAux	:= {}					// Array parcial de auxilio
Local aNomePd	:= {}					// Array aPdOld por matricula
Local cCodigos	:= &cCodRecalc			// Variavel que contem os codigos de verbas a serem recalculados.
Local cCodPen1P	:= ""					// Variavel com os codigos de pensao alimenticia para a 1a parcela do 13o salario.
Local cMesAnoRef:= GetMv("MV_FOLMES")	// Mes e ano aberto na folha de pagamento.
Local dDataPesq	:= ctod("")	// Variavel utilizada na busca das ferias e rescisoes.
Local dDtaPg	:= ctod("")				// Variavel utilizada para carga do aPd
Local lBusPen131:= .T.					// variavel que determina se deve buscar a pensao da 1a parcela para o calculo da rescisao de contrato
Local lGerou_	:= .F.					// Variavel que recebe a confirmacao de que a rescisao foi carregada para o APD.
Local nPos		:= 0					// Variavel utilizada para pesquisa
Local nValPen1P	:= 0					// Valor da pensao alimenticia da 1a parcela
Local nx		:= 0					// variavel para looping de array
Local dDtBusFer	:= Ctod("")				// Busca RH_DTRECIB ou RH_DTITENS

// Tratamento da existencia da Nova tabela de Dissidio Permanente (RHH)
Local cAliasDis	:= Iif( Sx2ChkTable( "RHH" ), "RHH", "TRB" )

//�����������������������������������������������������������������������Ŀ
//� Alimeto uma unica variavel para teste das verbas a serem recalculadas �
//�������������������������������������������������������������������������
cCodigos		:= cCodigos + cCodPensao

//��������������������������������������������������������������Ŀ
//� Quando for calculo de 2a parcela do 13o salario				 �
//����������������������������������������������������������������
If cRoteiro == "R13"
	//��������������������������������������������������������������Ŀ
	//� Utilizo o aPd salvo no inicio do processamento quando estiver�
	//� acumulando a matricula corrente.							 �
	//����������������������������������������������������������������
	If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
		aPd	:= aClone(aPdCorrent)
		For nx := 1 to len(aPd)
			If aPd[nx,1] $cCodigos
				aPd[nx,9] := "D"
			Endif
			//��������������������������������������������������������������Ŀ
			//� Somente quando for recalculo do 13o salario.				 �
			//����������������������������������������������������������������
			If lRecalc13o
				If aPd[nx,1] == aCodFol[027,1]
					If SRI->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT+aCodFol[027,1]))
						aPd[nx,5] := SRI->RI_VALOR
					endif
				Endif
			Endif
		next nx
	else
		If aCPF[z,4] <> "5"
			//��������������������������������������������������������������Ŀ
			//� Se o funcionario processado estiver em situacao normal		 �
			//����������������������������������������������������������������
			dbSelectArea( "SRI" )
			dbSetOrder(1)
			dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While ! Eof() .And. ( SRA->RA_FILIAL + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_MAT )
				cDel := " "
				//��������������������������������������������������������������Ŀ
				//� Marco com "D" as verbas que serao recalculadas.				 �
				//����������������������������������������������������������������
				If SRI->RI_PD $cCodigos
					cDel := "D"
				EndIf
				dDtaPg := If(lRecalc13o,ctod(""),If( Empty(SRI->RI_DATA) .Or. SRI->RI_TIPO2 $ "I*G",dData_Pgto,SRI->RI_DATA))
				FMatriz(SRI->RI_PD,SRI->RI_VALOR,SRI->RI_HORAS,cSemana,SRI->RI_CC,SRI->RI_TIPO1,SRI->RI_TIPO2,0,cDel,If(cDel#'D',dDtaPg,) )
				dbSelectArea( "SRI" )
				dbSkip()
			Enddo
			//��������������������������������������������������������������Ŀ
			//� Se o funcionario processado estiver em situacao normal		 �
			//����������������������������������������������������������������
			If lRecalc13o
				//����������������������������������������������Ŀ
				//� Troca o status desta matricula para demitido �
				//������������������������������������������������
				aCPF[z,4]	:= "5"
				//��������������������������������������������������������������Ŀ
				//� Carrega as verbas de 13o salario que estiverem no SRC		 �
				//����������������������������������������������������������������
				dbSelectArea( "SRC" )
				SRC->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) ) )
				While SRC->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT )  == RC_FILIAL + RC_MAT )
					cDel := " "
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					IF SRC->RC_TIPO2 $ cTipo2_ .and. SRC->RC_SEMANA == cSemana .and. SRC->RC_PD $cCodigos
						cDel := "D"
					Endif
					dDtapg := ctod("")
					If PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_REF13") == 'S'
						If ( nPos := Ascan(aPd,{|X| X[1] == SRC->RC_PD}) ) > 0
							aPd[nPos,4] := SRC->RC_HORAS
							aPd[nPos,5] += SRC->RC_VALOR
						else
							SRC->( FMatriz(RC_PD,RC_VALOR,RC_HORAS,RC_SEMANA,RC_CC,RC_TIPO1,RC_TIPO2,RC_PARCELA,cDel,dDtapg,,RC_SEQ ) )
						endif
					endif
					dbSelectArea("SRC")
					dbSkip()
				Enddo
			endif
		else
			//��������������������������������������������������������������Ŀ
			//� Se o funcionario processado estiver demitido				 �
			//����������������������������������������������������������������
			//�������������������������������������������������������������������Ŀ
			//� Pesquiso no cabecalho de rescisao se ja existe rescisao calculada �
			//����������������������������������������������������������������������
			dbselectarea("SRG")
			SRG->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT))
			While !SRG->(eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
				//�������������������������������������������������������������������Ŀ
				//� Se o mes ano da homologacao corrente for igual ao da rescisao	  �
				//� e a data de homologacao for menor ou igual a data de pagto da 2a. �
				//� parc.13o.S considero este movimento da rescisao para o recalculo. �
				//���������������������������������������������������������������������
				If	mesano(dData_Pgto) == mesano(SRG->RG_DATAHOM)
					If SRG->RG_DATAHOM > dData_Pgto
						aCPF[z,7] := "2"		// Marco como "nao acumulado" para buscar os valores de inss posteriormente.
					endif
					dDataPesq	:= SRG->RG_DTGERAR
					aCpf[z,9]	:= SRG->RG_DTGERAR
				endif
				SRG->(dbskip())
			enddo
			
			//��������������������������������������������������������������Ŀ
			//� Busco as verbas de rescisao quando existir rescisao calculada�
			//� e monto o aPd.												 �
			//����������������������������������������������������������������
			If !Empty(dDataPesq)
				dbselectarea("SRR")
				if SRR->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq)))
					While SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)
						cDel := " "
						//��������������������������������������������������������������Ŀ
						//� Marco com "D" as verbas que serao recalculadas.				 �
						//����������������������������������������������������������������
						IF SRR->RR_PD $cCodigos
							cDel := "D"
						Endif
						SRR->( FMatriz(RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,"S",0.00,cDel,RR_DATAPAG,," " ) )
						SRR->(DBSKIP())
					enddo
				endif
				//��������������������������������������������������������������Ŀ
				//� Ajusta o aPD antes de fazer a copia e soma-lo ao movimento.	 �
				//����������������������������������������������������������������
				fProv132(cCodigos)
			endif
		endif
	endif
	//����������������������������������������������������Ŀ
	//�Busca as verbas de pensao alimenticia da 1a parcela.�
	//������������������������������������������������������
	If aCPF[z,7] == "1"	.and. len(aPd) > 0	// Somente para matriculas que foram acumuladas
		fBusCadBenef(@aBenef131,"131",,.F.)
		For nx := 1 to len(aBenef131)
			//��������������������������������������������������������������Ŀ
			//� Busca a verba de pensao alimenticia da 1a parc.13o salario.  �
			//����������������������������������������������������������������
			If (nValPen1P	:= abs(fBuscaAcm(aBenef131[nx,1],,stod(strzero(year(dDataRef),4)+"0101"),stod(strzero(year(dDataRef),4)+"1231"),"V")) ) > 0
				fMatriz(aBenef131[nx,1],nValPen1P, , , ,"V","S",0.00,"",CTOD(""),.T.," ")
			endif
		next nx
	endif
	//��������������������������������������������������������������Ŀ
	//� Quando for calculo de rescisao								 �
	//����������������������������������������������������������������
Elseif cRoteiro == "RRE"
	//��������������������������������������������������������������Ŀ
	//� Utilizo o aPd salvo no inicio do processamento quando estiver�
	//� acumulando a matricula corrente.							 �
	//����������������������������������������������������������������
	If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
		aPd	:= aClone(aPdCorrent)
		For nx := 1 to len(aPd)
			If aPd[nx,1] $cCodigos
				aPd[nx,9] := "D"
			Endif
		next nx
	else
	//�������������������������������������������������������������������Ŀ
	//� Pesquiso no cabecalho de rescisao se ja existe rescisao calculada �
	//����������������������������������������������������������������������
		dbselectarea("SRG")
		SRG->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT))
		While !SRG->(eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
			//�������������������������������������������������������������������Ŀ
			//� Se o mes ano da homologacao corrente for igual ao da rescisao	  �
			//� pesquisada considero este movimento da rescisao para o recalculo. �
			//���������������������������������������������������������������������
			If	mesano(dData_Pgto) == mesano(SRG->RG_DATAHOM)
				//��������������������������������������������������������������Ŀ
				//� Se a data de homologacao da rescisao pesquisada for igual a	 �
				//� data de homologacao da matricula corrente calculada, altero	 �
				//� a situacao desta matricula para proporcionalizar os valores	 �
				//� entre as matriculas.										 �
				//����������������������������������������������������������������
				If dData_Pgto == SRG->RG_DATAHOM
					aCPF[z,4]	:= "1"
				endif
				dDataPesq	:= SRG->RG_DTGERAR
				aCpf[z,9]	:= SRG->RG_DTGERAR
			endif
			SRG->(dbskip())
		enddo

		//��������������������������������������������������������������Ŀ
		//� Busco as verbas de rescisao quando existir rescisao calculada�
		//� e monto o aPd.												 �
		//����������������������������������������������������������������
		If !Empty(dDataPesq)
			dbselectarea("SRR")
			if SRR->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq)))
				While SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)
					cDel := " "
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					IF SRR->RR_PD $cCodigos
						cDel := "D"
					Endif
					SRR->( FMatriz(RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00,cDel,RR_DATAPAG,," " ) )
					SRR->(DBSKIP())
				enddo
			endif

			//��������������������������������������������������������������Ŀ
			//� Se nao tiver incluido nenhuma verba no aPd nao deve buscar a �
			//� pensao alimenticia da 1a. parcela do 13o salario.			 �
			//����������������������������������������������������������������
			If Len(aPd) == 0
				lBusPen131	:= .F.
			endif
		else
			//������������������������������������������������������������������������������������Ŀ
			//� Quando nao existir rescisao calculada. Busco o movimento mensal deste funcionario. �
			//��������������������������������������������������������������������������������������
			fCaraPdR( cMesAnoRef , MesAno( dDataDem ),.F., Nil )  
			
			//��������������������������������������������������������������Ŀ
			//�Habilita as verbas do aPd p/gerar vlrs acumulados             �
			//����������������������������������������������������������������			
			//If ( cMesAnoRef == MesAno( dDataDem ) )
			//	aeval(apd,{ |x| x[9 ]:= if( !( x[1] $ cCodigos ) , " ", "D"  )   }   )
			//	aeval(apd,{ |x| x[9 ]:= " "   }   )
			//Endif 
			
			//��������������������������������������������������������������Ŀ
			//� Ajusta o aPD antes de fazer a copia e soma-lo ao movimento.	 �
			//����������������������������������������������������������������
			fProvRes(cCodigos,"FOL")
			aEval(aPd,{|x| aAdd(aPdAux,aClone(X)) } )
			aPd		:= {}

			//������������������������������������������������������������������������������������Ŀ
			//� Quando a matricula processada estiver em ferias, busco o movimento de ferias.      �
			//��������������������������������������������������������������������������������������
			If aCpf[z,4] == "3"		// Situacao de ferias
				Gerafer(aCodFol,dDataDem)
				//������������������������������������������������������������������������������Ŀ
				//� Tratamento da base de inss de ferias quando estiver no calculo de rescisao.	 �
				//��������������������������������������������������������������������������������
				dDtBusFer := fDtBusFer() // Busca RH_DTRECIB ou RH_DTITENS
				If cMesAnoRef == mesano(dDataDem)
					If SRR->(DBSEEK(ACPF[Z,2]+ACPF[Z,3]+"F"+DTOS(dDtBusFer)+aCodFol[065,1]))
						SRR->(fMatriz(	RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00,"",RR_DATAPAG,.T.," "))
					endif
					If SRR->(DBSEEK(ACPF[Z,2]+ACPF[Z,3]+"F"+DTOS(dDtBusFer)+aCodFol[013,1]))
						SRR->(fMatriz(	RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,"K",0.00,"",RR_DATAPAG,.T.," "))
					endif
				endif
				aCpf[z,4] := "5"	// Modifico a situacao para "Demitido" para nao ratear as diferencas encontradas para esta matricula
				//��������������������������������������������������������������Ŀ
				//� Ajusta o aPD antes de fazer a copia e soma-lo ao movimento.	 �
				//����������������������������������������������������������������
				fProvRes(cCodigos,"FER")
				aEval(aPd,{|x| aAdd(aPdAux,aClone(X)) } )
				aPd		:= {}
			endif

			//��������������������������������������������������������������Ŀ
			//� Pesquisa se ja possui 13o calculado.						 �
			//����������������������������������������������������������������
			dbSelectArea( "SRI" )
			dbSetOrder(1)
			//��������������������������������������������������������������Ŀ
			//� Pesquisa a verba de base de ir do 13o salario.				 �
			//����������������������������������������������������������������
			If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[027,1] )
				If mesano(dData_Pgto) == mesano(SRI->RI_DATA)
					//��������������������������������������������������������������Ŀ
					//� Posiciona na 1a verba da matricula corrente.				 �
					//����������������������������������������������������������������
					dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
					While ! Eof() .And. ( SRA->RA_FILIAL + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_MAT )
						cDel := " "
						//��������������������������������������������������������������Ŀ
						//� Marca com "D" as verbas que serao recalculadas.				 �
						//����������������������������������������������������������������
						If SRI->RI_PD $cCodigos
							cDel := "D"
						EndIf
						dDtaPg := If( Empty(SRI->RI_DATA) .Or. SRI->RI_TIPO2 $ "I*G",dData_Pgto,SRI->RI_DATA)
						FMatriz(SRI->RI_PD,SRI->RI_VALOR,SRI->RI_HORAS,cSemana,SRI->RI_CC,SRI->RI_TIPO1,SRI->RI_TIPO2,0,cDel,dDtaPg )
						dbSelectArea( "SRI" )
						dbSkip()
					Enddo
				endif
			endif
			dbselectarea("SRA")
			//��������������������������������������������������������������Ŀ
			//� Ajusta o aPD antes de fazer a copia e soma-lo ao movimento.	 �
			//����������������������������������������������������������������
			fProvRes(cCodigos,"132",@lBusPen131)
			aEval(aPd,{|x| aAdd(aPdAux,aClone(X)) } )
			aPd		:= aClone(aPdAux)
			aPdAux	:= {}


			//��������������������������������������������������������������Ŀ
			//� Se houverm verbas a serem processadas modificamos a situacao �
			//� do funcionario corrente.									 �
			//����������������������������������������������������������������
			If Len(aPd) > 0 
				//��������������������������������������������������������������Ŀ
				//� Indica que o funcionario sera acumulado mas nao sera rateado.�
				//����������������������������������������������������������������
				aCpf[z,4]	:= "5"
				aCpf[z,7]	:= "1"
			endif
		endif
	endif
	//����������������������������������������������������Ŀ
	//�Busca as verbas de pensao alimenticia da 1a parcela.�
	//������������������������������������������������������
	If lBusPen131			// Somente para matriculas que foram acumuladas
		fBusCadBenef(@aBenef131,"131",,.F.)
		For nx := 1 to len(aBenef131)
			//��������������������������������������������������������������Ŀ
			//� Busca a verba de pensao alimenticia da 1a parc.13o salario.  �
			//����������������������������������������������������������������
			If (nValPen1P	:= abs(fBuscaAcm(aBenef131[nx,1],,stod(strzero(year(dDataDem),4)+"0101"),stod(strzero(year(dDataDem),4)+"1231"),"V")) ) > 0
				fMatriz(aBenef131[nx,1],nValPen1P, , , ,"V","S",0.00,"",CTOD(""),.T.," ")
			endif
		next nx
	endif
//��������������������������������������������������������������Ŀ
//� Quando for calculo de ferias								 �
//����������������������������������������������������������������
ElseIf cRoteiro == "RFE"
	//��������������������������������������������������������������Ŀ
	//� Quando a matricula nao estiver demitida.					 �
	//����������������������������������������������������������������
	If aCPF[z,4] <> "5"
		//��������������������������������������������������������������Ŀ
		//� Utilizo o aPd salvo no inicio do processamento quando estiver�
		//� acumulando a matricula corrente.							 �
		//����������������������������������������������������������������
		If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
			aPd	:= aClone(aPdCorrent)
			For nx := 1 to len(aPd)
				If aPd[nx,1] $cCodigos
					aPd[nx,9] := "D"
				Endif
			next nx
		else
	
		//�������������������������������������������������������������������Ŀ
		//� Pesquiso no cabecalho de ferias se ja existem ferias calculadas	  �
		//���������������������������������������������������������������������
			dbselectarea("SRH")
			SRH->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT))
			While !SRH->(eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRH->RH_FILIAL+SRH->RH_MAT
				If	mesano(dData_Pgto) == mesano(SRH->RH_DTRECIB)
					dDataPesq	:= SRH->RH_DTRECIB
					aCpf[z,9]	:= SRH->RH_DTRECIB
				endif
				SRH->(dbskip())
			enddo
	
			//��������������������������������������������������������������Ŀ
			//� Busco as verbas de ferias quando existir ferias calculada	 �
			//� e monto o aPd.												 �
			//����������������������������������������������������������������
			If !Empty(dDataPesq)
				dbselectarea("SRR")
				if SRR->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT+"F"+DTOS(dDataPesq)))
					While SRA->RA_FILIAL+SRA->RA_MAT+"F"+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)
						cDel := " "
						IF SRR->RR_PD $cCodigos
							cDel := "D"
						Endif
						SRR->( FMatriz(RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00,cDel,RR_DATAPAG,," " ) )
						SRR->(DBSKIP())
					enddo
				endif
			endif
		endif
	else
	//��������������������������������������������������������������Ŀ
	//� Quando a matricula estiver demitida.						 �
	//����������������������������������������������������������������
		//�������������������������������������������������������������������Ŀ
		//� Pesquiso no cabecalho de rescisao se ja existe rescisao calculada �
		//���������������������������������������������������������������������
		dbselectarea("SRG")
		SRG->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT))
		While !SRG->(eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
			//�����������������������������������������������������������������������������Ŀ
			//� Se a data da homologacao tiver ocorrido antes do pagamento do adiantamento. �
			//�������������������������������������������������������������������������������
			If	mesano(dData_Pgto) == mesano(SRG->RG_DATAHOM)
				dDataPesq	:= SRG->RG_DTGERAR
				aCpf[z,9]	:= SRG->RG_DTGERAR
			endif
			SRG->(DBSKIP())
		enddo
		//��������������������������������������������������������������Ŀ
		//� Busco as verbas de rescisao quando existir rescisao calculada�
		//� e monto o aPd.												 �
		//����������������������������������������������������������������
		If !Empty(dDataPesq)
			dbselectarea("SRR")
			if SRR->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq)))
				While SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)
					//����������������������������������������������������������Ŀ
					//� Busco as verbas de Base IR Ferias e Dif.Base Ir Ferias	 �
					//������������������������������������������������������������
					IF ( SRR->RR_PD $aCodFol[016,1]+","+aCodFol[100,1] ) .and. aCodFol[236,1] <> space(3)
						If (nPos := ascan(aPd,{|X| x[1] == aCodFol[236,1] .and. x[9] <> "D"})) > 0
							aPd[nPos,4]	+= SRR->RR_HORAS
							aPd[nPos,5]	+= SRR->RR_VALOR
						else
							SRR->( FMatriz(aCodFol[236,1],RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00," ",RR_DATAPAG,," " ) )
						endif
					Endif
					//����������������������������������������������������������Ŀ
					//� Busco as verbas de IR Ferias e Dif. Ir Ferias			 �
					//������������������������������������������������������������
					IF ( SRR->RR_PD $aCodFol[067,1]+","+aCodFol[101,1] ) .and. aCodFol[237,1] <> space(3)
						If (nPos := ascan(aPd,{|X| x[1] == aCodFol[237,1] .and. x[9] <> "D"})) > 0
							aPd[nPos,4]	+= SRR->RR_HORAS
							aPd[nPos,5]	+= SRR->RR_VALOR
						else
							SRR->( FMatriz(aCodFol[237,1],RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00," ",RR_DATAPAG,," " ) )
						endif
					Endif
					//����������������������������������������������������������Ŀ
					//� Busco as verbas de base de inss ate o limite e acima	 �
					//������������������������������������������������������������
					IF ( SRR->RR_PD $aCodFol[013,1]+","+aCodFol[014,1] ) .and. aCodFol[396,1] <> space(3) .and. ;
						( mesano(M->RH_DATAINI) == mesano(dDataPesq) )
						If (nPos := ascan(aPd,{|X| x[1] == aCodFol[396,1] .and. x[9] <> "D"})) > 0
							aPd[nPos,4]	+= SRR->RR_HORAS
							aPd[nPos,5]	+= SRR->RR_VALOR
						else
							SRR->( FMatriz(aCodFol[396,1],RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00," ",RR_DATAPAG,," " ) )
						endif
					Endif
					//����������������������������������������������������������Ŀ
					//� Busco as verbas de inss s/folha e inss s/ferias			 �
					//������������������������������������������������������������
					IF ( SRR->RR_PD $aCodFol[064,1]+","+aCodFol[065,1] ) .and. aCodFol[397,1] <> space(3) .and. ;
						( mesano(M->RH_DATAINI) == mesano(dDataPesq) )
						If (nPos := ascan(aPd,{|X| x[1] == aCodFol[397,1] .and. x[9] <> "D"})) > 0
							aPd[nPos,4]	+= SRR->RR_HORAS
							aPd[nPos,5]	+= SRR->RR_VALOR
						else
							SRR->( FMatriz(aCodFol[397,1],RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00," ",RR_DATAPAG,," " ) )
						endif
					Endif
					SRR->(DBSKIP())
				enddo
			endif
		endif
	endif
//��������������������������������������������������������������Ŀ
//� Quando for adiantamento e funcionario demitido.				 �
//����������������������������������������������������������������
Elseif cRoteiro == "RAD" .and. aCPF[z,4] == "5"
	//�������������������������������������������������������������������Ŀ
	//� Pesquiso no cabecalho de rescisao se ja existe rescisao calculada �
	//���������������������������������������������������������������������
	dbselectarea("SRG")
	SRG->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT))
	While !SRG->(eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
		//�����������������������������������������������������������������������������Ŀ
		//� Se a data da homologacao tiver ocorrido antes do pagamento do adiantamento. �
		//�������������������������������������������������������������������������������
		If	mesano(dData_Pgto) == mesano(SRG->RG_DATAHOM) .and. SRG->RG_DATAHOM <= dData_Pgto
			dDataPesq	:= SRG->RG_DTGERAR
			aCpf[z,9]	:= SRG->RG_DTGERAR
		endif
		SRG->(DBSKIP())
	enddo
	//��������������������������������������������������������������Ŀ
	//� Busco as verbas de rescisao quando existir rescisao calculada�
	//� e monto o aPd.												 �
	//����������������������������������������������������������������
	If !Empty(dDataPesq)
		dbselectarea("SRR")
		if SRR->(DBSEEK(SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq)))
			While SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)
				cDel := " "
				//��������������������������������������������������������������Ŀ
				//� Marco com "D" as verbas que serao recalculadas.				 �
				//����������������������������������������������������������������
				IF SRR->RR_PD $cCodigos
					cDel := "D"
				Endif
				SRR->( FMatriz(RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00,cDel,RR_DATAPAG,," " ) )
				SRR->(DBSKIP())
			enddo
		endif

		//��������������������������������������������������������������Ŀ
		//� Ajusta o aPD antes de fazer a copia e soma-lo ao movimento.	 �
		//� Somente quando for adiantamento salarial.					 �
		//����������������������������������������������������������������
		fProvAdi()
	endif
//��������������������������������������������������������������������Ŀ
//� Quando for funcionario em sitacao normal para folha e adiantamento �
//����������������������������������������������������������������������
else
	//��������������������������������������������������������������Ŀ
	//� Utilizo o aPd salvo no inicio do processamento quando estiver�
	//� acumulando a matricula corrente.							 �
	//����������������������������������������������������������������
	If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
		aPd	:= aClone(aPdCorrent)
		For nx := 1 to len(aPd)
			//��������������������������������������������������������������Ŀ
			//� Marco com "D" as verbas que serao recalculadas.				 �
			//����������������������������������������������������������������
			If ( aPd[nx,1] $cCodigos ) .And. ( cSemana == aPd[nx,3] )
				aPd[nx,9] := "D"
			Endif
		next nx
		//���������������������������������������������������������������������������Ŀ
		//� Testa a existencia da verba de base de ir de adiantamento para considerar �
		//� as verbas desta matricula para o calculo.								  �
		//�����������������������������������������������������������������������������
		If cRoteiro == "RAD" .And. aCPF[z,4] <> "3"
			If Ascan(aPd,{|X| X[1] == aCodFol[010,1] .And. X[3] == cSemana}) == 0
				aPd	:= {}
			endif
		//���������������������������������������������������������������������������Ŀ
		//� Testa a existencia da verba de base de ir               o para considerar �
		//� as verbas desta matricula para o calculo.								  �
		//�����������������������������������������������������������������������������
		elseif cRoteiro == "RFP" .And. aCPF[z,4] <> "3"
			If Ascan(aPd,{|X| X[1] == aCodFol[015,1] .And. X[3] == cSemana}) == 0
				aCPF[z,8] := .F.
			endif
		endif
	else
		//��������������������������������������������������������������Ŀ
		//� Se o funcionario processado estiver demitido buscaremos a	 �
		//� rescisao no arquivo de rescisao.							 �
		//����������������������������������������������������������������
		If aCPF[z,4] == "5"	
			GeraResc( cFolMes , cSemana , @lGerou_ )
			If lGerou_
				For nx := 1 to len(aPd)
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					If aPd[nx,1] $cCodigos
						aPd[nx,9] := "D"
					Endif
				next nx
			endif
		else
			//��������������������������������������������������������������Ŀ
			//� Se o funcionario processado estiver em situacao normal		 �
			//����������������������������������������������������������������
			dbSelectArea( "SRC" )
			SRC->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) ) )
			While SRC->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT )  == RC_FILIAL + RC_MAT )
				cDel := " "
				//��������������������������������������������������������������Ŀ
				//� Marco com "D" as verbas que serao recalculadas.				 �
				//����������������������������������������������������������������
				IF SRC->RC_TIPO2 $ cTipo2_ .and. SRC->RC_SEMANA == cSemana .and. SRC->RC_PD $cCodigos
					cDel := "D"
				Endif
				dDtapg := SRC->( IF(Empty(RC_DATA) .And. !RC_PD $ aCodFol[106,1]+'*'+aCodFol[107,1] ,dData_Pgto,RC_DATA) )
			    
			    IF SRA->RA_CATFUNC = 'A'
				   SRC->( FMatrizX(RC_PD,RC_VALOR,RC_HORAS,RC_SEMANA,RC_CC,RC_TIPO1,RC_TIPO2,RC_PARCELA,cDel,dDtapg,,RC_SEQ,RC_QTDSEM,RC_ITEM,RC_CLVL ) )
				ELSE                                                                                                                     
				   SRC->( FMatriz(RC_PD,RC_VALOR,RC_HORAS,RC_SEMANA,RC_CC,RC_TIPO1,RC_TIPO2,RC_PARCELA,cDel,dDtapg,,RC_SEQ,RC_QTDSEM ) )
				ENDIF
				
				dbSelectArea("SRC")
				dbSkip()
			Enddo
		
			If lDissidio
				aNomePd	:= aClone(aPd)
				aPd		:= {}

				dbSelectArea( cAliasDis )

				// Caso update 150 nao tenha sido executado utilizara o indice do TRB.
				// Caso ja tenha sido executado utilizara o indice da nova tabela RHH
				// "TRB_FILIAL + TRB_MAT + TRB_MESANO + Substr(TRB_DATA,3,4)+Substr(TRB_DATA,1,2) + TRB_VB"

				If cAliasDis == "RHH"
					dbSetOrder( 1 )	// "RHH_FILIAL + RHH_MAT + RHH_MESANO + RHH_DATA + RHH_VB + RHH_CC + RHH_ITEM + RHH_CLVL"
				EndIf

				(cAliasDis)->(	dbSeek( SRA->(RA_FILIAL+RA_MAT) + Right(cMesAnoCalc,4)+Left(cMesAnoCalc,2) + MesAno( dDataBase ) ) )

				While (cAliasDis)->( ! Eof() )																.And. ;
					  SRA->RA_FILIAL 							== (cAliasDis)->&((cAliasDis)+"_FILIAL") 	.And. ;
					  SRA->RA_MAT 								== (cAliasDis)->&((cAliasDis)+"_MAT") 		.And. ;
					  Right(cMesAnoCalc,4)+Left(cMesAnoCalc,2) 	== (cAliasDis)->&((cAliasDis)+"_MESANO")	.And. ;
					  MesAno(dDataBase) 						== (cAliasDis)->&((cAliasDis)+"_DATA")

					//��������������������������������������������������������������Ŀ
					//� Despreza salario base de referencia do dissidio.			 �
					//����������������������������������������������������������������
					If (cAliasDis)->&((cAliasDis)+"_VB") == "000"
						(cAliasDis)->( dbSkip() )
						Loop
					EndIf

					cDel := " "

					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					IF (cAliasDis)->&((cAliasDis)+"_TIPO2") $ cTipo2_ 		.and. ;
					   (cAliasDis)->&((cAliasDis)+"_SEMANA") == cSemana 	.and. ;
					   (cAliasDis)->&((cAliasDis)+"_VB") $ cCodigos
						cDel := "D"
					Endif

					If Empty( (cAliasDis)->&((cAliasDis)+"_DTPGT") ) .And. ;
					   ! (cAliasDis)->&((cAliasDis)+"_VB") $ aCodFol[106,1] + '*' + aCodFol[107,1]
						dDtapg := dData_Pgto
					Else
						dDtapg := (cAliasDis)->&((cAliasDis)+"_DTPGT")
					EndIf

					(cAliasDis)->( FMatriz(	(cAliasDis)->&((cAliasDis)+"_VB")		,;
											(cAliasDis)->&((cAliasDis)+"_CALC")	,;
											(cAliasDis)->&((cAliasDis)+"_HORAS")	,;
											(cAliasDis)->&((cAliasDis)+"_SEMANA")	,;
											(cAliasDis)->&((cAliasDis)+"_CC")		,;
											(cAliasDis)->&((cAliasDis)+"_TIPO1")	,;
											(cAliasDis)->&((cAliasDis)+"_TIPO2")	,;
											(cAliasDis)->&((cAliasDis)+"_PARC")	,;
											cDel									,;
											dDtapg									,;
																					,;
											(cAliasDis)->&((cAliasDis)+"_SEQ")		,;
											(cAliasDis)->&((cAliasDis)+"_QTDSEM")	))

					dbSelectArea( (cAliasDis) )
					(cAliasDis)->( dbSkip() )
				Enddo
			EndIf

			//���������������������������������������������������������������������������Ŀ
			//� Testa a existencia da verba de base de ir de adiantamento para considerar �
			//� as verbas desta matricula para o calculo.								  �
			//�����������������������������������������������������������������������������
			If cRoteiro == "RAD" .And. aCPF[z,4] <> "3"
				If Ascan(aPd,{|X| X[1] == aCodFol[010,1] .And. X[3] == cSemana}) == 0
					aPd	:= {}
				endif

			//���������������������������������������������������������������������������Ŀ
			//� Testa a existencia da verba de base de ir               o para considerar �
			//� as verbas desta matricula para o calculo.								  �
			//�����������������������������������������������������������������������������
			elseif cRoteiro == "RFP" .And. aCPF[z,4] <> "3"
				If Ascan(aPd,{|X| X[1] == aCodFol[015,1] .And. X[3] == cSemana}) == 0
					aCPF[z,8] := .F.
				endif
			endif
		Endif
	Endif
Endif

//��������������������������������������������������������������Ŀ
//� Exclui as verbas de INSS de outras empresas quando as verbas �
//� nao tiverem sido informadas ou geradas pelo usuario.		 �
//����������������������������������������������������������������
If cRoteiro == "RFP"
	aEval(aPd,{ |X| x[9] := If( x[1] $aCodFol[288,1]+","+aCodFol[289,1] .and. !x[7]$"I,G","D",x[9] ) } )
Elseif cRoteiro == "R13"
	aEval(aPd,{ |X| x[9] := If( x[1] $aCodFol[290,1]+","+aCodFol[291,1] .and. !x[7]$"I,G","D",x[9] ) } )
endif


Return( aNomePd )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �RotIrMultV� Autor � Ricardo Duarte Costa	� Data � 15/09/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Carrega os roteiros do dos multiplos vinculos.             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cRot - Indica qual o roteiro a ser criado.                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
static function RotIrMultV(cRot)

If cRot == "RFP"
	//���������������������Ŀ
	//� Foha de pagamento	�
	//�����������������������
	Aadd( aRoteiroIR , { '00010','','FDiasTrab(@DiasTrab,cDiasMes,@lAdmissao)','' } )
	Aadd( aRoteiroIR , { '00020','','cPgSalMat := fPgMater()','' } )
	Aadd( aRoteiroIR , { '00030','','FDiasAfast(@nDiasAfas,@DiasTrab,,,cPgSalMat)','' } )
	
	//-- Roteiros para carregar aTarefas que eh utilziado na fSalProf para montar o aSalProf, usado no calculo do sal. familia
	Aadd( aRoteiroIR , { '00040','','GeraTarefa(dDatade,dDataAte,@aTarefas,"S")','' } )
	Aadd( aRoteiroIR , { '00050','(SRA->RA_CATFUNC $ "I*J")','aParProf := fParProf()','aParProf := {}' } )
	Aadd( aRoteiroIR , { '00060','(SRA->RA_CATFUNC $ "I*J")','FSalProf(@Salario,@SalHora,@SalDia,@SalMes,aTarefas,@aSalProf)','' } )
	
	Aadd( aRoteiroIR , { '00070','! SRA->RA_CATFUNC$ "P*A*E*G"','fCInss(aCodfol,aTinss)','' } )
	Aadd( aRoteiroIR , { '00080','MesAno(dData_Pgto) >= "200408" .and. MesAno(dData_Pgto) <="200412" .And. !( SRA->RA_CATFUNC $ SuperGetMv("MV_NGREDUT",,"") ) .And. fChkBsIr(aPd,DiasTrab,dData_pgto)','fGeraVerba(aCodFol[408,1],100)','' } )
	//-- Tratamento para Autonomos
	Aadd( aRoteiroIR , { '00090','SRA->RA_CATFUNC$ "P*A"','fCSalC(aCodfol,aTSalC)',''} )
	Aadd( aRoteiroIR , { '00100','SRA->RA_CATFUNC$ "A" .And. (Round(nSalC_b * 0.15,2) < Round(nBSalc * 0.20,2) .Or. EMPTY(SRA->RA_CLASSEC) )','fGeraVerba(aCodFol[221,1],nSalC_b)',''} )
	Aadd( aRoteiroIR , { '00110','SRA->RA_CATFUNC$ "A" .And. Round(nSalC_b * 0.15,2) > Round(nBSalC * 0.20,2)','fGeraVerba(aCodFol[225,1],nBSalC)',''} )
	Aadd( aRoteiroIR , { '00130','SRA->RA_CATFUNC$ "P"','fGeraVerba(aCodFol[221,1],nSalC_b)',''} )
	Aadd( aRoteiroIR , { '00130','SRA->RA_CATFUNC$ "P*A" .And. SRA->RA_INSSSC == "S"','fGeraVerba(aCodFol[222,1],nInssSc)',''} )
	Aadd( aRoteiroIR , { '00140','SRA->RA_CATFUNC$ "P*A" .And. MesAno(dDataBase) >= "200304"','fCInssAut(aCodfol,aTinss)',''} )
	Aadd( aRoteiroIR , { '00150','SRA->RA_CATFUNC$ "P*A" .And. MesAno(dDataBase) >= "200304"','nVInssDesc := 0',''})
	Aadd( aRoteiroIR , { '00160','SRA->RA_CATFUNC$ "P*A" .And. SRA->RA_TIPOPGT = "S" .And.  MesAno(dDataBase) >= "200304"','Aeval(aPd,{|X| nVInssDesc += If(X[1] == aCodFol[064,1] .And. X[3] < cSemana .And. X[9] <> "D",X[5],0)})',''})
	Aadd( aRoteiroIR , { '00170','SRA->RA_CATFUNC$ "P*A" .And. MesAno(dDataBase) >= "200304"','nDInssAut := If(nVInssAut+nVInssOut+nVInssDesc < NoRound(aTinss[Len(aTinss),1]*M_PERCAUTO,2), nVInssAut, NoRound(aTinss[Len(aTinss),1]*M_PERCAUTO,2)-nVInssOut-nVInssDesc)',''} )

	//-- Autonomos Freteiros/Carreteiros
	Aadd( aRoteiroIR , { '00180','SRA->RA_CATFUNC == "A" .And. SRA->RA_CATEG == "15"','S_CALC. INSS AUT.',''} )
	Aadd( aRoteiroIR , { '00190','SRA->RA_CATFUNC == "A" .And. SRA->RA_CATEG == "15"','S_CALC. IRRF AUT.',''} )
	//-- Retorna ao Autonomos Normais
	Aadd( aRoteiroIR , { '00200','SRA->RA_CATFUNC$ "P*A" .And. MesAno(dDataBase) >= "200304" .And. nDInssAut > 0','fGeraVerba(aCodFol[64,1], nDInssAut, M_PERCAUTO*100)',''} )
	Aadd( aRoteiroIR , { '00210','SRA->RA_CATFUNC$ "P*A" .And. MesAno(dDataBase) >= "200304" .And. nDInssAut > 0','fGeraVerba(aCodFol[167,1],nDInssAut)',''} )
	//-- Retorna ao tratamento geral
	Aadd( aRoteiroIR , { '00220','','FCalcPensao(aCodFol[64,1],aCodFol[66,1],aCodFol[56,1],0,dData_Pgto,"FOL")','' } )
	Aadd( aRoteiroIR , { '00230','','fCIr(aCodfol,aTabir,,dData_Pgto)','' } )
	Aadd( aRoteiroIR , { '00240','MesAno(dData_Pgto) >= "200408" .and. MesAno(dData_Pgto) <="200412" .And. fLocaliaPd(aCodfol[151,1]) > 0','fGeraVerba(aCodFol[411,1],100)','' } )
	Aadd( aRoteiroIR , { '00250','','FCalcIRLucro(aCodFol,aTabIr,cSemana,.T.)','' } )
	Aadd( aRoteiroIR , { '00260','','fCIrfer(aCodfol,aTabir,.T.,dData_pgto)','' } )
	Aadd( aRoteiroIR , { '00270','','fCIr13o(aCodfol,aTabir13)','' } )
	Aadd( aRoteiroIR , { '00280','( !cSitFolh $ "A*D*F" ) .Or. ( cSitFolh == "A" .And. nDiasAc+nDiasAd+nDiasMat+fVarRot("nDiasSalM") > 0 ) .Or. ( cSitFolh == "F".And. !fVarRot("lRetAf_OP") )','SalFam(aCodfol,@nSal_fami,"S")','' } )
	
elseif cRot == "RAD"
	//���������������������Ŀ
	//� Adiantamento     	�
	//�����������������������
	Aadd( aRoteiroIR , { '00010','','FIrMultvAd()','' } )
	Aadd( aRoteiroIR , { '00020','','FBaseIni()','' } )
	Aadd( aRoteiroIR , { '00030','','FSomaAdiant()','' } )
	Aadd( aRoteiroIR , { '00040','MesAno(dDataPgto) >= "200408" .and. MesAno(dDataPgto) <="200412" .And. !( SRA->RA_CATFUNC $ SuperGetMv("MV_NGREDUT",,"") ) .And. Base_Ini > 0 .And. fChkBsIr(aPd,Diastb,dDataPgto,"ADI")','fGeraVerba(aCodFol[408,1],100,,,,,,,,,.T.)','' } )
	Aadd( aRoteiroIR , { '00050','','FCalcPensao("XXX",aCodFol[9,1],aCodFol[58,1],0,dDataPgto)','' } )
	Aadd( aRoteiroIR , { '00060','','FM010IncIR()','' } )
	Aadd( aRoteiroIR , { '00070','MesAno(dDataPgto) >= "200408" .and. MesAno(dDataPgto) <="200412" .And. fLocaliaPd(aCodfol[151,1]) > 0','fGeraVerba(aCodFol[411,1],100,,,,,,,,,.T.)','' } )
	Aadd( aRoteiroIR , { '00080','','FCalcIRLucro(aCodFol,aTabIr,SEMANA,.T.)','' } )
	Aadd( aRoteiroIR , { '00090','IR_CALC > 0.10','FGeraVerba(cPdPesq,IR_CALC,0.00,SEMANA , ,"V","A",,,,.T.)','' } )
	Aadd( aRoteiroIR , { '00100','BASE_INI # 0','FGeraVerba(AcODFOL[10,1],BASE_INI,0.00,SEMANA , ,"V","A",,,,.T.)','' } )
	Aadd( aRoteiroIR , { '00110','VAL_DEDDEP # 0','FGeraVerba(aCodfol[59,1],VAL_DEDDEP,Val(SRA->RA_Depir),SEMANA , ,"V","A",,,,.T.)','' } )
elseif cRot == "RFE"
	//���������������������Ŀ
	//� Ferias           	�
	//�����������������������
	Aadd( aRoteiroIR , { '00010','','fInssFer()','' } )
	Aadd( aRoteiroIR , { '00020','MesAno(M->RH_DTRECIB) >= "200408" .and. MesAno(M->RH_DTRECIB) <="200412"','FMatriz(aCodFol[410,1],100,,,,,"C",,,,)','' } )
	Aadd( aRoteiroIR , { '00030','','fPOutFer()','' } )
	Aadd( aRoteiroIR , { '00040','','FCalcPensao(aCodFol[65,1],aCodFol[67,1],aCodFol[170,1],0,M->RH_DTRECIB)','' } )
	Aadd( aRoteiroIR , { '00050','','fcIrFer(aCodfol,aTabIr,,,.T.,"F")','' } )
elseif cRot == "RRE"
	//���������������������Ŀ
	//� Rescisao         	�
	//�����������������������
	Aadd( aRoteiroIR , { '00010','','fCInss(aCodfol,aTinss)','' } )
	Aadd( aRoteiroIR , { '00020','','fCInss13(aCodfol,aTinss,,nInssP,nBAtLim,nBAcLim)','' } )
	Aadd( aRoteiroIR , { '00030','','fC13Matern()','' } )
	Aadd( aRoteiroIR , { '00040','MesAno(M->RG_DATAHOM) >= "200408" .And. MesAno(M->RG_DATAHOM) <= "200412"','fGeraVerba(aCodFol[408,1],100)','' } )
	Aadd( aRoteiroIR , { '00050','','fCalcPensao(aCodfol[64,1],aCodFol[66,1],aCodFol[56,1],0,M->RG_DATAHOM," ")','' } )
	Aadd( aRoteiroIR , { '00060','','fCIr(aCodfol,aTabir,"R",M->RG_DATAHOM)','' } )
	Aadd( aRoteiroIR , { '00070','MesAno(M->RG_DATAHOM) >= "200408" .And. MesAno(M->RG_DATAHOM) <= "200412" .And. fLocaliaPd(aCodFol[151,1]) > 0','fGeraVerba(aCodFol[411,1],100)','' } )
	Aadd( aRoteiroIR , { '00080','','FCalcIRLucro(aCodFol,aTabIr,cSemana,.T.)','' } )
	Aadd( aRoteiroIR , { '00090','MesAno(M->RG_DATAHOM) >= "200408" .And. MesAno(M->RG_DATAHOM) <= "200412"','fGeraVerba(aCodFol[410,1],100)','' } )
	Aadd( aRoteiroIR , { '00100','','fCalcPensao(aCodfol[65,1],aCodFol[67,1],aCodFol[170,1],0,M->RG_DATAHOM,"FER")','' } )
	Aadd( aRoteiroIR , { '00110','','fCIrfer(aCodfol,aTabir,.T.,M->RG_DATAHOM)','' } )
	Aadd( aRoteiroIR , { '00120','MesAno(M->RG_DATAHOM) >= "200408" .And. MesAno(M->RG_DATAHOM) <= "200412"','fGeraVerba(aCodFol[409,1],100)','' } )
	Aadd( aRoteiroIR , { '00130','','fCalcPensao(aCodfol[70,1],aCodFol[71,1],aCodFol[128,1],0,M->RG_DATAHOM,"13o")','' } )
	Aadd( aRoteiroIR , { '00140','','fCIr13o(aCodfol,aTabir,,,nIr13P)','' } )
	Aadd( aRoteiroIR , { '00290','cCompl # "S" .or. ( cCompl == "S" .and. MesAno(GetMemVar("RG_DATADEM")) == MesAno(GetMemVar("RG_DTGERAR")) )','SalFam(aCodfol,@nSal_fami,"S",dDataDem)',''} )	
elseif cRot == "R13"
	//���������������������Ŀ
	//� Rescisao         	�
	//�����������������������
	Aadd( aRoteiroIR , { '00010','','fCInss13(aCodfol,aTinss13,.F.)','' } )
	Aadd( aRoteiroIR , { '00020','MesAno(dDataBase) >= "200408" .and. MesAno(dDataBase) <="200412" .And. nAvos > 0','fGeraVerba(aCodFol[409,1],100)','' } )
	Aadd( aRoteiroIR , { '00030','','FCalcPensao(aCodFol[70,1],aCodFol[71,1],aCodFol[128,1],0,dData_Pgto)','' } )
	Aadd( aRoteiroIR , { '00040','','fCIr13o(aCodfol,aTabir13,,.F.)','' } )
endif

return( len(aRoteiroIR) > 0 )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � GravaSRR � Autor �Ricardo Duarte Costa   � Data � 16/09/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava as Verbas da Matriz Calculadas nas Ferias		  	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GravaSRR(aPd,aCpf,z,cCodigos,cTipo)                        ���
��� 		 �														  	  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� aCpf - matriz com as matriculas que estao sendo processadas���
���          � z    - indica o posicionamento no array aCPF.              ���
���          � ccodigos - codigos das verbas que devem ser gravados.      ���
���          � cTipo - "F" e igual a ferias / "R" e igual a rescisao.     ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	 � Generico 											  	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GravaSRR(aCpf,z,cCodigos,cTipo)

Local aAreaSRR	:= SRR->(getarea())	// Salva a area do arquivo de itens de ferias e rescisoes.
Local nx 		:= 0					// variavel de loop

dbselectarea("SRR")
//���������������������������������������������������������Ŀ
//� Processa a atualizacao dos itens de ferias e rescisoes. �
//�����������������������������������������������������������
for nx := 1 to len(aPd)
	//���������������������������������������������������������Ŀ
	//� Somente para as verbas que sofreram recalculo e rateio. �
	//�����������������������������������������������������������
	If aPd[nx,1] $cCodigos
		//���������������������������������������������������������Ŀ
		//� Se a verba existir no movimento.						�
		//�����������������������������������������������������������
		If dbseek(aCpf[z,2]+aCpf[z,3]+cTipo+dtos(aCpf[z,9])+aPd[nx,1])
			reclock("SRR",.f.)
			//������������������������������������������������������������������Ŀ
			//� Se a verba estiver excluida no movimento excluo no arquivo tambem�
			//��������������������������������������������������������������������
			If aPd[nx,5] == 0 .or. aPd[nx,9] == "D"
				dbdelete()
			else
			//������������������������������������������������������������������Ŀ
			//� Se nao, atualizo os campos de horas e valor						 �
			//��������������������������������������������������������������������
				SRR->RR_HORAS	:= aPd[nx,4]
				SRR->RR_VALOR	:= aPd[nx,5]
			endif
			msunlock()
		else
		//���������������������������������������������������������������������������������������Ŀ
		//� Se a verba nao existir no movimento e nao estiver excluida, incluo a verba no arquivo.�
		//�����������������������������������������������������������������������������������������
			If aPd[nx,5] <> 0 .and. aPd[nx,9] <> "D"
				reclock("SRR",.t.)
				SRR->RR_FILIAL	:= aCpf[z,2]		//Filial
				SRR->RR_MAT		:= aCpf[z,3]		//Matricula
				SRR->RR_PD		:= aPd[nx,1]		//Verba
				SRR->RR_VALOR	:= aPd[nx,5]		//Valor
				SRR->RR_HORAS	:= aPd[nx,4]		//Horas
				SRR->RR_TIPO1	:= aPd[nx,6]		//Tipo da Verba ( D,H,V )
				SRR->RR_TIPO2	:= aPd[nx,7]		//Origem do Calculo
				SRR->RR_DATA	:= aCpf[z,9]		//Data de Geracao
				SRR->RR_DATAPAG	:= dData_Pgto		//Data de Pagamento
				SRR->RR_CC		:= aPd[nx,2]		//Centro de Custo
				SRR->RR_Tipo3	:= cTipo
				msunlock()
			endif
		endif
	endif
next nx

//����������������������������������������������Ŀ
//�Retorna a area dos itens de ferias e rescisoes�
//������������������������������������������������
restarea(aAreaSRR)

Return( NIL )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fProvRes	�Autor  �Ricardo Duarte Costa� Data �  23/09/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajusta os valores do movimento mensal para o calculo da    ���
���          � Rescisao.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Sigagpe                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
static function fProvRes(cCodigos,cTipo,lBusPen131)

Local aAux		:= aClone(aPd)	// Salvo o aPd para ajustar as verbas que serao consideradas.
Local cCodAux	:= aCodFol[106,1]+","+aCodFol[107,1]+","+aCodFol[010,1]+","+aCodFol[012,1] // Base ir mes ant / ir mes ant / Base ir Adt / Ir Adt
Local cTipo2	:= "K*V*I"		// Indica o Status "K" (Ferias) para recalcular o ir de ferias na rescisao
								// quando a matricula corrente tiver movimento de ferias no mes.
								// "V" sao as verbas que vieram do fechamento - "I" sao as verbas que foram informadas pelo usuario
Local cTipo13	:= "S*I"		// Indica o Status "S" (Segunda parcela do 13o salario) para recalcular o ir de 13o salario.
Local lIncFerias:= .F.
Local lInc13oSal:= .F.
Local nElement	:= 0			// Variavel utilizada para loop
Local nPos		:= 0			// variavel de posicionamento de array
Local nPos1		:= 0			// variavel de posicionamento de array
Local nx		:= 0			// Variavel utilizada para loop

aPd			:= {}
nElement	:= len(aAux)

//��������������������������������������������������������������Ŀ
//�Ajusto o aPd deixando somente as verbas nao excluidas.		 �
//����������������������������������������������������������������
For nx := 1 to nElement
	If aAux[nx,9] <> "D" .or. aAux[nx,1] == aCodFol[065,1] .or. aAux[nx,7] == "S"   // .or. aAux[nx,1] == aCodFol[318,1]
		//��������������������������������������Ŀ
		//�Tratamento do inss de ferias.		 �
		//����������������������������������������
		If aAux[nx,1] == aCodFol[065,1]
			aAux[nx,7] := "I"
			aAux[nx,9] := " "
		endif
		//��������������������������������������Ŀ
		//�Tratamento da base de ir 13o salario	 �
		//����������������������������������������
		If aAux[nx,1] == aCodFol[027,1]
			aAux[nx,9] := " "
		endif
		//��������������������������������������Ŀ
		//�Preserva Id 318 p/salario familia     �
		//����������������������������������������
		//If aAux[nx,1] == aCodFol[318,1] 
		//	aAux[nx,9] := " "
		//Endif
		aAdd(aPd,aClone(aAux[nx]))
	endif

next nx

aAux		:= aClone(aPd)
aPd			:= {}
nElement	:= len(aAux)

//����������������������������������������������Ŀ
//�Preparacao do array para processamento.		 �
//������������������������������������������������
for nx := 1 to nElement
	If !(aAux[nx,1] $aCodFol[010,1]+","+aCodFol[016,1]+","+aCodFol[027,1] ) .and. !(aAux[nx,7] == "V") 
		aAux[nx,9]	:= "D"
	endif
next nx

If cTipo == "FOL"
	//����������������������������������������������Ŀ
	//�Pesquisa se a verba de base de ir do Adto     �
	//�esta no mesmo mes de pagamento que a rescisao �
	//�corrente que esta sendo processada.           �
	//������������������������������������������������
	If (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[010,1] .and. X[9] <> "D"} )) > 0
		aAux[nPos,9]	:= "D"
		if mesano(dData_pgto) == mesano(aAux[nPos,10])
			for nx := 1 to nElement
				//����������������������������������������������������������������������������Ŀ
				//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
				//������������������������������������������������������������������������������
				If aAux[nx,1] $cCodAux
					aAux[nx,9] := " "
				endif
			next nx
		endif
	//����������������������������������������������Ŀ
	//�Pesquisa se a verba de base de ir do mes ante-�
	//�rior quando nao encontrar a base de ir do adto�
	//������������������������������������������������
	elseIf (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[106,1] .and. X[9] <> "D"} )) > 0
		aAux[nPos,9]	:= "D"
		if mesano(dData_pgto) == mesano(aAux[nPos,10])
			for nx := 1 to nElement
				//����������������������������������������������������������������������������Ŀ
				//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
				//������������������������������������������������������������������������������
				If aAux[nx,1] $cCodAux
					aAux[nx,9] := " "
				endif
			next nx
		endif
	endif
endif

If cTipo == "FER"
	//����������������������������������������������Ŀ
	//�Pesquisa se as verbas de ferias estao no mesmo�
	//�mes de pagamento que a rescisao corrente que  �
	//�esta sendo processada.						 �
	//������������������������������������������������
	If (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[016,1] .and. X[9] <> "D"} )) > 0
		aAux[nPos,9]	:= "D"
		if ( lIncFerias := mesano(dData_pgto) == mesano(aAux[nPos,10]) ) // indica que as ferias estao no mesmo mes/ano de pagamento da rescisao
			for nx := 1 to nElement
				//����������������������������������������������������������������������������Ŀ
				//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
				//������������������������������������������������������������������������������
				If aAux[nx,7] $cTipo2 .and. ! (aAux[nx,1] $cCodigos)
					aAux[nx,9] := " "
				endif
			next nx
		//��������������������������������������Ŀ
		//�Tratamento do inss de ferias.		 �
		//����������������������������������������
		elseif (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[065,1] .and. X[7] $cTipo2 } )) > 0
			aAux[nPos,1] := aCodFol[289,1]
			aAux[nPos,9] := " "
			if (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[013,1] .and. X[7] $cTipo2 } )) > 0
				aAux[nPos,1] := aCodFol[288,1]
				aAux[nPos,7] := "I"
				aAux[nPos,9] := " "
			endif
		endif
	//��������������������������������������Ŀ
	//�Tratamento do inss de ferias.		 �
	//����������������������������������������
	elseif (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[065,1] .and. X[7] $cTipo2 } )) > 0
		aAux[nPos,1] := aCodFol[289,1]
		aAux[nPos,9] := " "
		if (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[013,1] .and. X[7] $cTipo2 } )) > 0
			aAux[nPos,1] := aCodFol[288,1]
			aAux[nPos,7] := "I"
			aAux[nPos,9] := " "
		endif
	endif
endif

If cTipo == "132"
	//����������������������������������������������Ŀ
	//�Pesquisa se as verbas de 13o salario estao no �
	//�mesmo mes de pagamento que a rescisao corrente�
	//�que esta sendo processada.					 �
	//������������������������������������������������
	If (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[027,1] .and. X[9] <> "D"} )) > 0
		aAux[nPos,9]	:= "D"
		If mesano(dData_pgto) == mesano(aAux[nPos,10])			// indica que o 13o salario esta no mesmo mes/ano de pagamento da rescisao
			If ( lInc13oSal := aAux[nPos,10] <= dData_Pgto )	// indica que o 13o salario foi pago depois da recisao
				for nx := 1 to nElement
					//����������������������������������������������������������������������������Ŀ
					//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
					//������������������������������������������������������������������������������
					If aAux[nx,7] $cTipo13 .and. ! (aAux[nx,1] $cCodigos)
						aAux[nx,9] := " "
					endif
				next nx
			//��������������������������������������Ŀ
			//�Tratamento do inss de 13o salario	 �
			//����������������������������������������
			elseif (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[070,1] .and. X[7] $cTipo13 } )) > 0
				aAux[nPos,1] := aCodFol[291,1]
				aAux[nPos,7] := "I"
				aAux[nPos,9] := " "
				if (nPos		:= aScan(aAux,{|X| X[1] == aCodFol[019,1] .and. X[7] $cTipo13 } )) > 0
					aAux[nPos,1] := aCodFol[290,1]
					aAux[nPos,7] := "I"
					aAux[nPos,9] := " "
				endif
			endif
		endif
	endif

	//��������������������������������������������������������������Ŀ
	//� Se tiver incluido somente o INSS no movimento de 13o salario �
	//� modifica a variavel para .F. para nao buscar a pensao alimen-�
	//� ticia da 1a. parcela do 13o salario.						 �
	//����������������������������������������������������������������
	If ! lInc13oSal
		lBusPen131	:= .F.
	endif

endif

//��������������������������������������������������������������Ŀ
//�Ajusto o aPd deixando somente as verbas que serao utilizadas. �
//����������������������������������������������������������������
for nx := 1 to nElement
	If	aAux[nx,9] <> "D" .or. ( aAux[nx,1] $cCodigos .and. ;
		IIF(lIncFerias .and. lInc13oSal,;
			.T.,;
			IIF(lIncFerias,;
				aAux[nx,7] $cTipo2,;
				IIF(lInc13oSal,;
					aAux[nx,7] $cTipo13,;
					.F.;
					);
				);
			))
		aAdd(aPd,aClone(aAux[nx]))
	endif
next nx

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fProv132	�Autor  �Ricardo Duarte Costa� Data �  29/09/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajusta os valores da rescisao para o calculo da 2a parcela ���
���          � do 13o salario.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Sigagpe                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
static function fProv132(cCodigos)

Local aAux		:= aClone(aPd)	// Salvo o aPd para ajustar as verbas que serao consideradas.
Local nElement	:= 0			// Variavel utilizada para loop
Local nx		:= 0			// Variavel utilizada para loop

aPd	:= {}
nElement	:= len(aAux)

//�������������������������������������������������������������Ŀ
//�Pesquisa se as verbas de 13o salario que estao na rescisao. 	�
//���������������������������������������������������������������
for nx := 1 to nElement
	//����������������������������������������������������������������������������Ŀ
	//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
	//������������������������������������������������������������������������������
	If PosSrv(aAux[nx,1],SRA->RA_FILIAL,"RV_REF13") == 'S'
		aAdd(aPd,aclone(aAux[nx]))
	endif
next nx

return








/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FMatriz  � Autor � Mauro                 � Data � 23.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao Para Adicionar Verbas na Matriz                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cCod       =  Codigo da Verba                              ���
���          � nValor     =  Valor da Verba                               ���
���          � nHoras     =  Horas da Verba  --   Opcional                ���
���          � cSem       =  Semana da Verba --   Opcional                ���
���          � cCct       =  Centro de Custo --   Opcional                ���
���          � cTip1      =  Tipo da Verba   --   Horas Dias Valor        ���
���          � cTip2      =  Origem da Verba --   Opcional                ���
���          � nPar       =  Parcela da Verba--   Opcional                ���
���          � cDel       =  se Deletada "D" --   Opcional                ���
���          � cMes       =  Data de Pagto da Verba                       ���
���          � lAltera    =  Altera os conteudos mesmo que Verba ja exista���
���          �               em aPD                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fMatrizx(uParam1,uParam2,uParam3,uParam4,uParam5,uParam6,uParam7,uParam8,uParam9,uParam10,uParam11,uParam12,uParam13,uParam14,uParam15,uParam16, uParam17)/*
Function fMatriz        (cCod   ,nValor ,nHoras ,cSem   ,cCct   ,cTip1  ,cTip2  ,nPar   ,cDel   ,dMes    ,lAltera ,cSeq    ,nQtdSem ,cItCt   ,cClCt   ,cNumID)*/

Local lTemItem
Local lTemClVl


Local cCod		:= uParam1
Local nValor	:= uParam2
Local nHoras 	:= If(uParam3 = Nil , 0.00 , uParam3)
Local cSem   	:= If(uParam4 = Nil , cSemana , uParam4)
Local cCct   	:= If(uParam5 = Nil , Sra->Ra_cc , uParam5)
Local cTip1  	:= If(uParam6 = Nil , "V" , uParam6)
Local cTip2  	:= If(uParam7 = Nil .Or. uParam7 = " ", "C" , uParam7)
Local nPar   	:= If(uParam8 = Nil , 0 , uParam8)
Local cDel   	:= If(uParam9 = Nil , " " , uParam9)
Local lAltera	:= If(uParam11 = Nil, .F. , uParam11)
Local cSeq 	    := If(uParam12 = Nil," ",uParam12)
Local nQtdSem   := If(uParam13 = Nil, 0, uParam13)
Local cItCt     := If(uParam14 = Nil , Sra->Ra_item , uParam14)
Local cClCt     := If(uParam15 = Nil , Sra->Ra_clvl , uParam15)
Local dMes 
Local lEmpres	:= If(uParam17 == Nil, .F., uParam17)


lTemEmpC  	:= SRK->( FieldPos( "RK_EMPCONS" ) # 0 )


DEFAULT uParam10 := Ctod("//")
DEFAULT uParam16 := ""


dMes  := uParam10
cNumID:= uParam16

If FindFunction("fXMatriz")
	fXMatriz(uParam1,uParam2,uParam3,uParam4,uParam5,uParam6,uParam7,uParam8,uParam9,uParam10,uParam11,uParam12,uParam13,uParam14,uParam15,uParam16)
	Return
Endif

// N�o grava Valor ou Hora negativa e nao grava Valor e hora simultaneamente nulos.
If cCod # Nil .And. cCod # "   " .And. nValor # Nil .And. ( nValor >= 0.00 ) .and. ( nHoras >= 0.00 )  .and.;
    !(Empty(nValor) .and. Empty(nHoras) )

	//--Verifica se a verba existe no cadastro de verbas e 
	//--Carrega na Matriz de Incidencias as Verbas
	If FIncide(cCod)
              
		nPos := Ascan(aPd, { |X| X[1] = cCod .And. X[3] = cSem .And. X[2] = cCct .And. x[11]= cSeq .and. x[13] = cItCt .and. x[14] = cClCt } )
		If nPos = 0
			Aadd(aPd,{cCod,cCct,cSem,nHoras,Round(nValor,2),cTip1,cTip2,nPar,cDel,dMes,cSeq,nQtdSem,cItCt,cClCt,cNumID, lEmpres})
		ElseIf (nPos # 0 .And. cDel # "D" .And. ( aPd[nPos,9] = "D" .OR. lAltera = .T. ) .And. aPd[nPos,7] # "I") .Or. aPd[nPos,9] == "D"
			aPd[nPos,5]  := Round(nValor,2)
			aPd[nPos,4]  := nHoras
			aPd[Npos,9]  := " "
			aPd[Npos,10] := dMes
			aPd[nPos,6]  := cTip1
			aPd[nPos,7]	 := cTip2      
			aPd[nPos,12] := nQtdSem
			//-- Tratamento para desconto do emprestimo consignado
			If (lTemEmpC , aPd[nPos,16] := lEmpres , )
		EndIf
	Endif	
EndIf
Return

User Function GENTYPE01(cCampo)

Return(Type(cCampo))