#INCLUDE "PROTHEUS.CH"

Static nStcSeed

/*/
�����������������������������������������������������������������������Ŀ
�Programa  �MDJLIB22  �Autor�Marinaldo de Jesus       � Data �11/11/2008�
�����������������������������������������������������������������������Ĵ
�Descri��o �Bliblioteca de Funcoes de Criptografia Genericas da ASOEC	�
�����������������������������������������������������������������������Ĵ
�Uso       �Generico                                                    �
�����������������������������������������������������������������������Ĵ
�            ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL           �
�����������������������������������������������������������������������Ĵ
�Programador �Data      �Nro. Ocorr.�Motivo da Alteracao                �
�����������������������������������������������������������������������Ĵ
�            �          �           �                                   �
�������������������������������������������������������������������������/*/
/*/
������������������������������������������������������������������������Ŀ
�Fun��o    �U_MDJLIB22Exec�Autor �Marinaldo de Jesus   � Data �11/11/2008�
������������������������������������������������������������������������Ĵ
�Descri��o �Executar Funcoes Dentro de MDJLIB22                          �
������������������������������������������������������������������������Ĵ
�Sintaxe   �U_MDJLIB22Exec( cExecIn , aFormParam )						 �
������������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Retorno   �uRet                                                 	     �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �Generico 													 �
��������������������������������������������������������������������������/*/
User Function MDJLIB22Exec( cExecIn , aFormParam )

Local uRet

DEFAULT cExecIn		:= ""
DEFAULT aFormParam	:= {}

IF !Empty( cExecIn )
	cExecIn	:= BldcExecInFun( cExecIn , aFormParam )
	uRet	:= &( cExecIn )
EndIF

Return( uRet )

/*/
������������������������������������������������������������������������Ŀ
�Fun��o    �EnCrypt    	  �Autor �Marinaldo de Jesus   � Data �11/11/2008�
������������������������������������������������������������������������Ĵ
�Descri��o �Gerar Chave Criptografada                                    �
������������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Retorno   �cCrypt														 �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �Generico 													 �
��������������������������������������������������������������������������/*/
Static Function EnCrypt( cUncrypted )
Return( Embaralha( EnCodeUtf8( EnCode64( ApxTo64( cUncrypted ) ) ) , 0 ) )

/*/
������������������������������������������������������������������������Ŀ
�Fun��o    �DeCrypt    	  �Autor �Marinaldo de Jesus   � Data �11/11/2008�
������������������������������������������������������������������������Ĵ
�Descri��o �Decrypt de chave Criprografada pela Crypt                 	 �
������������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Retorno   �cDecrypt                                             	     �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �Generico 													 �
��������������������������������������������������������������������������/*/
Static Function DeCrypt( cEncrypted )
Return( Ap64Tox( Decode64( DeCodeUtf8( Embaralha( cEncrypted , 1 ) ) ) ) )

/*/
������������������������������������������������������������������������Ŀ
�Fun��o    �SplitCrypt 	  �Autor �Marinaldo de Jesus   � Data �11/11/2008�
������������������������������������������������������������������������Ĵ
�Descri��o �Decrypt de chave Criprografada pela Crypt                 	 �
������������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Retorno   �cDecrypt                                             	     �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �Generico 													 �
��������������������������������������������������������������������������/*/
Static Function SplitCrypt( cEncrypted , nParts )

Local aSplit := {}

Local cSplit

DEFAULT cEncrypted  := ""
DEFAULT nParts 		:= Max( Int( Len( cEncrypted ) / 2 ) , 1 )

Begin Sequence

	IF Empty( cEncrypted )
		Break
	EndIF

	cSplit := cEncrypted
	While !Empty( cSplit )
		aAdd( aSplit , SubStr( cSplit , 1 , nParts ) )
		cSplit := SubStr( cSplit , nParts + 1 )
	End While

End Sequence

Return( aSplit )

/*/
������������������������������������������������������������������������Ŀ
�Fun��o    �Random	      �Autor �Marinaldo de Jesus   � Data �12/11/2008�
������������������������������������������������������������������������Ĵ
�Descri��o �Gerar Numeros Aleatorios conforme Intervalo               	 �
������������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Retorno   �nRandom		                                           	     �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �Generico 													 �
��������������������������������������������������������������������������/*/
Static Function Random( nRange , nMin , nMax )

Local bRandom	:= { ||;
							( nRandom := Aleatorio( nRange , @nStcSeed ) ),;
							( ( nRandom >= nMin ) .and. ( nRandom <= nMax ) );
						}		

Local nRandom

DEFAULT nRange		:= 1
DEFAULT nMin 		:= 0
DEFAULT nMax 		:= nRange

DEFAULT nStcSeed	:= Int( ( nRange / 2 ) )

nMin				:= Max( nMin	, 0 )
nMax				:= Max( nMax	, 1 )
nRange				:= Max( nRange , 1 )

IF ( nMin > nMax )
	nMin := 0
EndIF

IF (;
		( nMax < nMin );
		.or.;
		( nMax > nRange );
	)
	nMax := nRange	
EndIF

While !Eval( bRandom )
	 IF (;
	 		( nRandom < nMin );
	 		.or.;
	 		( nRandom > nMax );
	 	)	
	 	IF ( nStcSeed < nMin )
     		nStcSeed += nMin
     		nStcSeed := Min( nMax , nStcSeed ) 
     	ElseIF ( nStcSeed > nMax )
     		nStcSeed -= ( nMax - nMin )
     		nStcSeed := Max( nMin , nStcSeed )
     	EndIF
     EndIF	
End While

Return( nRandom )