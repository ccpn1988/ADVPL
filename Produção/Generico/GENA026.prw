#include 'protheus.ch'
#include 'topconn.ch'     
#include "ap5mail.ch"

/*
Função: GENA026

Descrição: envio de email para lista de contatos

Atualizações:
09/07/2015 - Rafael Leite - Desenvolvimento inicial
*/                                                 

User Function GENA026

Processa({|| U_GENA026B() })

Return

User Function GENA026B
Local _lRet 	:= .T.										// Resultado esperado, caso algum e-mail nao seja enviado corretamente, retorna F
Local _lResult 	:= .F. 									// Controle da conexao com servidor
Local _lSendOk 	:= .F. 									// Controle de envio da mensagem
Local _cError  	:= '' 									// Log de erro no envio da mensagem
Local _cServer 	:= 'smtp.grupogen.com.br:25'			// Nome do servidor de e-mail

//Local _cConta	:= 'noreply@grupogen.com.br'			// Nome da conta a ser usada no e-mail
//Local _cSenha := 'genrj$1311'						// Senha 
//Local _cUser  := 'noreply@grupogen.com.br'			//Usuario para autenticacao
//Local _cPsw	:= 'genrj$1311'							//Senha para autenticacao        
//Local _cFrom     := 'noreply@grupogen.com.br'			//Remetente

Local _cConta	:= 'diretoria@grupogen.com.br'			// Nome da conta a ser usada no e-mail
Local _cSenha 	:= 'D1r&t0ri@'							// Senha 
Local _cUser    := 'diretoria@grupogen.com.br'			//Usuario para autenticacao
Local _cPsw		:= 'D1r&t0ri@'							//Senha para autenticacao        
Local _cFrom    := 'diretoria@grupogen.com.br'			//Remetente

Local _lAut		:= .T.					              	// Servidor com autenticacao   
Local _cTo       := ''		                            //Destinatario
Local _cSubject  := 'Comunicado Atlas+GEN aos clientes'  //Assunto
Local _cBody     := ''                                 	//Mensagem
Local _lFormat   := .F.      	                        //Arquivo texto ou html
Local _cAttachment	:= ''                               //Anexos
Local _aLog := {}
Local _cFileSQL, _cFileHtm, _cSQL, _cHTM, _cUserAt 
Local _cPerg := 'GENA026'
Local cAlias1 :=  GetNextAlias()    
Local _nCli := 0     
Local _nSend := 0
Local _nMail := 0  
Local lSFG001	:= GetMV("GEN_CFG001")

Local oProcess														//Objeto de controle do processo
Local oHtml															//Objeto de criacao do html
Local cProcess := "EMAIL"
Local nx

//PARAMETROS INICIAIS
//------------------------------------------------------------------------------------------------------------------------------------------

PutSx1(_cPerg, "01", "SQL:", "a", "a", "mv_ch1", "C", 90, 0, 0, "G","", "DIR", "", "", "MV_PAR01")
PutSx1(_cPerg, "02", "Html:", "a", "a", "mv_ch2", "C", 90, 0, 0, "G","", "DIR", "", "", "MV_PAR02")
PutSx1(_cPerg, "03", "Proc:", "a", "a", "mv_ch2", "C", 2, 0, 0, "G","", "", "", "", "MV_PAR03")

If !Pergunte(_cPerg,.T.)
	Return
Endif

AADD(_aLog,"Início: " + DtoC(dDatabase) + " - " + Time())

//Inicia processo de workflow
_cFileSQL := Alltrim(MV_PAR01)
_cFileHtm := Alltrim(MV_PAR02)

//ARQUIVO HTML
//------------------------------------------------------------------------------------------------------------------------------------------

//Abre o arquivo para uso
FT_FUSE(_cFileHtm)

//Posiciona no inicio do arquivo
FT_FGOTOP()

//Enquanto nao for fim do arquivo
_cHTM := ""
While ( !FT_FEOF() )
	
	//Armazena a linha do arquivo
	_cHTM += Alltrim( FT_FREADLN() ) + CHR(13)+CHR(10)
	
	//Proxima linha
	FT_FSKIP()
	
EndDo

//Fecha o arquivo
FT_FUSE()

//ARQUIVO SQL
//------------------------------------------------------------------------------------------------------------------------------------------

//Abre o arquivo para uso
FT_FUSE(_cFileSQL)

//Posiciona no inicio do arquivo
FT_FGOTOP()

//Enquanto nao for fim do arquivo
_cSQL := ""
While ( !FT_FEOF() )
	
	//Armazena a linha do arquivo
	_cSQL += Alltrim( FT_FREADLN() ) + CHR(13)+CHR(10)
	
	//Proxima linha
	FT_FSKIP()
	
EndDo

//Fecha o arquivo
FT_FUSE()


If Select(cAlias1) > 0
	(cAlias1)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), cAlias1, .F., .T.)

While !(cAlias1)->(eof())
    
	_cCliente := Alltrim((cAlias1)->CGC)
	
	_cNome := Upper(Alltrim((cAlias1)->NOME))
	_cNome := strtran(_cNome,"	","")
	
	_cBody := StrTran(_cHTM,"%cliente_nome%",_cNome) 
	
	_aMail := {}
	
	While !(cAlias1)->(eof()) .and.;
	_cCliente == Alltrim((cAlias1)->CGC)   
	
		_nCli++
	
		_aTmp := Separa((cAlias1)->EMAIL,";")
	    
		For nx:=1 To Len(_aTmp)				
            
			_cPesq := Alltrim(_aTmp[nx])
			_cPesq := StrTran(_cPesq,"	","")
			If aScan(_aMail,{|x| x == _cPesq} ) == 0 
				
				AADD(_aMail,_cPesq)
			Endif
		Next nx

		(cAlias1)->(DbSkip())
	End
		
	If Len(_aMail) > 0
		For nx:=1 To Len(_aMail)
		    
			_nSend++
			
			If _nSend == lSFG001
				
				MsgInfo("Janela de processamento")
				
				_nSend := 0
				
			Endif
			
			_nMail++
			
			//------------------------------------------------------------------------------
			
			_cTo := Alltrim(_aMail[nx])
			
			IncProc(_cTo)
			
			ACSendMail(_cConta,_cSenha,_cServer,_cFrom,_cTo,_cSubject,_cBody)   

			_cLog1 := "EMAIL " + ALLTRIM(MV_PAR03) + " - " + DtoC(dDataBase) + " - " + Time() + " - " + _cTo
			_cLog2 := "EMAIL " + ALLTRIM(MV_PAR03) + " - " + DtoS(dDataBase) + " - " + StrTran(Time(),":","") + " - " + _cTo
    
			ConOut(_cLog1)	
			MemoWrite("\EMAIL\" + _cLog2 + ".htm",_cBody)
			
			/*
			//------------------------------------------------------------------------------
			oProcess := TWFProcess():New( cProcess,'')                 
			
			oProcess:NewTask('', _cFileHtm)
			
			_cTo := _aMail[nx]			
			oProcess:cTo	  := _cTo
			
			oProcess:cSubject := _cSubject
			
			oHtml := oProcess:oHtml
			
			// dados da empresa     
			oProcess:ohtml:ValByName("cliente_nome",Upper(_cNome))
			
			// Envie a mensagem para o solicitante:
			oProcess:Start() 
						
			_cLog1 := "EMAIL " + DtoC(dDataBase) + " - " + Time() + " - " + _cTo
			_cLog2 := "EMAIL " + DtoS(dDataBase) + " - " + StrTran(Time(),":","") + " - " + _cTo
    
			ConOut(_cLog1)	
			MemoWrite("\EMAIL\" + _cLog2 + ".htm",_cNome)
			*/
		Next nx  
	Endif
End

AADD(_aLog,"Clientes listados: " + cValtoChar(_nCli))
AADD(_aLog,"Emails enviados: " + cValtoChar(_nMail))

AADD(_aLog,"Fim: " + DtoC(dDatabase) + " - " + Time())

U_GENA026A(_aLog)

Return   

User Function GENA026A(_aParm1)

Local oReport
Private _aLog := _aParm1

oReport := reportDef()
oReport:printDialog()

Return

static function reportDef()

local oReport
local cTitulo := "Log de processamento"
local cPerg := ""

oReport := TReport():New('GENA025A', cTitulo, cPerg , {|oReport| PrintReport(oReport)})

oReport:SetLandScape()

oReport:SetTotalInLine(.F.)

oReport:ShowHeader()

oSection0 := TRSection():New(oReport,"Mensagens",{""})

TRCell():New(oSection0,"LOG"		,,"Log",,100)

return (oReport)

Static Function PrintReport(oReport)

Local oSection0 := oReport:Section(1)
Local nx

For nx:=1 To Len(_aLog)
	
	oReport:IncMeter()
	
	oSection0:Init()
	
	oSection0:Cell("LOG"):SetValue(_aLog[nx])
	
	oSection0:PrintLine()      
		
Next nx

oSection0:Finish()

Return