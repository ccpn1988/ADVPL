#Include 'Protheus.ch'
#include "Rwmake.ch"
#include "Totvs.ch" 

/*/{Protheus.doc} _ConsCEP
Função para validação de CEP
@type User function
@author Ivan Oliveira
@since 24/11/2016
@version 1.0

@param 	${_cCepOrig}, ${Caractere}	, Código do CEP a Ser consultado.
@param 	${_lProcSCh}, ${Lógico	}	, Processo via Schedule?
@param 	${_lContProc},${Lógico	}	, Continuar processo, em caso de Erro por Schedule?
@param 	${_cDescItem},${Caractere}	, Descrição de onde é solicitado avaliação
@param 	${_cRetorno}, ${Caractere}	, Solicitação para retorno do erro

@return ${_lRet}, 	  ${Lógico}		, Caso CEP válido, retorna .t., a contrário, .f.

@example: u__ConsCEP('07000000')
/*/

User Function GENA062(_cCepOrig, _lProcSCh, _lContProc, _cDescItem, _cRetorno )

Local _aMetodos 	:= {}
Local _lRet 		:= .f.
Local _cCodServico 	:= '40010'
Local _aMensRet 	:= {{ 2,   'CEP inválido'}, { 3, 'CEP inválido'}, ;
						{ 999, 'CEP de origem inexistente, consulte o Busca CEP.'}, ;
					    { 7,   'Serviço indisponível, tente mais tarde' }}
Local _cResp 		:= _cErro := ''
Local _oWsdl

Default _cCepOrig 	:= 'xxxxxxxx'
Default _lProcSCh   := .f.
Default _lContProc  := .f.
Default _cDescItem  := ProcName(0)
Default _cRetorno   := ''

If ISINCALLSTACK("U_GENI029")
	Return .T.			
EndIf

//CEPs que não precisam de validação| Rafael Leite - 15/12/2016
//Validação criada, pois o CEP da Saraiva está desatualizado na Receita Federal, mas os Correios geraram um novo CEP.
If _cCepOrig $ GetMv("GEN_FAT142")
	Return .T.
Endif

// Retirando caracteres separador.
_cCepOrig := StrTran(_cCepOrig,'-','' )
_cCepDest := StrTran(_cCepOrig,'-','' )

_oWsdl := TWsdlManager():New()
//_lRet  := _oWsdl:ParseURL("http://ws.correios.com.br/calculador/CalcPrecoPrazo.asmx?WSDL")
_lRet  := _oWsdl:ParseFile("\HTML\CalcPrecoPrazo.xml")
_oWsdl:nTimeout := 120
  			 
 If _lRet
 
 	// Listar todos os métodos
  	_aMetodos := _oWsdl:ListOperations()
  	
  	// Verificando se existe método
  	if !empty(_aMetodos)
  	
  	 	// Selecionar o método específico
  		_lRet := _oWsdl:SetOperation( "CalcPrazo" )
  	
  		if _lRet
  	
  			// Setando valores para o método
  			if _lRet :=_oWsdl:SetFirst( "sCepOrigem", _cCepDest )
  		
  				if _lRet :=_oWsdl:SetFirst( "sCepDestino", _cCepOrig )
  			
  					if _lRet :=_oWsdl:SetFirst( "nCdServico", _cCodServico )
  					
  						Conout("GENA062 - consumindo ws correios - "+DtoS(DDatabase)+" - "+Time())
  						// Envia a mensagem SOAP ao servidor
  						if _lRet := _oWsdl:SendSoapMsg()
  							
  							Conout("GENA062 - Inicio Parse do retorno dos correios - "+DtoS(DDatabase)+" - "+Time())
  							// Recupera os elementos de retorno, já parseados
							_cResp := _oWsdl:GetParsedResponse()
							Conout("GENA062 - Fim Parse do retorno dos correios - "+DtoS(DDatabase)+" - "+Time())
							
							// Monta um array com a resposta parseada, considerando
							// as quebras de linha ( LF == Chr(10) ) 
							_aRetorno := StrTokArr(_cResp,chr(10))
							
							// Localiza código erro
							_nPosErr := ascan ( _aRetorno, 'Erro' )
			
							if _nPosErr > 0
			
								_nCodErro:= Abs(Val( StrTran(_aRetorno[_nPosErr], 'Erro:', '' ) ))
								_nPosErr := AScan(_aMensRet,{|x| x[1] == _nCodErro })  
								
								if _nPosErr > 0
								
									_cErro := _aMensRet[_nPosErr][02] + ': ' + Transform(_cCepOrig,"@R XXXXX-XXX")
									_lRet   := .f.
							
								Endif
			
							Endif
							
						Endif
	  				
  					Endif
  				
  				Endif
  			
  			Endif
  			
  		Endif
  	 
  	Endif
  	
Endif
  		
// Pega resposta do erro
if !_lRet 

	// Processo retorno
	 _cRetorno := if (!empty(_cErro), _cErro, _oWsdl:cError ) 

	// Se processament por Sche e for solicitado continuar em casos de erro não por rejeita de CEP.
	if _lProcSCh .and. _lContProc .and. empty(_cErro)
	
		_lRet := .t.
	
	Endif

	// Logando Referência
	if _lProcSCh .OR. "SCHEDULE" $ upper(alltrim(GetEnvServer()))
	
		conout( Repl('*', 150) )
		conout( 'Nome Processo: ' + ProcName(0) )
		conout( 'Data Execução: ' + Dtoc(date()) + ' - ' + time() )
		conout( "Ocorreu um erro na tentativa de consulta do CEP: " + Transform(_cCepOrig,"@R XXXXX-XXX") + '/ ' +;
				 if (!empty(_cErro), _cErro, _oWsdl:cError ) )
				 
		conout( Repl('*', 150) )
		
	Else
	
		// Se for erro no CEP
		if !empty(_cErro)
	
			_lRet := MsgYEsNo('O Cep: ' + Transform(_cCepOrig,"@R XXXXX-XXX") + ', informado no campo: ' + _cDescItem + ;
				 	', esta incorreto, deseja continuar assim mesmo?' , 'Atenção' )
				 	
		Else
		
			// Se for erro de indisponibilidade, deixar usuário resolver.
			if _lContProc
			
				if MsgYEsNo ("Continuar inclusão, pois ocorreu o seguinte erro na tentativa de consulta do CEP: " + ;
							  Transform(_cCepOrig,"@R XXXXX-XXX") + '/ ' + chr(10)+ chr(13) + _oWsdl:cError , "Atençao" )
				 		   
					_lRet := .t.
					
				Endif
				
			Else
			
				 MsgStop ("Continuar inclusão, pois ocorreu um erro na tentativa de consulta do CEP: " + ;
							Transform(_cCepOrig,"@R XXXXX-XXX") + '/ ' + _oWsdl:cError , "Atenção" )  
			
			Endif
				 	
		Endif
	
	Endif
  		
Endif
   
Return _lRet

  