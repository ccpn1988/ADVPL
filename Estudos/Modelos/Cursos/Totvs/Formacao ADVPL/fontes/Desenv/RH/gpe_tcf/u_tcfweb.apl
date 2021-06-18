#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH"
User Web Function TcfInit()

#IFDEF WEBMAN

	Return( u_w_HtmlDefault( "site em Manuten&ccedil;&atilde;o!!" , NIL , .T. , .F. ) )

#ELSE

	HttpFreeSession()
	TCFSetAllOk( .F. )

	u_w_InitEmp()

	Return( H_U_TCFIDX() )

#ENDIF	

User Web Function TcfStart()

Local cHtml := ""
                               
WEB EXTENDED INIT cHtml START "u_w_TCFInSite"
	cHtml := u_w_TcfInf()
WEB EXTENDED END	

Return( cHtml )

User Web Function TcfUpStart()
Local cReturn := "u_w_TcfPwd.apw"
Return( u_w_TCFInSite( cReturn , .F. ) )

User Web Function TCFInSite( cReturn , lLogout )

Local aEmpresas

Local cHtml
Local cEmp
Local cFil
Local cMatricula
Local cPassWord
Local cInconsistencia
Local cSraPassWord

Local lAllOk
Local lShowFoto

Begin Sequence

	IF ( TCFGelAllOk() )
		Break
	EndIF

	cEmp := TCFGetPstEmp()
	IF Empty( cEmp )
		cInconsistencia := "Empresa inv&aacute;lida"
		Break
	EndIF

	cFil := TCFGetPstFil()
	IF Empty( cFil ) 
		cInconsistencia := "Filial inv&aacute;lida"
		Break
	EndIF

	IF Empty( HttpPost->cMatricula )
		cInconsistencia := "Matricula inv&aacute;lida"
		Break
	EndIF

	aEmpresas	:= HttpSession->aEmpresas
	IF (;
			Empty( aEmpresas );
			.or.;
			( aScan( aEmpresas , { |x| SubStr(x[1],1,4) == HttpPost->cEmpFil } ) == 0 );
		)	
		cInconsistencia := "Empresa ou Filial inv&aacute;lida"
		Break
	EndIF

	SetModulo( "SIGAGPE" , "GPE" )
	HttpPost->cMatricula := Padr( HttpPost->cMatricula , TamSx3("RA_MAT")[1] )
	SRA->( dbSetOrder( RetOrdem("SRA") ) )
	IF (;
			Empty( HttpPost->cMatricula );
			.or.;
			SRA->( !MsSeek( xFilial( "SRA" , cFil ) + HttpPost->cMatricula , .F. ) );
		)	
		cInconsistencia := "Usu&aacute;rio n&atilde;o autorizado"
		Break
	EndIF

	IF (;
			Empty( HttpPost->cPassWord );
			.and.;
			Empty( TCFWGetPas() );
		)
		cInconsistencia := "Senha Inv&aacute;lida"
		Break
	EndIF

	cPassWord 		:= APXTo64( Upper( AllTrim( HttpPost->cPassWord ) ) )
	cPassWord 		:= IF( ( cPassWord == "00" ) , "" , cPassWord )
	cSraPassWord	:= APXTo64( Embaralha( Upper( AllTrim( SRA->RA_SENHA ) ) , 1 ) )
	IF (;
			Empty( cPassWord );
			.or.;
			!( cSraPassWord == cPassWord );
		)	
		cInconsistencia := "Senha Inv&aacute;lida"
		Break
	EndIF    

	TCFWSetEmp( cEmp )
	TCFWSetFil( cFil )
	TCFWSetMat( HttpPost->cMatricula )
	TCFWSetPas( HttpPost->cPassWord )
	TCFSetAllOk( .T. )

	HttpSession->cBmpPict		:= RetPictFun(@lShowFoto)
	HttpSession->lShowFoto		:= lShowFoto
	HttpSession->cNome			:= Capital( SRA->RA_NOME )
	HttpSession->cFuncao		:= Capital( SRA->( DescFun( RA_CODFUNC , RA_FILIAL ) ) )

	IF Empty( HttpSession->aMenuTcf )
		TcfGetMnu()
	EndIF

End Sequence

DEFAULT cReturn := 'u_w_TcfInit.apw'
DEFAULT lLogout := .T.
IF !Empty( cInconsistencia )
	cHtml := u_w_HtmlDefault( @cInconsistencia , @cReturn , @lLogout )
ElseIF !( TCFGelAllOk() )
	cHtml := u_w_HtmlDefault( NIL , @cReturn , @lLogout )
EndIF

Return( cHtml )

User Web Function TcfInf()

Local cHtml := ""

WEB EXTENDED INIT cHtml START "u_w_TCFInSite"

	cHtml := H_U_TCFINF()

WEB EXTENDED END

Return( cHtml )

User Web Function TcfDem()

Local cHtml := ""

WEB EXTENDED INIT cHtml START "u_w_TCFInSite"

	cHtml := H_U_TCFDEM()

WEB EXTENDED END

Return( cHtml )

User Web Function TcfPwd()

Local cHtml := ""

WEB EXTENDED INIT cHtml START "u_w_TCFInSite"

	cHtml := H_U_TCFPWD()

WEB EXTENDED END

Return( cHtml )

User Web Function TcfId()

Local cHtml := ""

WEB EXTENDED INIT cHtml START "u_w_TCFInSite"

	cHtml += '<div id="identificacao">' + CRLF
	cHtml += '	<img src="'+HttpSession->cBmpPict+'" alt="Sua foto"/>' + CRLF
	cHtml += '	<p>' + CRLF
	cHtml += '		<span>'+ HttpSession->cNome+'</span>' + CRLF
	cHtml += 		'<br />' + CRLF
	cHtml += 		HttpSession->cFuncao + CRLF
	cHtml += '	</p>' + CRLF
	cHtml += '</div>'

WEB EXTENDED END

Return( cHtml )

User Web Function InitEmp()

IF Empty( HttpSession->aEmpresas )
	HttpSession->aEmpresas := GetEmpSigaMat()
EndIF	

Return( "" )

User Web Function TcfGetEmp( lInSession )

Local cHtml		:= ""

Local nEmpresa
Local nEmpresas

DEFAULT lInSession := .F.

IF !( lInSession )
	cHtml += '<option selected value="">Selecione a Empresa/Filial</option>' + CRLF
EndIF

nEmpresas := Len( HttpSession->aEmpresas )
For nEmpresa := 1 To nEmpresas
	IF ( lInSession )
		IF ( SubStr( HttpSession->aEmpresas[ nEmpresa , 1 ] , 1 , 4 ) == ( TCFWGetEmp() + TCFWGetFil() ) )
			cHtml += '<option selected value="' + HttpSession->aEmpresas[ nEmpresa , 1 ] + '">'+ AllTrim( HttpSession->aEmpresas[ nEmpresa , 2 ] ) + '</option>' + CRLF
			Exit
		EndIF	
	Else
		cHtml += '<option value="' + HttpSession->aEmpresas[ nEmpresa , 1 ] + '">'+ AllTrim( HttpSession->aEmpresas[ nEmpresa , 2 ] ) + '</option>' + CRLF
	EndIF
Next nEmpresa

Return( cHtml )

User Web Function EmpSelected()
Return( u_w_TcfGetEmp( .T. ) )

User Web Function TcfGlbMnu()

Local cHtml := ""

Local nMnu 
Local nMnus
Local nMnuItem
Local nMnuItens

WEB EXTENDED INIT cHtml START "u_w_TCFInSite"

	nMnus := Len( HttpSession->aMenuTcf )


	cHtml += '<ul id="menu_global">' + CRLF
	cHtml += 				'<li><img src="imagens/b2c/ttl_menu_folha_de_pagamento.gif" alt="Folha de Pagamento" />' + CRLF
	cHtml += 					'<ul>' + CRLF
									For nMnu := 1 To nMnus
										nMnuItens := Len( HttpSession->aMenuTcf[ nMnu ] )
										For nMnuItem := 1 To nMnuItens
											IF ( ( nMnuItens > 1 ) .and. ( nMnuItem == 1 ) )
												Loop
											Else
												IF (;
														HttpSession->aMenuTcf[ nMnu , nMnuItem , 02 ] != "#";
														.and.;
														HttpSession->aMenuTcf[ nMnu , nMnuItem , 03 ] == "001";
													)	
	cHtml += 										'<li><a href="'+ HttpSession->aMenuTcf[ nMnu , nMnuItem , 02 ] + '">' + HttpSession->aMenuTcf[ nMnu , nMnuItem , 01 ] +'</a></li>' + CRLF
													EndIF
												EndIF
											Next nMnuItem
										Next nMnu
	cHtml += 					'</ul>' + CRLF
	cHtml += 				'</li>' + CRLF
	cHtml += 				'<!--<li><img src="imagens/b2c/ttl_menu_ponto_eletronico.gif" alt="Ponto Eletr&ocirc;nico" />' + CRLF
	cHtml += 					'<ul>' + CRLF
									For nMnu := 1 To nMnus
										nMnuItens := Len( HttpSession->aMenuTcf[ nMnu ] )
										For nMnuItem := 1 To nMnuItens
											IF ( ( nMnuItens > 1 ) .and. ( nMnuItem == 1 ) )
												Loop
											Else
												IF (;
														HttpSession->aMenuTcf[ nMnu , nMnuItem , 02 ] != "#";
														.and.;
														HttpSession->aMenuTcf[ nMnu , nMnuItem , 03 ] == "002";
													)	
	cHtml += 										'<li><a href="'+ HttpSession->aMenuTcf[ nMnu , nMnuItem , 02 ] + '">'+ HttpSession->aMenuTcf[ nMnu , nMnuItem , 01 ] + '</a></li>' + CRLF
												EndIF
											EndIF
										Next nMnuItem
									Next nMnu
	cHtml += 					'</ul>' + CRLF
	cHtml += 				'</li>-->' + CRLF
							For nMnu := 1 To nMnus
								nMnuItens := Len( HttpSession->aMenuTcf[ nMnu ] )
								For nMnuItem := 1 To nMnuItens
									IF ( ( nMnuItens > 1 ) .and. ( nMnuItem == 1 ) )
										Loop
									Else
										IF (;
												HttpSession->aMenuTcf[ nMnu , nMnuItem , 02 ] != "#";
												.and.;
												HttpSession->aMenuTcf[ nMnu , nMnuItem , 03 ] == "004";
											)	
	cHtml += 								'<li><a href="'+ HttpSession->aMenuTcf[ nMnu , nMnuItem , 02 ] + '"><img src="imagens/b2c/ttl_menu_informativo.gif" alt="Informativo" /></a></li>' + CRLF
										EndIF
									EndIF
								Next nMnuItem
							Next nMnu
							For nMnu := 1 To nMnus
								nMnuItens := Len( HttpSession->aMenuTcf[ nMnu ] )
								For nMnuItem := 1 To nMnuItens
									IF ( ( nMnuItens > 1 ) .and. ( nMnuItem == 1 ) )
										Loop
									Else
										IF (;
												HttpSession->aMenuTcf[ nMnu , nMnuItem , 02 ] != "#";
												.and.;
												HttpSession->aMenuTcf[ nMnu , nMnuItem , 03 ] == "003";
											)	
	cHtml += 								'<li><a href="'+ HttpSession->aMenuTcf[ nMnu , nMnuItem , 02 ] + ' "><img src="imagens/b2c/ttl_menu_alterar_senha.gif" alt="Alterar Senha" /></a></li>' + CRLF
										EndIF
									EndIF
								Next nMnuItem
							Next nMnu
	cHtml += 			'</ul>' + CRLF

WEB EXTENDED END

Return( cHtml )

User Web Function TcfStyle()

Local cHtml := ""

cHtml += '	<!--[if IE]>' + CRLF
cHtml += '			<link href="css/estilo_ie.css" rel="stylesheet" type="text/css" media="screen" />' + CRLF
cHtml += '	<![endif]-->' + CRLF

Return( cHtml )

Static Function TcfGetMnu()

Local aUnique			:= { "RBC_FILIAL" , "RBC_CODMNU" }

Local cFilRBC			:= ""
Local cRotina			:= ""
Local cDescri			:= ""
Local cCodMnu			:= ""

HttpSession->aMenuTcf	:= {}

RBC->( MsSeek( ( cFilRBC := xFilial("RBC") ) ) )
While RBC->( !Eof() .and. ( RBC_FILIAL == cFilRBC ) )
	
	IF RBC->( UniqueKey( aUnique ) )
		aAdd( HttpSession->aMenuTcf , {} )
	EndIF
			
	IF ( RBC->RBC_STATUS == "A" )
		
		IF !Empty( cRotina := AllTrim(RBC->RBC_ROTINA) )
			IF FindFunction( "w_"+cRotina )
				cRotina := "w_"+cRotina+".APW"
			ElseIF FindFunction( "l_"+cRotina )
				cRotina := "l_"+cRotina+".APW"
			ElseIF FindFunction( "h_"+cRotina )
				cRotina := "h_"+cRotina+".APW"
			ElseIF FindFunction( "u_"+cRotina )
				cRotina := "u_"+cRotina+".APW"
			Else
				//"Fun&ccedil;&atilde;o n&atilde;o encontrada no Reposit&oacute;rio"
				//"Existem inconsist&ecirc;ncias a serem verificadas:"
				cRotina := "w_TCFNoFunction.APW?NoFunction="+cRotina
			EndIF	
		Else
			cRotina := "#"
		EndIF

		cCodMnu	:= RBC->RBC_CODMNU
		cDescri := Capital( AllTrim( RBC->RBC_DESCRI ) )
			
		aAdd( HttpSession->aMenuTcf[Len( HttpSession->aMenuTcf ) ],	{; 
						  												cDescri ,; //Descricao do Menu
																		cRotina	,; //Programa a Ser Executado
																		cCodMnu  ; //Codigo do Menu
												 					};
		    )
	EndIF
	
	RBC->( dbSkip() )

End While

Return( NIL )

User Web Function TcfSair()
Local cHtml := '<li><a href="u_w_TcfReturn.apw"><img src="imagens/b2c/btn_sair.gif" alt="Sair" /></a><span>&nbsp;</span></li>' + CRLF
Return( cHtml )

User Web Function TcfReturn()
Return( u_w_TcfInit() )

User Web Function HtmlDefault( cMsg , cReturn , lLogout , lChangePdw , lDemonstrativo )

Local cHtmlDefault

DEFAULT cMsg			:= ""
DEFAULT	lLogout			:= .F.
DEFAULT lChangePdw		:= .F.
DEFAULT lDemonstrativo	:= .F.

IF ( lLogout )
	cReturn	:= "u_w_TcfReturn.apw"
EndIF

HttpSession->cDefMsg	:= cMsg
HttpSession->cDefReturn	:= cReturn

IF ( lLogout )
	cHtmlDefault := h_u_tcfmEnd()
ElseIF ( lChangePdw )
	cHtmlDefault := h_u_tcfmPwd()
ElseIF ( lDemonstrativo )
	cHtmlDefault := h_u_tcfdInfo()
Else
	cHtmlDefault := h_u_tcfmInfo()
EndIF

Return( cHtmlDefault )

User Web Function TCFUpdPsw()

Local cHtml			:= ""

Local aEmpresas
Local aPassWordAsc

Local cFil
Local cTemp
Local cReturn
Local cInconsistencia
Local cPassWordChar
Local cSraPassWord

Local dAdmissa
Local dNascimento

Local lCpfOk
Local lPassW
Local lAdmis
Local lNasci

Local nX
Local nPos
Local nLenPassWord
Local nPassWSeq

WEB EXTENDED INIT cHtml START "u_w_TcfUpStart"

	HttpPost->cPassWord			:= APXTo64( Upper( AllTrim( HttpPost->cPassWord ) ) )
	HttpPost->cNewPassWord		:= APXTo64( Upper( AllTrim( HttpPost->cNewPassWord ) ) )
	HttpPost->cConNewPassWord	:= APXTo64( Upper( AllTrim( HttpPost->cConNewPassWord ) ) )

	Begin Sequence

		IF Empty( HttpPost->cNewPassWord ) 
			cInconsistencia := "A senha n&atilde;o foi preenchida" + "<br><br>" + CRLF
			Break
		EndIF

		IF !( HttpPost->cNewPassWord == HttpPost->cConNewPassWord )
			cInconsistencia := "Senhas inv&aacute;lidas" + "<br><br>" + CRLF
			Break
		EndIF

		SRA->( MsSeek( xFilial( "SRA" , TCFWGetFil() ) + TCFWGetMat() ) )
		lCpfOk	:= ( Ap64ToX( APXTo64(Upper(AllTrim(HttpPost->cCPF))) ) == Upper( AllTrim(SRA->RA_CIC) ) )
		IF !( lCpfOk )
			cInconsistencia := "CPF inv&aacute;lido" + "<br><br>" + CRLF
			Break
		EndIF

		dAdmissa	:= Ctod(Day2Str(HttpPost->cDiaAdmissao)+"/"+Month2Str(HttpPost->cMesAdmissao)+"/"+Year2Str(HttpPost->cAnoAdmissao),"DDMMYY")
		lAdmis		:= ( dAdmissa == SRA->RA_ADMISSA )
		IF !( lAdmis )
			cInconsistencia := "Data de admiss&atilde;o inv&aacute;lida" + "<br><br>" + CRLF
			Break
		EndIF

		dNascimento	:= Ctod(Day2Str(HttpPost->cDiaNascimento)+"/"+Month2Str(HttpPost->cMesNascimento)+"/"+Year2Str(HttpPost->cAnoNascimento),"DDMMYY")
		lNasci		:= ( dNascimento == SRA->RA_NASC )
		IF !( lNasci )
			cInconsistencia := "Data de nascimento inv&aacute;lida" + "<br><br>" + CRLF
			Break
		EndIF

		cTemp := Ap64ToX( HttpPost->cNewPassWord )
		nLenPassWord	:= Len( cTemp )
		IF ( nLenPassWord < GetSx3Cache( "RA_SENHA" , "X3_TAMANHO" ) )
			HttpPost->cNewPassWord := "__LENINVALIDO__"
		EndIF
		IF ( HttpPost->cNewPassWord <> "__LENINVALIDO__" )
			aPassWordAsc := {}
			For nX := 1 To nLenPassWord
				cPassWordChar := SubStr( cTemp , nX , 1 )
				IF (;
						Empty( StrTran(cTemp,cPassWordChar,"") );
						.or.;
						( Len( StrTran(cTemp,cPassWordChar,"") ) <= 3 );
					)	
					HttpPost->cNewPassWord := "__CHARIGUAL__"
					Exit
				EndIF
				aAdd( aPassWordAsc , Asc( cPassWordChar ) ) 
			Next nX
			IF ( HttpPost->cNewPassWord <> "__CHARIGUAL__" )
				nX := 0
				IF (;
						!Empty( aPassWordAsc );
						.and.;
						( Len( aPassWordAsc ) > 1 );
					)	
					IF ( aPassWordAsc[1] < aPassWordAsc[2] )
						aEval( aPassWordAsc , { |x,y| IF( ( y == 1 ) .or. ( ( x - nX ) <>  1 ) , nX := x , ( ++nPassWSeq , nX := x ) ) } )
					Else
						aEval( aPassWordAsc , { |x,y| IF( ( y == 1 ) .or. ( ( x - nX ) <> -1 ) , nX := x , ( ++nPassWSeq , nX := x ) ) } )
					EndIF
				EndIF
				IF ( nPassWSeq == ( Len( cTemp ) - 1 ) )
					HttpPost->cNewPassWord := "__PASSWSEQUENC__"
				ElseIF ( cTemp == AllTrim( SRA->RA_MAT ) )
					HttpPost->cNewPassWord := "__PASSWEQUALMAT__"
				EndIF
			EndIF
			cTemp := ""
		EndIF

		lPassW := !( HttpPost->cNewPassWord $ "__CHARIGUAL__*__LENINVALIDO__*__PASSWEQUALMAT__*__PASSWSEQUENC__" ) 
		IF !( lPassW )
			Break
		EndIF

		cSraPassWord := APXTo64( AllTrim( Embaralha( Upper( AllTrim( SRA->RA_SENHA ) ) , 1 ) ) )
		IF !( cSraPassWord == HttpPost->cPassWord )
			cInconsistencia := "Senha Anterior Inv&aacute;lida" + "<br><br>" + CRLF
			Break
		EndIF		

		IF !SRA->( RecLock( "SRA" , .F. ) )
			cInconsistencia := "N&atilde;o foi  poss&iacutevem gravar a nova senha."
			Break
		EndIF
		SRA->RA_SENHA := Embaralha( Ap64ToX( HttpPost->cNewPassWord ) , 0 )
		SRA->( MsUnLock() )
		cReturn := "u_w_TcfInit.apw"
		cHtml	:= u_w_HtmlDefault( "Senha Alterada/Cadastrada com Sucesso:" , cReturn , .F. , .T. )

	End Sequence

	IF !( lPassW )
		IF ( HttpPost->cNewPassWord == "__CHARIGUAL__" )
			cInconsistencia := "N&atilde;o podem existir mais de 3 carecteres iguais na senha" + "<br><br>" + CRLF
		ElseIF ( HttpPost->cNewPassWord == "__LENINVALIDO__" )
			cInconsistencia := "O n&uacute;mero de caracteres da senha &eacute; menor que 6 (seis)" + "<br><br>" + CRLF	
		ElseIF ( HttpPost->cNewPassWord == "__PASSWSEQUENC__" )
			cInconsistencia := "A Senha n&atilde;o pode conter Caracteres Sequenciais" + "<br><br>" + CRLF
		ElseIF ( HttpPost->cNewPassWord == "__PASSWEQUALMAT__" )
			cInconsistencia := "A Senha n&atilde;o pode ser igual a Matricula" + "<br><br>" + CRLF	
		EndIF
	EndIF

	IF !Empty( cInconsistencia )
		cReturn := "u_w_TcfPwd.apw"
		cHtml	:= u_w_HtmlDefault( cInconsistencia , cReturn , .F. , .T. )
	EndIF

WEB EXTENDED END

Return( cHtml )