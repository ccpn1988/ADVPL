#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Geni019   º Autor ³ Danilo Azevedo     º Data ³  29/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de transportadoras                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Faturamento                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENI019()

Local lRotMens:=.F.
Private cFunName := PROCNAME()

Prepare Environment Empresa "00" Filial "1001"

Conout("Executando a rotina ==> " + cFunName,"","")
Importa()
Conout("Fim do Schedule... " + cFunName,"","")
Reset Environment

Return()


Static Function Importa()

cQry := "SELECT T.*, U.DESCRICAO EST, M.DESCRICAO MUN FROM TRANSPORTADORA T 
cQry += " INNER JOIN MUNICIPIO M ON T.IDMUNICIPIO = M.IDMUNICIPIO
cQry += " INNER JOIN UF U ON T.IDUF = U.IDUF
//cQry += " WHERE IDTRANSPORTADORA = 560
cQry += " ORDER BY IDTRANSPORTADORA"
cAlias := Criatrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

dbSelectArea("SA4")
dbSetOrder(1)
Do While !(cAlias)->(Eof())
	
	If dbSeek(xFilial("SA4")+STRZERO((cAlias)->IDTRANSPORTADORA,6))
		RecLock("SA4",.F.)
	Else
		RecLock("SA4",.T.)
		SA4->A4_FILIAL := xFilial("SA4")
		SA4->A4_COD := STRZERO((cAlias)->IDTRANSPORTADORA,6)
		SA4->A4_NOME := (cAlias)->DESCRICAO
	Endif
	
	SA4->A4_END := (cAlias)->ENDERECO
	SA4->A4_BAIRRO := (cAlias)->BAIRRO
	SA4->A4_CEP := (cAlias)->CEP
	SA4->A4_MUN := upper((cAlias)->MUN)
	SA4->A4_EST := (cAlias)->EST
	SA4->A4_VIA := (cAlias)->VIATRANSPORTADA
	SA4->A4_CONTATO := (cAlias)->CONTATO
	
	If !Empty((cAlias)->TEL)
		cTel := alltrim((cAlias)->TEL)
		cTel := strtran(cTel," ","")
		cTel := strtran(cTel,")","")
		cTel := strtran(cTel,"(","")
		cTel := strtran(cTel,"-","")
		cDdd := Space(0)
		
		If substr(cTel,1,1)="0" .and. substr(cTel,1,4)<>"0800"
			cTel := substr(cTel,2,len(cTel))
		Endif
		
		If len(cTel)=10 .or. len(cTel)=11 .and. substr(cTel,1,4)<>"0800"
			cDdd := substr(cTel,1,2)
			cTel := substr(cTel,3,len(cTel))
		Endif
		
		SA4->A4_DDD := cDdd
		SA4->A4_TEL := cTel
	Endif
	SA4->A4_CGC := (cAlias)->CGC
	SA4->A4_INSEST := (cAlias)->IE
	SA4->A4_EMAIL := lower((cAlias)->EMAIL)
	
	MsUnlock()
	(cAlias)->(dbskip())
Enddo

fErase(cAlias)

Return()
