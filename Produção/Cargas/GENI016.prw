#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENI016   � Autor �Alessandra Pinheiro � Data � 28/03/2013  ���
�������������������������������������������������������������������������͹��
���Descricao � Importa��o de classe de valor.                             ���
���          �                                                            ���
�������������������������������������������������������������������������ͻ��
���Altera��o �Autor  �Joni Fujiyama                  � Data �  02/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina foi adaptada para rodar por schedule.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENI016()

Private cFunName := PROCNAME()

If MsgYesNo("Esta rotina far� a importa��o de Classe de Valor. Deseja continuar?","Aten��o")
	RunCont()
Endif

Return()


//*************************************************************************************************//
// Rotina da execu��o por schedule				Autor: Joni Fujiyama			Data:02/07/2014			 //
//*************************************************************************************************//
User Function GENI016A()

Local lRotMens:=.F.
Private cFunName := PROCNAME()

Prepare Environment Empresa "00" Filial "1001"
RotMens("Executando a rotina ==> " + cFunName,"","")
//lRotMens := RotMens("Iniciando o Schedule ...","","")
RunCont()
lRotMens := RotMens("Fim do Schedule ...","","")
Reset Environment

Return()


/**************************************************************************************************
Mostra a mensagem na tela ou no console			Autor: Joni Fujiyama		Data:02/07/2014
**************************************************************************************************/
Static Function RotMens(pTexto1,pTexto2,pTexto3,pTipo)

IF cFunName == "U_GENI016"
	DO CASE
		Case pTipo = "1"
			MSGBOX(pTexto1,pTexto2)
		Case pTipo = "2"
			MSGINFO(pTexto1,pTexto2)
		Case pTipo = "3"
			AVISO(pTexto1,pTexto2,pTexto3)
		Case pTipo = "4"
			ALERTA(pTexto1,pTexto2)
		Case pTipo = "5"
			Return AVISO(pTexto1,pTexto2,pTexto3)
	ENDCASE
ELSE
	IF cFunName == "U_GENI016A"
		Conout(pTexto1)
	ENDIF
ENDIF


Return .T.


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  27/12/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont()

Local lErro   := .F.
Local cPath   := "\LogSiga\classe\"
Local cFile   := ""
Local cQuery
Local cQueryINS

Private lMSHelpAuto := .F. // para nao mostrar os erro na tela
Private lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e'que deu erro
Private cAliasQry := GetNextAlias()

cAmbiente := upper(alltrim(GetEnvServer()))
If !(cAmbiente $ "PRODUCAO-DANILO-SCHEDULE")
	cArqT := "DBA_EGK.TT_T03_PRODUTO_PROCESSO"
Else
	cArqT := "TT_I03_PRODUTO_PROCESSO"
Endif

cQuery := "SELECT * FROM "+cArqT+" TT "
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasQry, .F., .T.)

dbSelectArea(cAliasQry)
dbGoTop()
nTamCLVL := TAMSX3("CTH_CLVL")[1]
nTamXCOD := TAMSX3("CTH_XCOD")[1]
Do While !(cAliasQry)->(Eof())

	cCodObra:= PADR(ALLTRIM(SUBSTR((cAliasQry)->B1_COD,1,nTamCLVL)),nTamCLVL)
	cIdObra := PADR(ALLTRIM(SUBSTR((cAliasQry)->IDOBRA,1,nTamXCOD)),nTamXCOD)
	cDesc   := Alltrim(Upper((cAliasQry)->B1_DESC))
	
	aRotAuto := {}
	aAdd(aRotAuto,{"CTH_CLVL", cCodObra	, Nil})
	aAdd(aRotAuto,{"CTH_CLASSE", "2", Nil})
	aAdd(aRotAuto,{"CTH_DESC01", Alltrim(Upper(cDesc)), Nil})
	aAdd(aRotAuto,{"CTH_XCOD", cIdObra, Nil})
	
	DbSelectArea("CTH")
	DbSetOrder(1)
	If !DbSeek(xFilial("CTH")+cCodObra)
		nOpt := 3
	Else
		nOpt := 4
	Endif

	MSExecAuto({|x, y| CTBA060(x, y)},aRotAuto, nOpt)

	If lMSErroAuto //deu erro (retorno de msexecauto)
		lErro := .T.
		cFile := "Cod_"+Alltrim(cCodObra)+".log"
		
		MostraErro(cpath, cfile)
		DisarmTransaction()
		lMsErroAuto := .F.
	ElseIf nOpt = 3 //REGISTRO NOVO
		//�������������������������������������������������������
		//�GRAVA NA VIEW 'TT_I11_FLAG_VIEW' O REGISTRO IMPORTADO�
		//�������������������������������������������������������
		cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR)
		cQueryINS += " VALUES ('"+cArqT+"','B1_COD','"+alltrim(cCodObra)+"')
		TCSqlExec(cQueryINS)
	EndIf

	(cAliasQry)->(dbSkip())

EndDo

DbSelectarea(cAliasQry)
DbcloseArea()

If !lErro
	RotMens("Importa��o Finalizada com sucesso!","Aviso","2")
else
	RotMens("Importa��o finalizada, mas ocorreram algumas inconsist�ncias, verifique a pasta LogSiga","Aten��o","1")
endif

Return()
