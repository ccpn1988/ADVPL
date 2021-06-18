#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENR001   � Autor � Helimar            � Data �  08/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio Teste Contas a Pagar                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro (VIVAZ 9386).                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENR001()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "TITULOS A PAGAR - HELIMAR"
Local nLin         := 80

Local Cabec1       := "CABECALHO 1"
Local Cabec2       := " CABECALHO 2"
Local imprime      := .T.
Private aOrd             := {"Por numero","Por natureza"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "GENR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "GEN001"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GENR001" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SE2"

//PutSx1(cPerg,"01","Data inicial"    ,"","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par01" , ""    ,""     ,""       ,"","","","","","","" )
//PutSx1(cPerg,"02","Data final"      ,"","","mv_ch2","D",08,0,0,"G","","   ","","","mv_par02" , ""    ,""     ,""       ,"","","","","","","" )
//PutSx1(cPerg,"03","Somente ativos?" ,"","","mv_ch7","N",01,0,0,"C","","   ","","","mv_par03" ,"Sim ","Si   ","Yes    ","","N�o           ","No            ","No            ","","","" )

dbSelectArea("SE2")
dbSetOrder(1)

pergunte(cPerg,.T.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  08/11/13   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

//dbSelectArea(cString)

//���������������������������������������������������������������������Ŀ
//� Tratamento das ordens. A ordem selecionada pelo usuario esta contida�
//� na posicao 8 do array aReturn. E um numero que indica a opcao sele- �
//� cionada na mesma ordem em que foi definida no array aOrd. Portanto, �
//� basta selecionar a ordem do indice ideal para a ordem selecionada   �
//� pelo usuario, ou criar um indice temporario para uma que nao exista.�
//� Por exemplo:                                                        �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem < 5                                                       �
//�     dbSetOrder(nOrdem)                                              �
//� Else                                                                �
//�     cInd := CriaTrab(NIL,.F.)                                       �
//�     IndRegua(cString,cInd,"??_FILIAL+??_ESPEC",,,"Selec.Registros") �
//� Endif                                                               �
//�����������������������������������������������������������������������

nOrdem := aReturn[8]
//dbSetOrder(nOrdem)

cQry := "SELECT * FROM "+RetSqlName("SE2")
cQry += " WHERE E2_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
cQry += " AND E2_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'
cQry += " AND D_E_L_E_T_ = ' '
If nOrdem = 1
	cQry += " ORDER BY E2_NUM
Elseif nOrdem = 2
	cQry += " ORDER BY E2_NATUREZ
Endif
cAlias := Criatrab(Nil,.F.)
MsgRun("Selecionando registros...","Processando", {||DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)})


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())
//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� relatorio. Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Note que o descrito acima deve ser tratado de acordo com as ordens  �
//� definidas. Para cada ordem, o indice muda. Portanto a condicao deve �
//� ser tratada de acordo com a ordem selecionada. Um modo de fazer isto�
//� pode ser como a seguir:                                             �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem == 1                                                      �
//�     dbSetOrder(1)                                                   �
//�     cCond := "A1_COD <= mv_par02"                                   �
//� ElseIf nOrdem == 2                                                  �
//�     dbSetOrder(2)                                                   �
//�     cCond := "A1_NOME <= mv_par02"                                  �
//� ElseIf nOrdem == 3                                                  �
//�     dbSetOrder(3)                                                   �
//�     cCond := "A1_CGC <= mv_par02"                                   �
//� Endif                                                               �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.)                                      �
//� While !EOF() .And. &cCond                                           �
//�                                                                     �
//�����������������������������������������������������������������������

dbGoTop()

While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 60 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif


	cLin := (cAlias)->E2_NOMFOR + " | "
	cLin += (cAlias)->E2_NATUREZ + " | "
	cLin += transform((cAlias)->E2_VALOR,PesqPict("SE2","E2_VALOR"))

	@nLin,00 PSAY (cAlias)->E2_NOMFOR


   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
fErase(cAlias)

Return
