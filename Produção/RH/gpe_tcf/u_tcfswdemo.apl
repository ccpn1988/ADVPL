#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³TCFSwDemo   ³Autor ³ Marinaldo de Jesus   ³ Data ³27/06/2007³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Carregar o Demonstrativo de Pagamento Especifico no RHOnLine³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<ponto de entrada>											³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³Ponto de Entrada U_TCFSHOWDEMO                              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³                                   							³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                             								³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Web Function TCFSwDemo()

Local cHtml			:= ""
Local cType
Local cAnoMesTcf

Begin Sequence

	WEB EXTENDED INIT cHtml START "u_w_TCFInSite"

		HttpPost->cMsgDem := ""
	
		SetModulo( "SIGAGPE" , "GPE" )
	
		SRA->( dbSetOrder( RetOrdem("SRA") ) )
	
		IF !( SRA->( MsSeek( xFilial( "SRA" , TCFWGetFil() ) + TCFWGetMat() ) ) )
			HttpPost->cMsgDem := '<center><p class="alerta">N&atilde;o existem valores a serem visualizados!</p></center>'
	    EndIF
	
		IF Empty( HttpPost->cMes ) .and. !Empty( HttpGet->cMes )
			HttpPost->cMes		:= HttpGet->cMes
		EndIF	
			
		IF Empty( HttpPost->cAno ) .and. !Empty( HttpGet->cAno )
			HttpPost->cAno		:= HttpGet->cAno
		EndIF
		IF Empty( HttpPost->cRecTipo ) .and. !Empty( HttpGet->cRecTipo )
			HttpPost->cRecTipo  := HttpGet->cRecTipo
		EndIF	
		IF Empty( HttpPost->cSemana ) .and. !Empty( HttpGet->cSemana   )
			HttpPost->cSemana   := HttpGet->cSemana  
		EndIF	
	
	    cAnoMesTcf	:= StrZero(Val(HttpPost->cAno),4)+StrZero(Val(HttpPost->cMes),2)
		IF (;
				(;
					(;
						( Val(HttpPost->cRecTipo) == 2 );
						.and.;
						( cAnoMesTcf >= GetMv( "MV_FOLMES" ) );
					);
					.and.;
					( GetMv( "MV_FOLLIB") == 'N' );
				);
				.or.;
				(;
					( Val(HttpPost->cRecTipo) == 4 );
					.and.;
					( GetMv( "MV_FOL132") == 'N' );
				);	
			)	
		    HttpPost->cMsgDem := '<center><p class="alerta">Folha ainda N&Atilde;O Liberada para consulta!</p></center>'
		EndIF
	
		cHtml := h_u_tcfswdemo()

	WEB EXTENDED END

End Sequence

Return( cHtml )

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³SwTCFDemo   ³Autor ³ Marinaldo de Jesus   ³ Data ³27/06/2007³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Carregar o Demonstrativo de Pagamento Especifico no RHOnLine³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<ponto de entrada>											³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³Ponto de Entrada U_TCFSHOWDEMO                              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³                                   							³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³                             								³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Web Function SwTCFDemo()

Local cHtml			:= HttpGet->cDemoParam
Local cSvHtml		:= ""
Local nRecnoSRA		:= 0

DEFAULT cHtml		:= ""

Begin Sequence

	WEB EXTENDED INIT cHtml START "u_w_TCFInSite"

		IF !Empty( HttpPost->cMsgDem )
			Break
		EndIF
	
		SetModulo( "SIGAGPE" , "GPE" )
	
		SRA->( dbSetOrder( RetOrdem("SRA") ) )
	
		IF SRA->( MsSeek( xFilial( "SRA" , TCFWGetFil() ) + TCFWGetMat() ) )
	
			nRecnoSRA := SRA->( Recno() )
	
			cSvHtml := cHtml                                                         
	      	
			IF EmptyHtml( cHtml += U_RecNew(.T.,TCFWGetFil(),TCFWGetMat(),StrZero(Val(HttpPost->cMes),2) + StrZero(Val(HttpPost->cAno),4),Val(HttpPost->cRecTipo),HttpPost->cSemana) )
				HttpPost->cSemana := StrZero( Val( HttpPost->cSemana ) , TamSx3( "RC_SEMANA" ) [1] )
				cHtml	:= cSvHtml
				SRA->( dbGoto( nRecnoSRA ) )
				IF EmptyHtml( cHtml += U_RecNew(.T.,TCFWGetFil(),TCFWGetMat(),StrZero(Val(HttpPost->cMes),2) + StrZero(Val(HttpPost->cAno),4),Val(HttpPost->cRecTipo),HttpPost->cSemana) )
					HttpPost->cMsgDem := '<center><p class="alerta">N&atilde;o existem valores a serem visualizados!</p></center>'
				EndIF
			EndIF
	
		Else
	
			HttpPost->cMsgDem := '<center><p class="alerta">N&atilde;o existem valores a serem visualizados!</p></center>'
	
		EndIF	

	WEB EXTENDED END

End Sequence

IF !Empty( HttpPost->cMsgDem  )
	cHtml := u_w_HtmlDefault( HttpPost->cMsgDem , NIL , .F. , .F. , .T. )
EndIF

Return( cHtml )