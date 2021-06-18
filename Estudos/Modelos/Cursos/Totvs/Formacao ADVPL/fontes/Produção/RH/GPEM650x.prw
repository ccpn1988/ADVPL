#INCLUDE "PROTHEUS.CH"
#INCLUDE "Report.ch"

Static lExInAs400			:= ExeInAs400()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPEM650  ³ Autor ³ Emerson Rosa de Souza ³ Data ³ 09/08/2001   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera Movimentacao de Titulos no arquivo RC1                    ³±±                    
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS   ³  Motivo da Altera‡„o                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Emerson     ³ 19/09/01 ³        ³Alterar variavel nValDeducao p/ nValDedSer³±±
±±³Emerson     ³ 22/02/02 ³        ³Gravar no RC1 campos criados pelo usuario.³±±
±±³Emerson     ³ 07/03/02 ³        ³Passar a somar desconto do adto e subtrair³±±
±±³            ³          ³        ³base de I.R. do adto na funcao fTitUsu(). ³±±
±±³Emerson     ³ 13/05/02 ³        ³Tratar verba de acordo com definicao(P/D).³±±
±±³Emerson     ³ 19/07/02 ³        ³Inclusao do ponto de entrada GP650CPO para³±±
±±³            ³          ³        ³regravar campos do RC1 apos geracao titulo³±±
±±³Andreia     ³ 07/08/02 ³059060  ³Passagem da filial e do centro de custo na³±±
±±³            ³          ³        ³funcao "GPM240Proc" para filtragem correta³±±
±±³            ³          ³        ³destes campos.                            ³±±
±±³Emerson     ³ 02/10/02 ³        ³Buscar filial no RC0 de acordo com xFilial³±±
±±³Emerson     ³ 09/10/02 ³        ³Se o arquivo RC0 estiver exclusivo,filtrar³±±
±±³            ³          ³        ³titulo do usuario pela filial do arquivo. ³±±
±±³Emerson     ³ 05/03/03 ³        ³Tratar os novos campos de data vencimento ³±±
±±³            ³          ³        ³utilizados principalmente para geracao dos³±±
±±³            ³          ³        ³titulos de ferias e rescisao entre outros.³±±
±±³Emerson     ³ 01/04/03 ³        ³Alterar conteudo de "nTipImp" de 2 para 1.³±±
±±³Emerson     ³ 23/05/03 ³        ³Criar variavel cCpoFornec em fGravTit().  ³±±
±±³Emerson     ³ 08/07/03 ³        ³Inicializar var. cCpoFornec com cFornec.  ³±±
±±³Emerson     ³ 02/12/03 ³        ³Alteracao na gravacao do campo RC1_FILIAL,³±±
±±³            ³          ³        ³se arquivo compartilhado,gravar vazio,caso³±±
±±³            ³          ³        ³contrario gravar a filial do titulo.      ³±±
±±³Emerson     ³ 28/04/04 ³        ³Manter cFilAnt atualizada de acordo com a ³±±
±±³            ³          ³        ³filial que esta sendo gravada-Integridade ³±±
±±³Emerson     ³ 03/09/04 ³        ³Criar ponto de entrada p/checar Vl.Titulo.³±±
±±³Natie       ³ 09/08/05 ³Q02559  ³Testa conteudo cCpoDtLan                  ³±±
±±³Natie       ³ 29/08/05 ³083473  ³Efetua gravacao da dt de vencto conforme  ³±±
±±³            ³          ³        ³det.pelo usuario e grava dt vcto real veri³±±
±±³            ³          ³        ³cando Sabado/Domingo                      ³±±
±±³Andreia     ³ 02/11/05 ³087658  ³Criado novo campo na tabela RC0 para defi-³±±
±±³            ³          ³        ³nir se o vencimento real sera antecipado  ³±±
±±³            ³          ³        ³ou postergado no caso de cair em dia nao  ³±±
±±³            ³          ³        ³util.                                     ³±±
±±³Andreia     ³ 21/11/05 ³088063  ³Criada uma pergunta para informar a data  ³±±
±±³            ³          ³        ³de vencimento do titulo. Se esta pergunta ³±±
±±³            ³          ³        ³for informada, a data de vencimento confi-³±±
±±³            ³          ³        ³gurada na definicao do titulo sera ignora-³±±
±±³            ³          ³        ³da.                                       ³±±
±±³Ricardo D.  ³ 30/01/06 ³091675  ³Implementacao do calculo da data de venci-³±±
±±³            ³          ³        ³mento para o mes seguinte ao mes de pagto.³±±
±±³Tania       ³08/03/2006³092116  ³Nao permitir geracao de titulo do tipo An-³±±
±±³            ³          ³        ³tecipado (PA ou RA).                      ³±±
±±³Tania       ³16/03/2006³094353  ³Inclusao do campo Loja na rotina de gera- ³±±
±±³            ³          ³        ³cao do titulo.                            ³±±
±±³Ricardo D.  ³ 23/03/06 ³095821  ³Ajuste na gravacao dos campos de data de  ³±±
±±³            ³          ³        ³vencimento e data real pois a real nunca  ³±±
±±³            ³          ³        ³podera ser menor que a de vencimento.     ³±±
±±³Tania       ³25/04/2006³096638  ³Incluida consistencia de tabela. Quando   ³±±
±±³            ³          ³        ³for SRZ, nao fara validacao da matricula x³±±
±±³            ³          ³        ³intervalo do SX1.                         ³±±
±±³Tania       ³08/05/2006³098177  ³Acertada rotina de seek na tabela SRA, que³±±
±±³            ³          ³        ³ocasionava loop na gravacao do titulo re- ³±±
±±³            ³          ³        ³ferente a pensao.                         ³±±
±±³Tania       ³22/05/2006³098586  ³Salva e restaurada a area de trabalho nos ³±±
±±³            ³          ³        ³pontos em que faria nova leitura no arqui-³±±
±±³            ³          ³        ³vo.                                       ³±±
±±³Tania       ³01/09/2006³100146  ³Colocado o Include Report.Ch, para nao pro³±±
±±³            ³          ³        ³vocar erro na chamada do GPER050, para ge-³±±
±±³            ³          ³        ³racao dos titulos para o financeiro.      ³±±
±±³Ricardo D.  ³16/02/2007³119323  ³Ajuste no tratamento da variavel cCodTit  ³±±
±±³            ³          ³        ³p/nao entrar em looping quando o codigo da³±±
±±³            ³          ³        ³definicao de titulos estiver preenchido   ³±±
±±³            ³          ³        ³com 1 ou 2 digitos.                       ³±±
±±³Natie       ³19/03/07  ³120710  ³fGravTit-Salva e restaura a area(SRZ)     ³±±
±±³            ³          ³104235  ³                                          ³±±
±±³Renata E.   ³12/06/2007³112744  ³Ajuste em fGerPen, para abertura do       ³±±
±±³            ³          ³        ³arquivo correspondente ao mes\ano de comp ³±±
±±³            ³          ³        ³(opensrc).                                ³±±
±±³Mauro       ³06/07/2007³128822  ³Geracao de Titulos e Integracao com o fi- ³±±
±±³            ³          ³        ³nanceiro sobre verbas em valores futuros. ³±±
±±³Renata E.   ³11/12/2007³137459  ³Ajuste em fGerPen, posicionando o "while" ³±±
±±³            ³          ³        ³no SRA (While SRA->( !EOF())).		      ³±±
±±³Renata E.   ³19/12/2007³138160  ³Ajuste em fGravTit para gravar o campo    ³±±
±±³            ³          ³        ³RC1->R1_CC em branco qdo agrupamento for  ³±±
±±³            ³          ³        ³tipo "1 - Filial"					      ³±±
±±³Jonatas     ³25/04/2008³144123  ³Ajuste para tratar duplicidade de pensoes ³±±
±±³            ³          ³        ³existentes em rescisao e folha.           ³±±
±±³            ³          ³        ³Ajuste para leitura do arq. de fechamento.³±±
±±³Kelly       ³12/05/2008³141326  ³Ajuste no grupo de perguntas.             ³±±
±±³Renata E.   ³20/06/2008³148229  ³Ajuste na funcao "GPM240Proc", incluindo  ³±±
±±³            ³          ³        ³a passagem do tipo de contrato (cTpc),    ³±±
±±³            ³          ³        ³devido alteracao bops 141497              ³±±
±±³Marcelo     ³01/08/2008³150569  ³Ajuste em fGravTit para buscar a filial   ³±±
±±³            ³          ³        ³correta quando o fornecedor for preenchido³±±
±±³            ³          ³        ³com campo de arquivo.                     ³±±
±±³Marcelo     ³11/08/2008³145690  ³Retirado o bloqueio p/inclusao de titulos ³±±
±±³            ³          ³        ³do Tipo PA.                               ³±±
±±³Marcelo     ³18/08/2008³151593  ³Ajuste na funcao fTitUsu para indexar os  ³±±
±±³            ³          ³        ³lancamentos conforme o tipo de agrupamento³±±
±±³            ³          ³        ³definido.                                 ³±±
±±|Luciana     |07/01/2009|52382008|Inclusao de variaveis para tratar geracao ³±±
±±|            |          |        |do SRZ via procedure.                     ³±±
±±³Leandro Dr. ³20/03/2009³69172009³Ajuste para criacao de indice na tabela   ³±±
±±³            ³          ³        ³RC1 se necessario.                        ³±±
±±³Leandro Dr. ³01/06/2009³00013280³Alteracao na chamada da funcao GetSxeNum  ³±±
±±³            ³          ³        ³para GetSx8Num enviando o indice desejado.³±±
±±³Alex        ³11/08/2009³--------³Ajuste no Grupo de Campos filial          ³±±
±±³            ³          ³        ³tratamento para não considerar 2 posições ³±±
±±³            ³          ³        ³ fixas.                                   ³±±
±±³Andreia     ³03/09/2009³18389/09³Criacao do ponto de entrada GP650ACM      ³±±
±±³Andreia     ³29/09/2009³23773/09³A variavel aAliasFields foi declarada na  ³±±
±±³            ³          ³        ³GPM650Proc() para que possa ser vista por ³±±
±±³            ³          ³        ³todas as funcoes.                         ³±±
±±³Tiago Malta ³  19/10/09³22649/09³Ajuste para integração Logix com          ³±±
±±³            ³          ³        ³Rh Porhteus                               ³±±  
±±³Luciana     ³  28/01/10³21796/09³Criacao de query na fgerPens para filtrar ³±±
±±³            ³          ³        ³apenas os funcionarios que tenham registro³±± 
±±³            ³          ³        ³no Cadastro de Beneficiarios.             ³±± 
±±³Luciana     ³  18/05/10³09249/10³Ajuste na  GPM650Proc para considerar as  ³±±
±±³            ³          ³        ³cFilIni e cFilFim na chamada da GPM240Proc³±± 
±±³            ³          ³        ³para nao gravar titulos duplicados por    ³±± 
±±³            ³          ³        ³filial.                                   ³±±          
±±³Mauricio MR ³  22/06/10³0012985/³Ajuste na  GPM650Proc para considerar as  ³±±
±±³            ³          ³2010    ³filiais De/Ate no caso da tabela RC0 - De-³±± 
±±³            ³          ³        ³finicoes de titulos, estiver compartilhada³±± 
±±³            ³          ³        ³No caso dessa tabela estiver exclusiva, so³±±          
±±³            ³          ³        ³mente serao considerados os funcionarios  ³±±          
±±³            ³          ³        ³da filial de cada definicao de titulo.    ³±±          
±±³            ³          ³        ³Essas alteracoes serao aplicadas para a   ³±±          
±±³            ³          ³        ³geracao de titulos de IR e INSS/13o sal.  ³±±          
±±³Mauricio MR ³  04/08/10³0016903/³Ajuste na GPM650Proc para desprezar a data³±±
±±³            ³          ³2010    ³invalida gerada devido ao dia nao existir ³±± 
±±³            ³          ³        ³para o mes e assumir o ultimo dia do mes  ³±± 
±±³            ³          ³        ³do titulo.								  ³±± 
±±³Renata Elena³  13/05/11³0010862/³Ajuste em fGerPens, para inicilizar a     ³±±
±±³            ³          ³2011    ³variavel cAliasSRA() com "SRA"			  ³±± 
±±³Mauricio MR ³  07/07/11³0015614/³Ajuste para obter os beneficiarios vigen- ³±±
±±³            ³          ³2011    ³tes na data de referencia.				  ³±± 
±±³Luis Ricardo³09/08/2011³00014150³Disponibilizacao da geracao de titulos p/ ³±±
±±³Cinalli	   ³		  ³	   2011³nova opcao de tipo  de titulo (006-INSS de³±±
±±³			   ³		  ³		   ³Dissidio) e tratamento para nova tabela de³±±
±±³			   ³		  ³		   ³dissidio acumulado (RHH).				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
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

Aadd(aRegs,{"GPM650","13","Data de Vencimento ?","¿Fecha de Vencimiento ?","Due Date ?","mv_chd","D",08,0,00,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","S",aHelpPor,aHelpEng,aHelpSpa})

ValidPerg(aRegs,"GPM650",.T.)

Pergunte("GPM650",.F.)

If !Rc1VerInd() //Retirar nas proximas versoes
	Aviso( OemToAnsi("Atencao"),  OemToAnsi("Deve ser executado o programa para atualização de base do SIGAGPE - (RHUPDMOD)") +  CRLF + OemToAnsi("Selecione a atualização 'Ajustar Indices - RC1'."), { "OK" } ) //##"Atencao"##"Deve ser executado o programa para atualização de base do SIGAGPE - (RHUPDMOD)"##"Selecione a atualização 'Ajustar Indices - RC1'."
	Return
EndIf

//U_GP650SX3()

/* Retorne os Filtros que contenham os Alias Abaixo */
aAdd( aFilterExp , { "FILTRO_ALS" , "RC0"     	, NIL , NIL } )
/* Que Estejam Definidos para a Função */
aAdd( aFilterExp , { "FILTRO_PRG" , FunName() 	, NIL , NIL    } )


AADD(aSays,OemToAnsi( "Este programa gera titulos no  arquivo  de  movimentos (RC1) a partir do cadastro de" )) //"Este programa gera titulos no  arquivo  de  movimentos (RC1) a partir do cadastro de"
AADD(aSays,OemToAnsi( "definicoes (RC0). Apos gerados, estarao disponiveis para consultas e integracao com "))  //"definicoes (RC0). Apos gerados, estarao disponiveis para consultas e integracao com "
AADD(aSays,OemToAnsi( "o financeiro.                           											 "))  //"o financeiro.                           											 "

AADD(aButtons, { 17,.T.,{|| aRetFiltro := FilterBuildExpr( aFilterExp ) } } )
AADD(aButtons, { 5,.T.,{|o| Pergunte("GPM650",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1, If(GPM650OK(),FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a gravacao dos lancamentos do SIGAPCO        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoIniLan("000092")

FormBatch( cCadastro, aSays, aButtons )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a gravacao dos lancamentos do SIGAPCO          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PcoFinLan("000092")

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GPM650Proc³ Autor ³ Emerson Rosa de Souza ³ Data ³ 04.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de geracao de Titulos							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPM650Proc()  			                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 							                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function GPM650Proc()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis LOCAIS DO PROGRAMA                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAlias   := ALIAS()
Local cTitProc,nCnt,nCnt1,nFol13Sal,nNroSem,lCabec
Local cCpoPadRC1,cCposRC0, cRC1Cpo, cRC1Conf, nRecnoRC1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE DO PROGRAMA                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aCposUsu  	:= {}
Private dDataVenc 	:= CTOD("")
Private cAliasCC  	:= If(CtbInUse(), "CTT", "SI3")
Private lExistCC, lExistMAT, lExistDtV 
Private lSrz		:=	.F.
Private cMvEncInss	:=	SuperGetMv("MV_ENCINSS",,"N")
Private cERPLOGIX	:= GETMV( "MV_ERPLOGIX",,"2")
_SetOwnerPrvt(	"aAliasFields"	, {} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                          ³
//³ mv_par01        //  Filial De                                 ³
//³ mv_par02        //  Filial Ate                                ³
//³ mv_par03        //  Centro de Custo De                        ³
//³ mv_par04        //  Centro de Custo Ate                       ³
//³ mv_par05        //  Matricula De                              ³
//³ mv_par06        //  Matricula Ate                             ³
//³ mv_par07        //  Dt. Busca Pagto De                        ³
//³ mv_par08        //  Dt. Busca Pagto Ate                       ³
//³ mv_par09        //  Codigo Titulo De                          ³
//³ mv_par10        //  Codigo Titulo Ate                         ³
//³ mv_par11        //  Data de Emissao                           ³
//³ mv_par12        //  Competencia                               ³
//³ mv_par13        //  Data de vencimento                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Campos do RC1 (padrao do sistema)							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCpoPadRC1 := "RC1_FILIAL/RC1_INTEGR/RC1_FILTIT/RC1_CODTIT/RC1_DESCRI/RC1_PREFIX/"+;
			  "RC1_NUMTIT/RC1_TIPO/RC1_NATURE/RC1_FORNEC/RC1_EMISSA/RC1_VENCTO/"  +;
			  "RC1_VENREA/RC1_VALOR/RC1_DTBUSI/RC1_DTBUSF"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega os Filtros                                 	 	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cRC0Filter	:= GpFltAlsGet( aRetFiltro , "RC0" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para geracao do SRZ via procedure     	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lFolPgto    := .F.
lFol13Sl    := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava no array os campos do usuario criados no arquivo RC0 e ³
//³ RC1, assegurando que os dois tem o mesmo tipo e tamanho.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existem os campos RC1_CC e RC1_MAT				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "RC1" )
lExistCC  := ( FieldPos( "RC1_CC"  ) # 0 )
lExistMAT := ( FieldPos( "RC1_MAT" ) # 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica existencia dos cpos RC0_ALIADV/RC0_CPOBDV/RC0_FILTDV³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica existencia da nova tabela de Dissidio Acumulado (RHH) SE a		³
	//³ geracao de Titulo for de Dissidio. Se NAO existir a tabela sera			³
	//³ apresentada a mensagem informando a necessidade da execucao do update 	³
	//³ 143 para a criacao e impede a execucao da geracao somente para o tipo de³
	//³ titulo 006 - INSS - DISSIDIO ate que o update seja executado.			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If RC0->RC0_TIPTIT == '1' .and. '006' $ AllTrim( RC0->RC0_VERBAS ) .and. ! Sx2ChkTable( "RHH" )

		Aviso( "Atencao", "Execute a opção do compatibilizador referente à criação da nova tabela de Dissídio Acumulado. Para maiores informações verifique respectivo Boletim Técnico." + CRLF + "Somente os títulos de tipo 006 - INSS - Dissidio NÃO serão gerados até que o compatibilizador seja executado.", { "ok" } )																		//"Somente os títulos de tipo 006 - INSS - Dissidio NÃO serão gerados até que o compatibilizador seja executado." ## "OK"

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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o conteudo dos campos de usuario do RC0 em aCposUsu	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	For nCnt1 := 1 To Len(aCposUsu)
   		cCposRC0          := aCposUsu[nCnt1,1]
		aCposUsu[nCnt1,3] := &cCposRC0
   	Next nCnt1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula data de vencimento do titulo						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existem outros registro e os carregas em cVerbas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. RC0->RC0_FILIAL+RC0->RC0_CODTIT == cFilAtu+cCodTit
	   	cVerbas += AllTrim(RC0->RC0_VERBAS)
	   	dbSkip()
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Geracao dos titulos padroes do sistema                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipTit == "1"
		cTitProc := Left(cVerbas,3)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada para o programa de geracao do INSS - FOLHA/13o		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTitProc $ "001*002"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se deve gerar o arquivo SRZ com os valores de INSS	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nFol13Sal := If(cTitProc == "001", 1, 2)   // 1-Folha, 2-13o Salario
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Variaveis utilizadas para geracao do SRZ via procedure     	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lFolPgto    := ( nFol13Sal == 1 ) // Geracao dos registros 'FL' no SRZ
			lFol13Sl    := ( nFol13Sal == 2 ) // Geracao dos registros '13' no SRZ
			Rst040Imp() // Reinicializa static para execucao da procedure
			If !fGeraFolSRZ(nFol13Sal,{1,2},cCompetTit)    // 1-Indeterminado, 2-Determinado
				Loop
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carregando variaveis mv_par?? para Variaveis do Sistema      ³
			//³ Estas variaveis serao utilizadas em GPM240Proc()			 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nValAutonomo  := 0.00
			nValProLabore := 0.00
			nValReceita   := 0.00
			nValDedSer    := 0.00
			nValJuros     := 0.00
		 	cCentra       := ""
			cCompetencia  := cCompetTit
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tipo de Geracao na GPS:     1 - CC, 2 - Nivel CC, 3 - Filial ³
			//³ Tipo de Geracao no Titulo:  2 - CC, 3 - Nivel CC, 1 - Filial ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPorCc        := If(cAgrupa == "2", 1, If(cAgrupa == "3", 2, 3))
			cNivCCusto    := If( nPorCc == 2, "1", "")
			cTipo         := nFol13Sal
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processa duas vezes. 1-Contrato Indeterminado, 2-Determinado ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada para o programa de geracao dos valores de I.R.	     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf cTitProc == "003"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carregando variaveis mv_par?? para Variaveis do Sistema      ³
			//³ Estas variaveis serao utilizadas em GR050Imp()				 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ordem na Impressao do I.R.: 1 - Mat, 2 - CC,    3 - Nome	 ³
			//³ Ordem na Geracao de titulo: 2 - CC,  3 - Nivel, 1 - Filial   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nOrdem := If(cAgrupa $ "2*3", 2, 1)
			
			IF cCodTit $ "004-035"
			   Processa({|lEnd| U_GN050Imp(2,@lEnd,,,cAgrupa,,"GENM650"),"Gerando arquivo aguarde..."})  //"Gerando arquivo aguarde..."
            ELSE  
               Processa({|lEnd| N050Imp(2,@lEnd,,,cAgrupa,,"GENM650"),"Gerando arquivo aguarde..."})  //"Gerando arquivo aguarde..."
            ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada para o programa de geracao dos valores de PENSAO     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf cTitProc == "004"

			Processa({|lEnd| fGerPens(@lEnd),"Gerando arquivo aguarde..."})  //"Gerando arquivo aguarde..."

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada para o programa de geracao dos valores de DISSIDIO   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf cTitProc $ "006"

			Rst040Imp() // Reinicializa static para execucao da procedure
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carregando variaveis mv_par?? para Variaveis do Sistema      ³
			//³ Estas variaveis serao utilizadas em GPM240PrcD()			 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nValAutonomo  := 0.00
			nValProLabore := 0.00
			nValReceita   := 0.00
			nValDedSer    := 0.00
			nValJuros     := 0.00
		 	cCentra       := ""
			cCompetencia  := cCompetTit
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tipo de Geracao na GPS:     1 - CC, 2 - Nivel CC, 3 - Filial ³
			//³ Tipo de Geracao no Titulo:  2 - CC, 3 - Nivel CC, 1 - Filial ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPorCc        := If( cAgrupa == "2", 1, If(cAgrupa == "3", 2, 3))
			cNivCCusto    := If( nPorCc == 2, "1", "")
			cTipo         := nFol13Sal
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processa duas vezes. 1-Contrato Indeterminado, 2-Determinado ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Geracao dos titulos definidos pelo usuario					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf cTipTit == "2"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica Alias e Campo para filtrar o periodo   			 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GPM650OOk ³ Autor ³ Emerson Rosa de Souza ³ Data ³ 13.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Confirma parametros             							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPM650Ok()    			                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 							                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function GPM650Ok()

Return (MsgYesNo(OemToAnsi("Confirma configuracao dos parametros?"),OemToAnsi("Atencao"))) //"Confirma configura‡„o dos parƒmetros?"###"Aten‡„o"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fGerPens ³ Autor ³ Emerson Rosa de Souza ³ Data ³ 13.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta valores de pensao e grava no arquivo de titulos	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGerPens	    			                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 							                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Privates utilizadas em fBuscaLiq()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega Regua Processamento	                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica quebra de filial e busca novos codigos da folha     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	If (cAliasSRA)->RA_FILIAL # cFilialAnt
	   IF !FP_CODFOL(@aCodFol,(cAliasSRA)->RA_FILIAL)
	      Exit
	   Endif
	   cFilialAnt := (cAliasSRA)->RA_FILIAL
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Centro de custo para gravacao quando agrupar por funcionario ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cAliasSRA)->RA_CC # cCCAnt
		cCCAnt := (cAliasSRA)->RA_CC
	EndIf

	cAgrupAnt := &cCpoAgrup
	While (cAliasSRA)->( !Eof() ) .And. ( cFilialAnt + cAgrupAnt == (cAliasSRA)->RA_FILIAL + (cAliasSRA)->&cCpoAgrup )
		IncProc("Gerando Titulos - " + cDescri) //"Gerando Titulos - "
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao de acordo com definicao				 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ((cAliasSRA)->RA_CC  <  cCCDeT)  .Or. ((cAliasSRA)->RA_CC  > cCCAteT) .Or.;
		   ((cAliasSRA)->RA_MAT <  cMatDeT) .Or. ((cAliasSRA)->RA_MAT > cMatAteT)
		    (cAliasSRA)-> (dbSkip()) 
		    Loop
		EndIf 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca os valores do beneficiario							 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o titulo de acordo com seu agrupamento			     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fTitUsu  ³ Autor ³ Emerson Rosa de Souza ³ Data ³ 13.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Busca valores no arquivo definido pelo usuario			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fTitUsu	    			                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 							                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel obritatorias do arquivo LANCAMENTOS  				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAliasLan )
cPriCpo := FieldName(1) // Nome do primeiro campo do arquivo
cIniCpo := Substr(cPriCpo, 1, AT("_", cPriCpo))
cFilLan := cIniCpo + "FILIAL"
cCcLan  := cIniCpo + "CC"
cMatLan := cIniCpo + "MAT"
cValLan := cIniCpo + If(cAliasLan == "SRZ", "VAL",If (cAliasLan == "SRK","VALORTO","VALOR"))
cPDLan  := cIniCpo + If(cAliasLan == "SRT", "VERBA", "PD")
lMatLan := ( FieldPos( cMatLan ) > 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Prepara filtro do cadastro de funcionarios       			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA" )
dbSetOrder(1)
cFiltrSRA := AllTrim(cFiltrSRA)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para comparacao entre arquivo CABECALHO E LANCAMENTOS  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChaveCab := &( "{ || .T.}" )
cChaveLan := &( "{ || .T.}" )

If lCabec

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis obritatorias do arquivo CABECALHO    				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( cAliasCab )
	cPriCpo := FieldName(1) // Nome do primeiro campo do arquivo
	cIniCpo := Substr(cPriCpo, 1, AT("_", cPriCpo))
	cFilCab := cIniCpo + "FILIAL"
	cMatCab := cIniCpo + "MAT"
	lMatCab := ( FieldPos( cMatCab ) > 0 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta indice condicional do arquivo CABECALHO                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria indice temporario do arquivo CABECALHO				     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqNtx := CriaTrab(NIL,.f.)
	IndRegua(cAliasCab,cArqNtx,cIndCond,,cFor,"Selecionando Registros...")  //"Selecionando Registros..."
	dbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta chave para busca das verbas no arquivo de LANCAMENTOS  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa o arquivo CABECALHO definido pelo usuario		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		dbSelectArea( cAliasLan )
		If dbSeek( If(Empty(cChaveBas), Eval(cChaveCab), Eval(cChaveBas)) )
			dDataVenc := &(cAliasCab + "->" + cCpoDtCab)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Efetua tratamento especifico para agrupamento Filial/C.Custo,³
			//³ preserva a chave de agrupamento para somar a cada registro.  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona Alias do arquivo de LANCAMENTOS          			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( cAliasLan )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta indice condicional - LANCAMENTOS             			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria indice temporario do arquivo de LANCAMENTOS		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fProcLctos³ Autor ³ Emerson Rosa de Souza ³ Data ³ 13.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Busca valores no arquivo de Intes definido pelo usuario	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fProcLctos    			                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 							                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
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

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se satisfaz a condicao do arquivo de Cabecalho    	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Eval(cChaveCab) # Eval(cChaveLan)
			Exit
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao do Intervalo de Geracao		         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (&cFilLan  < cFilDeT ) .Or. (&cFilLan  > cFilAteT ) .Or.;
	       (&cCcLan  <  cCCDeT )  .Or. (&cCcLan   > cCCAteT )  .Or.;
	       If(lMatLan .And. (If(lSrz .And. cMvEncInss=="N",.F.,.T.)), ;
	       ((&cMatLan < cMatDeT) .Or. (&cMatLan > cMatAteT)),.F.)
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Centro de custo para gravacao quando agrupar por funcionario ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If &cCcLan # cCCAnt
			cCCAnt := &cCcLan
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Testa o filtro do cadastro de funcionarios                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se as verbas existem no arquivo em processamento    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
			                       
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³O ponto de entrada GP650ACM e utilizado no momento do agrupamento dos titulos        ³  
			//³Nele e possivel armazenar no array "aAliasFields" os dados que formam o título.      ³
			//³Exemplo: filial, matricula, verba, centro de custo, valor.                           ³
			//³Variaveis disponíveis:                                                               ³
			//³                                                                                     ³
			//³"	cFilLan                                                                         ³
			//³"	cCpoAgrup                                                                       ³
			//³"	cCcLan                                                                          ³
			//³"	cMatLan                                                                         ³
			//³"	cPDLan                                                                          ³
			//³"	cValLan                                                                         ³
			//³Todas estas variáveis deverão ser utilizadas com o símbolo de macro("&") na frente.  ³
			//³Ex.: cFil := &cFilLan                                                                ³
			//³Utiliar o ponto de entrada GP650CHK para utilizar o numero do titulo e guardar as    ³
			//³informacoes em  uma tabela.                                                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//If ExistBlock("GP650ACM")
	         //   ExecBlock("GP650ACM",.F.,.F.)
		    //Endif
	    EndIf
	    
		dbSelectArea(cAliasLan)
		(cAliasLan)->(dbSkip())
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o titulo de acordo com seu agrupamento                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_fGravTit(cFilialAnt,If(cAgrupa$"2*3",cAgrupAnt,If(cAgrupa=="4",cCCAnt,Nil)),;
			            If(cAgrupa=="4",cAgrupAnt, Nil),nValTitulo,aChaveAgrup,nRecAgrup)
	nValTitulo := 0
EndDo
dbSelectArea(cAlias)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fGravTit ³ Autor ³ Emerson Rosa de Souza ³ Data ³ 13.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava os valores gerados no arquivo de titulos			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGravTit()    			                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 							                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPEM240                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para agrupamento Filial/C.Custo quando o³
//³ usuario definir Data de Vencimento pelo arquivo de CABECALHO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aChaveAgrup := If( aChaveAgrup == Nil, {}, aChaveAgrup )
nRecAgrup   := If( nRecAgrup   == Nil, 0,  nRecAgrup   )

If !Empty(cFilGrav) .And. nVlTotTit > 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se Fornecedor foi preenchido com campo de arquivo   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Novo numero do titulo deve ser antes do Reclock devido a integridade ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNovoTit := GetSx8Num("RC1","RC1_NUMTIT",,RetOrdem( "RC1" , "RC1_FILIAL+RC1_NUMTIT" ))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona cFilAnt na filial corrente p/ garantir Integridade ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilAnt := cFilGrav

	dbSelectArea( "RC1" )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para checar o valor do titulo               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		
		//Tratamento de Integração Logix x Rh Protheus
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

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os campos criados pelo usuario - do RC0 para o RC1.    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	For nCnt1 := 1 To Len(aCposUsu)
	   		cCposRC1  := aCposUsu[nCnt1,2]
			&cCposRC1 := aCposUsu[nCnt1,3]
	   	Next nCnt1

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava no array o numero do recno para agrupar posteriormente ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aChaveAgrup ) > 0
			aChaveAgrup[Len(aChaveAgrup),2] := RECNO()
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para alterar campos do RC1                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("GP650CPO")
			EXECBLOCK("GP650CPO",.F.,.F.)
		Endif

		RC1->( MsUnLock() )
		ConfirmSX8()
		//integracao com modulo SIGAPCO
		PcoDetLan("000092","01","GPEM650")
	EndIf
	dbSelectArea( cAlias )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna filial original para o cFilAnt                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilAnt := cFilAux

EndIf
RestArea( aAreaSRA ) 
RestArea( aAreaSRZ )
If Len(aAreaLan)>0
	RestArea( aAreaLan )
EndIf
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GP650SX3	 ³ Autor ³ Tania Bronzeri       ³ Data ³16/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta SX3                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGravArelin  ºAutor  ³Tiago Malta      º Data ³  10/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Integração Logix X Rh Protheus.                  			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
