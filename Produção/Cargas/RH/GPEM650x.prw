#INCLUDE "PROTHEUS.CH"
#INCLUDE "Report.ch"

Static lExInAs400			:= ExeInAs400()

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � GPEM650  � Autor � Emerson Rosa de Souza � Data � 09/08/2001   ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Gera Movimentacao de Titulos no arquivo RC1                    ���                    
�����������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.                 ���
�����������������������������������������������������������������������������Ĵ��
���Programador � Data     � BOPS   �  Motivo da Altera��o                     ���
�����������������������������������������������������������������������������Ĵ��
���Emerson     � 19/09/01 �        �Alterar variavel nValDeducao p/ nValDedSer���
���Emerson     � 22/02/02 �        �Gravar no RC1 campos criados pelo usuario.���
���Emerson     � 07/03/02 �        �Passar a somar desconto do adto e subtrair���
���            �          �        �base de I.R. do adto na funcao fTitUsu(). ���
���Emerson     � 13/05/02 �        �Tratar verba de acordo com definicao(P/D).���
���Emerson     � 19/07/02 �        �Inclusao do ponto de entrada GP650CPO para���
���            �          �        �regravar campos do RC1 apos geracao titulo���
���Andreia     � 07/08/02 �059060  �Passagem da filial e do centro de custo na���
���            �          �        �funcao "GPM240Proc" para filtragem correta���
���            �          �        �destes campos.                            ���
���Emerson     � 02/10/02 �        �Buscar filial no RC0 de acordo com xFilial���
���Emerson     � 09/10/02 �        �Se o arquivo RC0 estiver exclusivo,filtrar���
���            �          �        �titulo do usuario pela filial do arquivo. ���
���Emerson     � 05/03/03 �        �Tratar os novos campos de data vencimento ���
���            �          �        �utilizados principalmente para geracao dos���
���            �          �        �titulos de ferias e rescisao entre outros.���
���Emerson     � 01/04/03 �        �Alterar conteudo de "nTipImp" de 2 para 1.���
���Emerson     � 23/05/03 �        �Criar variavel cCpoFornec em fGravTit().  ���
���Emerson     � 08/07/03 �        �Inicializar var. cCpoFornec com cFornec.  ���
���Emerson     � 02/12/03 �        �Alteracao na gravacao do campo RC1_FILIAL,���
���            �          �        �se arquivo compartilhado,gravar vazio,caso���
���            �          �        �contrario gravar a filial do titulo.      ���
���Emerson     � 28/04/04 �        �Manter cFilAnt atualizada de acordo com a ���
���            �          �        �filial que esta sendo gravada-Integridade ���
���Emerson     � 03/09/04 �        �Criar ponto de entrada p/checar Vl.Titulo.���
���Natie       � 09/08/05 �Q02559  �Testa conteudo cCpoDtLan                  ���
���Natie       � 29/08/05 �083473  �Efetua gravacao da dt de vencto conforme  ���
���            �          �        �det.pelo usuario e grava dt vcto real veri���
���            �          �        �cando Sabado/Domingo                      ���
���Andreia     � 02/11/05 �087658  �Criado novo campo na tabela RC0 para defi-���
���            �          �        �nir se o vencimento real sera antecipado  ���
���            �          �        �ou postergado no caso de cair em dia nao  ���
���            �          �        �util.                                     ���
���Andreia     � 21/11/05 �088063  �Criada uma pergunta para informar a data  ���
���            �          �        �de vencimento do titulo. Se esta pergunta ���
���            �          �        �for informada, a data de vencimento confi-���
���            �          �        �gurada na definicao do titulo sera ignora-���
���            �          �        �da.                                       ���
���Ricardo D.  � 30/01/06 �091675  �Implementacao do calculo da data de venci-���
���            �          �        �mento para o mes seguinte ao mes de pagto.���
���Tania       �08/03/2006�092116  �Nao permitir geracao de titulo do tipo An-���
���            �          �        �tecipado (PA ou RA).                      ���
���Tania       �16/03/2006�094353  �Inclusao do campo Loja na rotina de gera- ���
���            �          �        �cao do titulo.                            ���
���Ricardo D.  � 23/03/06 �095821  �Ajuste na gravacao dos campos de data de  ���
���            �          �        �vencimento e data real pois a real nunca  ���
���            �          �        �podera ser menor que a de vencimento.     ���
���Tania       �25/04/2006�096638  �Incluida consistencia de tabela. Quando   ���
���            �          �        �for SRZ, nao fara validacao da matricula x���
���            �          �        �intervalo do SX1.                         ���
���Tania       �08/05/2006�098177  �Acertada rotina de seek na tabela SRA, que���
���            �          �        �ocasionava loop na gravacao do titulo re- ���
���            �          �        �ferente a pensao.                         ���
���Tania       �22/05/2006�098586  �Salva e restaurada a area de trabalho nos ���
���            �          �        �pontos em que faria nova leitura no arqui-���
���            �          �        �vo.                                       ���
���Tania       �01/09/2006�100146  �Colocado o Include Report.Ch, para nao pro���
���            �          �        �vocar erro na chamada do GPER050, para ge-���
���            �          �        �racao dos titulos para o financeiro.      ���
���Ricardo D.  �16/02/2007�119323  �Ajuste no tratamento da variavel cCodTit  ���
���            �          �        �p/nao entrar em looping quando o codigo da���
���            �          �        �definicao de titulos estiver preenchido   ���
���            �          �        �com 1 ou 2 digitos.                       ���
���Natie       �19/03/07  �120710  �fGravTit-Salva e restaura a area(SRZ)     ���
���            �          �104235  �                                          ���
���Renata E.   �12/06/2007�112744  �Ajuste em fGerPen, para abertura do       ���
���            �          �        �arquivo correspondente ao mes\ano de comp ���
���            �          �        �(opensrc).                                ���
���Mauro       �06/07/2007�128822  �Geracao de Titulos e Integracao com o fi- ���
���            �          �        �nanceiro sobre verbas em valores futuros. ���
���Renata E.   �11/12/2007�137459  �Ajuste em fGerPen, posicionando o "while" ���
���            �          �        �no SRA (While SRA->( !EOF())).		      ���
���Renata E.   �19/12/2007�138160  �Ajuste em fGravTit para gravar o campo    ���
���            �          �        �RC1->R1_CC em branco qdo agrupamento for  ���
���            �          �        �tipo "1 - Filial"					      ���
���Jonatas     �25/04/2008�144123  �Ajuste para tratar duplicidade de pensoes ���
���            �          �        �existentes em rescisao e folha.           ���
���            �          �        �Ajuste para leitura do arq. de fechamento.���
���Kelly       �12/05/2008�141326  �Ajuste no grupo de perguntas.             ���
���Renata E.   �20/06/2008�148229  �Ajuste na funcao "GPM240Proc", incluindo  ���
���            �          �        �a passagem do tipo de contrato (cTpc),    ���
���            �          �        �devido alteracao bops 141497              ���
���Marcelo     �01/08/2008�150569  �Ajuste em fGravTit para buscar a filial   ���
���            �          �        �correta quando o fornecedor for preenchido���
���            �          �        �com campo de arquivo.                     ���
���Marcelo     �11/08/2008�145690  �Retirado o bloqueio p/inclusao de titulos ���
���            �          �        �do Tipo PA.                               ���
���Marcelo     �18/08/2008�151593  �Ajuste na funcao fTitUsu para indexar os  ���
���            �          �        �lancamentos conforme o tipo de agrupamento���
���            �          �        �definido.                                 ���
��|Luciana     |07/01/2009|52382008|Inclusao de variaveis para tratar geracao ���
��|            |          |        |do SRZ via procedure.                     ���
���Leandro Dr. �20/03/2009�69172009�Ajuste para criacao de indice na tabela   ���
���            �          �        �RC1 se necessario.                        ���
���Leandro Dr. �01/06/2009�00013280�Alteracao na chamada da funcao GetSxeNum  ���
���            �          �        �para GetSx8Num enviando o indice desejado.���
���Alex        �11/08/2009�--------�Ajuste no Grupo de Campos filial          ���
���            �          �        �tratamento para n�o considerar 2 posi��es ���
���            �          �        � fixas.                                   ���
���Andreia     �03/09/2009�18389/09�Criacao do ponto de entrada GP650ACM      ���
���Andreia     �29/09/2009�23773/09�A variavel aAliasFields foi declarada na  ���
���            �          �        �GPM650Proc() para que possa ser vista por ���
���            �          �        �todas as funcoes.                         ���
���Tiago Malta �  19/10/09�22649/09�Ajuste para integra��o Logix com          ���
���            �          �        �Rh Porhteus                               ���  
���Luciana     �  28/01/10�21796/09�Criacao de query na fgerPens para filtrar ���
���            �          �        �apenas os funcionarios que tenham registro��� 
���            �          �        �no Cadastro de Beneficiarios.             ��� 
���Luciana     �  18/05/10�09249/10�Ajuste na  GPM650Proc para considerar as  ���
���            �          �        �cFilIni e cFilFim na chamada da GPM240Proc��� 
���            �          �        �para nao gravar titulos duplicados por    ��� 
���            �          �        �filial.                                   ���          
���Mauricio MR �  22/06/10�0012985/�Ajuste na  GPM650Proc para considerar as  ���
���            �          �2010    �filiais De/Ate no caso da tabela RC0 - De-��� 
���            �          �        �finicoes de titulos, estiver compartilhada��� 
���            �          �        �No caso dessa tabela estiver exclusiva, so���          
���            �          �        �mente serao considerados os funcionarios  ���          
���            �          �        �da filial de cada definicao de titulo.    ���          
���            �          �        �Essas alteracoes serao aplicadas para a   ���          
���            �          �        �geracao de titulos de IR e INSS/13o sal.  ���          
���Mauricio MR �  04/08/10�0016903/�Ajuste na GPM650Proc para desprezar a data���
���            �          �2010    �invalida gerada devido ao dia nao existir ��� 
���            �          �        �para o mes e assumir o ultimo dia do mes  ��� 
���            �          �        �do titulo.								  ��� 
���Renata Elena�  13/05/11�0010862/�Ajuste em fGerPens, para inicilizar a     ���
���            �          �2011    �variavel cAliasSRA() com "SRA"			  ��� 
���Mauricio MR �  07/07/11�0015614/�Ajuste para obter os beneficiarios vigen- ���
���            �          �2011    �tes na data de referencia.				  ��� 
���Luis Ricardo�09/08/2011�00014150�Disponibilizacao da geracao de titulos p/ ���
���Cinalli	   �		  �	   2011�nova opcao de tipo  de titulo (006-INSS de���
���			   �		  �		   �Dissidio) e tratamento para nova tabela de���
���			   �		  �		   �dissidio acumulado (RHH).				  ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������/*/
User Function GENM650()
Local nOpca 	:= 0
Local aSays 	:={ }
Local aButtons	:= { } // arrays locais de preferencia
Local aRegs		:= {}
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local cTits		:= "" 
Local ni		:= 0

Local aFilterExp:=  {} //Expressao de filtro
Private aRetFiltro
Private cRC0Filter
Private aTipoErr	:=	{}
Private lLoja		:= ( FieldPos( "RC0_LOJA" ) # 0 )

Private cCadastro := OemToAnsi("Geracao de Titulos") //"Geracao de Titulos"

DEFAULT lExInAs400			:= ExeInAs400()
 
aHelpPor := {	"Esta data de vencimento somente    ",;
		 		"devera ser informada se a mesma 	",;
				"for diferente da data determinada	",;
				"na rotina de definincao do titulo. " }
				
aHelpEng := {	"This maturity date must be informed",;
				"only if it is different from the	",;
				"date defined in the bill definition",;
				"routine."							  }
                                                       
aHelpSpa := {	"Esta fecha de vencimiento solo debe",;
				"informarse si es diferente de la 	",;
				"fecha determinada en la rutina de	",;
				"definicion del titulo."			  }

Aadd(aRegs,{"GPM650","13","Data de Vencimento ?","�Fecha de Vencimiento ?","Due Date ?","mv_chd","D",08,0,00,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","S",aHelpPor,aHelpEng,aHelpSpa})

ValidPerg(aRegs,"GPM650",.T.)

Pergunte("GPM650",.F.)

If !Rc1VerInd() //Retirar nas proximas versoes
	Aviso( OemToAnsi("Atencao"),  OemToAnsi("Deve ser executado o programa para atualiza��o de base do SIGAGPE - (RHUPDMOD)") +  CRLF + OemToAnsi("Selecione a atualiza��o 'Ajustar Indices - RC1'."), { "OK" } ) //##"Atencao"##"Deve ser executado o programa para atualiza��o de base do SIGAGPE - (RHUPDMOD)"##"Selecione a atualiza��o 'Ajustar Indices - RC1'."
	Return
EndIf

//U_GP650SX3()

/* Retorne os Filtros que contenham os Alias Abaixo */
aAdd( aFilterExp , { "FILTRO_ALS" , "RC0"     	, NIL , NIL } )
/* Que Estejam Definidos para a Fun��o */
aAdd( aFilterExp , { "FILTRO_PRG" , FunName() 	, NIL , NIL    } )


AADD(aSays,OemToAnsi( "Este programa gera titulos no  arquivo  de  movimentos (RC1) a partir do cadastro de" )) //"Este programa gera titulos no  arquivo  de  movimentos (RC1) a partir do cadastro de"
AADD(aSays,OemToAnsi( "definicoes (RC0). Apos gerados, estarao disponiveis para consultas e integracao com "))  //"definicoes (RC0). Apos gerados, estarao disponiveis para consultas e integracao com "
AADD(aSays,OemToAnsi( "o financeiro.                           											 "))  //"o financeiro.                           											 "

AADD(aButtons, { 17,.T.,{|| aRetFiltro := FilterBuildExpr( aFilterExp ) } } )
AADD(aButtons, { 5,.T.,{|o| Pergunte("GPM650",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1, If(GPM650OK(),FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
//���������������������������������������������������������Ŀ
//� Inicializa a gravacao dos lancamentos do SIGAPCO        �
//�����������������������������������������������������������
PcoIniLan("000092")

FormBatch( cCadastro, aSays, aButtons )

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//����������������������������������������������������������������
If nOpca == 1
	ProcGpe({|lEnd| GPM650Proc()})  // Chamada do Processamento
Endif

If len(aTipoErr)>0  
	For ni=1 to len(aTipoErr)
		IF Empty(cTits)
			cTits	+=	aTipoErr[ni]
		Else
			cTits	+=	IIF(Substr(cTits,len(cTits)-2,3)!= aTipoErr[ni],(", "+aTipoErr[ni]),"")
		EndIf
    Next ni
	Aviso("Atencao!", "Nao foram gerados os titulos: " + cTits + ". Acerte os tipos e processe a geracao novamente.", {"OK"})
	//"Atencao!"###"Nao foram gerados os titulos: "###". Acerte os tipos e processe a geracao novamente." 
EndIf

//���������������������������������������������������������Ŀ
//� Finaliza a gravacao dos lancamentos do SIGAPCO          �
//�����������������������������������������������������������
PcoFinLan("000092")

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GPM650Proc� Autor � Emerson Rosa de Souza � Data � 04.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de geracao de Titulos							  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPM650Proc()  			                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 							                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function GPM650Proc()
//��������������������������������������������������������������Ŀ
//� Define Variaveis LOCAIS DO PROGRAMA                          �
//����������������������������������������������������������������
Local cAlias   := ALIAS()
Local cTitProc,nCnt,nCnt1,nFol13Sal,nNroSem,lCabec
Local cCpoPadRC1,cCposRC0, cRC1Cpo, cRC1Conf, nRecnoRC1
Local xLoop2,xLoop

//��������������������������������������������������������������Ŀ
//� Define Variaveis PRIVATE DO PROGRAMA                         �
//����������������������������������������������������������������
Private aCposUsu  	:= {}
Private dDataVenc 	:= CTOD("")
Private cAliasCC  	:= If(CtbInUse(), "CTT", "SI3")
Private lExistCC, lExistMAT, lExistDtV 
Private lSrz		:=	.F.
Private cMvEncInss	:=	SuperGetMv("MV_ENCINSS",,"N")
Private cERPLOGIX	:= GETMV( "MV_ERPLOGIX",,"2")
_SetOwnerPrvt(	"aAliasFields"	, {} )

//���������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                          �
//� mv_par01        //  Filial De                                 �
//� mv_par02        //  Filial Ate                                �
//� mv_par03        //  Centro de Custo De                        �
//� mv_par04        //  Centro de Custo Ate                       �
//� mv_par05        //  Matricula De                              �
//� mv_par06        //  Matricula Ate                             �
//� mv_par07        //  Dt. Busca Pagto De                        �
//� mv_par08        //  Dt. Busca Pagto Ate                       �
//� mv_par09        //  Codigo Titulo De                          �
//� mv_par10        //  Codigo Titulo Ate                         �
//� mv_par11        //  Data de Emissao                           �
//� mv_par12        //  Competencia                               �
//� mv_par13        //  Data de vencimento                        �
//�����������������������������������������������������������������
cFilDeT     := mv_par01
cFilAteT    := mv_par02
cCCDeT      := mv_par03
cCCAteT     := mv_par04
cMatDeT     := mv_par05
cMatAteT    := mv_par06
dDataDeT    := mv_par07
dDataAteT   := mv_par08
cCodTitDe   := mv_par09
cCodTitAte  := mv_par10
dDtEmisTit  := mv_par11
cCompetTit  := mv_par12
dVctoInf	:= mv_par13
cAnoMes		:= substr(cCompetTit,3,4)+substr(cCompetTit,1,2)	

//��������������������������������������������������������������Ŀ
//� Campos do RC1 (padrao do sistema)							 �
//����������������������������������������������������������������
cCpoPadRC1 := "RC1_FILIAL/RC1_INTEGR/RC1_FILTIT/RC1_CODTIT/RC1_DESCRI/RC1_PREFIX/"+;
			  "RC1_NUMTIT/RC1_TIPO/RC1_NATURE/RC1_FORNEC/RC1_EMISSA/RC1_VENCTO/"  +;
			  "RC1_VENREA/RC1_VALOR/RC1_DTBUSI/RC1_DTBUSF"

//��������������������������������������������������������������Ŀ
//� Carrega os Filtros                                 	 	     �
//����������������������������������������������������������������
cRC0Filter	:= GpFltAlsGet( aRetFiltro , "RC0" )

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para geracao do SRZ via procedure     	 �
//����������������������������������������������������������������
lFolPgto    := .F.
lFol13Sl    := .F.

//��������������������������������������������������������������Ŀ
//� Grava no array os campos do usuario criados no arquivo RC0 e �
//� RC1, assegurando que os dois tem o mesmo tipo e tamanho.     �
//����������������������������������������������������������������

aCampos := FWSX3Util():GetAllFields( "RC1", .F. )
                                           
For xLoop := 1 To Len(aCampos)

	If !(AllTrim(aCampos[xLoop]) $ cCpoPadRC1)

		cRC1Cpo   	:= aCampos[xLoop]
		cRC1Conf  	:= FWSX3Util():GetFieldType(aCampos[xLoop])+StrZero(TamSx3(aCampos[xLoop])[1], 3)+StrZero(TamSx3(aCampos[xLoop])[2], 1)
		nRecnoRC1 	:= RECNO()          
		nLoop2 	  	:= 0    
		aCampo 	  	:= FWSX3Util():GetAllFields( "RC0", .F. )    
		
		For xLoop2	:= 1 To Len(aCampo)
	   		If FWSX3Util():GetFieldType(aCampo[xLoop2])+StrZero(TamSx3(aCampo[xLoop2])[1], 3)+StrZero(TamSx3(aCampo[xLoop2])[2], 1) == cRC1Conf
				Aadd(aCposUsu, { "RC0->"+aCampo[xLoop2], "RC1->" + cRC1Cpo, Nil })
			EndIf		
		Next xLoop2
						
	EndIf
	
Next xLoop

/*dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("RC1")
While !Eof() .And. X3_ARQUIVO == "RC1"
	If !(AllTrim(X3_CAMPO) $ cCpoPadRC1)

		cRC1Cpo   := X3_CAMPO
		cRC1Conf  := X3_TIPO+StrZero(X3_TAMANHO, 3)+StrZero(X3_DECIMAL, 1)
		nRecnoRC1 := RECNO()
		dbSetOrder(2)
		If dbSeek("RC0" + Right(cRC1Cpo, 7))
			If X3_TIPO+StrZero(X3_TAMANHO, 3)+StrZero(X3_DECIMAL, 1) == cRC1Conf
				Aadd(aCposUsu, { "RC0->"+X3_CAMPO, "RC1->" + cRC1Cpo, Nil })
			EndIf
		EndIf
		dbSetOrder(1)
		dbGoTo(nRecnoRC1)
	EndIf
	dbSkip()
EndDo
*/
//��������������������������������������������������������������Ŀ
//� Verifica se existem os campos RC1_CC e RC1_MAT				 �
//����������������������������������������������������������������
dbSelectArea( "RC1" )
lExistCC  := ( FieldPos( "RC1_CC"  ) # 0 )
lExistMAT := ( FieldPos( "RC1_MAT" ) # 0 )

//��������������������������������������������������������������Ŀ
//� Verifica existencia dos cpos RC0_ALIADV/RC0_CPOBDV/RC0_FILTDV�
//����������������������������������������������������������������
dbSelectArea( "RC0" )
lExistDtV := ( FieldPos( "RC0_ALIADV" ) # 0  .And. FieldPos( "RC0_CPODTV" ) # 0 .And.;
			   FieldPos( "RC0_FILTDV" ) # 0  .And. FieldPos( "RC0_CPODTR" ) # 0 )

dbSeek( If( xFilial( "RC0" ) == Space(FWGETTAMFILIAL), Space(FWGETTAMFILIAL), cFilDeT) + cCodTitDe, .T. )
GPProcRegua(RC0->(RecCount()))

While !Eof() .And. RC0->RC0_FILIAL+RC0->RC0_CODTIT <= cFilAteT+cCodTitAte

	GPIncProc("Processando...") // "Processando..."
	
	If RC0->RC0_CODTIT < cCodTitDe .Or. RC0->RC0_CODTIT > cCodTitAte
		dbSelectArea( "RC0 " )
		dbSkip()
		Loop
	EndIf  
	
	
	If  !RC0->RC0_CODTIT $ "004-035"  
		dbSelectArea( "RC0 " )
		dbSkip()
		Loop
	EndIf
	

 	If !Empty( cRC0Filter )
 		If !( &( cRC0Filter ) )
			RC0->( dbSkip())
			Loop
		EndIf
	EndIf	

	//�������������������������������������������������������������������������Ŀ
	//� Verifica existencia da nova tabela de Dissidio Acumulado (RHH) SE a		�
	//� geracao de Titulo for de Dissidio. Se NAO existir a tabela sera			�
	//� apresentada a mensagem informando a necessidade da execucao do update 	�
	//� 143 para a criacao e impede a execucao da geracao somente para o tipo de�
	//� titulo 006 - INSS - DISSIDIO ate que o update seja executado.			�
	//���������������������������������������������������������������������������
	If RC0->RC0_TIPTIT == '1' .and. '006' $ AllTrim( RC0->RC0_VERBAS ) .and. ! Sx2ChkTable( "RHH" )

		Aviso( "Atencao", "Execute a op��o do compatibilizador referente � cria��o da nova tabela de Diss�dio Acumulado. Para maiores informa��es verifique respectivo Boletim T�cnico." + CRLF + "Somente os t�tulos de tipo 006 - INSS - Dissidio N�O ser�o gerados at� que o compatibilizador seja executado.", { "ok" } )																		//"Somente os t�tulos de tipo 006 - INSS - Dissidio N�O ser�o gerados at� que o compatibilizador seja executado." ## "OK"

		RC0->( dbSkip())
		Loop
	Endif

	cFilAtu   := RC0->RC0_FILIAL
	cCodTit   := RC0->RC0_CODTIT
	cDescri   := RC0->RC0_DESCRI
	cAgrupa   := IF( cERPLOGIX = "1", "4", RC0->RC0_AGRUPA) //RC0->RC0_AGRUPA
	cDmVenc   := RC0->RC0_DMVENC
	cMesPgt   := RC0->RC0_MESPGT
	cDsVenc   := RC0->RC0_DSVENC
	cFornec   := RC0->RC0_FORNEC
	cLoja	  := if(lLoja,RC0->RC0_LOJA,"00")
	cNature   := RC0->RC0_NATURE
	cPrefix   := RC0->RC0_PREFIX
	cTipTit   := RC0->RC0_TIPTIT
	cIdentTit := AllTrim(RC0->RC0_TIPO)
	cFiltrLan := RC0->RC0_FILTRV
	cFiltrSRA := RC0->RC0_FILTRF
	cCpoDtLan := Alltrim(RC0->RC0_FILTRD)
	cAliasLan := RC0->RC0_ALIAS
	lSrz	  := If( cAliasLan == "SRZ" , .T. , .F. )
	cDiaUtil  := If( FieldPos("RC0_DIAUTI") # 0,RC0->RC0_DIAUTI,"2")
   	cVerbas   := ""
   	lCabec    := .F.

	If lExistDtV
		cAliasCab := RC0->RC0_ALIADV
		cCpoDtCab := AllTrim(RC0->RC0_CPODTV)
		cFiltrCab := RC0->RC0_FILTDV
		cCpoDtRel := RC0->RC0_CPODTR
	   	lCabec    := (!Empty(RC0->RC0_ALIADV) .And. !Empty(RC0->RC0_CPODTV))
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Grava o conteudo dos campos de usuario do RC0 em aCposUsu	 �
	//����������������������������������������������������������������
   	For nCnt1 := 1 To Len(aCposUsu)
   		cCposRC0          := aCposUsu[nCnt1,1]
		aCposUsu[nCnt1,3] := &cCposRC0
   	Next nCnt1

	//��������������������������������������������������������������Ŀ
	//� Calcula data de vencimento do titulo						 �
	//����������������������������������������������������������������
	dDataVenc := CTOD("")
	If !Empty(cDmVenc) .And. !Empty(cMesPgt)  // Dia do mes para o vencimento
		If cMesPgt == "3" // Mes Seguinte ao Pagamento
			cNovMes :=  Strzero(Month(dDataDeT),2)
			cNovAno := Str(Year(dDataDeT),4)
			//-- Calcula o mes seguinte a data de apuracao.
			cNovMes := If(cNovMes == "12", "01", StrZero(Val(cNovMes)+1,2))
			cNovAno := If(cNovMes == "01", StrZero(Val(cNovAno)+1,4), cNovAno)
		Else
			cNovMes :=  Left(cCompetTit,2)
			cNovAno := Right(cCompetTit,4)
			If cMesPgt == "2" // Mes Seguinte
				cNovMes := If(cNovMes == "12", "01", StrZero(Val(cNovMes)+1,2))
				cNovAno := If(cNovMes == "01", StrZero(Val(cNovAno)+1,4), cNovAno)
			EndIf
		EndIf
		dDataVenc := CTOD(cDmVenc + "/" + cNovMes + "/" + cNovAno)
		//-- Se gerou um data invalida pois o dia nao existe para o mes gerado
		IF Empty(dDataVenc)
			//-- Assume o maior dia do mes gerado
			dDataVenc:= CTOD(Strzero(F_ULTDIA(Ctod("01/"+cNovMes+"/"+cNovAno)),2) + "/" + cNovMes + "/" + cNovAno)
		Endif	
			
	ElseIf !Empty(cDsVenc)   // Dia da Semana para o vencimento
		nNroSem := If(DOW(dDataAteT) > Len(cDsVenc), 7, 0)
		dDataVenc := (dDataAteT - DOW(dDataAteT) + Val(cDsVenc) + nNroSem)
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Verifica se existem outros registro e os carregas em cVerbas �
	//����������������������������������������������������������������
	While !Eof() .And. RC0->RC0_FILIAL+RC0->RC0_CODTIT == cFilAtu+cCodTit
	   	cVerbas += AllTrim(RC0->RC0_VERBAS)
	   	dbSkip()
	EndDo

	//��������������������������������������������������������������Ŀ
	//� Geracao dos titulos padroes do sistema                       �
	//����������������������������������������������������������������
	If cTipTit == "1"
		cTitProc := Left(cVerbas,3)
		//��������������������������������������������������������������Ŀ
		//� Chamada para o programa de geracao do INSS - FOLHA/13o		 �
		//����������������������������������������������������������������
		If cTitProc $ "001*002"
			//��������������������������������������������������������������Ŀ
			//� Verifica se deve gerar o arquivo SRZ com os valores de INSS	 �
			//����������������������������������������������������������������
			nFol13Sal := If(cTitProc == "001", 1, 2)   // 1-Folha, 2-13o Salario
			//��������������������������������������������������������������Ŀ
			//� Variaveis utilizadas para geracao do SRZ via procedure     	 �
			//����������������������������������������������������������������
			lFolPgto    := ( nFol13Sal == 1 ) // Geracao dos registros 'FL' no SRZ
			lFol13Sl    := ( nFol13Sal == 2 ) // Geracao dos registros '13' no SRZ
			Rst040Imp() // Reinicializa static para execucao da procedure
			If !fGeraFolSRZ(nFol13Sal,{1,2},cCompetTit)    // 1-Indeterminado, 2-Determinado
				Loop
			EndIf
			//��������������������������������������������������������������Ŀ
			//� Carregando variaveis mv_par?? para Variaveis do Sistema      �
			//� Estas variaveis serao utilizadas em GPM240Proc()			 �
			//����������������������������������������������������������������
			nValAutonomo  := 0.00
			nValProLabore := 0.00
			nValReceita   := 0.00
			nValDedSer    := 0.00
			nValJuros     := 0.00
		 	cCentra       := ""
			cCompetencia  := cCompetTit
			//��������������������������������������������������������������Ŀ
			//� Tipo de Geracao na GPS:     1 - CC, 2 - Nivel CC, 3 - Filial �
			//� Tipo de Geracao no Titulo:  2 - CC, 3 - Nivel CC, 1 - Filial �
			//����������������������������������������������������������������
			nPorCc        := If(cAgrupa == "2", 1, If(cAgrupa == "3", 2, 3))
			cNivCCusto    := If( nPorCc == 2, "1", "")
			cTipo         := nFol13Sal
			//��������������������������������������������������������������Ŀ
			//� Processa duas vezes. 1-Contrato Indeterminado, 2-Determinado �
			//����������������������������������������������������������������
			For nCnt := 1 To 2
				cTpc := Str(nCnt,1) //Define o tipo de contrato
				If Empty( xFilial( "RC0" ) )
					cFilIni := cFilDeT
					cFilFim := cFilAteT
				Else
					cFilIni := cFilAtu
					cFilFim := cFilAtu
				EndIf
				Processa({|lEnd|GPM240Proc(3,@lEnd,    ,,cFilIni,cFilFim,cCCDeT,cCCAteT,cTpc),"Gerando arquivo aguarde..."})  //"Gerando arquivo aguarde..."
			Next nCnt
		//��������������������������������������������������������������Ŀ
		//� Chamada para o programa de geracao dos valores de I.R.	     �
		//����������������������������������������������������������������
		ElseIf cTitProc == "003"
			//��������������������������������������������������������������Ŀ
			//� Carregando variaveis mv_par?? para Variaveis do Sistema      �
			//� Estas variaveis serao utilizadas em GR050Imp()				 �
			//����������������������������������������������������������������
			If Empty( xFilial( "RC0" ) )
				cFilDe    := cFilDeT
				cFilAte   := cFilAteT
			Else
				cFilDe := cFilAtu
				cFilAte := cFilAtu
			EndIf
		
			cCCDe 	  := cCCDeT
			cCCAte 	  := cCCAteT
			cMatDe    := cMatDeT
			cMatAte   := cMatAteT
			dDataDe   := dDataDeT
			dDataAte  := dDataAteT
			cNomDe    := Space(30)
			cNomAte   := Replicate("z", 30)
			cSinAna   := "A" // Analitica
			lSalta    := .F.
			nTipImp   := 1   // Tipo Relatorio no programa GPER050
			dVencto   := CTOD("")
			cNumRef   := ""
			cCentra   := ""
			//��������������������������������������������������������������Ŀ
			//� Ordem na Impressao do I.R.: 1 - Mat, 2 - CC,    3 - Nome	 �
			//� Ordem na Geracao de titulo: 2 - CC,  3 - Nivel, 1 - Filial   �
			//����������������������������������������������������������������
			nOrdem := If(cAgrupa $ "2*3", 2, 1)
			
			IF cCodTit $ "004-035"
			   Processa({|lEnd| U_GN050Imp(2,@lEnd,,,cAgrupa,,"GENM650"),"Gerando arquivo aguarde..."})  //"Gerando arquivo aguarde..."
            ELSE  
               Processa({|lEnd| N050Imp(2,@lEnd,,,cAgrupa,,"GENM650"),"Gerando arquivo aguarde..."})  //"Gerando arquivo aguarde..."
            ENDIF
		//��������������������������������������������������������������Ŀ
		//� Chamada para o programa de geracao dos valores de PENSAO     �
		//����������������������������������������������������������������
		ElseIf cTitProc == "004"

			Processa({|lEnd| fGerPens(@lEnd),"Gerando arquivo aguarde..."})  //"Gerando arquivo aguarde..."

		//��������������������������������������������������������������Ŀ
		//� Chamada para o programa de geracao dos valores de DISSIDIO   �
		//����������������������������������������������������������������
		ElseIf cTitProc $ "006"

			Rst040Imp() // Reinicializa static para execucao da procedure
			//��������������������������������������������������������������Ŀ
			//� Carregando variaveis mv_par?? para Variaveis do Sistema      �
			//� Estas variaveis serao utilizadas em GPM240PrcD()			 �
			//����������������������������������������������������������������
			nValAutonomo  := 0.00
			nValProLabore := 0.00
			nValReceita   := 0.00
			nValDedSer    := 0.00
			nValJuros     := 0.00
		 	cCentra       := ""
			cCompetencia  := cCompetTit
			//��������������������������������������������������������������Ŀ
			//� Tipo de Geracao na GPS:     1 - CC, 2 - Nivel CC, 3 - Filial �
			//� Tipo de Geracao no Titulo:  2 - CC, 3 - Nivel CC, 1 - Filial �
			//����������������������������������������������������������������
			nPorCc        := If( cAgrupa == "2", 1, If(cAgrupa == "3", 2, 3))
			cNivCCusto    := If( nPorCc == 2, "1", "")
			cTipo         := nFol13Sal
			//��������������������������������������������������������������Ŀ
			//� Processa duas vezes. 1-Contrato Indeterminado, 2-Determinado �
			//����������������������������������������������������������������
			For nCnt := 1 To 2
				cTpc := Str(nCnt,1) //Define o tipo de contrato
				If Empty( xFilial( "RC0" ) )
					cFilIni := cFilDeT
					cFilFim := cFilAteT
				Else
					cFilIni := cFilAtu
					cFilFim := cFilAtu
				EndIf
				Processa( { |lEnd| GPM240PrcD(3,@lEnd,,,cFilIni,cFilFim,cCCDeT,cCCAteT,cTpc,cAnoMes),"Gerando arquivo aguarde..."})  //"Gerando arquivo aguarde..."
			Next nCnt
		EndIf
	//��������������������������������������������������������������Ŀ
	//� Geracao dos titulos definidos pelo usuario					 �
	//����������������������������������������������������������������
	ElseIf cTipTit == "2"
		//��������������������������������������������������������������Ŀ
		//� Verifica Alias e Campo para filtrar o periodo   			 �
		//����������������������������������������������������������������
		If Empty(cAliasLan)
			dbSelectArea( "RC0" )
			Loop
		EndIf
		Processa({|lEnd| fTitUsu(@lEnd,lCabec),"Gerando arquivo aguarde..."})  //"Gerando arquivo aguarde..."
	EndIf
	dbSelectArea( "RC0" )
EndDo

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GPM650OOk � Autor � Emerson Rosa de Souza � Data � 13.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Confirma parametros             							  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPM650Ok()    			                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 							                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function GPM650Ok()

Return (MsgYesNo(OemToAnsi("Confirma configuracao dos parametros?"),OemToAnsi("Atencao"))) //"Confirma configura��o dos par�metros?"###"Aten��o"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fGerPens � Autor � Emerson Rosa de Souza � Data � 13.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta valores de pensao e grava no arquivo de titulos	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fGerPens	    			                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 							                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function fGerPens(lEnd)
Local cAlias    := ALIAS()
Local aArea		
Local aCodFol   := {}
Local aValBenef := {} 
Local aOrdBagRC := {}
Local nValor    := 0
Local nValTotal := 0
Local cAliasRC 	:= ""
Local cRCName
Local cFilialAnt,cCCAnt,nCntB,cAgrupAnt
Local cQuery		:= ""                                    
Local cAliasSRA		:= "SRA" 
Local cAliasCount 	:= ""   
Local cQry			:= ""  
Local cCount		:= ""  
Local lQuery		:= .F.  
Local cOrder

//-- Tratamento para competencia dos benecifiarios  
Local cMesAno		:= '' 
Local dDtIniComp	:= Ctod('')
Local dDtFimComp	:= Ctod('')
Local nUltDia		:= 0  
Local nX			:= 0  
Local aSRQStru		 
Local lTemDtIni		:= ( SRQ->(FieldPos('RQ_DTINI')) > 0  .and. SRQ->(FieldPos('RQ_DTFIM')) > 0  )

//��������������������������������������������������������������Ŀ
//� Variaveis Privates utilizadas em fBuscaLiq()                 �
//����������������������������������������������������������������
Private lImprFunci  := .F. // Indica se deve buscar valores dos funcionarios
Private lImprBenef  := .T. // Indica se deve buscar valores dos beneficiarios
Private lAdianta    := .T. // Busca pensao sobre adiantamento
Private lFolha      := .T. // Busca pensao sobre folha de pagamento
Private lPrimeira   := .T. // Busca pensao sobre primeira parcela do 13o
Private lSegunda    := .T. // Busca pensao sobre segunda parcela do 13o
Private lFerias     := .T. // Busca pensao sobre ferias
Private lExtras     := .T. // Busca pensao sobre valores extras
Private lRescisao   := .T. // Busca pensao sobre rescisao
Private cArqMovRC := "" 

Private cAcessaSR1	:= &( " { || " + ChkRH( "GPEM650" , "SR1" , "2" ) + " } " )
Private cAcessaSRA	:= &( " { || " + ChkRH( "GPEM650" , "SRA" , "2" ) + " } " )
Private cAcessaSRC	:= &( " { || " + ChkRH( "GPEM650" , "SRC" , "2" ) + " } " ) 
Private cAcessaSRG	:= &( " { || " + ChkRH( "GPEM650" , "SRG" , "2" ) + " } " )
Private cAcessaSRH	:= &( " { || " + ChkRH( "GPEM650" , "SRH" , "2" ) + " } " )
Private cAcessaSRI	:= &( " { || " + ChkRH( "GPEM650" , "SRI" , "2" ) + " } " )
Private cAcessaSRR	:= &( " { || " + ChkRH( "GPEM650" , "SRR" , "2" ) + " } " ) 
Private cCpoDel		:= If( TcSrvType() == "AS/400", "@DELETED@", "D_E_L_E_T_" )

Private dDataDe     := dDataDeT
Private dDataAte    := dDataAteT
Private Semana      := "  "

If !OpenSrc( cCompetTit, @cAliasRC, @aOrdBagRC, @cArqMovRC, dDataAte, .F.,.F.)
	Return .f.
Endif

//-- Tratamento para competencia dos beneficios   
cMesAno  := Substr(cCompetTit,1,2)+"/"+Substr(cCompetTit,3,4)

dDtIniComp	:= CToD( "01" + "/" + cMesAno )    //Primeiro dia do Mes            
nUltDia		:= f_UltDia( dDtIniComp )   		//Ultimo dia do Mes            
dDtFimComp	:= CToD(StrZero(nUltDia,2)+"/"+ cMesAno) 


#IFDEF TOP   
 	IF !( lExInAs400 ) 
		cAliasSRA	:= GetNextAlias()
		aSRQStru 	:= SRQ->(dbStruct())
		
		cSelect := "SELECT DISTINCT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_CC " + CRLF
		cQuery := "FROM " + RetSqlName("SRA") + " SRA, " + RetSqlName("SRQ") + " SRQ " + CRLF 
		cQuery += "WHERE	SRA.RA_FILIAL BETWEEN '" + cFilDeT + "' AND '" + cFilAteT	+ "' AND "
       	cQuery += "			SRA.RA_MAT    BETWEEN '" + cMatDeT + "' AND '" + cMatAteT	+ "' AND "
        cQuery += "			SRA.RA_CC     BETWEEN '" + cCcDeT  + "' AND '" + cCcAteT	+ "' AND "
		cQuery += "SRA.RA_FILIAL = SRQ.RQ_FILIAL AND " + CRLF
		cQuery += "SRA.RA_MAT = SRQ.RQ_MAT AND " + CRLF 
		
		//-- Verifica a existencia dos campos do periodo do beneficio para consistir o mesmo
		If lTemDtIni                                                   
				cQuery += "            (  (SRQ.RQ_DTINI = '' AND SRQ.RQ_DTFIM = '')  OR " 		+ CRLF  
				cQuery += "                (   " 		+ CRLF  
				cQuery += "                ( SRQ.RQ_DTINI <= '" + DTOS(dDtFimComp) + "' AND " 	+ CRLF 		
				cQuery += "                  SRQ.RQ_DTFIM >= '" + DTOS(dDtIniComp) + "' " 						 	  
				cQuery += "                ) ) )  AND " 	+ CRLF  			
		Endif	  
	
		cQuery += "				SRA." + cCpoDel + " = ' ' AND "  + CRLF
		cQuery += "				SRQ." + cCpoDel + " = ' ' "  + CRLF
		
		cOrder := " ORDER BY " 
		

		If cAgrupa $ "1*4"       // Filial*Funcionario    
			cOrder += " 1,2 " + CRLF
		ElseIf cAgrupa $ "2*3"   //Centro de Custo/Nivel de Centro de Custo 
			cOrder += " 1,3,2 " + CRLF
		EndIf

		cQry := ChangeQuery(cSelect+cQuery+cOrder) 
		
		//ABRE A EXECUCAO DA QUERY ATRIBUIDA AO SRA
		IF MsOpenDbf(.T.,"TOPCONN",TcGenQry(, ,cQry),cAliasSRA,.F.,.T.)
			lQuery := .T.
			For nX := 1 To Len(aSRQStru)   
			    IF 	( 'RQ_DTINI' == UPPER(Alltrim(aSRQStru[nX][1]))  ) .or.;
			    	( 'RQ_DTFIM' == UPPER(Alltrim(aSRQStru[nX][1]))  )
					TcSetField(cAliasSRA,aSRQStru[nX][1],aSRQStru[nX][2],aSRQStru[nX][3],aSRQStru[nX][4])
				EndIf
			Next nX
		
			//��������������������������������������������������������������Ŀ
			//� Carrega Regua Processamento	                                 �
			//����������������������������������������������������������������
		  	cAliasCount	:= GetNextAlias()
		  	cCount		:= "SELECT COUNT(RA_MAT) NROREG "
			cQuery		:= ChangeQuery( cCount + cQuery )
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery),cAliasCount, .F., .F. )
			nRegProc	:=	(cAliasCount)->NROREG
		    (cAliasCount)->(DbCloseArea())
		    DbSelectArea(cAliasSRA)
			GPProcRegua(nRegProc)   
		Endif	
	Endif
	
	IF !lQuery
	    cAliasSRA		:= "SRA" 
		dbSelectArea( "SRA" )
		ProcRegua( SRA->(RecCount())) 
	Endif	
#ELSE
	dbSelectArea( "SRA" )
	ProcRegua( SRA->(RecCount())) 
#ENDIF


If cAgrupa $ "1*4"       // Filial*Funcionario  
	dbSelectArea( "SRA" )
	dbSetOrder(1)
	dbSeek(cFilDeT + cMatDeT, .T.)
	cInicio := cAliasSRA+"->RA_FILIAL +" + cAliasSRA +"->RA_MAT"
	cFim    := cFilAteT + cMatAteT
ElseIf cAgrupa $ "2*3"   //Centro de Custo/Nivel de Centro de Custo
	dbSelectArea( "SRA" )
	dbSetOrder(2)
	dbSeek(cFilDeT + cCCDeT + cMatDeT,.T.)
	cInicio  :=cAliasSRA+"->RA_FILIAL +" + cAliasSRA + "->RA_CC +" +cAliasSRA+"->RA_MAT"
	cFim     := cFilAteT + cCCAteT + cMatAteT
EndIf


nValTotal  := 0
cFilialAnt := Replicate("!", FWGETTAMFILIAL)
cCCAnt	   := Replicate("!", GetSx3Cache("RA_CC", "X3_TAMANHO"))
cCpoAgrup  := If(cAgrupa=="1","RA_FILIAL",If(cAgrupa$"2*3","RA_CC","RA_MAT"))

While (cAliasSRA)->(!Eof()  .And. &cInicio <= cFim )
	//��������������������������������������������������������������Ŀ
	//� Verifica quebra de filial e busca novos codigos da folha     �
	//����������������������������������������������������������������
		
	If (cAliasSRA)->RA_FILIAL # cFilialAnt
	   IF !FP_CODFOL(@aCodFol,(cAliasSRA)->RA_FILIAL)
	      Exit
	   Endif
	   cFilialAnt := (cAliasSRA)->RA_FILIAL
	Endif

	//��������������������������������������������������������������Ŀ
	//� Centro de custo para gravacao quando agrupar por funcionario �
	//����������������������������������������������������������������
	If (cAliasSRA)->RA_CC # cCCAnt
		cCCAnt := (cAliasSRA)->RA_CC
	EndIf

	cAgrupAnt := &cCpoAgrup
	While (cAliasSRA)->( !Eof() ) .And. ( cFilialAnt + cAgrupAnt == (cAliasSRA)->RA_FILIAL + (cAliasSRA)->&cCpoAgrup )
		IncProc("Gerando Titulos - " + cDescri) //"Gerando Titulos - "
	
		//��������������������������������������������������������������Ŀ
		//� Consiste Parametrizacao de acordo com definicao				 �
		//����������������������������������������������������������������
		If ((cAliasSRA)->RA_CC  <  cCCDeT)  .Or. ((cAliasSRA)->RA_CC  > cCCAteT) .Or.;
		   ((cAliasSRA)->RA_MAT <  cMatDeT) .Or. ((cAliasSRA)->RA_MAT > cMatAteT)
		    (cAliasSRA)-> (dbSkip()) 
		    Loop
		EndIf 
		
		//��������������������������������������������������������������Ŀ
		//� Busca os valores do beneficiario							 �
		//����������������������������������������������������������������
		nValor    := 0
		aValBenef := {}
		cRCName := If( Empty(cAliasRC)	, NIL, cArqMovRC )                  
		
		//-- Posiciona no funcionario corrente
		SRA->( DbSeek( (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT ),.F. )
		
		fBuscaLiq(@nValor,@aValBenef,aCodFol,,,Ctod("01/" + Substr(cCompetTit,1,2) + "/" + Substr(cCompetTit,3,4), "DDMMYY"),cRCName)
		For nCntB := 1 To Len( aValBenef )
			nValTotal += aValBenef[nCntB,5]
		Next nCntB

	 
	   (cAliasSRA)-> (dbSkip())
	  
	EndDo
	//��������������������������������������������������������������Ŀ
	//� Grava o titulo de acordo com seu agrupamento			     �
	//���������������������������������������������������������������� 
	aArea :=  (cAliasSRA)->(GetArea())
	U_fGravTit(cFilialAnt,If(cAgrupa$"2*3",cAgrupAnt,If(cAgrupa=="4",cCCAnt,Nil)),If(cAgrupa=="4",cAgrupAnt, Nil),nValTotal)
	RestArea(aArea)
	nValTotal := 0
EndDo              

#IFDEF TOP
( cAliasSRA )->( dbCloseArea() )
#ENDIF

If !Empty( cAliasRC )
	fFimArqMov( cAliasRC , aOrdBagRC , cArqMovRC )
EndIf

dbSelectArea( "SRA" )
dbSetOrder(1)
dbSelectArea( cAlias)


Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fTitUsu  � Autor � Emerson Rosa de Souza � Data � 13.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Busca valores no arquivo definido pelo usuario			  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fTitUsu	    			                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 							                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function fTitUsu(lEnd,lCabec)
Local cAlias   := ALIAS()
Local cFilLimI := If(Empty(cFilAtu), cFilDeT, cFilAtu)
Local cFilLimF := If(Empty(cFilAtu), cFilAteT, cFilAtu)
Local cIniCpo,cPriCpo, cDtFiltro
Local cIndCond,cFor
Local cChaveCab, cChaveLan, cChaveBas
Local aChaveAgrup := {}
Local nRecAgrup   := 0
Local nPosAgrup,cChaveAgrup

Private cArqNtx,cCcLan,cMatLan,cFilLan,cPDLan,cValLan,lMatLan,lMatCab

//��������������������������������������������������������������Ŀ
//� Variavel obritatorias do arquivo LANCAMENTOS  				 �
//����������������������������������������������������������������
dbSelectArea( cAliasLan )
cPriCpo := FieldName(1) // Nome do primeiro campo do arquivo
cIniCpo := Substr(cPriCpo, 1, AT("_", cPriCpo))
cFilLan := cIniCpo + "FILIAL"
cCcLan  := cIniCpo + "CC"
cMatLan := cIniCpo + "MAT"
cValLan := cIniCpo + If(cAliasLan == "SRZ", "VAL",If (cAliasLan == "SRK","VALORTO","VALOR"))
cPDLan  := cIniCpo + If(cAliasLan == "SRT", "VERBA", "PD")
lMatLan := ( FieldPos( cMatLan ) > 0 )

//��������������������������������������������������������������Ŀ
//� Prepara filtro do cadastro de funcionarios       			 �
//����������������������������������������������������������������
dbSelectArea( "SRA" )
dbSetOrder(1)
cFiltrSRA := AllTrim(cFiltrSRA)

//��������������������������������������������������������������Ŀ
//� Chave para comparacao entre arquivo CABECALHO E LANCAMENTOS  �
//����������������������������������������������������������������
cChaveCab := &( "{ || .T.}" )
cChaveLan := &( "{ || .T.}" )

If lCabec

	//��������������������������������������������������������������Ŀ
	//� Variaveis obritatorias do arquivo CABECALHO    				 �
	//����������������������������������������������������������������
	dbSelectArea( cAliasCab )
	cPriCpo := FieldName(1) // Nome do primeiro campo do arquivo
	cIniCpo := Substr(cPriCpo, 1, AT("_", cPriCpo))
	cFilCab := cIniCpo + "FILIAL"
	cMatCab := cIniCpo + "MAT"
	lMatCab := ( FieldPos( cMatCab ) > 0 )

	//��������������������������������������������������������������Ŀ
	//� Monta indice condicional do arquivo CABECALHO                �
	//����������������������������������������������������������������
	cIndCond := cFilCab + If(lMatCab, "+" + cMatCab, "")
	cFor := '(' + cFilCab + If(lMatCab, "+" + cMatCab, "")+;
			' >= "' + cFilLimI + If(lMatCab, cMatDeT,'') + '")'
	cFor += ' .And. (' + cFilCab + If(lMatCab, "+" + cMatCab, "")+;
			' <= "' + cFilLimF + If(lMatCab, cMatAteT ,'') + '")'
	If !Empty(cFiltrCab)
		cFor += ' .And. ' + AllTrim(cFiltrCab)
	EndIf
	If !Empty(cCpoDtCab)
		cDtFiltro := 'DTOS(' + cCpoDtCab + ')'
		cFor += ' .And. (' +cDtFiltro+' >= "'+DTOS(dDataDeT)+'")'+' .And. ('+cDtFiltro+' <= "'+DTOS(dDataAteT)+'")'
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Cria indice temporario do arquivo CABECALHO				     �
	//����������������������������������������������������������������
	cArqNtx := CriaTrab(NIL,.f.)
	IndRegua(cAliasCab,cArqNtx,cIndCond,,cFor,"Selecionando Registros...")  //"Selecionando Registros..."
	dbGoTop()

	//��������������������������������������������������������������Ŀ
	//� Monta chave para busca das verbas no arquivo de LANCAMENTOS  �
	//����������������������������������������������������������������
	cTipoItens  := If(cAliasCab == "SRG", "R", If(cAliasCab == "SRH", "F", ""))
	cChaveBas   := "" //Chave basica para busca - somente Filial + Matricula
	If cAliasCab == "SRG"
		cChaveCab := &( "{ || " + cAliasCab + "->" + cFilCab + " + " + cAliasCab + "->" + cMatCab + " + cTipoItens + Dtos(SRG->RG_DTGERAR) }" )
	ElseIf cAliasCab == "SRH"
		cChaveCab := &( "{ || " + cAliasCab + "->" + cFilCab + " + " + cAliasCab + "->" + cMatCab + " + cTipoItens + Dtos(fDtBusFer()) }" )
	Else
		cChaveCab := &( "{ || " + cAliasCab + "->" + cFilCab + If(lMatCab, " + " + cAliasCab + "->" + cMatCab,"") + " + Dtos(" + cAliasCab + "->" + cCpoDtRel + ") }" )
		cChaveBas := &( "{ || " + cAliasCab + "->" + cFilCab + If(lMatCab, " + " + cAliasCab + "->" + cMatCab,"") + " }" )
	EndIf
	If 	!Empty(cCpoDtLan) 
		cChaveLan := &( "{ || " + cAliasLan + "->" + cFilLan + " + " + cAliasLan + "->" + cMatLan + " + cTipoItens + DTOS(" + cAliasLan + "->" + cCpoDtLan + ") }" )
	Else
		cChaveLan := &( "{ || " + cAliasLan + "->" + cFilLan + " + " + cAliasLan + "->" + cMatLan + " + cTipoItens }" )
    Endif
	//��������������������������������������������������������������Ŀ
	//� Processa o arquivo CABECALHO definido pelo usuario		     �
	//����������������������������������������������������������������
	While !Eof()
		dbSelectArea( cAliasLan )
		If dbSeek( If(Empty(cChaveBas), Eval(cChaveCab), Eval(cChaveBas)) )
			dDataVenc := &(cAliasCab + "->" + cCpoDtCab)
			//��������������������������������������������������������������Ŀ
			//� Efetua tratamento especifico para agrupamento Filial/C.Custo,�
			//� preserva a chave de agrupamento para somar a cada registro.  �
			//����������������������������������������������������������������
			If cAgrupa # "4"           //Agrupamento Funcionario
				cChaveAgrup := ""
				nRecAgrup   := 0
				If cAgrupa == "1"      //Agrupamento Filial
					cChaveAgrup := &cFilLan + Dtos(dDataVenc)
				ElseIf cAgrupa $ "2*3" //Agrupamento Centro de Custo
					cChaveAgrup := &cFilLan + &cCcLan + Dtos(dDataVenc)
				EndIf
				nPosAgrup := Ascan( aChaveAgrup, { |X| X[1] == cChaveAgrup })
				If nPosAgrup > 0
					nRecAgrup := aChaveAgrup[nPosAgrup, 2]
				Else
					Aadd( aChaveAgrup, { cChaveAgrup, 0 } )
				EndIf
			EndIf
			fProcLctos(cChaveCab, cChaveLan, aChaveAgrup, nRecAgrup)
		EndIf
		dbSelectArea( cAliasCab )
		dbSkip()
	EndDo

Else
	//��������������������������������������������������������������Ŀ
	//� Seleciona Alias do arquivo de LANCAMENTOS          			 �
	//����������������������������������������������������������������
	dbSelectArea( cAliasLan )

	//��������������������������������������������������������������Ŀ
	//� Monta indice condicional - LANCAMENTOS             			 �
	//����������������������������������������������������������������
	If cAgrupa $ "2*3"   //Centro de Custo/Nivel de Centro de Custo
		cIndCond := cFilLan + "+" + cCcLan + If(lMatLan, "+" + cMatLan, "")		
	Else
		cIndCond := cFilLan + If(lMatLan, "+" + cMatLan, "") + "+" + cCcLan
	EndIf

	cFor := '(' + cFilLan + "+" + cCcLan + If(lMatLan, "+" + cMatLan, "")+;
			' >= "' + cFilLimI+cCCDeT + If(lMatLan, cMatDeT,'') + '")'
	cFor += ' .And. (' + cFilLan + "+" + cCcLan + If(lMatLan, "+" + cMatLan, "")+;
			' <= "' + cFilLimF+cCCAteT + If(lMatLan, cMatAteT ,'') + '")'

	If !Empty(cFiltrLan)
		cFor += ' .And. ' + AllTrim(cFiltrLan)
	EndIf
	If !Empty(cCpoDtLan)
		cDtFiltro := 'DTOS(' + cCpoDtLan + ')'
		cFor += ' .And. (' +cDtFiltro+' >= "'+DTOS(dDataDeT)+'")'+' .And. ('+cDtFiltro+' <= "'+DTOS(dDataAteT)+'")'
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Cria indice temporario do arquivo de LANCAMENTOS		     �
	//����������������������������������������������������������������
	cArqNtx := CriaTrab(NIL,.f.)
	IndRegua(cAliasLan,cArqNtx,cIndCond,,cFor,"Selecionando Registros...")  //"Selecionando Registros..."
	dbGoTop()
	fProcLctos(cChaveCab, cChaveLan)
EndIf

dbSelectArea( If(lCabec, cAliasCab, cAliasLan) )
Set Filter To
RetIndex( If(lCabec, cAliasCab, cAliasLan) )
dbSetOrder(1)
fErase(cArqNtx+OrdBagExt())
dbSelectArea(cAlias)

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fProcLctos� Autor � Emerson Rosa de Souza � Data � 13.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Busca valores no arquivo de Intes definido pelo usuario	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fProcLctos    			                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 							                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
Static Function fProcLctos(cChaveCab,cChaveLan,aChaveAgrup,nRecAgrup)
Local cAlias := ALIAS()
Local cTipVerba
Local nValTitulo := 0
Local cFilialAnt,cCCAnt,cAgrupAnt
Local cCpoAgrup  := If(cAgrupa == "1", cFilLan, If(cAgrupa $ "2*3", cCcLan, cMatLan))

cFilialAnt := Replicate("!", FWGETTAMFILIAL)
cCCAnt     := Replicate("!", GetSx3Cache("RA_CC", "X3_TAMANHO"))
While !Eof() .And. Eval(cChaveCab) == Eval(cChaveLan)
	
	cFilialAnt 		:= &cFilLan
	cAgrupAnt  		:= &cCpoAgrup
	aAliasFields	:= {}
	
	While !Eof() .And. cFilialAnt + cAgrupAnt == &cFilLan + &cCpoAgrup

		//��������������������������������������������������������������Ŀ
		//� Verifica se satisfaz a condicao do arquivo de Cabecalho    	 �
		//����������������������������������������������������������������
		If Eval(cChaveCab) # Eval(cChaveLan)
			Exit
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Consiste Parametrizacao do Intervalo de Geracao		         �
		//����������������������������������������������������������������
		If (&cFilLan  < cFilDeT ) .Or. (&cFilLan  > cFilAteT ) .Or.;
	       (&cCcLan  <  cCCDeT )  .Or. (&cCcLan   > cCCAteT )  .Or.;
	       If(lMatLan .And. (If(lSrz .And. cMvEncInss=="N",.F.,.T.)), ;
	       ((&cMatLan < cMatDeT) .Or. (&cMatLan > cMatAteT)),.F.)
			dbSkip()
			Loop
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Centro de custo para gravacao quando agrupar por funcionario �
		//����������������������������������������������������������������
		If &cCcLan # cCCAnt
			cCCAnt := &cCcLan
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Testa o filtro do cadastro de funcionarios                   �
		//����������������������������������������������������������������
		If cFiltrSRA # Nil .And. !Empty(cFiltrSRA)
			cChaveBusca := &cFilLan + &cMatLan
			dbSelectArea( "SRA" )
			If dbSeek( cChaveBusca )
				If !&cFiltrSRA
					dbSelectArea( cAliasLan )
					dbSkip()
					Loop
				EndIf
			EndIf			
			dbSelectArea( cAliasLan )
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Verifica se as verbas existem no arquivo em processamento    �
		//����������������������������������������������������������������
		If &cPDLan $ cVerbas
			cTipVerba := Substr( cVerbas, AT(&cPDLan, cVerbas)+3, 1)
			If !(cTipVerba $ "P*D")
				PosSrv(&cPDLan,&cFilLan)
				cTipVerba := If(SRV->RV_TIPOCOD == "2", "D", "P")
				dbSelectArea( cAliasLan )
			EndIf
			If cTipVerba == "P"     // Verbas definidas (No Titulo) pelo usuario como provento
				nValTitulo += &cValLan
			ElseIf cTipVerba == "D" //Verbas definidas (No Titulo) pelo usuario como desconto
   				nValTitulo -= &cValLan
			EndIf                  
			                       
			//�������������������������������������������������������������������������������������Ŀ
			//�O ponto de entrada GP650ACM e utilizado no momento do agrupamento dos titulos        �  
			//�Nele e possivel armazenar no array "aAliasFields" os dados que formam o t�tulo.      �
			//�Exemplo: filial, matricula, verba, centro de custo, valor.                           �
			//�Variaveis dispon�veis:                                                               �
			//�                                                                                     �
			//�"	cFilLan                                                                         �
			//�"	cCpoAgrup                                                                       �
			//�"	cCcLan                                                                          �
			//�"	cMatLan                                                                         �
			//�"	cPDLan                                                                          �
			//�"	cValLan                                                                         �
			//�Todas estas vari�veis dever�o ser utilizadas com o s�mbolo de macro("&") na frente.  �
			//�Ex.: cFil := &cFilLan                                                                �
			//�Utiliar o ponto de entrada GP650CHK para utilizar o numero do titulo e guardar as    �
			//�informacoes em  uma tabela.                                                          �
			//���������������������������������������������������������������������������������������
			//If ExistBlock("GP650ACM")
	         //   ExecBlock("GP650ACM",.F.,.F.)
		    //Endif
	    EndIf
	    
		dbSelectArea(cAliasLan)
		(cAliasLan)->(dbSkip())
	EndDo
	//��������������������������������������������������������������Ŀ
	//� Grava o titulo de acordo com seu agrupamento                 �
	//����������������������������������������������������������������
	U_fGravTit(cFilialAnt,If(cAgrupa$"2*3",cAgrupAnt,If(cAgrupa=="4",cCCAnt,Nil)),;
			            If(cAgrupa=="4",cAgrupAnt, Nil),nValTitulo,aChaveAgrup,nRecAgrup)
	nValTitulo := 0
EndDo
dbSelectArea(cAlias)

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fGravTit � Autor � Emerson Rosa de Souza � Data � 13.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava os valores gerados no arquivo de titulos			  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fGravTit()    			                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 							                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPEM240                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
User Function fGravTit(cFilGrav, cCCGrav, cMatGrav, nValTit, aChaveAgrup, nRecAgrup)
Local cAlias  := ALIAS()
Local cFilAux := cFilAnt
Local cCposRC1, nCnt1, cCpoFornec := cFornec
Local dDataAux
Local aAreaSRA:= SRA->( GetArea() )
Local aAreaSRZ:= SRZ->( GetArea() )
Local aAreaLan:= {}

Private nVlTotTit := nValTit
Private cNovoTit


If cAliasLan # Nil .And. !Empty(cAliasLan)
	aAreaLan	:= (cAliasLan)->(GetArea())
EndIf

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para agrupamento Filial/C.Custo quando o�
//� usuario definir Data de Vencimento pelo arquivo de CABECALHO �
//����������������������������������������������������������������
aChaveAgrup := If( aChaveAgrup == Nil, {}, aChaveAgrup )
nRecAgrup   := If( nRecAgrup   == Nil, 0,  nRecAgrup   )

If !Empty(cFilGrav) .And. nVlTotTit > 0

	//��������������������������������������������������������������Ŀ
	//� Verifica se Fornecedor foi preenchido com campo de arquivo   �
	//����������������������������������������������������������������
	If "_" $ cFornec
		cCpoFornec := ""
		If cAgrupa $ "2*3" .And. lExistCC .And. cCCGrav # Nil
			dbSelectArea( cAliasCC )
			dbSeek( xFilial(cAliasCC) + cCCGrav )
			cCpoFornec := &( cAliasCC + "->" + AllTrim(cFornec) )
		ElseIf cAgrupa == "4" .And. lExistMAT .And. cMatGrav # Nil
			dbSelectArea( "SRA" )
			dbSeek( cFilGrav + cMatGrav )			
			cCpoFornec := &( "SRA->" + AllTrim(cFornec) )
		EndIf
	EndIf

	//����������������������������������������������������������������������Ŀ
	//� Novo numero do titulo deve ser antes do Reclock devido a integridade �
	//������������������������������������������������������������������������
	cNovoTit := GetSx8Num("RC1","RC1_NUMTIT",,RetOrdem( "RC1" , "RC1_FILIAL+RC1_NUMTIT" ))

	//��������������������������������������������������������������Ŀ
	//� Posiciona cFilAnt na filial corrente p/ garantir Integridade �
	//����������������������������������������������������������������
	cFilAnt := cFilGrav

	dbSelectArea( "RC1" )

	//��������������������������������������������������������������Ŀ
	//� Ponto de entrada para checar o valor do titulo               �
	//����������������������������������������������������������������
	If ExistBlock("GP650CHK")
		If !( ExecBlock("GP650CHK",.F.,.F.) )
			dbSelectArea( cAlias )
			Return( Nil )
		EndIf
	Endif                  
	
	dDataVenc := If( !empty(dVctoInf),dVctoInf,dDataVenc)

	If nRecAgrup > 0
		dbGoTo( nRecAgrup )
		RecLock("RC1",.F.,.F.)
		RC1->RC1_VALOR += nVlTotTit
		MsUnLock()
		//integracao com modulo SIGAPCO
		PcoDetLan("000092","01","GPEM650")
	Else
		RecLock("RC1",.T.,.T.)
		RC1->RC1_FILIAL   := SUBS(If( Empty(xFilial("RC1")), Space(FWGETTAMFILIAL), cFilGrav ),1,2)
		RC1->RC1_INTEGR   := "0"
		RC1->RC1_FILTIT   := cFilGrav
		If lExistCC .And. cCCGrav # Nil .and. cAgrupa # "1"
			RC1->RC1_CC := cCCGrav
		EndIf
		If lExistMAT .And. cMatGrav # Nil
			RC1->RC1_MAT := cMatGrav
		EndIf
		
		//Tratamento de Integra��o Logix x Rh Protheus
		IF RC1->( FieldPos('RC1_ARELIN') ) > 0
			fGravArelin( cMatGrav )
		ENDIF
		
		RC1->RC1_CODTIT   := cCodTit
		RC1->RC1_DESCRI   := cDescri
		RC1->RC1_PREFIX   := cPrefix
		RC1->RC1_NUMTIT   := cNovoTit
		RC1->RC1_TIPO     := cIdentTit
		RC1->RC1_NATURE   := cNature
		RC1->RC1_FORNEC   := cCpoFornec
		RC1->RC1_LOJA	  := cLoja
		RC1->RC1_EMISSA   := dDtEmisTit
		dDataAux 		  := DataValida(dDataVenc,If(cdiaUtil =="1",.F.,.T.))	// Vencimento real
		dDataVenc		  := If(dDataAux < dDataVenc,dDataAux,dDataVenc)		// Vencimento
		RC1->RC1_VENCTO   := dDataVenc
		RC1->RC1_VENREA   := dDataAux
		RC1->RC1_VALOR    := nVlTotTit
		RC1->RC1_DTBUSI   := dDataDeT
		RC1->RC1_DTBUSF   := dDataAteT

		//��������������������������������������������������������������Ŀ
		//� Grava os campos criados pelo usuario - do RC0 para o RC1.    �
		//����������������������������������������������������������������
	   	For nCnt1 := 1 To Len(aCposUsu)
	   		cCposRC1  := aCposUsu[nCnt1,2]
			&cCposRC1 := aCposUsu[nCnt1,3]
	   	Next nCnt1

		//��������������������������������������������������������������Ŀ
		//� Grava no array o numero do recno para agrupar posteriormente �
		//����������������������������������������������������������������
		If Len(aChaveAgrup ) > 0
			aChaveAgrup[Len(aChaveAgrup),2] := RECNO()
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Ponto de entrada para alterar campos do RC1                  �
		//����������������������������������������������������������������
		If ExistBlock("GP650CPO")
			EXECBLOCK("GP650CPO",.F.,.F.)
		Endif

		RC1->( MsUnLock() )
		ConfirmSX8()
		//integracao com modulo SIGAPCO
		PcoDetLan("000092","01","GPEM650")
	EndIf
	dbSelectArea( cAlias )

	//��������������������������������������������������������������Ŀ
	//� Retorna filial original para o cFilAnt                       �
	//����������������������������������������������������������������
	cFilAnt := cFilAux

EndIf
RestArea( aAreaSRA ) 
RestArea( aAreaSRZ )
If Len(aAreaLan)>0
	RestArea( aAreaLan )
EndIf
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GP650SX3	 � Autor � Tania Bronzeri       � Data �16/03/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta SX3                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
/*
User Function GP650SX3()
Local cReserv	 := ""
Local cUsado	 := ""

dbSelectArea( "SX3" )
dbSetOrder(2)

If dbSeek("RC1_FORNEC")
	cReserv	:=	SX3->X3_RESERV
	cUsado	:=	SX3->X3_USADO
EndIf

If dbSeek("RC1_LOJA")
	If !Empty(cReserv) .And. ((SX3->X3_RESERV # cReserv) .Or. (SX3->X3_USADO # cUsado))
		RecLock("SX3",.F.)
		SX3->X3_RESERV	:=	cReserv
		SX3->X3_USADO	:=	cUsado
		MsUnlock()
	EndIf
EndIf
Return Nil
*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGravArelin  �Autor  �Tiago Malta      � Data �  10/09/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Integra��o Logix X Rh Protheus.                  			  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fGravArelin( cMat )

Local cDepto  := space(10)
Local cArelin := space(10) 

	IF cMat <> nil .AND. !EMPTY(cMat) .AND. Getmv("MV_ERPLOGIX") == '1'
	
		SRA->( dbSetOrder(1) )
		SRA->( dbSeek( xFilial('SRA') + cMat ) )
		cDepto := SRA->RA_DEPTO
		
		SQB->( dbSetOrder(1) )
		SQB->( dbSeek( xFilial('SQB') + cDepto ) )
		cArelin := SQB->QB_ARELIN 
		
		IF !EMPTY(cArelin)
			RC1->RC1_ARELIN := cArelin
		ENDIF 
		
	ENDIF

Return()
