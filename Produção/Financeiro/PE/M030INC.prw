#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M030INC   º Autor ³ Danilo Azevedo     º Data ³  13/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Disparo de email ao incluir cliente.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Cadastro de cliente                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M030INC()

Local aArea	:= GetArea()

// Inclusão de classe de valor
If ParamIXB == 0
	fClasseGen()
	Restarea(aArea)
EndIf

//If upper(alltrim(GetEnvServer())) <> "HELIMAR"
If upper(alltrim(GetEnvServer())) <> "PRODUCAO"
	Return()
Endif

Public lSent030

If valtype(lSent030) = "L" //VERIFICA SE JA ENVIOU EMAIL
	Return()
Endif

If PARAMIXB == 3 //USUARIO CANCELOU OPERACAO
	Return()
EndIf

If SA1->A1_MSBLQL <> "1" .and. SA1->A1_XREV <> "1" //PROSSEGUE SOMENTE SE ESTIVER BLOQUEADO E COM NIVEL 1
	Return()
Endif
/*
aUsr	:= AllUsers()
nPosUsr	:= aScan(aUsr,{|x|x[1][1] == RetCodUsr()})
cSuper  := aUsr[nPosUsr][1][11]
nTamCod := len(RetCodUsr())
cMailSup 	:= Space(0) //UsrRetMail(aUsr[nPosUsr][1][11]) //EMAIL SUPERVISOR
Do While len(cSuper) > 0
	cMailSup += alltrim(UsrRetMail(substr(cSuper,1,nTamCod)))+";"
	cSuper := substr(cSuper,nTamCod+2,len(cSuper))
Enddo
*/
// cleuto - 23/01/2017 - alterado pois a função AllUsers está geradno erro log após migração R8
cMailSup 	:= Space(0) //UsrRetMail(aUsr[nPosUsr][1][11]) //EMAIL SUPERVISOR
aUsrSuper	:= FWSFUsrSup(RetCodUsr())
aEval(aUsrSuper, {|x| cMailSup += alltrim(UsrRetMail( x ))+";" } )

If Empty(cMailSup)
	MsgAlert("Entre em contato com o administrador do sistema e solicite a inclusão de superior no cadastro do seu usuário ("+alltrim(UsrFullName(RetCodUsr()))+").","Atenção")
Endif

//alltrim(UsrRetMail(RetCodUsr())) //email do usuario logado

//INICIO CABECALHO
cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">
cMensagem += '<head>
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
cMensagem += '<title>Pedido de Compra</title>
cMensagem += '<style type="text/css">
cMensagem += '.Cabec1 {
cMensagem += '	font-family: Verdana, Geneva, sans-serif;
cMensagem += '	font-size: 16px;
cMensagem += '}
cMensagem += 'body,td,th {
cMensagem += '	font-family: Verdana, Geneva, sans-serif;
cMensagem += '	font-size: 12px;
cMensagem += '	color: #000;
cMensagem += '}
cMensagem += 'body {
cMensagem += '	background-color: #FFF;
cMensagem += '}
cMensagem += '</style>
cMensagem += '</head>
cMensagem += '<body>
cMensagem += '<table width="100%" height="70" border="0" bgcolor="#FFFFFF" frame="void" rules="none">
cMensagem += '  <tr>
cMensagem += '    <td width="100%" height="66" align="center"><img src="http://tigen.web931.uni5.net/images/gen_logo_blue_all.png" alt="" width="560" height="156" align="center" /></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
cMensagem += '    <td width="100%" height="50" align="center"><span style="font-family: Verdana, Geneva, sans-serif"><strong><font color="0062A1" size="4">PROTHEUS GEN - </font></strong></span><span class="Cabec1"><strong><font color="0062A1" size="4">CADASTRO DE CLIENTE</font></strong></span></td>
cMensagem += '  </tr>
cMensagem += '</table>
//FIM CABECALHO

cMensagem += '<br />
cMensagem += '<br />
cMensagem += '<p><font size="3"><strong>Informamos que o cliente abaixo foi cadastrado e está aguardando sua liberação.'
cMensagem += '</font><br />
cMensagem += '<br />
cMensagem += '</p>
cMensagem += '<table width="100%" border="0">
cMensagem += '  <tr>
cMensagem += '    <td width="20%"><font size="2"><strong>Código / Loja:</strong></font></td>
cMensagem += '    <td><font size="2">'+SA1->A1_COD+'-'+SA1->A1_LOJA+'</font></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
cMensagem += '    <td><font size="2"><strong>Nome:</strong></font></td>
cMensagem += '    <td><font size="2">'+SA1->A1_NOME+'</font></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
cMensagem += '    <td><font size="2"><strong>CNPJ:</strong></font></td>
cMensagem += '    <td><font size="2">'+SA1->A1_CGC+'</font></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
_usuario := upper(Embaralha(SA1->A1_USERLGI,1))
_usuario := alltrim(substr(_usuario,3,len(_usuario)-5))
_usuario := usrfullname(_usuario)
cMensagem += '    <td><font size="2"><strong>Cadastrante:</strong></font></td>
cMensagem += '    <td><font size="2">'+alltrim(Iif(!Empty(SA1->A1_USERLGI),_usuario,'Não informado'))+'</font></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
cMensagem += '</table>
cMensagem += '<br />
cMensagem += '<br />
cMensagem += '<br />
cMensagem += '<p> MENSAGEM AUTOMÁTICA GERADA PELO SISTEMA PROTHEUS. FAVOR NÃO RESPONDER.
cMensagem += '<br />
cMensagem += '</p></body>
cMensagem += '</html>

cMensagem := oemtoansi(cMensagem)
U_GenSendMail(,,,"noreply@grupogen.com.br",cMailSup,oemtoansi("Protheus - Cadastro de cliente"),cMensagem,,,.F.)
lSent030 := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o cliente existe na tabela de autores e em existindo³
//³muda o tipo de clientes para autor.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ParamIXB == 0
	U_GENA045C()
EndIF


RestArea(aArea)

Return()

static Function fClasseGen()

Local lErro   := .F.
Local cPath   := "\LogSiga\classe\"
Local cFile   := ""

Private nTamCLVL := TAMSX3("CTH_CLVL")[1]
Private nTamDESC := TAMSX3("CTH_DESC01")[1]
Private lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e'que deu erro

cCodCL := PADR(ALLTRIM(SUBSTR("C" + SA1->A1_COD,1,nTamCLVL)),nTamCLVL)
cDesc  := ALLTRIM(UPPER(SUBSTR(SA1->A1_NOME,1,nTamDESC)))

aRotAuto := {}
aAdd(aRotAuto,{"CTH_CLVL"	, cCodCL,Nil})
aAdd(aRotAuto,{"CTH_CLASSE"	, "2"	,Nil})
aAdd(aRotAuto,{"CTH_DESC01"	, cDesc	,Nil})


DbSelectArea("CTH")
CTH->(DbSetOrder(1))
If CTH->(!DbSeek(xFilial("CTH")+cCodCL))
	nOpt := 3

	MSExecAuto({|x, y| CTBA060(x, y)},aRotAuto, nOpt)
	
	If lMSErroAuto //deu erro (retorno de msexecauto)
		lErro := .T.
		cFile := "Cod_"+Alltrim(cCodCL)+".log"
		
		MostraErro(cPath, cFile)
		DisarmTransaction()
		lMSErroAuto := .F.
	EndIf
Endif      

Return