#INCLUDE "PROTHEUS.CH"
 
Static LIRMULTV		:= .F.
Static nOrdemMult	:= 0
Static aPdvMUV		:= {}
Static aPdMUV		:= {}
Static cRotMUV		:= ""
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
���Leandro Dr. �26/02/14�M12RH01  		 �Unificacao da folha.                      ���
���			   �		�001958			 �P12                                       ���
���Christiane V�30/01/15�PCDEF-12041     �Corre��o da leitura do per�odo atual      ���
���Renan Borges�03/08/15�TSUKD4          �Ajuste para calcular corretamente a segun-���
���			   �		�          		 �da parcela do 13� sal�rio, mesmo quando a ���
���			   �		�          		 �f�rmula de Multiplos v�nculos est� ativa. ���
���Renan Borges�13/11/15�TTFDLY          �Ajuste para que a restricao de matriculas ���
���			   �		�		   		 �ativas seja aplicavel p/ todos os roteiros���
���			   �		�		   		 �exceto rescisao.                          ���
���Raquel H    �14/01/16�TUDTZD          �Ajuste para n�o excluir verbas informadas ���
���			   �		�		   		 �mesmo que estas sejam de Ir.              ���
���Raquel H    �14/01/16�TUDYCE          �Ajuste na fun��o  fCarregaPd p/ considerar���
���			   �		�		   		 �roteiro na busca de dados na SRC.         ���
���Raquel H    �29/01/16�TUHLUS          �Ajuste na fun��o  fSomaCpf p/ considerar  ���
���			   �		�		   		 �se � verba informada ao checar dt ref e dt���
���			   �		�		   		 �pagamento.							    ���
���Raquel H    �04/03/16�TUKV34          �Ajuste ao calcular complemento de 13 para ���
���			   �		�		   		 �considerar o periodo da Folha.            ���
���Renan Borges�06/04/16�SEST            �Ajuste para quando n�o houver periodo ati-���
���			   �		�		   		 �vo para segunda matricula de multiplos vin���
���			   �		�		   		 �culos seja abortado e gerado Log, sem ge- ���
���			   �		�		   		 �rar error.log.                            ���
���Raquel H    �14/04/16�TUXOYU          �Ajuste para recalcular o INSS de Ferias   ���
���			   �		�		   		 �corretamente de acordo com os novos concei���
���			   �		�		   		 �tos da versao 12.                         ���
���Gustavo M.  �11/05/16�TVCIK9          �Ajuste para recalcular o INSS de Ferias   ���
���			   �		�		   		 �Mes Seguinte e Rescisao.				    ���
���Esther V.   �29/06/16�	  TVN825     �Ajustado filtro na SRA para realizar		���
���			   �        �				 � calculo correto de MULTV.				���
���Allyson M.  �27/07/16�TVQMO7          �Ajuste no calculo de IR p/ somente consi- ���
���			   �		�		   		 �derar os lan�amentos de cada v�nculo, ao  ���
���			   �		�		   		 �inv�s de considerar a base de IR de todos ���
���			   �		�		   		 �os v�nculos e nao recalcular as verbas de	���
���			   �		�		   		 �ferias se o MV_DINSSFM estiver com S ou R	���
��|Esther V.   |24/08/16|	  TVHHIO     |Ajuste para sempre manter a verba do tipo |��
��|			   |        |				 |I - Informada, despresando os valores     |��
��|			   |        |				 |calculados. Ajustado calculo do Sal.Fam.  |��
��|			   |        |				 |para pagar beneficio apenas para o vinculo|�� 
��|			   |        |				 |que possui dependentes declarados.		|��
��|C�cero Alves|06/10/16|TWE010		     |Ajuste para posicionar no funcion�rio cor-|��
��|			   |        |				 |reto alterando a vari�vel cFilMatCor		|��
��|Gabriel A.  |06/01/17|MRH-3705	     |Altera��o realizada para vincular o fonte |��
��|			   |        |				 |� Issue.                                  |��
���Allyson M.  �03/02/17�MRH-5876        �Inclusao do Id 1412 - Devolucao Inss p/que���
���			   � 		�                �seja feito o recalculo da verba na folha. ���
���Eduardo K.  �03/02/17�MPRIMESP-8939   �ajuste p/ validar se teto de INSS j� foi  ���
���			   � 		�                �atingido nas ferias antes da rescis�o,    ���
���Gabriel A.  �03/03/17�MRH-5253        �Ajuste no c�lculo de 132 para MULTV para  ���
���            �        �                �que n�o sejam geradas verbas de           ���
���            �        �                �adiantamento indevidamente.               ���
���Gabriel A.  �18/08/17�DRHPAG-4995     �Ajuste para que caso o teto do INSS seja  ���
���            �        �                �ultrapassado s� com o INSS de f�rias a    ���
���            �        �                �verba de INSS de folha seja seletada.     ���
������������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������� */
User Function MULTV(nProc)
Local aSRAArea	:= SRA->(GetArea())
Local aSRCArea	:= SRC->(GetArea())

Local aParametros	:= Array(7)

Local cAliasQry		:= "QUERYSRC"
Local cJoin			:= ""
Local cFilter		:= ""

Local nRecSRA		:= SRA->(Recno())
Local nQtdCPF		:= 0

Private cRet		:= " "
Private lRecalc13o	:= .T.		// Variavel que determina se esta no calculo da folha de dezembro recalculando o 13o salario
Private lUtiMultiV	:= .F.		// Variavel que determina se funcionario possui multiplo vinculo

Private lItemClVl   := SuperGetMv( "MV_ITMCLVL", .F., "2" ) $ "13"
Private lMUVFol		:= .F.
Private lRatIR		:= If( Type("P_RATIRMV") == "U", .T., P_RATIRMV)
Private lRatINSS	:= If( Type("P_RATINSMV") == "U", .F., P_RATINSMV)
Private nProc1 		:= 0  //Processamento para a Oas , sem rateio de valores para autonomos semanalistas

Private nAliqFMV  := 0
Private lTetoINSS := .F.

Private lDissMUV  := LDISSIDIO

DEFAULT nProc := 0

nProc1 := nProc

//��������������������������������������������������������������Ŀ
//� Testa se a deve executar o IRMULTV.							 �
//����������������������������������������������������������������
If !LIRMULTV .Or. nOrdemMult == 0
	If ( nOrdemMult	:= RetOrdem( "SRA" , "RA_CIC+RA_FILIAL+RA_MAT" , .T. ) ) <> 0
		LIRMULTV	:= .T.
	EndIf
	If !LIRMULTV
		Return cRet
	EndIf
EndIf

cFilter	:= "RA_CIC = '" + SRA->RA_CIC + "' AND "
cFilter := "%" + cFilter + " SRA.D_E_L_E_T_ = ' '" + "%"

BeginSql alias cAliasQry
	SELECT COUNT(*) TOTALREG
	FROM %table:SRA% SRA
	WHERE %exp:cFilter%
EndSql

//Se nao possuir multiplos vinculos ou nao existir calculo para os outros vinculos, abandona rotina
If (cAliasQry)->(!Eof())
	nQtdCPF := (cAliasQry)->TOTALREG
EndIf

SRA->(DbGoTo(nRecSRA))

(cAliasQry)->(DbCloseArea())

If nQtdCPF <= 0
	RestArea(aSRAArea)
	Return cRet
EndIf

//��������������������������������������������������������������Ŀ
//� Testa as variaveis para o cadastro de Formulas				 �
//����������������������������������������������������������������
If cTipoRot == "6" //132
	If Type("aTabIr13") == "U" .or. Len(aTabIr13) == 0
		Return cRet
	EndIf
Else
	If Type("aTabIr") == "U" .or. Len(aTabIr) == 0
		Return cRet
	EndIf
EndIf

If cTipoRot $ "1*9" //Folha
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 					 			  	 �
	//����������������������������������������������������������������
	aParametros[01]		:=	1					//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC			//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC			//	CPF Ate
	aParametros[04] 	:=	cSemana				//	Semana a Ser Calculada
	aParametros[05]		:=	dData_Pgto			//	Data de Pagamento
	aParametros[06] 	:=	If(cComp13=="S",1,2)//  Calc. Compl. 13o.  1=Sim/2=Nao
	aParametros[07]     :=	"CDEGHIJMPST"		//  Categorias a serem calculadas
ElseIf cTipoRot == "2" //Adiantamento
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 					 			  	 �
	//����������������������������������������������������������������
	aParametros[01]		:=	2					//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC			//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC			//	CPF Ate
	aParametros[04] 	:=	cSemana				//	Semana a Ser Calculada
	aParametros[05]		:=	dData_Pgto			//	Data de Pagamento
	aParametros[06] 	:=	1					//  Calc. Compl. 13o.  1=Sim/2=Nao
	aParametros[07]     :=	"CDEGHIJMPST"		//  Categorias a serem calculadas
ElseIf cTipoRot == "6" //132
	//��������������������������������������������������������������Ŀ
	//� Testa as variaveis que so existem quando esta executando o	 �
	//� calculo da diferenca de 13o salario no calculo padrao da	 �
	//� folha de pagamento.											 �
	//����������������������������������������������������������������
	If Type("lCompl132") == "U" .or. !lCompl132
		lRecalc13o	:= .F.
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 									 �
	//����������������������������������������������������������������
	aParametros[01]		:=	3								//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC						//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC						//	CPF Ate
	aParametros[04] 	:=	cSemana							//	Semana a Ser Calculada
	aParametros[05]		:=	dData_Pgto						//	Data de Pagamento
	aParametros[06] 	:=	2								//  Calc. Compl. 13o.  1=Sim/2=Nao
	aParametros[07]     :=	"CDEGHIJMPST"					//  Categorias a serem calculadas
ElseIf cTipoRot == "3" //Ferias
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 									 �
	//����������������������������������������������������������������
	aParametros[01]		:=	4								//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC						//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC						//	CPF Ate
	aParametros[04] 	:=	cSemana							//	Semana a Ser Calculada
	aParametros[05]		:=	M->RH_DTRECIB					//	Data de Pagamento
	aParametros[06] 	:=	2								//  Calc. Compl. 13o.  Sim/Nao
	aParametros[07]     :=	"CDEGHIJMPST"					//  Categorias a serem calculadas
ElseIf cTipoRot == "4" //Rescisao
	//��������������������������������������������������������������Ŀ
	//� Carregando as Perguntas 									 �
	//����������������������������������������������������������������
	aParametros[01]		:=	5								//	Calcular por 1-Folha  2-Adiantamento  3-13o Salario  4-Ferias  5-Rescisao
	aParametros[02]		:=	SRA->RA_CIC						//	CPF De
	aParametros[03] 	:=	SRA->RA_CIC						//	CPF Ate
	aParametros[04] 	:=	cSemana							//	Semana a Ser Calculada
	aParametros[05]		:=	M->RG_DATAHOM					//	Data de Pagamento
	aParametros[06] 	:=	2								//  Calc. Compl. 13o.  1=Sim/2=Nao
	aParametros[07]     :=	"CDEGHIJMPST"					//  Categorias a serem calculadas
EndIf

If SRA->RA_CATFUNC == "A" .AND. SRA->RA_TIPOPGT == "S" // //Processamento para a Oas , sem rateio de valores para autonomos semanalistas, Se For proc mensal nao executa
	nProc1:= 0
EndIf

cRotMUV := fGetCalcRot(cTipoRot)
lMUVFol := cTipoRot $ "1*9"

U_CalcMVProcessa(aParametros,@aPdOld,@aParProf,@aTarefas,@aSalProf,@aPd)

RestArea(aSRCArea)
RestArea(aSRAArea)

Return cRet

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o	 �CalcMVProcessa� Autor � Ricardo Duarte Costa	� Data � 24/08/04 ���
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
User Function CalcMVProcessa(aParametros,aParam1,aParam2,aParam3,aParam4,aParam5)

*------------------------------*
Local aAreaSra	:= {}	// Array para salvar o posicionamento do SRA - Cadastro de funcionarios
Local aAreaSrg	:= {}	// Array para salvar o posicionamento do SRG - Cabecalho de Rescisoes
Local aAreaSrh	:= {}	// Array para salvar o posicionamento do SRH - Cabecalho de Ferias
Local aBenef_	:= {}	// Array com as verbas dos beneficiarios de pensao alimenticia.
Local aBenef131	:= {}	// Array com as verbas dos beneficiarios de pensao alimenticia na 1a parcela do 13o salario
Local aCPF		:= {}	// Array em que ficam armazendas toadas as matriculas do CPF que esta sendo processado
Local axxx		:= {}	// Array auxiliar temporario
Local aPerAtual := {}
Local cFiltSRA := ""
Local cCodAux	:= ""	// variavel que contem os codigos da verbas de pensao alimenticia do adiantamento salarial para ajuste do calculo
Local cCodPenAdt:= ""	// variavel que contem o codigo da verba de provento de pensao alimenticia do adiantamento salarial
Local cCodPensao:= ""	// Verbas de pensao a recalcular
Local cCodRecalc:= ""	// Verbas a recalcular
Local cSemAxu	:= ""
Local cProcAnt	:= ""
Local cRotAnt	:= ""
Local cSemAnt	:= ""
Local cNomeArray:= ""	// Variavel auxiliar para o processamento da proporcionalizacao dos valores entre matriculas
Local cTipo2_	:= ""	// Determina o Status das verbas que podem ser excluidas antes do recalculo.
Local cTipoPen_	:= ""	// Determina o tipo de pensao alimenticia a ser calculada
Local cTipoSRZ	:= " "	// Variavel que define o tipo de registro do resumo que sera excluido.
Local lAutonomo := .F.	// Variavel para identificar se o tratamento de multiplos vinculos sera para autonomo ou nao
Local lProlabore:= .F.	// Variavel para identificar se o tratamento de multiplos vinculos sera para prolabore ou nao
Local lCondPen	:= ""	// Determina em qual matricula deverao ser carregadas as verbas de pensao alimenticia. Tem influencia no calculo de recisao.
Local lCont		:= .T.	// Variavel que trata o retorno da execucao do roteiro de calculo
Local lUltSAnt	:= .F.
Local nElement	:= 0	// variavel de looping
Local nPos		:= 0	// Variavel de posicionamento
Local nVezes	:= 0	// Determina o numero de vezes em que buscara as verbas de pensao alimenticia a ser recalculada
Local nX        := 0	// Variavel de looping
Local nH		:= 0	// Variavel de looping
Local nY        := 0	// Variavel de looping
Local nP		:= 0 
Local nz		:= 0	// Varivael de looping
Local z			:= 0	// Variavel de looping
Local nRet		:= 0	//Controle do ExecRot
Local lPrimVez	:= .F. // Variavel para controle de execucao de transferencia de valores entre Celetista e Autonomo/Prolabore
Local nCateg	:= 0	// Variavel de looping  		
Local aCateg	:= {}   // Controle das categorias a serem tratadas no Multiplo Vinculo
Local cNomePd	:= ""	// Variavel com o nome do array que armazena o aPdOld por funcionario
Local cRotAux	:= ""
Local aDisPdOld	:= {}	// Variavel que armazena o aPdOld do funcionario corrente
Local aSvTaref	:= {}	// Variavel de backup do array aTarefas
Local aSvPaPro	:= {}	// Variavel de backup do array aParProf
Local aSvSlPro	:= {}	// Variavel de backup do array aSalProf
Local aSaveMnemo:= {}
Local bFilSRA
Local cFilMatAtu:= ""
Local nInssPos  := 0 
Local nTetoInss := 0
Local nValInss  := 0
Local nI		:= 0
Local nAtiv		:= 0
Local nCont		:= 0

Local nInssAut	:= 0        	//Valor ja pago de INSS para autonomos
Local nBaseAut	:= 0         //Valor da base ja paga de Inss para autonomos
Local nRecInss	:= 0
Local nRecBase	:= 0
Local cBaseAut	:= aCodFol[013,1]+"/"+aCodFol[014,1]+'/'+aCodFol[221,1]+'/'+aCodFol[288,1]
Local cInssAut	:= aCodFol[064,1]+"/"+aCodFol[065,1]+'/'+aCodFol[289,1]
Local cAutQry	:= "'" + aCodFol[013,1] + "','" + aCodFol[014,1] + "','" + aCodFol[221,1] + "','" + aCodFol[288,1] + "','" + aCodFol[064,1] + "','" + aCodFol[065,1] + "','" + aCodFol[289,1] + "'"
Local nPosINSS  := 0
//��������������������������������������������������������������Ŀ
//� Define Variaveis Privadas do Programa						 �
//����������������������������������������������������������������
Private aPDTot 		:= {}	// matriz com todas as verbas de todos os funcionarios
Private aPdOut 		:= {}	// matriz com todas as verbas de todos os funcionarios
Private aPdCorrent	:= {}	// matriz com o calculo corrente processado para ferias e rescisao.
Private cCPFAnt		:= ""	// Variavel que guardara o CPF Anterior para comparacao.
Private cFilMatCor	:= ""	// Variavel que guardara a Filial e Matricula corrente no caso de calculo de ferias e rescisao.

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
If cTipoRot $ "1*9"    //Folha
	cCodRecalc	:= 'aCodFol[047,1]+","+aCodFol[043,1]+","+aCodFol[045,1]+","+aCodFol[066,1]+","+aCodFol[015,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[064,1]+","+aCodFol[167,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[100,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[101,1]+","+aCodFol[408,1]+","+aCodFol[437,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[034,1]+","+aCodFol[221,1]+","+aCodFol[225,1]+","+aCodFol[992,1]+","+aCodFol[993,1]+","'
	//Trata a devolucao Inss de Ferias caso ele exista e esteja cadastrado
	If( Len(aCodFol) >= 1412 .And. !Empty(aCodFol[1412,1]) )
		cCodRecalc	:= cCodRecalc + '+aCodFol[1412,1]+","'
	EndIf
	cTipoPen_	:= "FOL"
	cTipo2_		:= "CR"
	If !(cInssFM $ "S*R") 
		cTipo2_		+= "K"
		cCodRecalc		+= '+aCodFol[065,1]+","
	EndIf
ElseIf cTipoRot == "2"  //Adiantamento
	cCodRecalc	:= 'aCodFol[010,1]+","+aCodFol[012,1]+","+aCodFol[008,1]+","+aCodFol[408,1]+","+aCodFol[063,1]+","'
	cTipoPen_	:=	"ADI"
	cTipo2_		:= "A"
ElseIf cTipoRot == "6"   //13.Salario
	cCodRecalc	:= 'aCodFol[021,1]+","+aCodFol[026,1]+","+aCodFol[070,1]+","+aCodFol[071,1]+","+aCodFol[409,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[019,1]+","+aCodFol[020,1]+","+aCodFol[027,1]+","+aCodFol[169,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[994,1]+","+aCodFol[995,1]
	cTipoPen_	:=	"132"
	cTipo2_		:= "S"
ElseIf cTipoRot == "3"   //Ferias
	cCodRecalc	:= 'aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[065,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[104,1]+","+aCodFol[102,1]+","+aCodFol[067,1]+","+aCodFol[168,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[410,1]+","+aCodFol[016,1]+","+aCodFol[232,1]+","      
	cTipoPen_	:=	"FER"
	cTipo2_		:= "K"
ElseIf cTipoRot == "4"   //Rescisao
	cCodRecalc	:= 'aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[064,1]+","+aCodFol[066,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[408,1]+","+aCodFol[167,1]+","+aCodFol[100,1]+","+aCodFol[101,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[067,1]+","+aCodFol[070,1]+","+aCodFol[177,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[071,1]+","+aCodFol[019,1]+","+aCodFol[020,1]+","+aCodFol[169,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[409,1]+","+aCodFol[410,1]+","+aCodFol[126,1]+","+aCodFol[045,1]+","'
	cCodRecalc	:= cCodRecalc + '+aCodFol[015,1]+","+aCodFol[016,1]+","+aCodFol[027,1]+","+aCodFol[034,1]+","'
	cTipoPen_	:=	"FOL"
	cTipo2_		:= "R"
EndIf

//��������������������������������������������������������������Ŀ
//� Salvo a area dos arquivos de cabecalhos de ferias e rescisao.�
//����������������������������������������������������������������
aAreaSra	:= SRA->(GetArea())
cFiltSRA	:= SRA->(DbFilter()) //carrega filtro aplicado na SRA
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

aSaveMnemo	:= SaveMnemonicos() //Salva os mnemonicos utilizados no calculo da folha

DbSelectArea("SRD")
DbSetOrder(RetOrder("SRD","RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA"))

//�������������������������������������������������������������������������Ŀ
//� Altero a ordem do cadastro de funcionarios para RA_CIC+RA_FILIAL+RA_MAT �
//���������������������������������������������������������������������������
dbSelectArea( "SRA" )
SRA->(DbClearFilter()) //limpa filtro aplicado na SRA a fim de buscar funcionarios com MULTV
dbsetorder(nOrdemMult)
DbSeek(cCpfDe_,.T.)

Begin Sequence
	
	lPrimVez:= .F.
	While !SRA->(Eof()) .and. SRA->RA_CIC <= cCpfAte_
		
		//-- Guarda a filial e a matricula do funcion�rio
		cFilMatAtu		:= SRA->RA_FILIAL+SRA->RA_MAT
				
		//��������������������������������������������������������������Ŀ
		//� Carrego o array aCPF com todas as matriculas encontradas.	 �
		//����������������������������������������������������������������
		aCPFAll		:= {}
		If !(fVerCpf(SRA->RA_CIC,@aCPFAll,lAutonomo,lProlabore,@aCateg))
			Break
		EndIf

		For nCont := 1 To Len(aCPFAll)
			If aCPFAll[nCont, 4] != "4"
				nAtiv++
			EndIf
		Next nCont
			
		If nAtiv <= 1
			dbselectarea("SRA")
			dbskip()
			Loop
		EndIf
		
		lLoop:=.F.
		For nCateg:= 1 To Len(aCateg)   
		    aCPF	:= {}  
		    If Len(aCateg) > 1
			    If nCateg == 2  
			    	lPrimVez:= .T.
			    	Aeval(aCPFAll,{|x|IF( ( x[5]$'P/A' )	,aAdd(aCPF,x),Nil)})
			    Else                                                       
			    	Aeval(aCPFAll,{|x|IF( !(x[5]$'P/A')	,aAdd(aCPF,x),Nil)})
			    	If Len(aCPFAll) <> Len(aCPF)
			    		
			    		dbSelectArea('SRC')
			    		dbSetOrder(1)
			    		
			    		For nX:= 1 To Len(aCPFAll) 
			    			If (nPos:= aScan(aCPF, { |x| x[2] + x[3] == aCPFAll[nX][2] + aCPFAll [nx][3] })) > 0
			    				Loop
			    			EndIf
			    			
			    			For nY:=1 to Len(cInssAut) Step 4
				    		   	If SRC->(DbSeek(aCPFAll[nx][2]+aCPFAll[nx][3]+SubStr(cInssAut,ny,3))) 
				    		   	 	While SRC->( !Eof() .and. RC_FILIAL + RC_MAT + RC_PD == aCPFAll[nx][2]+aCPFAll[nx][3]+SubStr(cInssAut,ny,3) )
				    					nInssAut+= SRC->RC_VALOR
				    					nRecInss := SRC->(Recno())
					    				SRC->(dbSkip())
					    			EndDo
					    		EndIf
					     	Next		
				    		If nInssAut > 0
				    			For ny:=1 to Len(cBaseAut) Step 4 
				    				If SRC->(DbSeek(aCPFAll[nx][2]+aCPFAll[nx][3]+SubStr(cBaseAut,ny,3))) 
					    				While SRC->( !Eof() .and. RC_FILIAL + RC_MAT + RC_PD == aCPFAll[nx][2]+aCPFAll[nx][3]+SubStr(cBaseAut,ny,3) )
				    						nBaseAut+= SRC->RC_VALOR
				    						nRecBase := SRC->(Recno())
					    					SRC->(dbSkip())
					    		   		EndDo
					    		   	EndIf
					    		Next
			    		   	EndIf
			    		   	
			    		   	//Semanalistas - Procura verba no acumulado
			    		   	If aCPFAll[nX,14] == "S"
			    		   		If cTipoRot $ "1*9"
				    		   		cRotAux := If(aCPFAll[nX,5] $ "A*P" , fGetCalcRot("9"),fGetRotOrdinar())
				    		   	Else
				    		   		cRotAux := fGetCalcRot(cTipoRot)
				    		   	EndIf
			    		   		cAliasQry := GetNextAlias()
			    		   		
								cFilter	:= "RD_FILIAL = '" + aCPFAll[nx][2] + "' AND "
								cFilter += "RD_MAT = '" + aCPFAll[nx][2] + "' AND "
								cFilter += "RD_PROCES = '" + cProcesso + "' AND "
								cFilter += "RD_ROTEIR = '" + cRotAux + "' AND "
								cFilter += "RD_PERIODO = '" + cPeriodo + "' AND "
								cFilter += "RD_PD IN (" + cAutQry + ")"
								cFilter := "%" + cFilter + " AND SRD.D_E_L_E_T_ = ' '" + "%"
								
								BeginSql alias cAliasQry
									SELECT * 
									FROM %table:SRD% SRD
									WHERE %exp:cFilter%
								EndSql
								
			    		   	 	While (cAliasQry)->( !Eof() )
			    		   	 		If (cAliasQry)->RD_PD $ cInssAut
				    					nInssAut+= (cAliasQry)->RD_VALOR
				    				ElseIf (cAliasQry)->RD_PD $ cBaseAut
				    					nBaseAut+= (cAliasQry)->RD_VALOR
				    				EndIf
				    				(cAliasQry)->(dbSkip())
				    			EndDo
				    			
				    			If nInssAut == 0
				    				nBaseAut := 0
				    			EndIf
				    			
				    			(cAliasQry)->(DbCloseArea())
			    		   	EndIf	
			    		Next
			       	EndIf
			    EndIf
			Else
		 		aCPF:=aClone(aCPFAll)
		    EndIf
			
						
			//��������������������������������������������������������������Ŀ
			//� Testa a quantidade de matriculas encontradas para iniciar o	 �
			//� processamento.												 �
			//����������������������������������������������������������������
			If (nElement := Len(aCPF)  ) < 1
			   Loop
			EndIf
			
			//��������������������������������������������������������������Ŀ
			//� Carrega os beneficiarios para a primeira matricula processada�
			//� Quando For rescisao carrega conForme a matricula corrente.   �
			//����������������������������������������������������������������
			SRA->(dbSetOrder(nOrdemMult))
			If(cTipoRot $ "3*4",;
				SRA->(DbSeek(aCpf[1,1]+cFilMatCor)),;
				SRA->(DbSeek(aCpf[1,1]+aCpf[1,2]+aCpf[1,3]));
				)
	
			//�����������������������������������������������������������������Ŀ
			//� Determina para quais tipos de calculo deve buscar as verbas de	�
			//� alimenticia.													�
			//�������������������������������������������������������������������
			nVezes	:= 1
			If cTipoRot == "4"
				nVezes	:= 3
			EndIf
	
			//�����������������������������������������������������������������Ŀ
			//� Troca o conteudo de cTipoPen_ quando For um calculo de rescisao.�
			//�������������������������������������������������������������������
			For nz := 1 to nVezes
				If nVezes > 1
					If nz == 2
						cTipoPen_	:= "FER"
					ElseIf nz == 3
						cTipoPen_	:= "132"
					EndIf
				EndIf
				//��������������������������������������������������������������Ŀ
				//� Carrega os codigo das verbas de pensao para o recalculo.     �
				//����������������������������������������������������������������
				fBusCadBenef(@aBenef_,cTipoPen_,,.F.)
				For ny := 1 to Len(aBenef_)
					If !Empty(aBenef_[ny,1]) .and. aBenef_[ny,3] == 0 .and. aBenef_[ny,4] == 0
						cCodPensao	:= cCodPensao + aBenef_[ny,1] + ","
					EndIf
				Next ny
			Next nz
	        
			If U_GENTYPE01("aInssOut") == "A" .And. Len(aInssOut) > 0 .And. aInssOut[1][5] <> SRA->RA_CIC
				aInssOut:= {}
			EndIf
			
			//Se for folha complementar - Exclui verba de compensa��o de IR se houver, pois ser� gerada novamente considerando o MULTV
			If LCALCCOMPL .And. ( nPos := AScan(aPdCorrent,{ |X| X[1] == aCodFol[0659,1] } ) ) > 0
				aPdCorrent[nPos,9] := "D"
			EndIf
				
			//����������������������������������������������������������������Ŀ
			//� Inicia o processamento acumulando os valores de cada matricula �
			//� no array aPdTotal.											   �
			//������������������������������������������������������������������
			For z := 1 to Len(aCPF)
	
				//��������������������������������������������������������������Ŀ
				//� Posiciona no funcionario a ser calculado          	 	     �
				//����������������������������������������������������������������
				SRA->(dbSetOrder(nOrdemMult))
				SRA->(DbSeek(aCpf[z,1]+aCpf[z,2]+aCpf[z,3]))
	
				//��������������������������������������������������������������Ŀ
				//� Limpa os arrays para a proxima matricula a processar		 �
				//����������������������������������������������������������������
				SetMnemonicos(NIL,NIL,.T.,"aPd")				//aPd 		:= {}   // Limpa a matriz do src
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
				
				If nInssAut > 0
					If nRecInss > 0
						SRC->(DbGoTo(nRecInss))
					EndIf
					SRC->( FMatriz(aCodFol[289,1],nInssAut,RC_HORAS,aCpf[z,15],RC_CC,RC_TIPO1,RC_TIPO2,RC_PARCELA,"  ",dData_Pgto,,RC_SEQ,,RC_ITEM,RC_CLVL ) )
					nInssAut:= 0 
				EndIf
				If nBaseAut > 0
					If nRecBase > 0
						SRC->(DbGoTo(nRecBase))
					EndIf
			   		SRC->( FMatriz(aCodFol[288,1],nBaseAut,RC_HORAS,aCpf[z,15],RC_CC,RC_TIPO1,RC_TIPO2,RC_PARCELA,"  ",dData_Pgto,,RC_SEQ,,RC_ITEM,RC_CLVL ) )
					nBaseAut := 0
				EndIf
				
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
				
					fSomaCPF(@aCpf,z, @lPrimVez, (nCateg==2) )  
				Else
					//�������������������������������������������������������������������������������������Ŀ
					//� Ajusto a posicao 8 do array aCPF para indicar que este funcionario sera desprezado e�
					//� diminuo 01 na variavel nElement para indicar quantas matriculas serao processadas.  �
					//���������������������������������������������������������������������������������������
					aCpf[z,8]	:= .F.
					nElement	:= nElement - 1
				EndIf
			Next z
	
			//���������������������������������������������������������Ŀ
			//� Ordenamos o array aCPF						            �
			//� Ordem: Acumulado + CPF + Categoria +Filial + Matricula	�
			//�����������������������������������������������������������
			aSort( aCPF ,,, { |x,y| x[7]+x[1]+x[13]+x[2]+x[3] < y[7]+y[1]+y[13]+y[2]+y[3] } )

			//��������������������������������������������������������������Ŀ
			//� Carrega os valores totais para o array do calculo			 �
			//���������������������������������������������������������������� 
			lLoop:=.F.
			If Len(aPdTot) > 0 
	            //-- Garante que seja posicionado no primeiro vinculo NAO DESPREZADO
				If ! aCPF[1,8]
					For z:=1 to Len(aCPF)
					    If aCPF[z,8]
					    	SRA->(dbSetOrder(nOrdemMult)) 
			    			SRA->(DbSeek(aCpf[z,1]+aCpf[z,2]+aCpf[z,3]))   
			    			Exit
			    		EndIf
			    	Next z		
			    Else
			    	SRA->(dbSetOrder(nOrdemMult))
	    			SRA->(DbSeek(aCpf[1,1]+aCpf[1,2]+aCpf[1,3]))
			    EndIf

				aPd 	:= aClone(aPDTot)
	
			//���������������������������������������������������������������Ŀ
			//� Se nao tiver movimento mas tiver multiplos vinculos. Posiciona�
			//� na ultima matricula do CPF corrente e salta para  o   proximo �
			//� funcionario.												  �
			//�����������������������������������������������������������������
			ElseIf Len(aCpf) > 0
				aPd		:= {}
				aPdTot	:= {}
				If( Len(aCateg) == 1 )
					SRA->(dbSetOrder(nOrdemMult))
				  	SRA->(DbSeek(aCpf[Len(aCpf),1]+aCpf[Len(aCpf),2]+aCpf[Len(aCpf),3]))
					SRA->(DBSKIP())
				 	lLoop:=.T.
				 	Exit
				Else
					Loop
				EndIf	
			
			//��������������������������������������������������������������Ŀ
			//� Zera as variaveis de movimentos.							 �
			//����������������������������������������������������������������
			Else
				aPd		:= {}
				aPdTot	:= {} 
				IF( Len(aCateg) == 1 )
					SRA->(DBSKIP())
					lLoop:=.T.
					Exit
				Else
					Loop
				EndIf	
			EndIf
					
			//�������������������������������������������������������������������������������������Ŀ
			//� Posiciona no funcionario corrente para executar o calculo da rescisao e das ferias. �
			//���������������������������������������������������������������������������������������
			If cTipoRot $ "3*4"
				SRA->(dbSetOrder(nOrdemMult))
				SRA->(DbSeek(aCpf[1,1]+cFilMatCor))
			EndIf
			
			If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
				If GENTYPE01("aParProf") == "U"
					aSvPaPro := aClone( aParProf ) 
				EndIf
				aSvTaref	 := aClone( aTarefas )
				aSvSlPro	 := aClone( aSalProf )                                       
			EndIf
			
			lUtiMultiV	:= .T.
			
			cSvSetRot 		:= SetRotExec( cRot )
			cSvSetPer 		:= SetPeriodCalc( cPeriodo )
			
			If SRA->RA_PROCES  <> cProcesso
				aPerAtual := {}
				fGetPerAtual( @aPerAtual, xFilial("RCH", SRA->RA_FILIAL), SRA->RA_PROCES, If(SRA->RA_CATFUNC $ "A*P", fGetCalcRot("9"), fGetCalcRot("1")) ) 
				If !Empty(aPerAtual)
					cSvSetNumPago 	:= SetNumPgCalc( aPerAtual[1,2] )
				EndIf
			Else
				cSvSetNumPago 	:= SetNumPgCalc( cNumPag )
			EndIf		

			//Guarda conteudo para que seja carregado no roteiro MUV			
			aPdvMUV		:= aPdv
			aPdMUV		:= aPd
			
			If lMUVFol //Para o caso de multiplo vinculo com categoria diferente, se for autonomo deve executar o roteiro de autonomo.
				cRotMUV := If(SRA->RA_CATFUNC $ "A*P", fGetCalcRot("9"), fGetCalcRot("1"))
			EndIf

			If lDissidio .And. cTipoRot == "1" .And. aScan( aCPF, { |x| x[4] == "3" } ) > 0
				If ( nPos := aScan( aPdTot, { |X| x[1] == aCodFol[65,1] } ) ) > 0
					nDescTet := NoRound(aTInss[Len(aTInss),1] * aTInss[Len(aTInss),2], 2)
					If aPdTot[nPos, 5] >= nDescTet
						aPd[nPos, 5] := aPdTot[nPos, 5] := nDescTet
						cCodRecalc += '+aCodFol[65,1]+","'
					EndIf
				EndIf
			EndIf

			If lDissidio .And. cTipoRot == "6"
				aEval( aPd, { |x| If(x[1] $ (aCodfol[70,1] + "/" + aCodfol[19,1] + "/" + aCodfol[20,1] + "/" + aCodfol[169,1]), x[9] := "D", Nil) } )
			EndIf
			
			nRet := ExecRot( SRA->RA_FILIAL , "MUV" ) //Executa roteiro de multiplos vinculos para a matricula corrente
			
			If nRet < 0 .or. nRet == 2 //Retorna 2 quando calcculo eh abortado
				FINALCALC()
				Break
			EndIf
			
			//Executa Salalrio Familia para o outro vinculo para garantir geracao da verba.
			If 	Ascan(aPd,{|x| (x[1] == aCodFol[034,1])}) == 0
				For z := 1 to Len(aCpf)
					If Ascan(&("a"+aCpf[z,12]),{|x|  x[1] = aCodFol[034,1]}) > 0
						SRA->(dbSetOrder(nOrdemMult))
						SRA->(DbSeek(aCpf[z,1]+aCpf[z,2]+aCpf[z,3]))					
						SALFAM(ACODFOL,@NSAL_FAMI,"S")
					EndIf
				Next z
				SRA->(DbSeek(aCpf[1,1] + cFilMatAtu))
			EndIf

			If nProc1 == 1 .and. aCpf[1,5] == "A" //somente se For autonomo e optou pelo processamento, guardo totais na ApdOut
				aPdOut := aClone(aPd) 		
			EndIf 
			
			//����������������������������������������������������������������������Ŀ
			//�  as verba de pensao alimenticia da 1a parcela do 13o salario  		 �
			//� apos o calculo dos multiplos vinculos.								 �
			//������������������������������������������������������������������������
			If cTipoRot $ "4*6"
				//����������������������������������������������������Ŀ
				//�Apaga as verbas de pensao alimenticia da 1a parcela.�
				//������������������������������������������������������
				fBusCadBenef(@aBenef131,"131",,.F.)
				For nZ := 1 to Len(aBenef131)
					fDelPd(aBenef131[nz,1])
				Next nZ
			EndIf
			
			Begin Transaction  
			
				//��������������������������������������������������������������������Ŀ
				//� Salva o Array total para proporcionalizacao e gravacao dos valores �
				//����������������������������������������������������������������������
				aPdTot 	:= aClone(aPD)
	
				//��������������������������������������������������������������Ŀ
				//� Separa os Valores por Matricula e atualiza o aPd de cada uma �
				//� das matriculas calculadas.									 �
				//����������������������������������������������������������������   
			    
				If (nCateg==2) 
				    //-- Compoe base de INSS
				    If (nPos1:= Ascan(aPdTot,{|x| (x[9] <> 'D' .and. x[1]$aCodFol[064,1]+'/'+aCodFol[065,1]+'/'+aCodFol[070,1]) }))> 0 
				    	nValor := aPdTot[npos1,5] 
				    	If (nPos2:= Ascan(aPdTot,{|x| ( x[9] <> 'D' .and. x[1]$aCodFol[289,1]+'/'+aCodFol[291,1]) }))> 0 
				    	   	aPdTot[npos2,5] += nValor 
				       	EndIf   	
			       	EndIf 
			       	//-- Compoe base Salario Contribuicao INSS
			       	 If (nPos1:= Ascan(aPdTot,{|x| (x[9] <> 'D' .and. x[1]==acodfol[221,1]) }))> 0 
				    	nValor := aPdTot[npos1,5] 
				    	If (nPos2:= Ascan(aPdTot,{|x| ( x[9] <> 'D' .and. x[1]$aCodFol[288,1]+'/'+aCodFol[290,1]) }))> 0 
				    	   	aPdTot[npos2,5] += nValor 
				       	EndIf   	
			       	EndIf   					    	
				EndIf
		
				//-- Se recis�o, verifica se o teto do INSS j� foi atingido devido � f�rias no mesmo per�odo
				If cTipoRot == "4"
					nTetoInss := round(aTInss[4,1]*aTInss[4,2],2)
					For nI := 1 To Len(aCpf)
						If SRR->(DbSeek(aCpf[nI,2] + aCpf[nI,3] + "F"))
							While !SRR->(Eof()) .And. aCpf[nI,2] == SRR->RR_FILIAL .And. aCpf[nI,3] == SRR->RR_MAT .And. SRR->RR_TIPO3 == "F"
								If SRR->RR_PD == aCodfol[0065,1] .And. SRR->RR_PERIODO == AnoMes(M->RG_DATADEM)
									nValInss += SRR->RR_VALOR
									If nValInss == nTetoInss
										nInssPos := AScan(aPdTot ,{|X| X[1] == aCodfol[64,1] })
										aPdTot[nInssPos,9] := "D"
									EndIf
	  							EndIf
	  							SRR->(DbSkip())
	  						EndDo
	  					EndIf
      				Next nI
				EndIf
				
				//Caso o Inss j� tenha ultrapassado o teto apenas com o INSS de f�rias, deleta a verba do INSS de folha
				If lTetoINSS //lTetoINSS - Vari�vel alimentada no GPEXCIMP caso o teto do INSS j� tenha sido ultrapassado apenas com o INSS de f�rias
					nPosINSS := aScan(aPdCorrent,{ |X| X[1] == aCodFol[0064,1] } )
					If nPosINSS > 0
						aPdCorrent[nPosINSS,9] := "D"
					EndIf
				EndIf
				If cTipoRot == "3" .And. aScan( aPdTot, { |x| x[1] == aCodFol[397,1]  } ) > 0
					nVal65232 := 0
					aEval( aPdTot, { |x| If(x[1] $ aCodfol[65,1] + "/" + aCodfol[232,1], nVal65232 += x[5], Nil) } )
					aEval( aPd, { |x| If( x[1] == aCodfol[168,1], x[5] := nVal65232, Nil ) } )
					aEval( aPdTot, { |x| If( x[1] == aCodfol[168,1], x[5] := nVal65232, Nil ) } )
				EndIf				
				
				fProporc(aCpf,cCodRecalc,cCodPensao, aCPFALL, aCateg)
				
				cProcAnt := cProcesso
				cSemAnt	 := cNumPag
				cRotAnt	 := cRot
				lUltSAnt := lUltSemana
	
				//��������������������������������������������������������������Ŀ
				//� Inicia a gravacao dos calculos rateados por matricula		 �
				//����������������������������������������������������������������
				For z := 1 to Len(aCpf)

					//��������������������������������������������������������������Ŀ
					//� Filtro para as matriculas que participaram do movimento		 �
					//����������������������������������������������������������������
					If aCPF[z,8]
	
						//��������������������������������������������������������������Ŀ
						//� Posiciona no primeiro funcionario a ajustar					 �
						//����������������������������������������������������������������
						SRA->(dbSetOrder(nOrdemMult))
						SRA->(DbSeek(aCpf[z,1]+aCpf[z,2]+aCpf[z,3]))
						lUltSemana := aCpf[z,16]
						
						//�����������������������������������������������������������������������������������Ŀ
						//�Se estiver demitido ou nao foi acumulado nao atualizo nada pois nao posso modificar�
						//�os valores dessas matriculas.													  �
						//�������������������������������������������������������������������������������������
						If aCPF[z,4] == "5" .or. aCPF[z,7] == "2"
							Loop
						EndIf
						
						cProcesso := SRA->RA_PROCES
	    		   		If cTipoRot $ "1*9"
		    		   		cRotAux := If(aCPF[z,5] $ "A*P" , fGetCalcRot("9"),fGetRotOrdinar())
		    		   	Else
		    		   		cRotAux := fGetCalcRot(cTipoRot)
		    		   	EndIf
		    		   	cRot	 := cRotAux
						cNumPag	 := aCpf[z,15]
	                    
						//��������������������������������������������������������������Ŀ
						//� Atualiza o array que sera gravado para a matricula			 �
						//����������������������������������������������������������������
						cNomeArray	:= "a"+aCPF[z,12]
						aPd			:= aClone(&(cNomeArray))   
						
						For nP:=1 to Len(cCodPensao) Step 4
							If (nPos:= Ascan(aPdTot, { |X| X[1] == SubStr(cCodPensao,nP,3) .And. X[9] # "D" } )) > 0 .And. !( (nPos1:= Ascan(aPd, { |X| X[1] == SubStr(cCodPensao,nP,3) .And. X[9] # "D" } )) > 0 ) 
								AAdd(aPd,aPdTot[nPos])
							EndIf
						Next	
							
						//��������������������������������������������������������������Ŀ
						//� Rateio de centro de custo									 �
						//����������������������������������������������������������������
						fEncarCc()
						
						//��������������������������������������������������������������Ŀ
						//� Calcula o liquido atualizado.                            	 �
						//����������������������������������������������������������������
						//��������������������������������������������������������������Ŀ
						//� Folha de Pagamento											 �
						//����������������������������������������������������������������
						If cTipoRot $ "1*9"
							cSemAux := cSemana
							cSemana := aCpf[z,15]
							If !lRatIR
								aEval( aPd, { |x| If( x[1] $ (aCodFol[066,1]+"/"+aCodFol[015,1]+"/"+cCodPensao) .And. x[3] == cSemana .And. x[7] != "I", x[9] := "D", NIL ) } )
								fCIr(aCodFol,aTabIr,,dData_Pgto)
								FCalcPensao(aCodFol[64,1],aCodFol[66,1],,0,dData_Pgto)
								aEval( aPd, { |x| If( x[1] $ (aCodFol[066,1]+"/"+aCodFol[015,1]) .And. x[3] == cSemana .And. x[7] != "I", x[9] := "D", NIL ) } )
								fCIr(aCodFol,aTabIr,,dData_Pgto)
							EndIf
							fLiquido(aCodfol,aCodfol[47,1],nValArred,aCodfol[43,1],.T.,aCodFol[45,1],.T.)    
							cSemana := cSemAux
						//��������������������������������������������������������������Ŀ
						//� Adiantamento												 �
						//����������������������������������������������������������������
						ElseIf cTipoRot == "2"
	                        VAL_ADTO	:= 0
	                        IR_CALC		:= 0
							Aeval(aPd, { |X| VAL_ADTO += If(X[1]==aCodFol[007,1] .and. Semana == X[3],X[5],0) } )
							Aeval(aPd, { |X| IR_CALC  += If(X[1]==aCodFol[012,1] .and. Semana == X[3],X[5],0) } )
							CALCLIQ(VAL_ADTO,IR_CALC)
							If nValArrAd > 0
								CALC_ARRE(@VAL_LIQ,@nValArrAd,@VAL_ARRE)
							EndIf
							If VAL_ARRE > 0
								FGeraVerba(aCodfol[8,1],VAL_ARRE,0.00,SEMANA , ,"V","A",,,,.T.)
							Else
								fDelPd(aCodFol[008,1],semana)
							EndIf
						//��������������������������������������������������������������Ŀ
						//� Ferias Normais, Coletivas ou Programadas.					 �
						//����������������������������������������������������������������
						ElseIf cTipoRot == "3"
							nValProv := nValDesc := 0.00
							If !lRatIR
								aEval( aPd, { |x| If( x[1] $ (aCodFol[067,1]+"/"+aCodFol[016,1]+"/"+cCodPensao) .And. x[3] == cSemana .And. x[7] != "I", x[9] := "D", NIL ) } )
								fCIrFer(aCodFol,aTabIr,,,.T.,"F")
								FCalcPensao(aCodFol[65,1], aCodFol[67,1],, 0, GetMemVar("RH_DTRECIB"))
								aEval( aPd, { |x| If( x[1] $ (aCodFol[067,1]+"/"+aCodFol[016,1]) .And. x[3] == cSemana .And. x[7] != "I", x[9] := "D", NIL ) } )
								fCIrFer(aCodFol,aTabIr,,,.T.,"F")
							EndIf
							Aeval( aPd ,{ |X|  SomaInc(X,1,@nValProv, , , , , , ,aCodFol) })
							Aeval( aPd ,{ |X|  SomaInc(X,2,@nValDesc, , , , , , ,aCodFol) })
							fLiqFer()
						//��������������������������������������������������������������Ŀ
						//� Rescisoes normais ou coletivas								 �
						//����������������������������������������������������������������
						ElseIf cTipoRot == "4"
							//����������������������������������������������������Ŀ
							//�Apaga as verbas de pensao alimenticia da 1a parcela.�
							//������������������������������������������������������
							For nz := 1 to Len(aBenef131)
								fDelPd(aBenef131[nz,1])
							Next nz
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
							EndIf
							cSemAux := cSemana
							cSemana := aCpf[z,15]
							If !lRatIR
								aEval( aPd, { |x| If( x[1] $ (aCodFol[066,1]+"/"+aCodFol[015,1]+"/"+aCodFol[067,1]+"/"+aCodFol[016,1]+"/"+aCodFol[071,1]+"/"+aCodFol[027,1]+"/"+cCodPensao) .And. x[3] == cSemana .And. x[7] != "I", x[9] := "D", NIL ) } )
								fCIr(aCodFol,aTabIr,"R",GetMemVar("RG_DATAHOM"))
								fCIrFer(aCodFol,aTabIr,.T.,GetMemVar("RG_DATAHOM"))
								CargaIR(@aTabIr13, MesAno(GetMemVar("RG_DATAHOM")) )
								fCIr13o(aCodFol,aTabIr13,,,NIR13P)
								fCalcPensao(aCodfol[64,1] , aCodFol[66,1] , aCodFol[56,1] , 0 , GetMemVar("RG_DATAHOM") ," ")
								aEval( aPd, { |x| If( x[1] $ (aCodFol[066,1]+"/"+aCodFol[015,1]+"/"+aCodFol[067,1]+"/"+aCodFol[016,1]+"/"+aCodFol[071,1]+"/"+aCodFol[027,1]) .And. x[3] == cSemana .And. x[7] != "I", x[9] := "D", NIL ) } )
								fCIr(aCodFol,aTabIr,"R",GetMemVar("RG_DATAHOM"))
								fCIrFer(aCodFol,aTabIr,.T.,GetMemVar("RG_DATAHOM"))
								fCIr13o(aCodFol,aTabIr13,,,NIR13P)								
							EndIf
							nObrig	:= fLiquido(aCodfol,aCodFol[126,1],0,"",.T.,aCodFol[045,1],.T.,.F.)
							nLiq	:= nLiquido - nObrig
							IF(nMulta > 0.00 .and. nLiq > 0.00,fGeraVerba(aCodfol[177,1],Min(nLiq,nMulta)),'' )
							fLiquido(aCodfol,aCodFol[126,1],0,"",.T.,aCodFol[045,1],.T.,.T.,.T.)
							cSemana := cSemAux
						//��������������������������������������������������������������Ŀ
						//� 13o salario - 2a parcela.									 �
						//����������������������������������������������������������������
						ElseIf cTipoRot == "6"
							//����������������������������������������������������Ŀ
							//�Apaga as verbas de pensao alimenticia da 1a parcela.�
							//������������������������������������������������������
							For nz := 1 to Len(aBenef131)
								fDelPd(aBenef131[nz,1])
							Next nz
							cSemAux := cSemana
							cSemana := aCpf[z,15]
							If !lRatIR
								aEval( aPd, { |x| If( x[1] $ (aCodFol[071,1]+"/"+aCodFol[027,1]+"/"+aCodfol[30,1]+"/"+aCodfol[994,1]+"/"+aCodfol[995,1]+"/"+cCodPensao) .And. x[3] == cSemana .And. x[7] != "I", x[9] := "D", NIL ) } )
								fCIr13o(aCodFol,aTabIr13,,.F.)
								FCalcPensao(aCodFol[70,1], aCodFol[71,1], , 0, dData_Pgto)
								aEval( aPd, { |x| If( x[1] $ (aCodFol[071,1]+"/"+aCodFol[027,1]) .And. x[3] == cSemana .And. x[7] != "I", x[9] := "D", NIL ) } )
								fCIr13o(aCodFol,aTabIr13,,.F.)
							EndIf
							fLiquido(aCodfol,aCodfol[21,1],nValArred,aCodfol[26,1],.T.,aCodfol[30,1],.F.)
							cSemana := cSemAux
						EndIf
	
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
						If cTipoRot $ "1*9"
							If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
								If IsInCallStack("GP690CAL")
									aPdOld		:= aClone( aDisPdOld )
								EndIf
								aPdCorrent	:= aClone(aPd)
								If Len(aCpf) > 1
									Aeval( aPD , { |X| Gravafol(X) } )
								EndIf
							Else
								If IsInCallStack("GP690CAL")
									cNomePd	:= "p"+aCPF[z,12]
									aPdOld	:= aClone(&(cNomePd))
									Gravafol()
								Else
									If SRA->RA_FILIAL + SRA->RA_MAT <> aCpf[z,2]+aCpf[z,3]
										SRA->(dbSetOrder(nOrdemMult))
										SRA->(DbSeek(aCpf[z,2]+aCpf[z,3]))
									EndIf
									cSemAux := cSemana
									cSemana := aCpf[z,15]
									Aeval( aPD , { |X| Gravafol(X) } )
									cSemana := cSemAux
								EndIf
							EndIf
						//��������������������������������������������������������������Ŀ
						//� Adiantamento												 �
						//����������������������������������������������������������������
						ElseIf cTipoRot == "2"
							If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
								aPdCorrent	:= aClone(aPd)
							Else
								cSemAux := cSemana
								cSemana := aCpf[z,15]
								Aeval( aPD , { |X| GravaAdt(X) } )
								cSemana := cSemAux
							EndIf
						//��������������������������������������������������������������Ŀ
						//� Ferias Normais, Coletivas ou Programadas.					 �
						//����������������������������������������������������������������
						ElseIf cTipoRot == "3"
							If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
								aPdCorrent	:= aClone(aPd)
							Else
								GravaSRR(aCpf,z,&(cCodRecalc)+cCodPensao,"F")
							EndIf
						//��������������������������������������������������������������Ŀ
						//� Rescisoes normais ou coletivas								 �
						//����������������������������������������������������������������
						ElseIf cTipoRot == "4"
							If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
								aPdCorrent	:= aClone(aPd)
							Else
								GravaSRR(aCpf,z,&(cCodRecalc)+cCodPensao,"R")
							EndIf
						//��������������������������������������������������������������Ŀ
						//� 13o Salario - 2a Parcela									 �
						//����������������������������������������������������������������
						ElseIf cTipoRot == "6"
							//��������������������������������������������������������������Ŀ
							//� Se For recalculo do 13o salario limpa as verbas excluidas.	 �
							//����������������������������������������������������������������
							If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
								If lRecalc13o
									axxx := aClone(aPd)
									aPd  := {}
									For nz := 1 to Len(axxx)
										If axxx[nz,9] <> "D"
											aadd(aPd,aClone(axxx[nz]))
										EndIf
									Next nz
								EndIf
								//��������������������������������������������������������������Ŀ
								//� Atualizo o array apdcorrent quando a matricula processada For�
								//� a matricula corrente.										 �
								//����������������������������������������������������������������
								aPdCorrent	:= aClone(aPd)
							Else
								//��������������������������������������������������������������Ŀ
								//� Se nao For o recalculo do 13o salario na folha de pagamento. �
								//� grava o novo calculo do 13o salario.						 �
								//����������������������������������������������������������������
								If IsInCallStack("GP690CAL")
									cNomePd	:= "p"+aCPF[z,12]
									aPdOld	:= aClone(&(cNomePd))
									Grava132()
								Else
									If ! lRecalc13o
										Aeval ( aPD , { |X| Grava132(X) } )
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				Next z
				
				cProcesso := cProcAnt
				cNumPag	  := cSemAnt
				cRot	  := cRotAnt
				lUltSemana:= lUltSAnt
	
			End Transaction                
        
       Next nCateg
        
        If lLoop
        	lLoop:= .F.
           	Loop
        EndIf  
        
		//��������������������������������������������������������������Ŀ
		//� Limpa os arrays criados para armazenar os valores parciais	 �
		//� das matriculas processadas.									 �
		//����������������������������������������������������������������
		For z := 1 to Len(aCpf)
			cNomeArray		:= "a"+aCPF[z,12]
			&(cNomeArray)	:= Nil                  
				cNomePd			:= "p"+aCPF[z,12]
			&(cNomePd)		:= Nil
		Next z


       	//��������������������������������������������������������������Ŀ
		//� Apos o processamento, deleta o registro de "OK", indicando   |
		//| que devera ser gerado um novo SRZ.							 |
		//����������������������������������������������������������������
		If cTipoRot == "6" .and. !lRecalc13o
			cTipoSRZ	:= 2
		Else
			cTipoSRZ	:= 1
		EndIf
		fDelRegSRZ(cTipoSRZ,SRA->RA_TPCONTR)
       
		//��������������������������������������������������������������Ŀ
		//� Posiciona na ultima matricula do mesmo CPF para continuar o	 �
		//� processamento.												 �
		//����������������������������������������������������������������
		dbSelectArea( "SRA" )
		If Len(aCpfALL) > 0
			aSort( aCPFALL ,,, { |x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )
			SRA->(DbSetOrder(nOrdemMult))
			SRA->(DbSeek(aCpfALL[Len(aCpfALL),1]+aCpfALL[Len(aCpfALL),2]+aCpfALL[Len(aCpfALL),3]))
		EndIf
		
		SRA->(DBSKIP()) 
		
	EndDo
	
End Sequence  

//��������������������������������������������������������������Ŀ
//� Retorna o Indice Padrao e o posicionamento dos arquivos		 �
//� de funcionarios, cabecalho de ferias e rescisoes			 �
//����������������������������������������������������������������
dbSelectArea("SRA")
If !(Empty(cFiltSRA))
	bFiltSRA := { || &(cFiltSRA) }
	SRA->(DbSetfilter( bFiltSRA, cFiltSRA )) //inclui filtro para retornar para GPEM060
EndIf
RestArea(aAreaSRA)
dbselectarea("SRG")
RestArea(aAreaSRG)
dbselectarea("SRH")
RestArea(aAreaSRH)

RestoreMnemonicos( aSaveMnemo ) //Restaura os mnemonicos originais

//��������������������������������������������������������������Ŀ
//� Retorna o array corrente recalculado para que a rotina		 �
//� termine de gravar o calculo da matricula corrente.			 �
//����������������������������������������������������������������
If lDissidio	
	aParam1	:= aClone( aDisPdOld )
EndIf

If !Type("aParProf") == "U"
	aParam2	:= aClone( aSvPaPro )	
EndIf

aParam3	:= aClone( aSvTaref )
aParam4	:= If (Len(aCpf) > 0 .and. !Empty( aSvSlPro ), aClone( aSvSlPro ), aSalProf)
aParam5	:= aClone( aPdCorrent )

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

If IsInCallStack("GP690CAL")
	GravaDissidio(aPd,aPdOld,,aCodFol)
Else
	If aX[3] == cSemana
		IF aX[1] $ aCodFol[043,1]+"/"+aCodFol[044,1]+"/"+aCodFol[047,1]
			cCTC:= Posicione("SRA",1,SRA->RA_FILIAL + SRA->RA_MAT,"SRA->RA_CC")
		Else
			cCTC:= aX[2]
		EndIf	
		GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aX[1],If(!Empty(aX[10]),aX[10],dData_Pgto),cCTC,;
				If(Empty(aX[3]),cSemana,aX[3] ),aX[6],aX[7],aX[4],aX[5],aX[8],aX[9],,aX[11],aX[12],aX[13],aX[14],If(Len(aX)>= 17,aX[17],''),aX[20],aX[21],aX[15])
	EndIf
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
Static Function fVerCpf(cCpfAnt,aCPF,lAutonomo,lProlabore, aCateg)

Local aArea		:= GetArea()
Local aAreaRCH	:= RCH->(GetArea())
Local aPerAtual	:= {}
Local cSitFolha	:= ""
Local cTestaCat	:= ""
Local lCont		:= .T.
Local lUltSem	:= .T.
Local cCategAnt	:= SRA->RA_CATEG
Local cFilFunc	:= ""
Local cMatFunc	:= ""
Local cRotAux	:= ""
Local cSemAux	:= ""
Local cSemAux2	:= ""
Local cPerCalc	:= ""

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
	cSitFolha := fBuscaSituacao(SRA->RA_FILIAL,SRA->RA_MAT,dDataDe)

	//��������������������������������������������������������������Ŀ
	//� Consiste CPF nao inFormado ou branco. Nao serao processados. �
	//����������������������������������������������������������������
	If Empty(cCpfAnt) .or. cCpfAnt = nil
		dbSelectArea("SRA")
		Return
	EndIf 
	
	//��������������������������������������������������������������Ŀ
	//� Desconsidera Estagiario(Mensalista/Horista)        			 �
	//����������������������������������������������������������������
	If (SRA->RA_CATFUNC $'EG')
		SRA->(DbSkip())      
		Loop
	EndIf
	
	//�����������������������������������������������������������������������������������������������Ŀ
	//� Consiste a Mudanca da CPF. Se mudou encerra o loop e passa para o processamento dos calculos. �
	//�������������������������������������������������������������������������������������������������
	If (cCpfAnt == SRA->RA_CIC) 

		//��������������������������������������������������������������Ŀ
		//� Verifica a categoria que esta sendo processada. Se For autono�
		//� mo, nao verifica a categoria. Se For prolabore, so incluira  �
		//� matriculas de autonomos e\ou prolabores						 �
		//����������������������������������������������������������������
		If !lAutonomo
			If !( &(cTestaCat) ) 
				dbSelectArea("SRA")
				dbSkip()
				Loop
			EndIf    
		EndIf	
		
		//��������������������������������������������������������������Ŀ
		//� Autonomo categoria 15 so pode ter tratamento de multiplos    �
		//� vinculos com categoria 15 (freteiro), devido ter base de INSS�
		//� e IRF reduzida                                               �
		//����������������������������������������������������������������
 	   If (cCategAnt == "15" .and. SRA->RA_CATEG <> "15") .or. (cCategAnt <> "15" .and. SRA->RA_CATEG == "15")
	   		dbSelectArea("SRA")
			dbSkip()
			Loop
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� N�o deve calcular folha para funcion�rios demitidos em meses �
		//� anteriores � data base. 									 �
		//����������������������������������������������������������������
		dbSelectArea( "SRG" )
		If DbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			If cSitFolha == "D"
				while SRG->( ! Eof() ) .and. SRG->RG_FILIAL == SRA->RA_FILIAL .and. SRG->RG_MAT == SRA->RA_MAT
					//��������������������������������������������������������������������������Ŀ
					//� A Data da Geracao pode ser diferente da Data Base, mas se o Mes e Ano da �
					//� Data de Demissao do funcionario For IGUAL ao Mes e Ano ABERTO (cAnoMes), �
					//� este funcionario DEVE entrar na folha, pois caracteriza uma demissao	 �
					//� "programada" para o mes/ano aberto com data de gravacao anterior a mesma.�
					//����������������������������������������������������������������������������
					If MesAno(SRG->RG_DTGERAR) # MesAno(dDataDe) .and. MesAno(SRG->RG_DATADEM) < cAnoMes
						If !DbSeek(SRA->RA_FILIAL + SRA->RA_MAT + cAnoMes)
							dbSelectArea( "SRA" )
							dbSkip()
							Loop
						EndIf
					EndIf
					SRG->( dbSkip() )
				EndDo
			EndIf
		EndIf
		
		//Verifica se possui transfer�ncia
		If cSitFolha == "D" .And. !Empty(SRA->RA_DEMISSA) .And. SRA->RA_DEMISSA < SToD(MesAno(dDataDe) + "01") 
			SRA->( DbSkip() )
			Loop
		EndIf

		dbSelectArea( "SRA" )

		//�������������������������������������������������������������������������Ŀ
		//� Retorna para o inicio desta funcao para revalidar a Situacao e CPF caso	�
		//� a Matricula do Funcionario tenha mudado no SRA ao validar a data de de-	�
		//� missao em meses anteriores conForme condicao acima. Este retorno eh		�
		//� necessario para funcionarios demitidos anteriormente, que voltaram a	�
		//� trabalhar na empresa e atualmente possuem multiplos vinculos, pois		� 
		//� estava "misturando"	os dados do funcionario com situacao de demitido na	�
		//� primeira passagem com os dados ATIVOS atualmente.						�
		//���������������������������������������������������������������������������
		If SRA->( RA_FILIAL + RA_MAT ) # cFilFunc + cMatFunc
			Loop
		EndIf
		
		aPerAtual 	:= {}
   		If cTipoRot $ "1*9"
	   		cRotAux := If(SRA->RA_CATFUNC $ "A*P" , fGetCalcRot("9"),fGetRotOrdinar())
	   	Else
	   		cRotAux := fGetCalcRot(cTipoRot)
	   	EndIf
	   	
	   	If cRotAux == fGetCalcRot("6") // Para roteiro 132		
			If lDissidio .Or. (P_CCOMP13 = 'S' .And. Month(dDataAte) == 12 .And. fComp13Fol()) 			
				cPerCalc	:= If(Empty(cPeriodo),GetPeriodCalc(),cPeriodo)
				cSemana 	:= If(Empty(cNumPag),GetNumPgCalc(),cNumPag)
				cSemAux		:= cSemana
			Else
				fGetPerAtual( @aPerAtual, xFilial("RCH", SRA->RA_FILIAL), SRA->RA_PROCES, cRotAux )
				If Len(aPerAtual) > 0
					cPerCalc := aPerAtual[1,1]
					cSemana  := cSemAux := aPerAtual[1,2] //Numero de pagamento atual
				Else
					CMSGLOG := FMSGFORM({}) + "O PERIODO '" + CPERIODO + "' N�O EST� ATIVO. SELECIONE UM PERIODO ATIVO PARA O C�LCULO. PROCESSO -> " + SRA->RA_PROCES + ". FILIAL -> " + SRA->RA_FILIAL
					ADDLOGEXECROT( CMSGLOG )
					FINALCALC()
					Return .F.
				EndIf
			EndIf	   	
	   	Else 		   	
			fGetPerAtual( @aPerAtual, xFilial("RCH", SRA->RA_FILIAL), SRA->RA_PROCES, cRotAux )
			If Len(aPerAtual) > 0
				cPerCalc	:= aPerAtual[1,1]
				cSemana	:= cSemAux 	:= aPerAtual[1,2] //Numero de pagamento atual
			Else
				CMSGLOG := FMSGFORM({}) + "O PERIODO '" + CPERIODO + "' N�O EST� ATIVO. SELECIONE UM PERIODO ATIVO PARA O C�LCULO. PROCESSO -> " + SRA->RA_PROCES + ". FILIAL -> " + SRA->RA_FILIAL
				ADDLOGEXECROT( CMSGLOG )
				FINALCALC()
				Return .F.
			EndIf 
		EndIf
		cSemAux2	:= cSemana		
				
		fCarPeriodo( cPerCalc , cRotAux , {} , @lUltSem , 0 , .F. )
		
		cSemana := cSemAux2

		If cSitFolha == "D" .And. AllTrim(SRA->RA_RESCRAI) $ '30/31' 
			cSitFolha := "T"
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
					If(SRA->RA_CATFUNC=="A", "1", "0" ),;		   //13 - Indica Categoria de Autonomo
					SRA->RA_TIPOPGT	,;	//14 - Tipo de Pagamento
					cSemAux,		;	//15 - Semana atual do funcionario
					lUltSem,		;	//16 - Indica se eh a ultima semana do periodo (usado para semanalistas)
					0.00,			;	//17 - Percentual de distribuicao de INSS sem considerar IR
					0.00			})	//18 - Percentual de distribuicao de INSS 13o sem considerar IR

		//-- Alimenta com as categorias identificadas
		If SRA->RA_CATFUNC $'P.A.'                        
			If Ascan(aCateg,{|x| SRA->RA_CATFUNC  $  x[2] } ) == 0
				aAdd(aCateg, {1,'P.A'} )
			EndIf	
		Else               
	    	If Ascan(aCateg,{|x| 'X'  $  x[2]  }) == 0
				aAdd(aCateg, {0,'X'} )  
			EndIf				
		EndIf					
	Else
		//��������������������������������������������������������������Ŀ
		//� Encerro o processamento do loop pois a proxima matricula nao �
		//� e do mesmo CPF a ser processado.             				 �
		//����������������������������������������������������������������
		lCont		:= .F.
		cCpfAnt		:= SRA->RA_CIC
		cCategAnt	:= SRA->RA_CATEG 
	EndIf
	SRA->(DBSKIP())
EndDo

//��������������������������������������������������������������Ŀ
//� Se tiver somente uma matricula no Array, zeramos o array pois�
//� nao deve haver processamento para somente uma matricula.	 �
//����������������������������������������������������������������
If Len(aCpf) <= 1
	aCPF	:= {}  
	aCateg	:= {}	
EndIf

 
//���������������������������������������������������������Ŀ
//� Ordena para Celetista serem processados antes dos demais�
//� vinculos.												�
//�����������������������������������������������������������
aSort( aCateg ,,, { |x,y| x[1] < y[1] } )

RestArea(aArea)
RestArea(aAreaRCH)

Return .T.

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
Static Function fSomaCPF(aCpf,n,lPrimVez, lSecond)

Local cCodBase	:= ""		// Codigo das verbas de base e inss normal
Local cCodigo	:= ""		// Variavel auxiliar para a troca do codigo das verbas de base e inss normais
Local cCodOut	:= ""		// Codigo das verbas de base e inss de outras empresas
Local cCodPesq	:= Space(3)	// Codigo da verba de base de ir que sera utilizada para determinar se deve 
							// ou nao somar esta matricula no movimento a ser recalculado.
Local nPos		:= 0		// variavel de loop
Local ny		:= 0		// variavel de loop
Local aAuxaPd	:= {} 

Local cNomeArray:= ''

//��������������������������������������������������������������Ŀ
//� Define a verba que sera pesquisada para comparar a data de 	 �
//� pagamento.													 �
//����������������������������������������������������������������
If cTipoRot $ "1*4*9"
//�����������������������������Ŀ
//�Folha de Pagamento e Rescisao�
//�������������������������������
	cCodPesq	:= aCodFol[015,1]+","+If( aCpf[n,4]=="5" , aCodFol[396,1] , aCodFol[016,1] )
	cCodBase	:= aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[064,1]+","+aCodFol[065,1]+","
	cCodOut		:= aCodFol[288,1]+","+aCodFol[289,1]
ElseIf cTipoRot == "2"
//�����������������������������Ŀ
//�Adiantamento					�
//�������������������������������
	cCodPesq	:= aCodFol[106,1]
	cCodBase	:= aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[064,1]+","
	cCodOut		:= aCodFol[288,1]+","+aCodFol[289,1]
ElseIf cTipoRot == "6"
//�����������������������������Ŀ
//�2a parcela do 13o salario	�
//�������������������������������
	cCodPesq	:= aCodFol[027,1]
	cCodBase	:= aCodFol[019,1]+","+aCodFol[020,1]+","+aCodFol[070,1]+","
	cCodOut		:= aCodFol[290,1]+","+aCodFol[291,1]
ElseIf cTipoRot == "3"
//�����������������������������Ŀ
//�Ferias						�
//�������������������������������
	// Quando a matricula estiver demitida uso outra verba de para base
	cCodPesq	:= If( aCpf[n,4]=="5" , aCodFol[396,1] , aCodFol[016,1] )
	cCodBase	:= aCodFol[013,1]+","+aCodFol[014,1]+","+aCodFol[065,1]+","
	cCodOut		:= aCodFol[288,1]+","+aCodFol[289,1]
EndIf

If aCPF[n,7] <> "2" // somente para funcionarios acumulados em APDTOT
	cNomeArray		:=  "a"+aCPF[n,12]
EndIf  

//������������������������������������������������������������������Ŀ
//� Quando For tratar o Prolabore/Autonomo e possuir mais de uma cate�
//� goria de vinculo, gera base outras.								 �
//��������������������������������������������������������������������      
If lSecond  .and. lPrimVez
	lPrimVez:= .F.
    For ny:= 1 To Len(aPdTot)
	    If !aPdTot[ny,1] $cCodBase
			 aPdTot[ny,9] := 'D'
		Else
			//������������������������������������������������������������������Ŀ
			//� Troco os codigos de inss normal para inss de outras empresas.	 �
			//��������������������������������������������������������������������
			If 	aPdTot[ny,1] == If(cTipoRot <> "6",aCodFol[013,1],aCodFol[019,1]) .or. ;
				aPdTot[ny,1] == If(cTipoRot <> "6",aCodFol[014,1],aCodFol[020,1])
				cCodigo	:= If(cTipoRot <> "6",aCodFol[288,1],aCodFol[290,1])
			Else
				cCodigo	:= If(cTipoRot <> "6",aCodFol[289,1],aCodFol[291,1])
			EndIf 
			aPdTot[ny,1]:=cCodigo
		EndIf	
	Next nY

	For nY:=1 To Len(aPdTot)
		If aPdTot[nY,09] <> "D"  
			cCodigo:= aPdTot[ny,1]
			If (nPos := aScan( aPdTot ,{ |x| x[1] == cCodigo.and. x[9] <> 'D' .and. cSemana == x[3]  .and. !(x[7] $"I,G") } ) ) > 0
				If nPos <> nY
					If aPdTot[nY,3] == cSemana
						aPdTot[nPos,5] := aPdTot[nPos,5] + aPdTot[ny,5] 
						aPdTot[ny,9] := 'D'	
					EndIf
				EndIf	
			EndIf
		EndIf
	Next nY

	aAux:= {}			
    Aeval(aPDTot,{|x| IF(x[9]<> 'D',aAdd(aAux,x),Nil) } )  
    aPdTot:=aClone(aAux)
EndIf

//��������������������������������������������������������������Ŀ
//� Verifica se existe a verba de de base de IR para o calculo   �
//� corrente.													 �
//����������������������������������������������������������������
If (nPos := aScan( aPd ,{ |x| x[1] $ cCodPesq } ) )  > 0
	//��������������������������������������������������������������Ŀ
	//� Verifica se o mes de pagamento e o mesmo para todas as matri-�
	//� culas. Se nao For,indica que esta matricula nao foi acumulada�
	//� no aPdTot. No calculo do adiantamento salarial nao incluira	 �
	//� quando estiver testando uma matricula ja demitida que teve a �
	//� sua data de homologacao posterior a data de pagto do Adto.	 �
	//����������������������������������������������������������������
	If ( aCPF[n,4] != "3" .And.  MesAno(aPd[nPos,10]) <> MesAno(dData_Pgto) .and. !Empty(aPd[nPos,10]) .and. !lDissidio .And. fFerLicMat() ) .or. ;
	   ( aPd[nPos,10] > dData_Pgto .and. cTipoRot == "2" .and. aCPF[n,4] == "5")
			aCPF[n,7]	:= "2"
	EndIf
Elseif !lDissidio
	aCPF[n,7]	:= "2"
EndIf

//��������������������������������������������������������������Ŀ
//� Somo ao array aPdTot todos os valores das verbas de todas as �
//� matriculas que estiverem sinalizadas para acumular.			 �
//����������������������������������������������������������������
For ny := 1 to Len(aPd)
	//��������������������������������������������������������������Ŀ
	//� Executo somente quando a matricula For acumulada.			 �
	//����������������������������������������������������������������
	If aCPF[n,7] <> "2"
		If (nPos := aScan( aPdTot ,{ |x| x[1] == aPd[ny,1] .and. X[9] <> 'D' .and. ( X[3] == cSemana .or. aCPF[n,14] == "S")  } ) )  > 0 .and. aPd[ny,9] <> 'D' .and. ( cSemana == aPd[ny,3] .or. aCPF[n,14] == "S" )
			If !(cInssFM $ "S*R" .And. aPd[ny,1] == aCodFol[065,1]) 
				aPdTot[nPos,4] := aPdTot[nPos,4] + aPd[ny,4]
			EndIf
			aPdTot[nPos,5] := aPdTot[nPos,5] + aPd[ny,5]
		ElseIf aPd[ny,9] <> "D"
			aAdd(aPdTot, aPd[nY])
			If aCPF[n,15] <> cSemana .and. aCpf[n,14] == "S"
				aPdTot[Len(aPdTot),3] := cSemana
			EndIf
		EndIf
	ElseIf cTipoRot <> "2"
	//������������������������������������������������������������������Ŀ
	//� Se a matricula nao For acumulada, fazemos o tratamento do INSS	 �
	//��������������������������������������������������������������������
		//������������������������������������������������������������������Ŀ
		//� Tratamento do INSS quando as datas de pagto estiverem diferentes �
		//� entre as matriculas do mesmo CPF. Busco os valores de inss ja	 �
		//� descontados e acumulo como Base e Inss de outras empresas.		 �
		//� Somente em casos de rescisao e quando nao tiver as verbas 288/289�
		//� inFormadas no movimento.										 �
		//��������������������������������������������������������������������
		//������������������������������������������������������������������Ŀ
		//� Codigos de Inss Outras Empresas									 �
		//��������������������������������������������������������������������
		If aPd[ny,1] $cCodOut
			//������������������������������������������������������������������Ŀ
			//� Ajusto os valores quando as verbas de inss de outras empresas nao�
			//� Foram inFormadas.												 �
			//��������������������������������������������������������������������
			If (nPos := aScan( aPdTot ,{ |x| x[1] == aPd[ny,1] .and. x[9] <> 'D' .and. ( cSemana == x[3] .or. aCPF[n,14] == "S" )  .and. x[7] $"I,G" } ) ) == 0
				If (nPos := aScan( aPdTot ,{ |x| x[1] == aPd[ny,1] .and. x[9] <> 'D' .and. ( cSemana == x[3] .or. aCPF[n,14] == "S" ) } ) ) > 0
					aPdTot[nPos,5] := aPdTot[nPos,5] + aPd[ny,5]
				Else
					aAdd(aPdTot, aPd[nY])
					aPdTot[Len(aPdTot),7] := If(cTipoRot=="6","S","C")
				EndIf
			EndIf
		//������������������������������������������������������������������Ŀ
		//� Codigos de Inss Normal											 �
		//��������������������������������������������������������������������
		ElseIf aPd[ny,1] $cCodBase
			//������������������������������������������������������������������Ŀ
			//� Troco os codigos de inss normal para inss de outras empresas.	 �
			//��������������������������������������������������������������������
			If 	aPd[ny,1] == If(cTipoRot <> "6",aCodFol[013,1],aCodFol[019,1]) .or. ;
				aPd[ny,1] == If(cTipoRot <> "6",aCodFol[014,1],aCodFol[020,1])
				cCodigo	:= If(cTipoRot <> "6",aCodFol[288,1],aCodFol[290,1])
			Else
				cCodigo	:= If(cTipoRot <> "6",aCodFol[289,1],aCodFol[291,1])
			EndIf
			//������������������������������������������������������������������Ŀ
			//� Ajusto os valores quando as verbas de inss de outras empresas nao�
			//� Foram inFormadas.												 �
			//��������������������������������������������������������������������
			If (nPos := aScan( aPdTot ,{ |x| x[1] == cCodigo .and. x[9] <> 'D' .and. ( cSemana == x[3] .or. aCPF[n,14] == "S" ) .and. x[7] $"I,G" } ) )  == 0
				If (nPos := aScan( aPdTot ,{ |x| x[1] == cCodigo .and. x[9] <> 'D' .and. ( cSemana == x[3] .or. aCPF[n,14] == "S" ) } ) ) > 0
					aPdTot[nPos,5] := aPdTot[nPos,5] + aPd[ny,5]
				Else
					aAdd(aPdTot, aPd[nY])
					aPdTot[Len(aPdTot),7] := If(cTipoRot=="6","S","C")
				EndIf
			EndIf
		EndIf
	EndIf
Next ny

Return nil

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
Static Function fProporc(aCpf,cCodRecalc,cCodPensao, aCPFALL, aCateg) 

Local aAux			:= {}		// array auxiliar para tratamento das verbas excluidas em aPdTot
Local aTroca		:= {}		// array que contem as verbas correspondentes para inss de folha e 13o salario.
Local cOrigem		:= {}
Local cCodPd		:= ""		// codigo da verba que esta sendo processada no loop
Local cCodBaseProp	:= if(	cTipoRot $ "1*4*9",;
							aCodFol[015,1],;
							If(	cTipoRot=="2",;
								aCodFol[010,1],;
								If(	cTipoRot=="3",;
									aCodfol[016,1],;
									aCodFol[027,1];
									);
									);
									)
								// variavel que indica qual a verba sera utiliza como base para proporcionalizacao
Local cRefFer		:= if(	cTipoRot $ "1*4*9",;
							"N",;
							If(	cTipoRot=="2",;
								"N",;
								If(	cTipoRot=="3",;
									"S",;
									"N";
									);
									);
									)
								// variavel que indica se as verbas a serem consideradas referem-se a ferias.
Local cRef13o		:= if(	cTipoRot $ "1*4*9",;
							"N",;
							If(	cTipoRot=="2",;
								"N",;
								If(	cTipoRot=="3",;
									"N",;
									"S";
									);
									);
									)
								// variavel que indica se as verbas a serem considerads referem-se a 13o salario.
Local cNomeArray	:= ""		// variavel que guarda o nome do array que sera processado
Local cNomeValor	:= ""		// variavel que guarda o nome da a ser utilizado na proporcionalizacao
Local cArrayAux		:= ""
Local cArrayTmp		:= ""		//variavel para acessar array dos vinculos durante verificacao de verbas informadas
Local dDataIR		:= if(	cTipoRot $ "1*6*9",;
							dData_Pgto,;
							If(	cTipoRot=="2",;
								dDataPgto,;
								If(	cTipoRot=="3",;
									dDataDe,;
									If( cTipoRot == "4",;
										M->RG_DATAHOM,;
										CTOD("");
										);
										);
										);
										)
								// variavel que guarda a data de pagamento para utilizacao na proporcionalizacao
Local lTemDem		:= .F.		// variavel auxiliar para verificar se tem uma matricula demitida
Local nNomeValor	:= 0		// variavel auxiliar para a proporcionalizacao
Local nNomeVlr2		:= 0		// variavel auxiliar para a proporcionalizacao (INSS)
Local nNomeVlr3		:= 0		// variavel auxiliar para a proporcionalizacao (INSS)
Local _nNomeValor 	:= 0		// variavel auxiliar para a proporcionalizacao 
Local nValAux		:= 0
Local nValAux2		:= 0
Local nCont			:= 0
Local nPos			:= 0		// variavel de posicionamento
Local nPos2			:= 0		// variavel de posicionamento
Local nPosTot		:= 0		// variavel de posicionamento
Local nPosX         := 0
Local nPosY			:= 0
Local nPercParcial	:= 0		// variavel que guarda os percentuais de rateios ja definidos durante o processamento.
Local nPercP2		:= 0		// variavel que guarda os percentuais de rateios ja definidos durante o processamento. (INSS)
Local nPercP3		:= 0		// variavel que guarda os percentuais de rateios ja definidos durante o processamento. (INSS)
Local nValInss		:= 0		// variavel auxiliar para a proporcionalizacao do inss de outras empresas
Local nValIRF		:= 0		// variavel auxiliar para a proporcionalizacao do inss de outras empresas
Local nValorTot		:= 0		// variavel que auxiliar na definicao dos percentuais de rateio
Local nValorTot2	:= 0		// variavel que auxiliar na definicao dos percentuais de rateio (INSS)
Local nValorTot3	:= 0		// variavel que auxiliar na definicao dos percentuais de rateio (INSS)
Local _nValorTot	:= 0 		// variavel auxiliar para total 
Local nValParc		:= 0		// variavel que guarda os valores parciais rateados durante o processamento.
Local nVerbas		:= 0		// variavel que guarda a quantidade de verbas a serem processadas.
Local nw			:= 0
Local nx			:= 0		// variavel para loop
Local ny			:= 0		// variavel para loop
Local nz			:= 0		// variavel para loop
Local nP 			:= 0     
Local nA			:= 0
Local nB			:= 0
Local nTotAux		:= 0
Local cMesInc		:= ""

Local cCCAtual		:= ""		//?-Centro de Custo do Funcionario Corrente
Local cSemAux		:= ""		//Semana Auxiliar - Utilizada para funcionarios de processos diferentes
Local cSemAux2		:= ""		//Semana Auxiliar - Utilizada para funcionarios de processos diferentes
Local cSemAux3		:= ""		//Semana Auxiliar - Utilizada para funcionarios de processos diferentes
Local nValor14		:= 0

Local nPosINSSF      := 0
Local nBsINSSFER     := 0
Local cVerbFer       := ""

//��������������������������������������������������������������Ŀ
//� Limpa o array aPdTot das verbas excluidas e reordena.        �
//����������������������������������������������������������������
For ny := 1 to Len(aPdTot)
	If aPdTot[ny,9] <> 'D'
		aAdd( aAux, aClone(aPdTot[ny]) )
	EndIf
Next ny
aPdTot	:= aClone(aAux)
aAux	:= nil
aSort( aPdTot ,,, { |x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )

//������������������������������������������������������������������Ŀ
//� Pesquisa o valor total da verba de base de IR que sera utilizada �
//� para o rateio dos demais valores.								 �
//��������������������������������������������������������������������
If  SRA->RA_CATFUNC=="A" .AND. SRA->RA_CATEG == "15" .and. Type("cTransPaP") # "U"
	Aeval( aPdTot ,{ |X| If(X[3] == cSemana                        .And. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc) + "," + cTransPaP  ) ,SomaInc(X,5,@nValorTot,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol),NIL) } ) 
	Aeval( aPdTot ,{ |X| If(X[3] == cSemana  .and. x[1]$cTransPaP .And. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc))                      ,SomaInc(X,5,@_nValorTot,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol),NIL) } )
	
   	If Type ("NPERBCIR1") # "U" .and. nperbcir1>0 
		nValorTot	:= nValorTot * nperbcir1			//-- transp.Mercadorias 
 	Else
		nValorTot	:= nValorTot * 0.40			//-- transp.Mercadorias 
	EndIf
	
 	If Type ("NPERBCIR2") # "U" .and. nperbcir2>0 	
 		_nValorTot	:= _nValorTot * nperbcir2		//-- transp.Passageiros 
 	Else
		_nValorTot	:= _nValorTot * 0.60		//-- transp.Passageiros 
 	EndIf	     	

	nValorTot:= nValorTot + _nValorTot
Else 
	If cTipoRot == "3" // Se roteiro de Ferias, pega mes da Data do Recibo
		cMesInc	:= Month(M->RH_DTRECIB)
	Else
		cMesInc := If(!empty(dDataIR),Month(dDataIR),"")
	EndIf
	Aeval( aPdTot ,{ |X| If(X[3] == cSemana  .And. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc) ),SomaInc(X,5,@nValorTot,11,cRefFer,12,cRef13o,cMesInc,,aCodFol,,,!lDissidio),NIL) } )	
	If lRatINSS
		Aeval( aPdTot ,{ |X| If(X[3] == cSemana .And. !(X[1] $ aCodFol[151,1]+","+cCodPensao+&(cCodRecalc) ), SomaInc(X,4,@nValorTot2,11,cRefFer,12,cRef13o,,,aCodFol,,,!lDissidio), NIL) } )
		If cTipoRot == "4"
			Aeval( aPdTot ,{ |X| If(X[3] == cSemana .And. !(X[1] $ aCodFol[151,1]+","+cCodPensao+&(cCodRecalc) ), SomaInc(X,4,@nValorTot3,11,cRefFer,12,"S",,,aCodFol,,,!lDissidio), NIL) } )
		EndIf
	EndIf	
EndIf

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
For ny := 1 to Len(aCPF)
	cSemAux := aCpf[nY,15]
	//��������������������������������������������������������������Ŀ
	//� Filtro para as matriculas que participaram do movimento		 �
	//����������������������������������������������������������������
	If aCPF[ny,8]
		//��������������������������������������������������������������Ŀ
		//� Filtro para as matriculas que Foram acumuladas em aPdTot	 �
		//����������������������������������������������������������������
		If aCPF[ny,7] <> "2" // somente para funcionarios acumulados em APDTOT
			cNomeArray		:= "a"+aCPF[ny,12]
			cNomeValor		:= "n"+aCPF[ny,12]
			&(cNomeValor)	:= 0
			nNomeValor		:= 0
			nNomeVlr2		:= 0
			nNomeVlr3		:= 0
			//�����������������������������������������������������������������������Ŀ
			//� Encontra o valor de cada matricula para apurar o percentual de rateio �
			//�������������������������������������������������������������������������
			If SRA->RA_CATFUNC=="A" .AND. SRA->RA_CATEG == "15" .and. U_GENTYPE01("cTransPaP") # "U" 
				cSemAux3 := cSemana
				cSemana	 := cSemAux //Iguala cSemana a semana do funcionario para utilizacao no somainc
				Aeval( &(cNomeArray) ,{ |X| If(X[3] == cSemAux .And.                        !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc)+ "," + cTransPaP ),SomaInc(X,5,@nNomeValor,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol),NIL) } )
				Aeval( &(cNomeArray) ,{ |X| If(X[3] == cSemAux .And.  x[1]$ cTransPaP .and. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc)                  ),SomaInc(X,5,@_nNomeValor,11,cRefFer,12,cRef13o,If(!empty(dDataIR),Month(dDataIR),nil),,aCodFol),NIL) } )
				cSemana  := cSemAux3
				
				If U_GENTYPE01("NPERBCIR1") # "U" .and. nperbcir1<>0 
					nNomeValor	:= nNomeValor  * nperbcir1
				Else
					nNomeValor	:= nNomeValor  * 0.40 
				EndIf

 				If U_GENTYPE01("NPERBCIR2") # "U" .and. nperbcir2<>0 
					_nNomeValor	:= _nNomeValor * nperbcir2
  				Else
					_nNomeValor	:= _nNomeValor * 0.60 
				EndIf

				nNomeValor	:= nNomeValor + _nNomeValoR 	
			Else
				cSemAux3 := cSemana
				cSemana	 := cSemAux //Iguala cSemana a semana do funcionario para utilizacao no somainc
				If cTipoRot == "3" // Se roteiro de Ferias, pega mes da Data do Recibo
					cMesInc	:= Month(M->RH_DTRECIB)
				Else
					cMesInc := If(!empty(dDataIR),Month(dDataIR),"")
				EndIf
				Aeval( &(cNomeArray) ,{ |X| If(!Empty(cSemana := X[3]) .And. !(X[1] $aCodFol[151,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nNomeValor,11,cRefFer,12,cRef13o,cMesInc,,aCodFol,,,!lDissidio),NIL) } )
				If lRatINSS
					Aeval( &(cNomeArray) ,{ |X| If(!Empty(cSemana := X[3]) .And. !(X[1] $ aCodFol[151,1]+","+cCodPensao+&(cCodRecalc)), SomaInc(X,4,@nNomeVlr2,11,cRefFer,12,cRef13o,,,aCodFol,,,!lDissidio), NIL) } )
					If cTipoRot == "4"
						Aeval( &(cNomeArray) ,{ |X| If(!Empty(cSemana := X[3]) .And. !(X[1] $ aCodFol[151,1]+","+cCodPensao+&(cCodRecalc)), SomaInc(X,4,@nNomeVlr3,11,cRefFer,12,"S",,,aCodFol,,,!lDissidio), NIL) } )
					EndIf
				EndIf
				cSemana  := cSemAux3
			EndIf
			&(cNomeValor)	:= nNomeValor
			//�����������������������������������������������������������������������Ŀ
			//� Zera os valores de base para matriculas que nao tiveram adiantamento. �
			//�������������������������������������������������������������������������
			If cTipoRot=="2" .And. aCPF[ny,4] <> "5"
				Aeval( &(cNomeArray) ,{ |X| nValAux += IF(X[3] == cSemAux .And. X[1]==aCodFol[106,1] .And. X[9] # "D" .And. (MesAno(dDataIR) == MesAno(X[10]) .Or. Empty(X[10])),X[5],0) } )
				If &(cNomeValor) == nValAux
					&(cNomeValor)	:= 0
				EndIf
			EndIf
			//����������������������������������������������������������������������Ŀ
			//� Se a matricula nao estiver demitida, calcula o percentual de rateio. �
			//������������������������������������������������������������������������
			If aCPF[ny,4] <> "5" // somente para funcionarios nao demitidos
				aCpf[ny,6]	:= Round( (&(cNomeValor)/nValorTot*100) , 7 )
				aCpf[ny,10]	:= aCpf[ny,6]
				aCpf[ny,11]	:= aCpf[ny,6]
				If lRatINSS
					aCpf[ny,17]	:= Round( (nNomeVlr2 / nValorTot2 * 100) , 7 )
					aCpf[ny,18] := aCpf[ny,17]
					If cTipoRot == "4"
						aCpf[ny,18]	:= Round( (nNomeVlr3 / nValorTot3 * 100) , 7 )
					EndIf
				EndIf
				If ny == Len(aCPF)
					aCpf[ny,6]	:= 100 - nPercParcial
					aCpf[ny,10]	:= aCpf[ny,6]
					aCpf[ny,11]	:= aCpf[ny,6]
					If lRatINSS
						aCpf[ny,17]	:= 100 - nPercP2
						aCpf[ny,18]	:= aCpf[ny,17]
						If cTipoRot == "4"
							aCpf[ny,18]	:= 100 - nPercP3
						EndIf
					EndIf
				Else
					nPercParcial:= nPercParcial + aCpf[ny,6]
					If lRatINSS
						nPercP2 := nPercP2 + aCpf[ny,17]
						If cTipoRot == "4"
							nPercP3 := nPercP3 + aCpf[ny,18]
						EndIf
					EndIf
				EndIf
			Else
			//����������������������������������������������������������������������Ŀ
			//� Se a matricula estiver demitida diminiremos o valor desta matricula	 �
			//� do total apurado de Forma a encontrar o percentual correto de rateio.�
			//������������������������������������������������������������������������
				nValorTot	:= nValorTot - &(cNomeValor)
			EndIf
		EndIf
	EndIf
Next ny

//������������������������������������������������������������������Ŀ
//� Processa o calculo dos percentuais para rateio do inss de ferias �
//� quando esta no calculo da folha e tem pelo menos 01 funcionario  �
//� em situacao de ferias.                                           �
//��������������������������������������������������������������������
Aeval(aCPF,{ |X| If(X[4]=="3",nCont += 1,"") } )	// "3" - Situacao de ferias
If cTipoRot $ "1*9" .And. nCont > 0
	//-- Calculo dos percentuais em funcao da base de ir de ferias
	nValorTot	:= 0
	nPercParcial:= 0
	Aeval( aPdTot ,{ |X| IF(X[3] == cSemana .And. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+aCodFol[168,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nValorTot,11,"S",12,"N",nil,,aCodFol,,,!lDissidio),NIL) } )
	For ny := 1 to Len(aCPF)
		cSemAux := aCpf[nY,15]
		//��������������������������������������������������������������Ŀ
		//� Filtro para as matriculas que participaram do movimento		 �
		//����������������������������������������������������������������
		If aCPF[ny,8]
			//��������������������������������������������������������������Ŀ
			//� Filtro para as matriculas que Foram acumuladas em aPdTot	 �
			//����������������������������������������������������������������
			If aCPF[ny,7] <> "2" // somente para funcionarios acumulados em APDTOT
				cNomeArray		:= "a"+aCPF[ny,12]
				cNomeValor		:= "n"+aCPF[ny,12]
				&(cNomeValor)	:= 0
				nNomeValor		:= 0
				//�����������������������������������������������������������������������Ŀ
				//� Encontra o valor de cada matricula para apurar o percentual de rateio �
				//�������������������������������������������������������������������������
				cSemAux3 := cSemana
				cSemana	 := cSemAux //Iguala cSemana a semana do funcionario para utilizacao no somainc
				Aeval( &(cNomeArray) ,{ |X| IF(!Empty(cSemana := X[3]).And. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+aCodFol[168,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nNomeValor,11,"S",12,"N",nil,,aCodFol,,,!lDissidio),NIL) } )
				cSemana  := cSemAux3
				&(cNomeValor)	:= nNomeValor
				//����������������������������������������������������������������������Ŀ
				//� Se a matricula nao estiver demitida, calcula o percentual de rateio. �
				//������������������������������������������������������������������������
				If aCPF[ny,4] <> "5" // somente para funcionarios nao demitidos
					aCpf[ny,10]	:= Min( Round( (&(cNomeValor)/nValorTot*100) , 7 ), 100 )
					If ny == Len(aCPF)
						aCpf[ny,10]	:= 100 - nPercParcial
					Else
						nPercParcial:= nPercParcial + aCpf[ny,10]
					EndIf
				Else
				//����������������������������������������������������������������������Ŀ
				//� Se a matricula estiver demitida diminiremos o valor desta matricula	 �
				//� do total apurado de Forma a encontrar o percentual correto de rateio.�
				//������������������������������������������������������������������������
					nValorTot	:= nValorTot - &(cNomeValor)
				EndIf
				
				If U_GENTYPE01("nAliqFMV") <> "U" .And. nAliqFMV > 0
					nBsINSSFER := 0
					cVerbFer   := aCodFol[72,1] + "," + aCodFol[77,1]
					AEval( &(cNomeArray) ,{ |X| IIf( X[1] $ cVerbFer, nBsINSSFER += X[5], Nil ) } )
					If nBsINSSFER > 0
						nPosINSSF := AScan( &(cNomeArray), { |X| X[1] == aCodFol[65,1] } )
						If nPosINSSF  > 0
							&(cNomeArray + "[" + StrZero(nPosINSSF) + ",5]") := Round(nBsINSSFER * nAliqFMV,2)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Next ny

	//-- Calculo dos percentuais em funcao da base de ir total
	nValorTot	:= 0
	nValorTot	:= 0
	nValorTot2	:= 0
	nNomeVlr2	:= 0
	nPercParcial:= 0
	nPercP2		:= 0
	Aeval( aPdTot ,{ |X| IF(X[3] == cSemana .And. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+aCodFol[168,1]+","+aCodFol[65,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nValorTot,,,,,nil,,aCodFol,,,!lDissidio),NIL) } )
	If lRatINSS
		Aeval( aPdTot ,{ |X| IF(X[3] == cSemana .And. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+aCodFol[168,1]+","+aCodFol[65,1]+","+cCodPensao+&(cCodRecalc)), SomaInc(X,4,@nValorTot2,,,,,nil,,aCodFol,,,!lDissidio), NIL) } )
	EndIf
	For ny := 1 to Len(aCPF)
		cSemAux := aCpf[nY,15]
		//��������������������������������������������������������������Ŀ
		//� Filtro para as matriculas que participaram do movimento		 �
		//����������������������������������������������������������������
		If aCPF[ny,8]
			//��������������������������������������������������������������Ŀ
			//� Filtro para as matriculas que Foram acumuladas em aPdTot	 �
			//����������������������������������������������������������������
			If aCPF[ny,7] <> "2" // somente para funcionarios acumulados em APDTOT
				cNomeArray		:= "a"+aCPF[ny,12]
				cNomeValor		:= "n"+aCPF[ny,12]
				&(cNomeValor)	:= 0
				nNomeValor		:= 0
				//�����������������������������������������������������������������������Ŀ
				//� Encontra o valor de cada matricula para apurar o percentual de rateio �
				//�������������������������������������������������������������������������
				cSemAux3 := cSemana
				cSemana	 := cSemAux //Iguala cSemana a semana do funcionario para utilizacao no somainc
				Aeval( &(cNomeArray) ,{ |X| IF( !Empty(cSemana := X[3]) .and. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+aCodFol[168,1]+","+aCodFol[65,1]+","+cCodPensao+&(cCodRecalc)),SomaInc(X,5,@nNomeValor,,,,,nil,,aCodFol,,,!lDissidio),NIL) } )
				If lRatINSS
					Aeval( &(cNomeArray) ,{ |X| IF( !Empty(cSemana := X[3]) .and. !(X[1] $aCodFol[151,1]+","+aCodFol[164,1]+","+aCodFol[168,1]+","+aCodFol[65,1]+","+cCodPensao+&(cCodRecalc)), SomaInc(X,4,@nNomeVlr2,,,,,nil,,aCodFol,,,!lDissidio), NIL) } )
				EndIf
				cSemana := cSemAux3
				&(cNomeValor)	:= nNomeValor
				//����������������������������������������������������������������������Ŀ
				//� Se a matricula nao estiver demitida, calcula o percentual de rateio. �
				//������������������������������������������������������������������������
				If aCPF[ny,4] <> "5" // somente para funcionarios nao demitidos
					aCpf[ny,11]	:= Round( (&(cNomeValor)/nValorTot*100) , 7 )
					If lRatINSS
						aCpf[ny,17]	:= Round( (nNomeVlr2 / nValorTot2 * 100) , 7 )
					EndIf
					If ny == Len(aCPF)
						aCpf[ny,11]	:= 100 - nPercParcial
						If lRatINSS
							aCpf[ny,17]	:= 100 - nPercP2
						EndIf
					Else
						nPercParcial:= nPercParcial + aCpf[ny,11]
						nPercP2		:= nPercP2 + aCpf[ny,17]
					EndIf
				Else
				//����������������������������������������������������������������������Ŀ
				//� Se a matricula estiver demitida diminiremos o valor desta matricula	 �
				//� do total apurado de Forma a encontrar o percentual correto de rateio.�
				//������������������������������������������������������������������������
					nValorTot	:= nValorTot - &(cNomeValor)
				EndIf
			EndIf
		EndIf
	Next ny
EndIf

//��������������������������������������������������������������������������Ŀ
//� Processa a proprocionalizacao dos valores para todas as matriculas.		 �
//����������������������������������������������������������������������������
//��������������������������������������������������������������������������Ŀ
//� Determina a quantidade de verbas a ser processada						 �
//����������������������������������������������������������������������������
nVerbas		:= Len(&(cCodRecalc)+cCodPensao) 
For nx := 1 to nVerbas step 4
	//��������������������������������������������������������������������������Ŀ
	//� Determina o codigo da verba a ser proporcionalizada. 					 �
	//����������������������������������������������������������������������������
	cCodPd		:= SubStr((&(cCodRecalc)+cCodPensao),nx,3)
	nValParc	:= 0
	//��������������������������������������������������������������������������Ŀ
	//� Proporcionaliza os valores de todas as verbas de IR/Pensao/Inss			 �
	//����������������������������������������������������������������������������
	For ny := 1 to Len(aCpf)
		cSemAux := aCpf[nY,15]
		//��������������������������������������������������������������Ŀ
		//� Filtro para as matriculas que participaram do movimento		 �
		//����������������������������������������������������������������
		If aCPF[ny,8]
			If aCPF[ny,4] == "5"			
				lTemDem := .T.
			EndIf
			//��������������������������������������������������������������Ŀ
			//� Filtro para as matriculas que Foram acumuladas em aPdTot	 �
			//����������������������������������������������������������������
			If aCPF[ny,7] <> "2"
				cNomeArray	:= "a"+aCPF[ny,12]
				//��������������������������������������������������������������Ŀ
				//� Pesquiso a verba recalculada com o valor total em aPdTot	 �
				//����������������������������������������������������������������
				If ( nPosTot := aScan( aPdTot,{ |x| x[1] = cCodPd .and. x[3] == cSemana } ) ) > 0 
					If aPdTot[nPosTot][7] <> "I" //se verba diferente de Informada, faz recalculo e atualiza valores.
						//����������������������������������������������������������������������Ŀ
						//� Pesquisa a verba no array de cada matricula.						 �
						//� Se encontrar a verba, atualiza o seu valor, horas e flag de exclusao �
						//�����������������������������������������������������������������������
						If ( nPos := aScan( &(cNomeArray),{ |x| x[1] = cCodPd .and. x[3] == cSemAux } ) ) > 0 
							//����������������������������������������������������������������������Ŀ
							//� Se a matricula nao estiver demitida, calcula o percentual de rateio. �
							//������������������������������������������������������������������������
							If aCPF[ny,4] <> "5"		// Diferente de demitido
								nValAux := 0
								If aCPF[ny,14] == "S"
									Aeval( &(cNomeArray) ,{ |X| IF( X[1] == cCodPd .and. X[3] <> cSemAux,nValAux += X[5],NIL) } )
								EndIf
								&(cNomeArray)[nPos,4]	:= aPdTot[nPosTot,4]
								If lRatINSS .And. cTipoRot $ "1*3*4*6*9" .And. aPdTot[nPosTot,1]$(aCodFol[013,1]+"*"+aCodFol[014,1]+"*"+aCodFol[064,1]+"*"+aCodFol[167,1]+"*"+aCodFol[221,1]+"*"+aCodFol[225,1]+"*"+aCodFol[1412,1]+"*"+aCodFol[019,1]+"*"+aCodFol[020,1]+"*"+aCodFol[070,1]+"*"+aCodFol[169,1]+"*"+aCodFol[065,1]+"*"+aCodFol[168,1]+"*"+aCodFol[232,1])
									If cTipoRot $ "1*4*9" .And. aPdTot[nPosTot,1] $ (aCodFol[100,1]+"*"+aCodFol[101,1]+"*"+aCodFol[659,1])
										&(cNomeArray)[nPos,5]	:= Round( aPdTot[nPosTot,5] * aCPF[ny,10] / 100 , 2 ) - nValAux
									ElseIf cTipoRot == "4" .And. aPdTot[nPosTot,1] $ (aCodFol[019,1]+"*"+aCodFol[020,1]+"*"+aCodFol[070,1]+"*"+aCodFol[169,1])//verba 13o
										&(cNomeArray)[nPos,5]	:= Round( aPdTot[nPosTot,5] * aCPF[ny,18] / 100 , 2 ) - nValAux
									Else
										&(cNomeArray)[nPos,5]	:= Round( aPdTot[nPosTot,5] * aCPF[ny,17] / 100 , 2 ) - nValAux
									EndIf
								ElseIf aPdTot[nPosTot,1]$(aCodFol[065,1]+"*"+aCodFol[100,1]+"*"+aCodFol[101,1]+"*"+aCodFol[659,1]) .And. cTipoRot $ "1*4*9"
									&(cNomeArray)[nPos,5]	:= Round( aPdTot[nPosTot,5] * aCPF[ny,10] / 100 , 2 ) - nValAux
								ElseIf aPdTot[nPosTot,1]$(aCodFol[013,1]+"*"+aCodFol[014,1]) .And. cTipoRot $ "1*4*9"
									&(cNomeArray)[nPos,5]	:= Round( aPdTot[nPosTot,5] * aCPF[ny,11] / 100 , 2 ) - nValAux
								Else
									&(cNomeArray)[nPos,5]	:= Round( aPdTot[nPosTot,5] * aCPF[ny,6] / 100 , 2 ) - nValAux
								EndIf
								&(cNomeArray)[nPos,5]   := Max(&(cNomeArray)[nPos,5],0)
								&(cNomeArray)[nPos,9]	:= Iif(&(cNomeArray)[nPos,5]<>0," ","D")
							Else
							//����������������������������������������������������������������������Ŀ
							//� Se a matricula estiver demitida diminiremos o valor desta matricula	 �
							//� do total apurado de Forma a rateiar o valor total sem modificar as	 �
							//� matriculas demitidas.												 �
							//������������������������������������������������������������������������
								aPdTot[nPosTot,5]	:= aPdTot[nPosTot,5] - &(cNomeArray)[nPos,5]
							EndIf
						Else
						//����������������������������������������������������������������������Ŀ
						//� Se nao encontrar a verba e a matricula nao estiver demitida.		 �
						//� Cria a verba no array de cada matricula.							 �
						//������������������������������������������������������������������������
								//No caso de Salario Familia, nao deve criar a verba no segundo vinculo. 
								//O recebimento do valor eh feito apenas no vinculo em que ha dependentes cadastrados para o SALFAM.
								//Nesse caso, apenas atualizo o valor do SALFAM para o vinculo onde ja tem a verba.
							If (aCPF[ny,4] <> "5") .AND. (cCodPD != aCodFol[034,1])
								nValAux := 0
								aSRAArea := SRA->(GetArea())
								cCCAtual := Posicione("SRA",1,aCPF[ny,2]+aCPF[ny,3],"SRA->RA_CC")
								RestArea(aSRAArea)
								If aCPF[ny,14] == "S"
									Aeval( &(cNomeArray) ,{ |X| IF( X[1] == cCodPd .and. X[3] <> cSemAux,nValAux += X[5],NIL) } )
								EndIf
								nValAux2 := Round( aPdTot[nPosTot,5] * Iif(aPdTot[nPosTot,1]$aCodFol[065,1]+"*"+aCodFol[100,1]+"*"+aCodFol[101,1]+"*"+aCodFol[659,1] .And. cTipoRot $ "1*4*9",aCPF[ny,10],If(aPdTot[nPosTot,1]$aCodFol[013,1]+"*"+aCodFol[014,1] .And. cTipoRot $ "1*4*9",aCpf[ny,11],aCPF[ny,6])) / 100 , 2 )
								nValAux2 := Max(nValAux2 - nValAux , 0 )
								aAdd(&(cNomeArray),{	cCodPd, cCCAtual, cSemAux, aPdTot[nPosTot,4],		;
														nValAux2,	;
														aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
														aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
														aPdTot[nPosTot,12],aPdTot[nPosTot,13],aPdTot[nPosTot,14],aPdTot[nPosTot,15],aPdTot[nPosTot,16],;
														aPdTot[nPosTot,17],aPdTot[nPosTot,18],aPdTot[nPosTot,19],aPdTot[nPosTot,20],aPdTot[nPosTot,21] } )
								nPos := Len(&(cNomeArray))
							EndIf						
						EndIf
						//����������������������������������������������������������������������Ŀ
						//� Acumula os valores ja rateados na variavel nValParc com a finalidade �
						//� de ajustar os totais sem deixar faltar centavos						 �
						//������������������������������������������������������������������������
						If (aCPF[ny,7] == "1") .and. (aCPF[ny,4] <> "5")	// Ajusta os centavos para a ultima matricula processada
							If ny == Len(aCpf) .AND. (nPos != 0)
								&(cNomeArray)[nPos,5]	:= Max(aPdTot[nPosTot,5] - nValParc - nValAux , 0 )	
							ElseIf ny == Len(aCpf) .AND. (nPos == 0)
							//Se por acaso a verba existir apenas em 1 dos vinculos, deixo todo o valor calculado neste vinculo.
							//Exemplo, Sal.Familia onde apenas 1 dos vinculos recebe o beneficio.
								nw := 0
								While (nPos == 0 .AND. nw < Len(aCPF)) 
									nw++
									cArrayTmp := "a"+aCPF[nw,12]
									nPos := aScan(&(cArrayTmp),{|x| x[1] == cCodPd})
								EndDo
								If nPos != 0
									&(cArrayTmp)[nPos,5] := &(cArrayTmp)[nPos,5] + (aPdTot[nPosTot,5] - nValParc - nValAux)
								EndIf
							ElseIf (nPos != 0)
								nValParc	:= nValParc + &(cNomeArray)[nPos,5] + nValAux
							EndIf
						EndIf
					Else //se verba informada, devo verificar se em algum dos vinculos a verba esta como "C" para mudar posicao [9] de "D" (deletada) para "" (ativa)
						For nZ := 1 to Len(aCPF)
							cArrayTmp	:= "a"+aCPF[nZ,12]
							nPos:= aScan( &(cArrayTmp),{ |x| x[1] = cCodPd .AND. x[7] <> "I" .AND. x[9] == "D" })
							If nPos > 0
								&(cArrayTmp)[nPos][9] := ""
								//como os valores nao sao somados no array aPdTot quando o tipo de verba eh diferente
								//sera adicionado o valor neste momento para geracao das verbas de base Outras Empresas
								aPdTot[nPosTot][5] += &(cArrayTmp)[nPos][5]
								nPos := 0
							EndIf
						Next nZ
					EndIf
				EndIf
			EndIf
		EndIf
	Next ny
Next nx

//�������������������������������������������������������������������������������������������������������������Ŀ
//� Processa a geracao do inss de outras empresas para folha mensal, 13o salario normal e adiantamento para IRF �
//���������������������������������������������������������������������������������������������������������������
If cTipoRot $ "1*9" .or. ( cTipoRot == "6" .and. !lRecalc13o ) .or. cTipoRot == "2"  
	If cTipoRot $ "1*9"    //FOLHA
		//��������������������������������������������������������������������������Ŀ
		//� Contem as verbas de inss e base de inss que deverao ser geradas como     �
		//� outras empresas.														 �
		//����������������������������������������������������������������������������
		If !Empty(aCodFol[288,1]) .And. !Empty(aCodFol[289,1])
			If !lTemDem
				aAdd( aTroca , { aCodFol[013,1]+","+aCodFol[014,1]+','+aCodFol[221,1] , aCodFol[288,1], "1" } )	// Salario de Contribuicao ate o limite e acima do limite
				aAdd( aTroca , { aCodFol[064,1]+","+aCodFol[065,1] , aCodFol[289,1], "1" } )	// Inss s/salario e inss s/ferias
			Else
				aAdd( aTroca , { aCodFol[013,1]+","+aCodFol[014,1]+','+aCodFol[221,1]+','+aCodFol[288,1] , aCodFol[288,1], "1" } )	// Salario de Contribuicao ate o limite e acima do limite
				aAdd( aTroca , { aCodFol[064,1]+","+aCodFol[065,1]+','+aCodFol[289,1] , aCodFol[289,1], "1" } )	// Inss s/salario e inss s/ferias			
			EndIf
		EndIf   
		
		//��������������������������������������������������������������������������������������Ŀ
		//� Contem as verbas de IRF e Base de IRF que deverao ser geradas como outras empresas.	 �
		//����������������������������������������������������������������������������������������
		If !Empty(aCodFol[992,1]) .And. !Empty(aCodFol[993,1])
			aAdd( aTroca , { aCodFol[015,1], aCodFol[992,1], "2" } )	// Bse IRF s/Salario 
			aAdd( aTroca , { aCodFol[066,1], aCodFol[993,1], "2" } )	// IRF s/Salario 
		EndIf
	
	ElseIf cTipoRot == "6" // 13.SALARIO
		//��������������������������������������������������������������������������Ŀ
		//� Contem as verbas de inss e base de inss que deverao ser geradas como     �
		//� outras empresas.														 �
		//����������������������������������������������������������������������������
		If !Empty(aCodFol[290,1]) .And. !Empty(aCodFol[291,1])
			aAdd( aTroca , { aCodFol[019,1]+","+aCodFol[020,1]+','+aCodFol[221,1]  , aCodFol[290,1], "1" } )	// Salario de Contribuicao ate o limite 13o salario e acima do limite
			aAdd( aTroca , { aCodFol[070,1]                     , aCodFol[291,1], "1" } )	// Inss s/13o salario
		EndIf  
		
		//��������������������������������������������������������������������������������������Ŀ
		//� Contem as verbas de IRF e Base de IRF que deverao ser geradas como outras empresas.	 �
		//����������������������������������������������������������������������������������������
		If !Empty(aCodFol[994,1]) .And. !Empty(aCodFol[995,1])
			aAdd( aTroca , { aCodFol[027,1], aCodFol[994,1], "2" } )	// Base IRF s/13.Salario
			aAdd( aTroca , { aCodFol[071,1], aCodFol[995,1], "2" } )	// IRF s/13.salario
		EndIf
	ElseIf cTipoRot == "2" //Adiantamento  - Somente IRF
		//��������������������������������������������������������������������������������������Ŀ
		//� Contem as verbas de IRF e Base de IRF que deverao ser geradas como outras empresas.	 �
		//����������������������������������������������������������������������������������������
		If !Empty(aCodFol[996,1]) .And. !Empty(aCodFol[997,1])
			aAdd( aTroca , { aCodFol[010,1], aCodFol[996,1], "2" } )	// Bse IRF s/Adiantamento
			aAdd( aTroca , { aCodFol[012,1]+","+aCodFol[009,1], aCodFol[997,1], "2" } )	// IRF s/Adiantamento
		EndIf
	EndIf
	
	//��������������������������������������������������������������������������Ŀ
	//� Executa para todas as verbas do array aTroca.							 �
	//����������������������������������������������������������������������������
	For nx := 1 to Len(aTroca) step 1
		//��������������������������������������������������������������������������Ŀ
		//� Proporcionaliza os valores de todas as verbas de Inss					 �
		//����������������������������������������������������������������������������
		For ny := 1 to Len(aCpf)
			cSemAux := aCpf[nY,15]
			//��������������������������������������������������������������Ŀ
			//� Filtro para as matriculas que Foram acumuladas em aPdTot	 �
			//����������������������������������������������������������������
			If aCPF[ny,8]
				//��������������������������������������������������������������Ŀ
				//� Filtro para as matriculas que foram acumuladas em aPdTot	 �
				//����������������������������������������������������������������
				If aCPF[ny,7] <> "2"            
				
					cNomeArray	:= "a"+aCPF[ny,12]
					nValTot		:= 0
					nValInss	:= 0
					nValIRF		:= 0
					nValBCInss :=0
					If aTroca[nx,3] == "1"
						nPosTot		:= aScan( aPdTot,{ |x| x[1] $aTroca[nx,1] .and. x[3] <= cSemana .and. x[9] <> "D" } ) 
						//��������������������������������������������������������������Ŀ
						//� Pesquiso a verba recalculada com o valor total em aPdTot	 �
						//���������������������������������������������������������������� 
						If nProc1 == 1 .and. aCPF[ny,5] == "A"   //Para autonomos Semanalistas o Total sera lido do ApdOut
							aEval( aPdOut,{ |x| nValTot += If(x[1] $aTroca[nx,1] .and. x[3] <= cSemana .and. x[9] <> "D",x[5],0) } ) 
						Else					
							aEval( aPdTot,{ |x| nValTot += If(x[1] $aTroca[nx,1] .and. x[3] <= cSemana .and. x[9] <> "D" ,x[5],0) } ) 
						EndIf						
                        
                        If nValTot == 0 .And. aCodFol[064,1] $ aTroca[nx,1]
                        	nPos  		:= aScan( &(cNomeArray),{ |x| x[1] = aTroca[nx,2] .and. x[3] <= cSemAux .and. x[9] <> "D" } )
                        	If nPos > 0 .And. (&(cNomeArray)[nPos,7] $"I,G")
                        		nPosTot:=aScan( aPdTot,{ |x| x[1] = aTroca[nx,2] .and. x[3] <= cSemana .and. x[9] <> "D" } )
                        	  	nTotAux:= 0
					   		   	nB:=0
					   		   	For nA := 1 to Len(aCpf)
					   		   		cSemAux2 := aCpf[nA,15]
					   		   		cArrayAux	:= "a"+aCPF[na,12]
			   		   				If nProc1 == 1 .and. aCPF[nA,5] == "A"   //Para autonomos Semanalistas o Total sera lido do ApdOut
								   		aEval( &(cArrayAux),{ |x| nTotAux += If(x[1] $ aTroca[nx,2] .and. x[3] = cSemAux2 .And. x[7] $ 'I,G' .and. x[9] <> "D",x[5],0) } )
								   		If nTotAux > 0
								  			If nB == 0
								   				nB:= nA
								   			EndIf
								   		EndIf
								   	Else
										aEval( &(cArrayAux),{ |x| nTotAux += If(x[1] $ aTroca[nx,2] .and. x[3] <= cSemAux2 .And. x[7] $ 'I,G' .and. ( x[9] <> "D" .or. x[3] <> cSemAux ),x[5],0) } )
										If nTotAux > 0
								   			If nB == 0
								   				nB:= nA
								   			EndIf
								   		EndIf
									EndIf 
								Next			
						   		 
								If nTotAux == If( cTipoRot == "6", aTInss13[Len(aTInss13)][1]*aTInss13[Len(aTInss13)][2] , aTInss[Len(aTInss)][1]*aTInss[Len(aTInss)][2] )
									 nValTot:= nTotAux
								EndIf
								    
								 If nTotAux > 0 .And. U_GENTYPE01("aInssOut") == "A" 
								   	If Len(aInssOut) > 0
								   		nPosT:= Ascan(aInssOut,{|x| x[1]+x[3]+x[4] == aTroca[nx,2]+aCpF[nB,2] + aCpF[nB,3]  } )
								   		If nPosT == 0
									    	aAdd(aInssOut , {aTroca[nx,2],nTotAux,aCpF[nB,2],aCpF[nB,3],aCpf[nB,1]})
									    EndIf 
									Else
										AADD(aInssOut , {aTroca[nx,2],nTotAux,aCpF[nB,2],aCpF[nB,3],aCpf[nB,1]})
									EndIf
								EndIf
							                
							 EndIf		
						 EndIf				
						 
						 If nValTot == 0
						 	nTotAux:= 0
							aEval( aPdTot,{ |x| nTotAux += If(x[1] $ aTroca[nx,2] .and. x[3] = cSemana .And. x[7] $ 'I,G' .and. x[9] <> "D",x[5],0) } )	
                            If nTotAux > 0
                            	nValTot:= nTotAux
                            	nPosTot		:= aScan( aPdTot,{ |x| x[1] $aTroca[nx,2] .and. x[3] <= cSemana .and. x[9] <> "D" } )
                            EndIf
                        EndIf
                        If nValTot > 0
							//����������������������������������������������������������������������Ŀ
							//� Pesquisa a verba no array de cada matricula.						 �
							//� Se encontrar a verba, atualiza o seu valor, horas e flag de exclusao �
							//������������������������������������������������������������������������
							// Verba de inss de outras empresas
							If nProc1 == 1 .and. aCPF[ny,5] == "A"   //Para autonomos Semanalistas o Total sera lido do ApdOut
							 	nPos  := aScan( &(cNomeArray),{ |x| x[1] = aTroca[nx,2] .and. x[3] = cSemAux .and. x[9] <> "D" } )
							Else
								nPos  := aScan( &(cNomeArray),{ |x| x[1] = aTroca[nx,2] .and. x[3] <= cSemAux .and. x[9] <> "D" } )   
							EndIf
							// Verba de inss normal do movimento  
							If nProc1 == 1 .and. aCPF[ny,5] == "A"   //Para autonomos Semanalistas o Total sera lido do ApdOut
								aEval( &(cNomeArray),{ |x| nValInss += If(x[1] $aTroca[nx,1] .and. x[3] = cSemAux .and. x[9] <> "D",x[5],0) } )
							Else
								aEval( &(cNomeArray),{ |x| nValInss += If(x[1] $aTroca[nx,1] .and. x[3] <= cSemAux .and. ( x[9] <> "D" .or. x[3] <> cSemAux ),x[5],0) } )
							EndIf
							If nValInss == 0
								Loop
							EndIf
							If nPos > 0 .and. !(&(cNomeArray)[nPos,7] $"I,G")
								//���������������������������������������������������������������������������������Ŀ
								//� Se a matricula nao estiver demitida, ajusta o valor de inss de outras empresas. �
								//�����������������������������������������������������������������������������������
								If aCPF[ny,4] <> "5"		// Diferente de demitido
									&(cNomeArray)[nPos,5]	:= (nValTot - nValInss)
								EndIf
								If nProc1 == 1 .and. aCPF[ny,5] == "A" 
									If aCPF[ny,4] <> "5"		// Diferente de demitido 
										If cTipoRot == "6"
										   If (nValTot - nValInss) > ATINSS13[4,1] .AND. aTroca[nx,2] == aCodfol[288,1] 
												&(cNomeArray)[nPos,5]	:= ATINSS13[4,1]
									       Else
									       		&(cNomeArray)[nPos,5]	:= (nValTot - nValInss)
									       EndIf
									    Else
										   If (nValTot - nValInss) > ATINSS[4,1] .AND. aTroca[nx,2] == aCodfol[288,1] 
												&(cNomeArray)[nPos,5]	:= ATINSS[4,1]
									       Else
									       		&(cNomeArray)[nPos,5]	:= (nValTot - nValInss)
									       EndIf
									    EndIf
									EndIf    
								EndIf	
							ElseIf nPos > 0 .and. (&(cNomeArray)[nPos,7] $ "I,G") //Busca Verbas de INSS Outra Empresa caso sejam inFormadas
					   		   		nTotAux:= 0
					   		   		nB:=0
					   		   		For nA := 1 to Len(aCpf)
					   		   			cArrayAux	:= "a"+aCPF[na,12]
					   		   			cSemAux2 := aCpf[nA,15]
			   		   					If nProc1 == 1 .and. aCPF[nA,5] == "A"   //Para autonomos Semanalistas o Total sera lido do ApdOut
									   		aEval( &(cArrayAux),{ |x| nTotAux += If(x[1] $ aTroca[nx,2] .and. x[3] = cSemAux2 .And. x[7] $ 'I,G' .and. x[9] <> "D",x[5],0) } )
									   		If nTotAux > 0
									   			If nB == 0
									   				nB:= nA
									   			EndIf
									   		EndIf
									   	Else
											aEval( &(cArrayAux),{ |x| nTotAux += If(x[1] $ aTroca[nx,2] .and. x[3] <= cSemAux2 .And. x[7] $ 'I,G' .and. ( x[9] <> "D" .or. x[3] <> cSemAux2 ),x[5],0) } )
											If nTotAux > 0
									   			If nB == 0
									   				nB:= nA
									   			EndIf
									   		EndIf
										EndIf 
									Next			
								    
								    If nTotAux > 0 .And. U_GENTYPE01("aInssOut") == "A" 
								    	If Len(aInssOut) > 0
								    		nPosT:= Ascan(aInssOut,{|x| x[1]+x[3]+x[4] == aTroca[nx,2]+aCpF[nB,2] + aCpF[nB,3]  } )
								    		If nPosT == 0
										    	AADD(aInssOut , {aTroca[nx,2],nTotAux,aCpF[nB,2],aCpF[nB,3],aCpf[nB,1]})
										    EndIf 
										Else
											AADD(aInssOut , {aTroca[nx,2],nTotAux,aCpF[nB,2],aCpF[nB,3],aCpf[nB,1]})
										EndIf
									EndIf
								    
								    If U_GENTYPE01("aInssOut") == "A" .And. Len(aInssOut) > 0 .And. aScan(aInssOut,{|x| x[3] == aCpF[nY,2] .And. x[4] == aCpF[nY,3]}) >  0
										cOrigem:= aPdTot[nPosTot,7]
								 	Else
								  		cOrigem:= "C"
								 	EndIf
								    
								    IF U_GENTYPE01("aInssOut") == "A" .And. Len(aInssOut) > 0 .And. aScan(aInssOut,{|x| x[3] == aCpF[nY,2] .And. x[4] == aCpF[nY,3]}) >  0 .And. cOrigem == "C"
								      	cSeq:= "2"
								 	Else
								 		cSeq:= aPdTot[nPosTot,11]
								 	EndIf 
									
									If nPos > 0
										cSeq := Soma1(&(cNomeArray)[nPos, 11])
									EndIf
									
								    cCCAtual:= Posicione("SRA",1,aCPF[ny,2]+aCPF[ny,3],"SRA->RA_CC")
								    
									aAdd(&(cNomeArray),{	aTroca[nx,2], cCCAtual, cSemAux, aPdTot[nPosTot,4],		;
															Max(nValTot - nValInss,0), ;
															aPdTot[nPosTot,6], cOrigem, aPdTot[nPosTot,8],;
															aPdTot[nPosTot,9], aPdTot[nPosTot,10], cSeq,;
															aPdTot[nPosTot,12],aPdTot[nPosTot,13],aPdTot[nPosTot,14],aPdTot[nPosTot,15],aPdTot[nPosTot,16],;
															aPdTot[nPosTot,17],aPdTot[nPosTot,18],aPdTot[nPosTot,19],aPdTot[nPosTot,20],aPdTot[nPosTot,21] } )
								    
							ElseIf nPos == 0  
						   		//Soma Valor da verba inFormada
						   		If U_GENTYPE01("aInssOut") == "A" .And. Len(aInssOut) > 0  .And. If( cTipoRot == "6", nValTot <> (aTInss13[Len(aTInss13)][1]*aTInss13[Len(aTInss13)][2] ) , nValTot <> (aTInss[Len(aTInss)][1]*aTInss[Len(aTInss)][2] ) )
						   	   		nPosX:= Ascan(aInssOut,{|x| x[1] $ aTroca[nx,2] .And. x[5] == SRA->RA_CIC  } )
						   			If nPosX > 0
						   				If (nPosY:= Ascan(aCPF,{|x| x[4] $ "5"  } )) == 0
						   					nValTot+= aInssOut[nPosX][2]
						   				EndIf
						   			EndIf
						   		EndIf
											   		
						   		//����������������������������������������������������������������������Ŀ
								//� Se nao encontrar a verba e a matricula nao estiver demitida.		 �
								//� Cria a verba no array de cada matricula.							 �
								//������������������������������������������������������������������������
								If aCPF[ny,4] <> "5"  .OR. (nProc1 == 1 .and. aCPF[ny,5] == "A" .and. aCPF[ny,4] == "5" ) //se For demitido OU novo processamento inclue verbas
									aSRAArea := SRA->(GetArea())
									cCCAtual := Posicione("SRA",1,aCPF[ny,2]+aCPF[ny,3],"SRA->RA_CC")
									RestArea(aSRAArea) 
									 
									If nProc1 == 1 .and. aCPF[ny,5] == "A"   // COntrole da Oas  
								  			nValBCInss := nValTot - nValInss
								  			If aTroca[nx,2] == aCodfol[288,1] 
								  				If cTipoRot == "6"
  													If nValBCInss >	ATINSS13[4,1]
									  					nValBCInss := ATINSS13[4,1]
									  				EndIf
								  				Else
									  				If nValBCInss >	ATINSS[4,1]
									  					nValBCInss := ATINSS[4,1]
									  				EndIf
								  				EndIf
								  			EndIf
								  			
											aAdd(&(cNomeArray),{	aTroca[nx,2], cCCAtual, cSemAux, aPdTot[nPosTot,4],		;                                                                           		
																Max(nValBCInss,0), ;
																aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
																aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
																aPdTot[nPosTot,12],aPdTot[nPosTot,13],aPdTot[nPosTot,14],aPdTot[nPosTot,15],aPdTot[nPosTot,16],;
																aPdTot[nPosTot,17],aPdTot[nPosTot,18],aPdTot[nPosTot,19],aPdTot[nPosTot,20],aPdTot[nPosTot,21] } )
								  					
									Else
										If U_GENTYPE01("aInssOut") == "A" .And. Len(aInssOut) > 0 .And. nPos > 0 .And. aScan(aInssOut,{|x| x[3] == &(cNomeArray)[nPos,2] .And. x[4] == &(cNomeArray)[nPos,3]}) >  0
											cOrigem:= aPdTot[nPosTot,7]
									 	Else
									  		cOrigem:= "C"
									 	EndIf
									 	IF U_GENTYPE01("aInssOut") == "A" .And. Len(aInssOut) > 0 .And. aScan(aInssOut,{|x| x[3] == aCpF[nY,2] .And. x[4] == aCpF[nY,3]}) >  0 .And. cOrigem == "C"
									      	cSeq:= "2"
									 	Else
										 	If nValTot == If(cTipoRot == "6" , (aTInss13[Len(aTInss13)][1]*aTInss13[Len(aTInss13)][2] ) ,(aTInss[Len(aTInss)][1]*aTInss[Len(aTInss)][2] ) )
											    cSeq:= "  "
											Else
												cSeq:= aPdTot[nPosTot,11]
											EndIf
									 	EndIf
									 	
										aAdd(&(cNomeArray),{	aTroca[nx,2], cCCAtual, cSemAux, aPdTot[nPosTot,4],		;                                                                           		
															Max(nValTot - nValInss,0), ;
															aPdTot[nPosTot,6], cOrigem, aPdTot[nPosTot,8],;
															aPdTot[nPosTot,9], aPdTot[nPosTot,10], cSeq,;
															aPdTot[nPosTot,12],aPdTot[nPosTot,13],aPdTot[nPosTot,14],aPdTot[nPosTot,15],aPdTot[nPosTot,16],;
															aPdTot[nPosTot,17],aPdTot[nPosTot,18],aPdTot[nPosTot,19],aPdTot[nPosTot,20],aPdTot[nPosTot,21] } )
									EndIf
								EndIf
							EndIf
						EndIf
					Else  
						//Demonstracao verbas de Base e valor IRF 
						//Para Mensalistas x Autonomo o calculo do IRF e individual, ou seja, nao realizamos o calculo de multiplos vinculos, e por isso
						//essas verbas de IRF nao serao demonstradas. O INSS do mensalista e descontado do autonomo garantindo assim o recolhimento ate o teto.
		
						nPosTot := aScan( aPdTot,{ |x| x[1] $aTroca[nx,1] .and. x[3] == cSemana .and. x[9] <> "D"  } ) 
						//��������������������������������������������������������������Ŀ
						//� Pesquiso a verba recalculada com o valor total em aPdTot	 �
						//����������������������������������������������������������������  
						If nProc1 == 1 .and. aCPF[ny,5] == "A"
							aEval( aPdOut,{ |x| nValTot += If(x[1] $aTroca[nx,1] .and. x[3] <= cSemana .and. x[9] <> "D",x[5],0) } ) 
						Else
							aEval( aPdTot,{ |x| nValTot += If(x[1] $aTroca[nx,1] .and. x[3] == cSemana .and. x[9] <> "D",x[5],0) } ) 
						EndIf
						
						If nValTot > 0
							//����������������������������������������������������������������������Ŀ
							//� Pesquisa a verba no array de cada matricula.						 �
							//� Se encontrar a verba, atualiza o seu valor, horas e flag de exclusao �
							//������������������������������������������������������������������������
							// Verba de inss de outras empresas
						 	nPos  		:= aScan( &(cNomeArray),{ |x| x[1] = aTroca[nx,2] .and. x[3] == cSemAux .and. x[9] <> "D" } )
							// Verba de inss normal do movimento
							aEval( &(cNomeArray),{ |x| nValInss += If(x[1] $aTroca[nx,1] .and. x[3] == cSemAux .and. x[9] <> "D",x[5],0) } )

							nPos  		:= aScan( &(cNomeArray),{ |x| x[1] = aTroca[nx,2] .and. x[3] == cSemAux .and. x[9] <> "D" } )
							aEval( &(cNomeArray),{ |x| nValIrf += If(x[1] $aTroca[nx,1] .and. x[3] == cSemAux .and. x[9] <> "D",x[5],0) } )
	
							If nPos > 0 .and. !(&(cNomeArray)[nPos,7] $"I,G")  
								If aCPF[ny,4] <> "5"		// Diferente de demitido
									&(cNomeArray)[nPos,5]	:= (nValTot - nValIRF)
								EndIf
							ElseIf nPos == 0
								If aCPF[ny,4] <> "5"
									aSRAArea := SRA->(GetArea())
									cCCAtual := Posicione("SRA",1,aCPF[ny,2]+aCPF[ny,3],"SRA->RA_CC")
									RestArea(aSRAArea)
									aAdd(&(cNomeArray),{	aTroca[nx,2], cCCAtual, cSemAux, aPdTot[nPosTot,4],		;                                                                           		
														Max(nValTot - nValIrf,0), ;
														aPdTot[nPosTot,6], aPdTot[nPosTot,7], aPdTot[nPosTot,8],;
														aPdTot[nPosTot,9], aPdTot[nPosTot,10], aPdTot[nPosTot,11],;
														aPdTot[nPosTot,12],aPdTot[nPosTot,13],aPdTot[nPosTot,14],aPdTot[nPosTot,15],aPdTot[nPosTot,16],;
														aPdTot[nPosTot,17],aPdTot[nPosTot,18],aPdTot[nPosTot,19],aPdTot[nPosTot,20],aPdTot[nPosTot,21] } ) 
								EndIf
							EndIf 
						EndIf	
                    EndIf
				EndIf
			EndIf
		Next ny
	Next nx
EndIf
				
//����������������������������������������������������������������������Ŀ
//� Para multiplos vinculos entre mensalista  x mensalista, no array do  �
//� autonomo, trocar as verbas de ID 013 e 014 (Sal Contr. ate teto inss �
//� e acima do teto), pela verba 221 (base inss prol\autonomo)			 �
//������������������������������������������������������������������������

For nZ := 1 to Len(aCpf)
	cSemAux			:= aCpf[nZ,15]
	cNomeArray		:= "a"+aCPF[nz,12]   // Atualiza o array que sera gravado para a matricula	
	If U_GENTYPE01(cNomeArray) <> "U" 
		If aCPF[nz,13] == "1" 						 //Autonomo			
			nPos := aScan( &(cNomeArray),{ |x| x[1] == aCodfol[014,1] .and. x[3] <= cSemAux .and. x[9] <> "D" } )
			If nPos > 0
				nValor14 := &(cNomeArray)[nPos,5]
				&(cNomeArray)[npos,9] := 'D'
			EndIf
					
			nPos := aScan( &(cNomeArray),{ |x| x[1] == aCodfol[013,1] .and. x[3] <= cSemAux .and. x[9] <> "D" } )
					
			If nPos > 0
				&(cNomeArray)[npos,1] := acodfol[221,1]
				&(cNomeArray)[npos,5] += nValor14
			EndIf
		EndIf
	EndIf		

Next nZ
 
Return Nil
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

If aX[7] == 'I' .And. Empty(ax[10]) .And. ax[1]$(aCodFol[007,1]+"/"+ aCodFol[012,1]+"/"+ aCodFol[010,1]) 
	dDtPgt := dDataPgto
ElseIf aX[7] # 'A'.And. PosSrv(aX[1],SRA->RA_FILIAL,"RV_ADIANTA") == 'N'
	dDtPgt := If (Ax[10] = Nil , CtoD(""), Ax[10])
ElseIf Empty(aX[10]) .Or. aX[3] == Semana
	dDtPgt := dDataPgto
Else
	dDtPgt := aX[10]
EndIf

GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aX[1], dDtPgt ,aX[2],aX[3],aX[6],aX[7],aX[4],aX[5],aX[8],ax[9],,aX[11],,,,,aX[20],aX[21],aX[15])

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

nElement	:= Len(aPd)
For nx := 1 to nElement
	//��������������������������������������������������������������������������Ŀ
	//� Limpa a matriz deixando somente os codigos necessarios ao recalculo do IR�
	//� e troca os codigos de IR da rescisao por IR do mes anterior.			 �
	//����������������������������������������������������������������������������
	If ( nPos := aScan(aTroca,{|X| x[1] == aPd[nx,1] } ) ) > 0
		If MesAno(dData_Pgto) == MesAno(aPd[nx,10]) .or. Empty(aPd[nx,10])
			//��������������������������������������������������������������Ŀ
			//� Quando nao For a base de ir de folha na rescisao, somaremos	 �
			//� as verbas de ir (mes anterior, adiantamento, folha) que 	 �
			//� estiverem no mesmo mes de pagamento da rescisao.			 �
			//����������������������������������������������������������������
			If aTroca[nPos,1] <> aCodFol[015,1]
				If ( nPos1 := aScan(aAux,{|X| x[1] == aTroca[nPos,2] } ) ) > 0
					aAux[nPos1,5]	+= aPd[nx,5]
				Else
					aAdd(aAux,Aclone(aPd[nx]))
					aAux[Len(aAux),1]	:= aTroca[nPos,2]
				EndIf
			Else
			//��������������������������������������������������������������Ŀ
			//� Quando For a base de ir de folha na rescisao.				 �
			//����������������������������������������������������������������
				aAdd(aAux,Aclone(aPd[nx]))
				aAux[Len(aAux),1]	:= aTroca[nPos,2]
			EndIf
		EndIf
	EndIf
Next nx

aPd	:= aClone(aAux)

Return

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
Local cRotAux	:= ""
Local cMesAnoRef:= cAnoMes				// Mes e ano aberto na folha de pagamento//Mnemonico carregado em CARGARCH
Local dDataPesq	:= CtoD("")				// Variavel utilizada na busca das ferias e rescisoes.
Local dDtaPg	:= CtoD("")				// Variavel utilizada para carga do aPd
Local lBusPen131:= .T.					// variavel que determina se deve buscar a pensao da 1a parcela para o calculo da rescisao de contrato
Local lGerou_	:= .F.					// Variavel que recebe a confirmacao de que a rescisao foi carregada para o APD.
Local nPos		:= 0					// Variavel utilizada para pesquisa
Local nValPen1P	:= 0					// Valor da pensao alimenticia da 1a parcela
Local nx		:= 0					// variavel para looping de array
Local dDtBusFer	:= CtoD("")				// Busca RH_DTRECIB ou RH_DTITENS
Local nIndexTmp	:= 0

// Tratamento da existencia da Nova tabela de Dissidio Permanente (RHH)
Local cAliasDis	:= Iif( Sx2ChkTable( "RHH" ), "RHH", "TRB" )

Local aArea		:= GetArea()
Local aSRCArea	:= SRC->(GetArea())
//�����������������������������������������������������������������������Ŀ
//� Alimeto uma unica variavel para teste das verbas a serem recalculadas �
//�������������������������������������������������������������������������
cCodigos		:= cCodigos + cCodPensao 
SRC->(DbSetOrder(1))

If cTipoRot $ "1*9"
	cRotAux := If(aCPF[z,5] $ "A*P" , fGetCalcRot("9"),fGetRotOrdinar())
Else
	cRotAux := fGetCalcRot(cTipoRot)
EndIf

//��������������������������������������������������������������Ŀ
//� Quando For calculo de 2a parcela do 13o salario				 �
//����������������������������������������������������������������
If cTipoRot == "6"
	//��������������������������������������������������������������Ŀ
	//� Utilizo o aPd salvo no inicio do processamento quando estiver�
	//� acumulando a matricula corrente.							 �
	//����������������������������������������������������������������
	If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
		aPd	:= aClone(aPdCorrent)
		If aCPF[z,14] == "S" //Semanalista - Carrega semanas anteriores
			dbSelectArea( "SRD" )
			DbSetOrder(RetOrder("SRD","RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA"))
			
			SRD->( DbSeek( SRA->( RA_FILIAL + RA_MAT + RA_PROCES + cRotAux + cPeriodo ) ) )
			While SRD->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT + RA_PROCES) + cRotAux + cPeriodo  == RD_FILIAL + RD_MAT + RD_PROCES + RD_ROTEIR + RD_PERIODO )
				cDel := " "
				//��������������������������������������������������������������Ŀ
				//� Marco com "D" as verbas que serao recalculadas.				 �
				//����������������������������������������������������������������
				If SRD->RD_PD $ cCodigos 
					cDel := "D"
				EndIf
				dDtapg := CtoD("")
				If PosSrv(SRD->RD_PD,SRA->RA_FILIAL,"RV_REF13") == 'S'
					If ( nPos := Ascan(aPd,{|X| X[1] == SRD->RD_PD .and. x[3] == SRD->RD_SEMANA}) ) > 0
						aPd[nPos,4] := SRD->RD_HORAS
						aPd[nPos,5] += SRD->RD_VALOR
					Else
						SRD->( FMatriz(RD_PD,RD_VALOR,RD_HORAS,RD_SEMANA,RD_CC,RD_TIPO1,RD_TIPO2,,cDel,dDtapg,,RD_SEQ,,RD_ITEM,RD_CLVL ) )
					EndIf
				EndIf
				dbSelectArea("SRD")
				dbSkip()
			EndDo
		EndIf
		For nX := 1 to Len(aPd)
			If aPd[nX,1] $ cCodigos .And. !(aPd[nX,7] $ "I")
				aPd[nX,9] := "D"
			EndIf
			//��������������������������������������������������������������Ŀ
			//� Somente quando For recalculo do 13o salario.				 �
			//����������������������������������������������������������������
			If lRecalc13o
				If aPd[nX,1] == aCodFol[027,1]
					If SRC->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+aCodFol[027,1]))
						aPd[nX,5] := SRC->RC_VALOR
					EndIf
				EndIf
			EndIf
		Next nX
	Else
		If aCPF[z,4] <> "5"
			//��������������������������������������������������������������Ŀ
			//� Se o funcionario processado estiver em situacao normal		 �
			//����������������������������������������������������������������
			nIndexTmp := SRC->(IndexOrd())
			
			SRC->( DbSetOrder(6) ) // RC_FILIAL+RC_MAT+RC_PROCES+RC_ROTEIR+RC_PERIODO+RC_SEMANA                                                                                                       
			SRC->( DbSeek( SRA->( RA_FILIAL + RA_MAT + RA_PROCES) + cRotAux ) )
			While SRC->(!Eof() .And. ( SRA->( RA_FILIAL + RA_MAT + RA_PROCES ) + cRotAux == RC_FILIAL + RC_MAT + RC_PROCES + RC_ROTEIR ) )
				cDel := " "
				//��������������������������������������������������������������Ŀ
				//� Marco com "D" as verbas que serao recalculadas.				 �
				//����������������������������������������������������������������
				If SRC->RC_PD $ cCodigos
					cDel := "D"
				EndIf
				dDtaPg := If(lRecalc13o,CtoD(""),If( Empty(SRC->RC_DATA) .Or. SRC->RC_TIPO2 $ "I*G",dData_Pgto,SRC->RC_DATA))
				FMatriz(SRC->RC_PD,SRC->RC_VALOR,SRC->RC_HORAS,cSemana,SRC->RC_CC,SRC->RC_TIPO1,SRC->RC_TIPO2,0,cDel,If(cDel#'D',dDtaPg,) )
				dbSelectArea( "SRC" )
				dbSkip()
			EndDo
			
			//Restaura o indice que estava anteriormente
			SRC->( DbSetOrder(nIndexTmp) )

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
				SRC->( DbSeek( SRA->( RA_FILIAL + RA_MAT ) ) )
				While SRC->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT )  == RC_FILIAL + RC_MAT )
					cDel := " "
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					If SRC->RC_TIPO2 $ cTipo2_ .and. SRC->RC_SEMANA == cSemana .and. SRC->RC_PD $ cCodigos
						cDel := "D"
					EndIf
					dDtapg := CtoD("")
					If PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_REF13") == 'S'
						If ( nPos := Ascan(aPd,{|X| X[1] == SRC->RC_PD}) ) > 0
							aPd[nPos,4] := SRC->RC_HORAS
							aPd[nPos,5] += SRC->RC_VALOR
						Else
							SRC->( FMatriz(RC_PD,RC_VALOR,RC_HORAS,RC_SEMANA,RC_CC,RC_TIPO1,RC_TIPO2,RC_PARCELA,cDel,dDtapg,,RC_SEQ,RC_ITEM,RC_CLVL ) )
						EndIf
					EndIf
					dbSelectArea("SRC")
					dbSkip()
				EndDo
			EndIf
			If aCPF[z,14] == "S" //Semanalista - Carrega semanas anteriores
				dbSelectArea( "SRD" )
				DbSetOrder(RetOrder("SRD","RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA"))
				
				SRD->( DbSeek( SRA->( RA_FILIAL + RA_MAT + RA_PROCES + cRotAux + cPeriodo ) ) )
				While SRD->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT + RA_PROCES) + cRotAux + cPeriodo  == RD_FILIAL + RD_MAT + RD_PROCES + RD_ROTEIR + RD_PERIODO )
					cDel := " "
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					If SRD->RD_TIPO2 $ cTipo2_ .and. SRD->RD_PD $ cCodigos
						cDel := "D"
					EndIf
					dDtapg := CtoD("")
					If PosSrv(SRD->RD_PD,SRA->RA_FILIAL,"RV_REF13") == 'S'
						If ( nPos := Ascan(aPd,{|X| X[1] == SRD->RD_PD .and. x[3] == SRD->RD_SEMANA}) ) > 0
							aPd[nPos,4] := SRD->RD_HORAS
							aPd[nPos,5] += SRD->RD_VALOR
						Else
							SRD->( FMatriz(RD_PD,RD_VALOR,RD_HORAS,RD_SEMANA,RD_CC,RD_TIPO1,RD_TIPO2,,cDel,dDtapg,,RD_SEQ,RD_ITEM,RD_CLVL ) )
						EndIf
					EndIf
					dbSelectArea("SRD")
					dbSkip()
				EndDo
			EndIf

			If lDissidio
				aPd:= fCarMvto(SRA->RA_FILIAL,SRA->RA_MAT,cSemana,SRA->RA_PROCES,cPeriodo,fGetCalcRot(cTipoRot),cNumPag)
				aNomePd	:= aClone(aPd)
				aPd		:= {}

				dbSelectArea( cAliasDis )

				If cAliasDis == "RHH"
					dbSetOrder( 1 )	// "RHH_FILIAL + RHH_MAT + RHH_MesAno + RHH_DATA + RHH_VB + RHH_CC + RHH_ITEM + RHH_CLVL"
				EndIf

				(cAliasDis)->(	DbSeek( SRA->(RA_FILIAL+RA_MAT) + cMesAnoCalc + MesAno( dDataDe ) ) )

				While (cAliasDis)->( ! Eof() )                                 .And. ;
					  SRA->RA_FILIAL  == (cAliasDis)->&((cAliasDis)+"_FILIAL") .And. ;
					  SRA->RA_MAT     == (cAliasDis)->&((cAliasDis)+"_MAT")    .And. ;
					  cMesAnoCalc     == (cAliasDis)->&((cAliasDis)+"_MesAno") .And. ;
					  MesAno(dDataDe) == (cAliasDis)->&((cAliasDis)+"_DATA")

					//��������������������������������������������������������������Ŀ
					//� Despreza salario base de referencia do dissidio.			 �
					//����������������������������������������������������������������
					If (cAliasDis)->&((cAliasDis)+"_VB") == "000" .Or. cRot	!= (cAliasDis)->&((cAliasDis)+"_ROTEIR")
						(cAliasDis)->( dbSkip() )
						Loop
					EndIf

					cDel := " "

					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					If (cAliasDis)->&((cAliasDis)+"_TIPO2") $ cTipo2_ 		.and. ;
					   (cAliasDis)->&((cAliasDis)+"_SEMANA") == cSemana 	.and. ;
					   (cAliasDis)->&((cAliasDis)+"_VB") $ cCodigos
						cDel := "D"
					EndIf

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
				EndDo
			EndIf

		Else
			//��������������������������������������������������������������Ŀ
			//� Se o funcionario processado estiver demitido				 �
			//����������������������������������������������������������������
			//�������������������������������������������������������������������Ŀ
			//� Pesquiso no cabecalho de rescisao se ja existe rescisao calculada �
			//����������������������������������������������������������������������
			dbselectarea("SRG")
			SRG->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT))
			While !SRG->(eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
				//�������������������������������������������������������������������Ŀ
				//� Se o mes ano da homologacao corrente For igual ao da rescisao	  �
				//� e a data de homologacao For menor ou igual a data de pagto da 2a. �
				//� parc.13o.S considero este movimento da rescisao para o recalculo. �
				//���������������������������������������������������������������������
				If	MesAno(dData_Pgto) == MesAno(SRG->RG_DATAHOM)
					If SRG->RG_DATAHOM > dData_Pgto
						aCPF[z,7] := "2"		// Marco como "nao acumulado" para buscar os valores de inss posteriormente.
					EndIf
					dDataPesq	:= SRG->RG_DTGERAR
					aCpf[z,9]	:= SRG->RG_DTGERAR
				EndIf
				SRG->(dbskip())
			EndDo
			
			//��������������������������������������������������������������Ŀ
			//� Busco as verbas de rescisao quando existir rescisao calculada�
			//� e monto o aPd.												 �
			//����������������������������������������������������������������
			If !Empty(dDataPesq)
				dbselectarea("SRR")
				If SRR->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq)))
					While SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)
						cDel := " "
						//��������������������������������������������������������������Ŀ
						//� Marco com "D" as verbas que serao recalculadas.				 �
						//����������������������������������������������������������������
						If SRR->RR_PD $ cCodigos
							cDel := "D"
						EndIf
						SRR->( FMatriz(RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,"S",0.00,cDel,RR_DATAPAG,," " ) )
						SRR->(DbSkip())
					EndDo
				EndIf
				//��������������������������������������������������������������Ŀ
				//� Ajusta o aPD antes de fazer a copia e soma-lo ao movimento.	 �
				//����������������������������������������������������������������
				fProv132(cCodigos)
			EndIf
		EndIf
	EndIf
	//����������������������������������������������������Ŀ
	//�Busca as verbas de pensao alimenticia da 1a parcela.�
	//������������������������������������������������������
	If aCPF[z,7] == "1"	.and. Len(aPd) > 0	// Somente para matriculas que Foram acumuladas
		fBusCadBenef(@aBenef131,"131",,.F.)
		For nx := 1 to Len(aBenef131)
			//��������������������������������������������������������������Ŀ
			//� Busca a verba de pensao alimenticia da 1a parc.13o salario.  �
			//����������������������������������������������������������������
			If (nValPen1P	:= abs(fBuscaAcm(aBenef131[nx,1],,stod(strzero(year(dDataRef),4)+"0101"),stod(strzero(year(dDataRef),4)+"1231"),"V")) ) > 0
				fMatriz(aBenef131[nx,1],nValPen1P, , , ,"V","S",0.00,"",CTOD(""),.T.," ")
			EndIf
		Next nx
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Quando For calculo de rescisao								 �
	//����������������������������������������������������������������
ElseIf cTipoRot == "4"
	SRC->(DbSetOrder(1))
	//��������������������������������������������������������������Ŀ
	//� Utilizo o aPd salvo no inicio do processamento quando estiver�
	//� acumulando a matricula corrente.							 �
	//����������������������������������������������������������������
	If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
		aPd	:= aClone(aPdCorrent)
		For nx := 1 to Len(aPd)
			If aPd[nx,1] $ cCodigos
				aPd[nx,9] := "D"
			EndIf
		Next nx
	Else
	//�������������������������������������������������������������������Ŀ
	//� Pesquiso no cabecalho de rescisao se ja existe rescisao calculada �
	//����������������������������������������������������������������������
		dbselectarea("SRG")
		SRG->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT))
		While !SRG->(Eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
			//�������������������������������������������������������������������Ŀ
			//� Se o mes ano da homologacao corrente For igual ao da rescisao	  �
			//� pesquisada considero este movimento da rescisao para o recalculo. �
			//���������������������������������������������������������������������
			If	MesAno(dData_Pgto) == MesAno(SRG->RG_DATAHOM)
				//��������������������������������������������������������������Ŀ
				//� Se a data de homologacao da rescisao pesquisada For igual a	 �
				//� data de homologacao da matricula corrente calculada, altero	 �
				//� a situacao desta matricula para proporcionalizar os valores	 �
				//� entre as matriculas.										 �
				//����������������������������������������������������������������
				If dData_Pgto == SRG->RG_DATAHOM
					aCPF[z,4]	:= "1"
				EndIf
				dDataPesq	:= SRG->RG_DTGERAR
				aCpf[z,9]	:= SRG->RG_DTGERAR
			EndIf
			SRG->(dbskip())
		EndDo

		//��������������������������������������������������������������Ŀ
		//� Busco as verbas de rescisao quando existir rescisao calculada�
		//� e monto o aPd.												 �
		//����������������������������������������������������������������
		If !Empty(dDataPesq)
			dbselectarea("SRR")
			If SRR->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq)))
				While SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)
					cDel := " "
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					IF SRR->RR_PD $cCodigos
						cDel := "D"
					EndIf
					SRR->( FMatriz(RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00,cDel,RR_DATAPAG,,RR_SEQ ) )
					SRR->(DBSKIP())
				EndDo
			EndIf

			//��������������������������������������������������������������Ŀ
			//� Se nao tiver incluido nenhuma verba no aPd nao deve buscar a �
			//� pensao alimenticia da 1a. parcela do 13o salario.			 �
			//����������������������������������������������������������������
			If Len(aPd) == 0
				lBusPen131	:= .F.
			EndIf
		Else
			//������������������������������������������������������������������������������������Ŀ
			//� Quando nao existir rescisao calculada. Busco o movimento mensal deste funcionario. �
			//��������������������������������������������������������������������������������������
			fCaraPdR(.F., Nil )  
			
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
				If cMesAnoRef == MesAno(dDataDem)
					If SRR->(DbSeek(ACPF[Z,2]+ACPF[Z,3]+"F"+DTOS(dDtBusFer)+aCodFol[065,1]))
						SRR->(fMatriz(	RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00,"",RR_DATAPAG,.T.," "))
					EndIf
					If SRR->(DbSeek(ACPF[Z,2]+ACPF[Z,3]+"F"+DTOS(dDtBusFer)+aCodFol[013,1]))
						SRR->(fMatriz(	RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,"K",0.00,"",RR_DATAPAG,.T.," "))
					EndIf
				EndIf
				aCpf[z,4] := "5"	// Modifico a situacao para "Demitido" para nao ratear as diferencas encontradas para esta matricula
				//��������������������������������������������������������������Ŀ
				//� Ajusta o aPD antes de fazer a copia e soma-lo ao movimento.	 �
				//����������������������������������������������������������������
				fProvRes(cCodigos,"FER")
				aEval(aPd,{|x| aAdd(aPdAux,aClone(X)) } )
				aPd		:= {}
			EndIf

			//��������������������������������������������������������������Ŀ
			//� Pesquisa se ja possui 13o calculado.						 �
			//����������������������������������������������������������������
			dbSelectArea( "SRC" )
			DbSetOrder(RetOrder("SRC","RC_FILIAL+RC_MAT+RC_PROCES+RC_ROTEIR+RC_PERIODO+RC_SEMANA"))
			//��������������������������������������������������������������Ŀ
			//� Pesquisa a verba de base de ir do 13o salario.				 �
			//����������������������������������������������������������������
			If DbSeek( SRA->RA_FILIAL + SRA->RA_MAT + cProcesso + fGetCalcRot("6")+cPeriodo)
				If MesAno(dData_Pgto) == MesAno(SRC->RC_DATA)
					//��������������������������������������������������������������Ŀ
					//� Posiciona na 1a verba da matricula corrente.				 �
					//����������������������������������������������������������������
					While ! Eof() .And. ( SRA->RA_FILIAL + SRA->RA_MAT + cProcesso + fGetCalcRot("6") + cPeriodo == SRC->RC_FILIAL + SRC->RC_MAT + SRC->RC_PROCES + SRC->RC_ROTEIR + SRC->RC_PERIODO )
						cDel := " "
						//��������������������������������������������������������������Ŀ
						//� Marca com "D" as verbas que serao recalculadas.				 �
						//����������������������������������������������������������������
						If SRC->RC_PD $ cCodigos
							cDel := "D"
						EndIf
						dDtaPg := If( Empty(SRC->RC_DATA) .Or. SRC->RC_TIPO2 $ "I*G",dData_Pgto,SRC->RC_DATA)
						FMatriz(SRC->RC_PD,SRC->RC_VALOR,SRC->RC_HORAS,SRC->RC_SEMANA,SRC->RC_CC,SRC->RC_TIPO1,SRC->RC_TIPO2,0,cDel,dDtaPg )
						dbSelectArea( "SRC" )
						dbSkip()
					EndDo
				EndIf
			EndIf
			
			If aCPF[z,14] == "S" //Semanalista - Carrega semanas anteriores
				dbSelectArea( "SRD" )
				DbSetOrder(RetOrder("SRD","RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA"))
				
				SRD->( DbSeek( SRA->( RA_FILIAL + RA_MAT + RA_PROCES + fGetCalcRot("6") + cPeriodo ) ) )
				While SRD->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT + RA_PROCES ) + fGetCalcRot("6") + cPeriodo  == RD_FILIAL + RD_MAT + RD_PROCES + RD_ROTEIR + RD_PERIODO )
					cDel := " "
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					If SRD->RD_PD $ cCodigos
						cDel := "D"
					EndIf
					dDtaPg := dData_Pgto
					If ( nPos := Ascan(aPd,{|X| X[1] == SRD->RD_PD  .and. x[3] == SRD->RD_SEMANA}) ) > 0
						aPd[nPos,4] := SRD->RD_HORAS
						aPd[nPos,5] += SRD->RD_VALOR
					Else
						SRD->( FMatriz(RD_PD,RD_VALOR,RD_HORAS,RD_SEMANA,RD_CC,RD_TIPO1,RD_TIPO2,,cDel,dDtapg,,RD_SEQ,RD_ITEM,RD_CLVL ) )
					EndIf
					dbSelectArea("SRD")
					dbSkip()
				EndDo
			EndIf
			
			dbselectarea("SRA")
			SRC->(DbSetOrder(1))
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
			EndIf
		EndIf
	EndIf
	//����������������������������������������������������Ŀ
	//�Busca as verbas de pensao alimenticia da 1a parcela.�
	//������������������������������������������������������
	If lBusPen131			// Somente para matriculas que Foram acumuladas
		fBusCadBenef(@aBenef131,"131",,.F.)
		For nx := 1 to Len(aBenef131)
			//��������������������������������������������������������������Ŀ
			//� Busca a verba de pensao alimenticia da 1a parc.13o salario.  �
			//����������������������������������������������������������������
			If (nValPen1P	:= abs(fBuscaAcm(aBenef131[nx,1],,stod(strzero(year(dDataDem),4)+"0101"),stod(strzero(year(dDataDem),4)+"1231"),"V")) ) > 0
				fMatriz(aBenef131[nx,1],nValPen1P, , , ,"V","S",0.00,"",CTOD(""),.T.," ")
			EndIf
		Next nx
	EndIf
//��������������������������������������������������������������Ŀ
//� Quando For calculo de ferias								 �
//����������������������������������������������������������������
ElseIf cTipoRot == "3"
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
			For nx := 1 to Len(aPd)
				If (aPd[nx,1] $ cCodigos) .AND. !(aPd[nX,7] $ "I")
					aPd[nx,9] := "D"
				EndIf
			Next nx
		Else
	
		//�������������������������������������������������������������������Ŀ
		//� Pesquiso no cabecalho de ferias se ja existem ferias calculadas	  �
		//���������������������������������������������������������������������
			dbselectarea("SRH")
			SRH->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT))
			While !SRH->(eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRH->RH_FILIAL+SRH->RH_MAT
				If	MesAno(dData_Pgto) == MesAno(M->RH_DTRECIB)
					dDataPesq	:= M->RH_DTRECIB
					aCpf[z,9]	:= M->RH_DTRECIB
				EndIf
				SRH->(dbskip())
			EndDo
	
			//��������������������������������������������������������������Ŀ
			//� Busco as verbas de ferias quando existir ferias calculada	 �
			//� e monto o aPd.							    					 �
			//����������������������������������������������������������������
			If !Empty(dDataPesq)
				dbselectarea("SRR")
				dbSetOrder(5) //Filial + Matricula + Dt do Recibo de Ferias(RR_DATAPAG) + Verba
				If SRR->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+DTOS(dDataPesq)))
					While SRA->RA_FILIAL+SRA->RA_MAT+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+DTOS(SRR->RR_DATAPAG)
						If SRR->RR_TIPO3 == "F"
							cDel := " "
							If SRR->RR_PD $cCodigos
								cDel := "D"
							EndIf
						EndIf
						SRR->( FMatriz(RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00,cDel,RR_DATAPAG,," " ) )
						SRR->(DbSkip())
					EndDo
				EndIf 
			EndIf
		EndIf
	Else
	//��������������������������������������������������������������Ŀ
	//� Quando a matricula estiver demitida.						 �
	//����������������������������������������������������������������
		//�������������������������������������������������������������������Ŀ
		//� Pesquiso no cabecalho de rescisao se ja existe rescisao calculada �
		//���������������������������������������������������������������������
		dbselectarea("SRG")
		SRG->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT))
		While !SRG->(eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
			//�����������������������������������������������������������������������������Ŀ
			//� Se a data da homologacao tiver ocorrido antes do pagamento do adiantamento. �
			//�������������������������������������������������������������������������������
			If	MesAno(dData_Pgto) == MesAno(SRG->RG_DATAHOM)
				dDataPesq	:= SRG->RG_DTGERAR
				aCpf[z,9]	:= SRG->RG_DTGERAR
			EndIf
			SRG->(DBSKIP())
		EndDo
		//��������������������������������������������������������������Ŀ
		//� Busco as verbas de rescisao quando existir rescisao calculada�
		//� e monto o aPd.												 �
		//����������������������������������������������������������������
		If !Empty(dDataPesq)
			dbselectarea("SRR")
			If SRR->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq)))
				While SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)
					//����������������������������������������������������������Ŀ
					//� Busco as verbas de Base IR Ferias e Dif.Base Ir Ferias	 �
					//������������������������������������������������������������
					If ( SRR->RR_PD $aCodFol[016,1]+","+aCodFol[100,1] ) .and. aCodFol[236,1] <> space(3)
						If (nPos := ascan(aPd,{|X| x[1] == aCodFol[236,1] .and. x[9] <> "D"})) > 0
							aPd[nPos,4]	+= SRR->RR_HORAS
							aPd[nPos,5]	+= SRR->RR_VALOR
						Else
							SRR->( FMatriz(aCodFol[236,1],RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00," ",RR_DATAPAG,," " ) )
						EndIf
					EndIf
					//����������������������������������������������������������Ŀ
					//� Busco as verbas de IR Ferias e Dif. Ir Ferias			 �
					//������������������������������������������������������������
					If ( SRR->RR_PD $aCodFol[067,1]+","+aCodFol[101,1] ) .and. aCodFol[237,1] <> space(3)
						If (nPos := ascan(aPd,{|X| x[1] == aCodFol[237,1] .and. x[9] <> "D"})) > 0
							aPd[nPos,4]	+= SRR->RR_HORAS
							aPd[nPos,5]	+= SRR->RR_VALOR
						Else
							SRR->( FMatriz(aCodFol[237,1],RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00," ",RR_DATAPAG,," " ) )
						EndIf
					EndIf
					//����������������������������������������������������������Ŀ
					//� Busco as verbas de base de inss ate o limite e acima	 �
					//������������������������������������������������������������
					If ( SRR->RR_PD $aCodFol[013,1]+","+aCodFol[014,1] ) .and. aCodFol[396,1] <> space(3) .and. ;
						( MesAno(M->RH_DATAINI) == MesAno(dDataPesq) )
						If (nPos := ascan(aPd,{|X| x[1] == aCodFol[396,1] .and. x[9] <> "D"})) > 0
							aPd[nPos,4]	+= SRR->RR_HORAS
							aPd[nPos,5]	+= SRR->RR_VALOR
						Else
							SRR->( FMatriz(aCodFol[396,1],RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00," ",RR_DATAPAG,," " ) )
						EndIf
					EndIf
					//����������������������������������������������������������Ŀ
					//� Busco as verbas de inss s/folha e inss s/ferias			 �
					//������������������������������������������������������������
					If ( SRR->RR_PD $aCodFol[064,1]+","+aCodFol[065,1] ) .and. aCodFol[397,1] <> space(3) .and. ;
						( MesAno(M->RH_DATAINI) == MesAno(dDataPesq) )
						If (nPos := ascan(aPd,{|X| x[1] == aCodFol[397,1] .and. x[9] <> "D"})) > 0
							aPd[nPos,4]	+= SRR->RR_HORAS
							aPd[nPos,5]	+= SRR->RR_VALOR
						Else
							SRR->( FMatriz(aCodFol[397,1],RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00," ",RR_DATAPAG,," " ) )
						EndIf
					EndIf
					SRR->(DBSKIP())
				EndDo
			EndIf
		EndIf
	EndIf
//��������������������������������������������������������������Ŀ
//� Quando For adiantamento e funcionario demitido.				 �
//����������������������������������������������������������������
ElseIf cTipoRot == "2" .and. aCPF[z,4] == "5"
	//�������������������������������������������������������������������Ŀ
	//� Pesquiso no cabecalho de rescisao se ja existe rescisao calculada �
	//���������������������������������������������������������������������
	dbselectarea("SRG")
	SRG->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT))
	While !SRG->(eof()) .and. SRA->RA_FILIAL+SRA->RA_MAT == SRG->RG_FILIAL+SRG->RG_MAT
		//�����������������������������������������������������������������������������Ŀ
		//� Se a data da homologacao tiver ocorrido antes do pagamento do adiantamento. �
		//�������������������������������������������������������������������������������
		If	MesAno(dData_Pgto) == MesAno(SRG->RG_DATAHOM) .and. SRG->RG_DATAHOM <= dData_Pgto
			dDataPesq	:= SRG->RG_DTGERAR
			aCpf[z,9]	:= SRG->RG_DTGERAR
		EndIf
		SRG->(DBSKIP())
	EndDo
	//��������������������������������������������������������������Ŀ
	//� Busco as verbas de rescisao quando existir rescisao calculada�
	//� e monto o aPd.												 �
	//����������������������������������������������������������������
	If !Empty(dDataPesq)
		dbselectarea("SRR")
		If SRR->(DbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq)))
			While SRA->RA_FILIAL+SRA->RA_MAT+"R"+DTOS(dDataPesq) == SRR->RR_FILIAL+SRR->RR_MAT+SRR->RR_TIPO3+DTOS(SRR->RR_DATA)
				cDel := " "
				//��������������������������������������������������������������Ŀ
				//� Marco com "D" as verbas que serao recalculadas.				 �
				//����������������������������������������������������������������
				IF SRR->RR_PD $cCodigos
					cDel := "D"
				EndIf
				SRR->( FMatriz(RR_PD,RR_VALOR,RR_HORAS,RR_SEMANA,RR_CC,RR_TIPO1,RR_TIPO2,0.00,cDel,RR_DATAPAG,," " ) )
				SRR->(DBSKIP())
			EndDo
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Ajusta o aPD antes de fazer a copia e soma-lo ao movimento.	 �
		//� Somente quando For adiantamento salarial.					 �
		//����������������������������������������������������������������
		fProvAdi()
	EndIf
//��������������������������������������������������������������������Ŀ
//� Quando For funcionario em sitacao normal para folha e adiantamento �
//����������������������������������������������������������������������
Else
	//��������������������������������������������������������������Ŀ
	//� Utilizo o aPd salvo no inicio do processamento quando estiver�
	//� acumulando a matricula corrente.							 �
	//����������������������������������������������������������������
	If SRA->RA_FILIAL+SRA->RA_MAT == cFilMatCor
		aPd	:= aClone(aPdCorrent)
		For nx := 1 to Len(aPd)
			//��������������������������������������������������������������Ŀ
			//� Marco com "D" as verbas que serao recalculadas.				 �
			//����������������������������������������������������������������
			If ( aPd[nx,1] $ cCodigos ) .And. ( cSemana == aPd[nx,3] ) .And. !(aPd[nX,7] $ "I") .And. !(cInssFM $ "S*R" .And. aPd[nX,7] == "K")
				aPd[nx,9] := "D"
			EndIf
		Next nx
		
		If aCPF[z,14] == "S" //Semanalista - Carrega semanas anteriores
			dbSelectArea( "SRD" )
			DbSetOrder(RetOrder("SRD","RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA"))
			
			SRD->( DbSeek( SRA->( RA_FILIAL + RA_MAT + RA_PROCES + cRotAux + cPeriodo ) ) )
			While SRD->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT + RA_PROCES ) + cRotAux + cPeriodo  == RD_FILIAL + RD_MAT + RD_PROCES + RD_ROTEIR + RD_PERIODO )
				cDel := " "
				//��������������������������������������������������������������Ŀ
				//� Marco com "D" as verbas que serao recalculadas.				 �
				//����������������������������������������������������������������
				If SRD->RD_TIPO2 $ cTipo2_ .and. SRD->RD_PD $ cCodigos
					cDel := "D"
				EndIf
				dDtapg := dData_Pgto
				If ( nPos := Ascan(aPd,{|X| X[1] == SRD->RD_PD .and. x[3] == SRD->RD_SEMANA}) ) > 0
					aPd[nPos,4] := SRD->RD_HORAS
					aPd[nPos,5] += SRD->RD_VALOR
				Else
					SRD->( FMatriz(RD_PD,RD_VALOR,RD_HORAS,RD_SEMANA,RD_CC,RD_TIPO1,RD_TIPO2,,cDel,dDtapg,,RD_SEQ,RD_ITEM,RD_CLVL ) )
				EndIf
				dbSelectArea("SRD")
				dbSkip()
			EndDo
		EndIf
		//���������������������������������������������������������������������������Ŀ
		//� Testa a existencia da verba de base de ir de adiantamento para considerar �
		//� as verbas desta matricula para o calculo.								  �
		//�����������������������������������������������������������������������������
		If cTipoRot == "2" .And. aCPF[z,4] <> "3"
			If Ascan(aPd,{|X| X[1] == aCodFol[010,1] .And. X[3] == cSemana}) == 0
				aPd	:= {}
			EndIf
		//���������������������������������������������������������������������������Ŀ
		//� Testa a existencia da verba de base de ir               o para considerar �
		//� as verbas desta matricula para o calculo.								  �
		//�����������������������������������������������������������������������������
		ElseIf cTipoRot $ "1*9" .And. aCPF[z,4] <> "3" .And. !lDissidio
			If Ascan(aPd,{|X| X[1] == aCodFol[015,1] .And. ( X[3] == cSemana .or. aCPF[z,14] == "S")}) == 0
				aCPF[z,8] := .F.
			EndIf
		EndIf
	Else
		//��������������������������������������������������������������Ŀ
		//� Se o funcionario processado estiver demitido buscaremos a	 �
		//� rescisao no arquivo de rescisao.							 �
		//����������������������������������������������������������������
		If aCPF[z,4] == "5"	
			GeraResc( cAnoMes , cSemana , @lGerou_ )
			If lGerou_
				For nx := 1 to Len(aPd)
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					If aPd[nx,1] $ cCodigos
						aPd[nx,9] := "D"
					EndIf
				Next nx
			EndIf
		Else
			//��������������������������������������������������������������Ŀ
			//� Se o funcionario processado estiver em situacao normal		 �
			//����������������������������������������������������������������
			dbSelectArea( "SRC" )
			dbSetOrder(6) // RC_FILIAL+RC_MAT+RC_PROCES+RC_ROTEIR+RC_PERIODO+RC_SEMANA                                                                                                       
			SRC->( DbSeek( SRA->( RA_FILIAL + RA_MAT + RA_PROCES) + cRotAux + cPeriodo + cSemana  ) )
			While SRC->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT + RA_PROCES ) + cRotAux + cPeriodo + cSemana == RC_FILIAL + RC_MAT + RC_PROCES + cRotAux + RC_PERIODO + RC_SEMANA )
				If SRC->RC_ROTEIR $ cRotAux
					cDel := " " 
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					If SRC->RC_TIPO2 $ cTipo2_ .and. ( SRC->RC_SEMANA == cSemana .or. aCPF[z,14] == "S" ) .and. SRC->RC_PD $ cCodigos
						cDel := "D"
						If nProc1 == 1 .and. aCPF[z,5] == "A" //somente se For autonomo e optou pelo processamento
							aCpf[z,4]	:= "5"			// marca o recibo antigo como demitido para que as verbas nao sejam alteradas	
						EndIf
					EndIf
					dDtapg := SRC->( IF( ( Empty(RC_DATA) .And. !RC_PD $ aCodFol[106,1]+'*'+aCodFol[107,1]) .or. aCPF[z,14] == "S",dData_Pgto,RC_DATA) )
					SRC->( FMatriz(RC_PD,RC_VALOR,RC_HORAS,RC_SEMANA,RC_CC,RC_TIPO1,RC_TIPO2,RC_PARCELA,cDel,dDtapg,,RC_SEQ,RC_QTDSEM,RC_ITEM, RC_CLVL ) )
					dbSelectArea("SRC")
				EndIf
				dbSkip()
			EndDo
			
			If aCPF[z,14] == "S" //Semanalista - Carrega semanas anteriores
				dbSelectArea( "SRD" )
				DbSetOrder(RetOrder("SRD","RD_FILIAL+RD_MAT+RD_PROCES+RD_ROTEIR+RD_PERIODO+RD_SEMANA"))
				
				SRD->( DbSeek( SRA->( RA_FILIAL + RA_MAT + RA_PROCES + cRotAux + cPeriodo ) ) )
				While SRD->( !Eof() .And. SRA->( RA_FILIAL + RA_MAT + RA_PROCES ) + cRotAux + cPeriodo  == RD_FILIAL + RD_MAT + RD_PROCES + RD_ROTEIR + RD_PERIODO )
					cDel := " "
					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					If SRD->RD_TIPO2 $ cTipo2_ .and. SRD->RD_PD $ cCodigos
						cDel := "D"
					EndIf
					dDtapg := dData_Pgto
					If ( nPos := Ascan(aPd,{|X| X[1] == SRD->RD_PD .and. x[3] == SRD->RD_SEMANA}) ) > 0
						aPd[nPos,4] := SRD->RD_HORAS
						aPd[nPos,5] += SRD->RD_VALOR
					Else
						SRD->( FMatriz(RD_PD,RD_VALOR,RD_HORAS,RD_SEMANA,RD_CC,RD_TIPO1,RD_TIPO2,,cDel,dDtapg,,RD_SEQ,RD_ITEM,RD_CLVL ) )
					EndIf
					dbSelectArea("SRD")
					dbSkip()
				EndDo
			EndIf
		
			If lDissidio
				aPd:= fCarMvto(SRA->RA_FILIAL,SRA->RA_MAT,cSemana,SRA->RA_PROCES,cPeriodo,fGetCalcRot(cTipoRot),cNumPag)
				aNomePd	:= aClone(aPd)
				aPd		:= {}

				dbSelectArea( cAliasDis )

				If cAliasDis == "RHH"
					dbSetOrder( 1 )	// "RHH_FILIAL + RHH_MAT + RHH_MesAno + RHH_DATA + RHH_VB + RHH_CC + RHH_ITEM + RHH_CLVL"
				EndIf

				(cAliasDis)->(	DbSeek( SRA->(RA_FILIAL+RA_MAT) + cMesAnoCalc + MesAno( dDataDe ) ) )

				While (cAliasDis)->( ! Eof() )                                 .And. ;
					  SRA->RA_FILIAL  == (cAliasDis)->&((cAliasDis)+"_FILIAL") .And. ;
					  SRA->RA_MAT     == (cAliasDis)->&((cAliasDis)+"_MAT")    .And. ;
					  cMesAnoCalc     == (cAliasDis)->&((cAliasDis)+"_MesAno") .And. ;
					  MesAno(dDataDe) == (cAliasDis)->&((cAliasDis)+"_DATA")

					//��������������������������������������������������������������Ŀ
					//� Despreza salario base de referencia do dissidio.			 �
					//����������������������������������������������������������������
					If (cAliasDis)->&((cAliasDis)+"_VB") == "000" .Or. cRot != (cAliasDis)->&((cAliasDis)+"_ROTEIR")
						(cAliasDis)->( dbSkip() )
						Loop
					EndIf

					cDel := " "

					//��������������������������������������������������������������Ŀ
					//� Marco com "D" as verbas que serao recalculadas.				 �
					//����������������������������������������������������������������
					If (cAliasDis)->&((cAliasDis)+"_TIPO2") $ cTipo2_ 		.and. ;
					   (cAliasDis)->&((cAliasDis)+"_SEMANA") == cSemana 	.and. ;
					   (cAliasDis)->&((cAliasDis)+"_VB") $ cCodigos
						cDel := "D"
					EndIf

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
				EndDo
			EndIf

			//���������������������������������������������������������������������������Ŀ
			//� Testa a existencia da verba de base de ir de adiantamento para considerar �
			//� as verbas desta matricula para o calculo.								  �
			//�����������������������������������������������������������������������������
			If cTipoRot == "2" .And. aCPF[z,4] <> "3"
				If Ascan(aPd,{|X| X[1] == aCodFol[010,1] .And. X[3] == cSemana}) == 0
					aPd	:= {}
				EndIf

			//���������������������������������������������������������������������������Ŀ
			//� Testa a existencia da verba de base de ir               o para considerar �
			//� as verbas desta matricula para o calculo.								  �
			//�����������������������������������������������������������������������������
			ElseIf cTipoRot $ "1*9" .And. aCPF[z,4] <> "3"
				If (!lDissidio .And. Ascan(aPd,{|X| X[1] == aCodFol[015,1] .And. ( X[3] == cSemana .or. aCPF[z,14] == "S" )}) == 0) .Or.;
					(lDissidio .And. Ascan(aPd,{|X| X[1] == aCodFol[013,1] .And. ( X[3] == cSemana .or. aCPF[z,14] == "S" )}) == 0)
					aCPF[z,8] := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

//��������������������������������������������������������������Ŀ
//� Exclui as verbas de INSS de outras empresas quando as verbas �
//� nao tiverem sido inFormadas ou geradas pelo usuario.		 �
//����������������������������������������������������������������
If cTipoRot $ "1*9"
	aEval(aPd,{ |X| x[9] := If( x[1] $ aCodFol[288,1]+","+aCodFol[289,1] .and. !x[7]$"I,G","D",x[9] ) } )
ElseIf cTipoRot == "6"
	aEval(aPd,{ |X| x[9] := If( x[1] $ aCodFol[290,1]+","+aCodFol[291,1] .and. !x[7]$"I,G","D",x[9] ) } )
EndIf          

RestArea(aSRCArea)
RestArea(aArea)

Return( aNomePd )

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

Local aAreaSRR	:= SRR->(GetArea())	// Salva a area do arquivo de itens de ferias e rescisoes.
Local nx 		:= 0					// variavel de loop

dbselectarea("SRR")
//���������������������������������������������������������Ŀ
//� Processa a atualizacao dos itens de ferias e rescisoes. �
//�����������������������������������������������������������
For nx := 1 to Len(aPd)
	//���������������������������������������������������������Ŀ
	//� Somente para as verbas que sofadmireram recalculo e rateio. �
	//�����������������������������������������������������������
	If aPd[nx,1] $ cCodigos
		//���������������������������������������������������������Ŀ
		//� Se a verba existir no movimento.						�
		//�����������������������������������������������������������
		If cTipo == "F"
			lRet1:= DbSeek(aCpf[z,2]+aCpf[z,3]+dtos(aCpf[z,9])+aPd[nx,1]) .And.	SRR->RR_TIPO3 == cTipo
		Else
			lRet1:= DbSeek(aCpf[z,2]+aCpf[z,3]+cTipo+dtos(aCpf[z,9])+aPd[nx,1])
		Endif
		
		If lRet1
			Reclock("SRR",.F.)
			//������������������������������������������������������������������Ŀ
			//� Se a verba estiver excluida no movimento excluo no arquivo tambem�
			//��������������������������������������������������������������������
			If aPd[nx,5] == 0 .or. aPd[nx,9] == "D"
				dbdelete()
			Else
			//������������������������������������������������������������������Ŀ
			//� Se nao, atualizo os campos de horas e valor						 �
			//��������������������������������������������������������������������
				SRR->RR_HORAS	:= aPd[nx,4]
				SRR->RR_VALOR	:= aPd[nx,5]
			EndIf
			Msunlock()
		
		Else
		//���������������������������������������������������������������������������������������Ŀ
		//� Se a verba nao existir no movimento e nao estiver excluida, incluo a verba no arquivo.�
		//�����������������������������������������������������������������������������������������
			If aPd[nx,5] <> 0 .and. aPd[nx,9] <> "D"
				Reclock("SRR",.t.)
				SRR->RR_FILIAL	:= aCpf[z,2]		//Filial
				SRR->RR_MAT		:= aCpf[z,3]		//Matricula
				SRR->RR_PD		:= aPd[nx,1]		//Verba
				SRR->RR_PROCES	:= SRA->RA_PROCES // Processo
				SRR->RR_ROTEIR	:= cRot	// Roteiro
				SRR->RR_PERIODO	:= cPeriodo	// Periodo				
				SRR->RR_SEMANA	:= cSemana	// Semana
				SRR->RR_VALOR	:= aPd[nx,5]		//Valor
				SRR->RR_HORAS	:= aPd[nx,4]		//Horas
				SRR->RR_TIPO1	:= aPd[nx,6]		//Tipo da Verba ( D,H,V )
				SRR->RR_TIPO2	:= aPd[nx,7]		//Origem do Calculo
				If cTipo == "F"
					SRR->RR_DATA	:= M->RH_DATAINI	//Data de Geracao(SRH) - Data Inicial das Ferias(SRR)
					SRR->RR_DATAPAG	:= If(Empty(aCpf[z,9]),M->RH_DTRECIB,aCpf[z,9])		//Data de Pagamento(SRH) - Data de Recibo de Ferias(SRR)
				Else
					SRR->RR_DATA	:= aCpf[z,9]		//Data de Geracao
					SRR->RR_DATAPAG	:= dData_Pgto		//Data de Pagamento
				Endif
				SRR->RR_CC		:= aPd[nx,2]		//Centro de Custo
				SRR->RR_Tipo3	:= cTipo
				Msunlock()
			EndIf
		EndIf
	EndIf
Next nx

//����������������������������������������������Ŀ
//�Retorna a area dos itens de ferias e rescisoes�
//������������������������������������������������
RestArea(aAreaSRR)

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
Static Function fProvRes(cCodigos,cTipo,lBusPen131)

Local aAux		:= aClone(aPd)	// Salvo o aPd para ajustar as verbas que serao consideradas.
Local cCodAux	:= aCodFol[106,1]+","+aCodFol[107,1]+","+aCodFol[010,1]+","+aCodFol[012,1] // Base ir mes ant / ir mes ant / Base ir Adt / Ir Adt
Local cTipo2	:= "K*V*I"		// Indica o Status "K" (Ferias) para recalcular o ir de ferias na rescisao
								// quando a matricula corrente tiver movimento de ferias no mes.
								// "V" sao as verbas que vieram do fechamento - "I" sao as verbas que Foram inFormadas pelo usuario
Local cTipo13	:= "S*I"		// Indica o Status "S" (Segunda parcela do 13o salario) para recalcular o ir de 13o salario.
Local lIncFerias:= .F.
Local lInc13oSal:= .F.
Local nElement	:= 0			// Variavel utilizada para loop
Local nPos		:= 0			// variavel de posicionamento de array
Local nPos1		:= 0			// variavel de posicionamento de array
Local nx		:= 0			// Variavel utilizada para loop

aPd			:= {}
nElement	:= Len(aAux)

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
		EndIf
		//��������������������������������������Ŀ
		//�Tratamento da base de ir 13o salario	 �
		//����������������������������������������
		If aAux[nx,1] == aCodFol[027,1]
			aAux[nx,9] := " "
		EndIf

		aAdd(aPd,aClone(aAux[nx]))
	EndIf

Next nx

aAux		:= aClone(aPd)
aPd			:= {}
nElement	:= Len(aAux)

//����������������������������������������������Ŀ
//�Preparacao do array para processamento.		 �
//������������������������������������������������
For nx := 1 to nElement
	If !(aAux[nx,1] $aCodFol[010,1]+","+aCodFol[016,1]+","+aCodFol[027,1] ) .and. !(aAux[nx,7] == "V") 
		aAux[nx,9]	:= "D"
	EndIf
Next nx

If cTipo == "FOL"
	//����������������������������������������������Ŀ
	//�Pesquisa se a verba de base de ir do Adto     �
	//�esta no mesmo mes de pagamento que a rescisao �
	//�corrente que esta sendo processada.           �
	//������������������������������������������������
	If (nPos := aScan(aAux,{|X| X[1] == aCodFol[010,1] .and. X[9] <> "D"} )) > 0
		aAux[nPos,9]	:= "D"
		If MesAno(dData_pgto) == MesAno(aAux[nPos,10])
			For nx := 1 to nElement
				//����������������������������������������������������������������������������Ŀ
				//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
				//������������������������������������������������������������������������������
				If aAux[nx,1] $cCodAux
					aAux[nx,9] := " "
				EndIf
			Next nx
		EndIf
	//����������������������������������������������Ŀ
	//�Pesquisa se a verba de base de ir do mes ante-�
	//�rior quando nao encontrar a base de ir do adto�
	//������������������������������������������������
	ElseIf (nPos := aScan(aAux,{|X| X[1] == aCodFol[106,1] .and. X[9] <> "D"} )) > 0
		aAux[nPos,9] := "D"
		If MesAno(dData_pgto) == MesAno(aAux[nPos,10])
			For nx := 1 to nElement
				//����������������������������������������������������������������������������Ŀ
				//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
				//������������������������������������������������������������������������������
				If aAux[nx,1] $cCodAux
					aAux[nx,9] := " "
				EndIf
			Next nx
		EndIf
	EndIf
EndIf

If cTipo == "FER"
	//����������������������������������������������Ŀ
	//�Pesquisa se as verbas de ferias estao no mesmo�
	//�mes de pagamento que a rescisao corrente que  �
	//�esta sendo processada.						 �
	//������������������������������������������������
	If (nPos := aScan(aAux,{|X| X[1] == aCodFol[016,1] .and. X[9] <> "D"} )) > 0
		aAux[nPos,9] := "D"
		If ( lIncFerias := MesAno(dData_pgto) == MesAno(aAux[nPos,10]) ) // indica que as ferias estao no mesmo mes/ano de pagamento da rescisao
			For nx := 1 to nElement
				//����������������������������������������������������������������������������Ŀ
				//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
				//������������������������������������������������������������������������������
				If aAux[nx,7] $ cTipo2 .and. ! (aAux[nx,1] $ cCodigos)
					aAux[nx,9] := " "
				EndIf
			Next nx
		//��������������������������������������Ŀ
		//�Tratamento do inss de ferias.		 �
		//����������������������������������������
		ElseIf (nPos := aScan(aAux,{|X| X[1] == aCodFol[065,1] .and. X[7] $cTipo2 } )) > 0
			aAux[nPos,1] := aCodFol[289,1]
			aAux[nPos,9] := " "
			If (nPos := aScan(aAux,{|X| X[1] == aCodFol[013,1] .and. X[7] $cTipo2 } )) > 0
				aAux[nPos,1] := aCodFol[288,1]
				aAux[nPos,7] := "I"
				aAux[nPos,9] := " "
			EndIf
		EndIf
	//��������������������������������������Ŀ
	//�Tratamento do inss de ferias.		 �
	//����������������������������������������
	ElseIf (nPos := aScan(aAux,{|X| X[1] == aCodFol[065,1] .and. X[7] $cTipo2 } )) > 0
		aAux[nPos,1] := aCodFol[289,1]
		aAux[nPos,9] := " "
		If (nPos := aScan(aAux,{|X| X[1] == aCodFol[013,1] .and. X[7] $cTipo2 } )) > 0
			aAux[nPos,1] := aCodFol[288,1]
			aAux[nPos,7] := "I"
			aAux[nPos,9] := " "
		EndIf
	EndIf
EndIf

If cTipo == "132"
	//����������������������������������������������Ŀ
	//�Pesquisa se as verbas de 13o salario estao no �
	//�mesmo mes de pagamento que a rescisao corrente�
	//�que esta sendo processada.					 �
	//������������������������������������������������
	If (nPos := aScan(aAux,{|X| X[1] == aCodFol[027,1] .and. X[9] <> "D"} )) > 0
		aAux[nPos,9] := "D"
		If MesAno(dData_pgto) == MesAno(aAux[nPos,10])			// indica que o 13o salario esta no mesmo mes/ano de pagamento da rescisao
			If ( lInc13oSal := aAux[nPos,10] <= dData_Pgto )	// indica que o 13o salario foi pago depois da recisao
				For nx := 1 to nElement
					//����������������������������������������������������������������������������Ŀ
					//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
					//������������������������������������������������������������������������������
					If aAux[nx,7] $cTipo13 .and. ! (aAux[nx,1] $cCodigos)
						aAux[nx,9] := " "
					EndIf
				Next nx
			//��������������������������������������Ŀ
			//�Tratamento do inss de 13o salario	 �
			//����������������������������������������
			ElseIf (nPos := aScan(aAux,{|X| X[1] == aCodFol[070,1] .and. X[7] $cTipo13 } )) > 0
				aAux[nPos,1] := aCodFol[291,1]
				aAux[nPos,7] := "I"
				aAux[nPos,9] := " "
				If (nPos := aScan(aAux,{|X| X[1] == aCodFol[019,1] .and. X[7] $cTipo13 } )) > 0
					aAux[nPos,1] := aCodFol[290,1]
					aAux[nPos,7] := "I"
					aAux[nPos,9] := " "
				EndIf
			EndIf
		EndIf
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Se tiver incluido somente o INSS no movimento de 13o salario �
	//� modifica a variavel para .F. para nao buscar a pensao alimen-�
	//� ticia da 1a. parcela do 13o salario.						 �
	//����������������������������������������������������������������
	If !lInc13oSal
		lBusPen131	:= .F.
	EndIf

EndIf

//��������������������������������������������������������������Ŀ
//�Ajusto o aPd deixando somente as verbas que serao utilizadas. �
//����������������������������������������������������������������
For nx := 1 to nElement
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
	EndIf
Next nx

Return

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
Static Function fProv132(cCodigos)

Local aAux		:= aClone(aPd)	// Salvo o aPd para ajustar as verbas que serao consideradas.
Local nElement	:= 0			// Variavel utilizada para loop
Local nx		:= 0			// Variavel utilizada para loop

aPd	:= {}
nElement	:= Len(aAux)

//�������������������������������������������������������������Ŀ
//�Pesquisa se as verbas de 13o salario que estao na rescisao. 	�
//���������������������������������������������������������������
For nx := 1 to nElement
	//����������������������������������������������������������������������������Ŀ
	//� Ajusto somente as verbas que serao consideradas para o calculo da rescisao �
	//������������������������������������������������������������������������������
	If PosSrv(aAux[nx,1],SRA->RA_FILIAL,"RV_REF13") == 'S'
		aAdd(aPd,aclone(aAux[nx]))
	EndIf
Next nx

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fConfMUV	�Autor  �Leandro Drumond     � Data �  26/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega array com as verbas ja calculadas para recalculo   ���
���          � dos multiplos vinculos. Necessario pois ExecRot apaga todos���
���          � os mnemonicos.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Sigagpe                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function fConfMUV(aPd,aPdv)

aPd  := aPdMUV
aPDV := aPdvMUV
cRot := cRotMUV

LDISSIDIO := lDissMUV 

Return

/*/{Protheus.doc}fFerLicMat
Verifica se houve f�rias interrompidas em virtude de licen�a maternidade.
@author Gabriel de Souza Almeida
@since 30/08/2017
@version P12
@return lFerLicMat, L�gico
/*/
Static Function fFerLicMat()
	Local lFerLicMat := .T.
	Local nPos       := 0
	
	If ( nPos := aScan(aPd,{|x| x[1] == aCodFol[0072,1] .And. x[9] <> "D"}) ) > 0 .And. ( aPd[nPos,4] + nDiasMat ) > 30
		lFerLicMat := .F.
	EndIf
Return lFerLicMat

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GravaFol � Autor � Mauro                 � Data � 29.05.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava as Verbas da Matriz Calculadas na 2� Parcela do 13�  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � Grava132(X)                                                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� X =  Matriz Multi contendo                                 ���
���          � Codigo da Verba , C.Custo, cSemana, Horas , Valor , Tipo1,;���
���          � Tipo2 , Parcela                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������/*/

Static Function Grava132(aX)
Local lItemClVl   := GetMvRH( "MV_ITMCLVL", .F., "2" ) $ "1*3"

If IsInCallStack("GP690CAL")
	GravaDissidio(aPd,aPdOld,,aCodFol)
Else
	If lItemClVl
		GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aX[1],If(!Empty(aX[10]),aX[10],dData_Pgto),aX[2],;
		cSemana,aX[6],aX[7],aX[4],aX[5],aX[8],aX[9],,aX[11],aX[12],aX[13],aX[14],If(Len(aX)>= 17,aX[17],''),aX[20],aX[21],aX[15])
	Else
		GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aX[1],If(!eMPTY(aX[10]),aX[10],dData_Pgto),aX[2],;
		cSemana,aX[6],aX[7],aX[4],aX[5],aX[8],aX[9], ,aX[11],aX[12],,,If(Len(aX)>= 17,aX[17],''),aX[20],aX[21],aX[15])
	EndIf		
EndIf		
      
Return Nil