#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������Ŀ
�Programa  �MDJLIB23  �Autor�Marinaldo de Jesus       � Data �11/11/2008�
�����������������������������������������������������������������������Ĵ
�Descri��o �Bliblioteca de Funcoes Generica ( Geracao de ChaveID )     	�
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
�Fun��o    �U_MDJLIB23Exec�Autor �Marinaldo de Jesus   � Data �11/11/2008�
������������������������������������������������������������������������Ĵ
�Descri��o �Executar Funcoes Dentro de MDJLIB23                          �
������������������������������������������������������������������������Ĵ
�Sintaxe   �U_MDJLIB23Exec( cExecIn , aFormParam )						 �
������������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Retorno   �uRet                                                 	     �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �Generico 													 �
��������������������������������������������������������������������������/*/
User Function MDJLIB23Exec( cExecIn , aFormParam )

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
�Fun��o    �GetNewKey     �Autor �Marinaldo de Jesus   � Data �11/11/2008�
������������������������������������������������������������������������Ĵ
�Descri��o �Retorna um Numero Sequencial Valido                          �
������������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									 �
������������������������������������������������������������������������Ĵ
�Retorno   �cNextKey                                               	     �
������������������������������������������������������������������������Ĵ
�Observa��o�                                                      	     �
������������������������������������������������������������������������Ĵ
�Uso       �Generico 													 �
��������������������������������������������������������������������������/*/
Static Function GetNewKey()

Local aEmpFil
Local aFields

Local bGetKey

Local cRdd			:= "TOPCONN"
Local cData			:= "keyid"
Local cAlias    	:= "__KEY_ID__"

Local cIndex
Local cQuery
Local cAliasQuery
Local cNextKey
Local cPrepareIn

Local nKeySize

Begin Sequence

	nKeySize	:= 15

	IF ( Select( cAlias ) == 0 )

		cIndex	:= ( cData + "1" )

		IF !( MsFile( cData ) )
			aFields	:= { { "ID" , "C" , nKeySize , 0 } }
			dbCreate( cData , @aFields , cRdd )
		EndIF

		dbUseArea( .T. , cRdd , cData , cAlias , .T. )

		IF !( MsFile( cData , cIndex, "TOPCONN" ) )
			( cAlias )->( dbCreateIndex( cIndex , "ID" , { || ID } , IF( .F. , .T. , NIL ) ) )
		EndIF

		( cAlias )->( dbClearIndex() )
		( cAlias )->( dbSetIndex( cIndex ) )

	EndIF

	cQuery 		:= "select max(ID) ID from " + cData
	cQuery 		:= ChangeQuery( cQuery )
	
	cAliasQuery	:= GetNextAlias()

	dbUseArea(.T.,"TOPCONN",TcGenQry( NIL , NIL , cQuery ) , cAliasQuery )

	IF ( cAliasQuery )->( Eof() .or. Bof() )
		cNextKey	:= Replicate( "0" , nKeySize )
	Else
		cNextKey	:= ( cAliasQuery )->ID
	EndIF
	( cAliasQuery )->( dbCloseArea() )

    PutFileInEof( cAlias )
	bGetKey := { || cNextKey := GetNewCodigo( cAlias , "ID" , "ID" , { || cNextKey := Soma1( cNextKey ) } , .F. , .F. , "" , "" , cNextKey , .F. ) }
	While ( cAlias )->( dbSeek( Eval( bGetKey ) , .F. ) )
		PutFileInEof( cAlias )
	End While

	IF ( cAlias )->( UsrRecLock( cAlias  , .T. , .F. ) )
		( cAlias )->ID := cNextKey
		( cAlias )->( MsUnLock() )
	EndIF

	FreeLocks( NIL , NIL , .T. , NIL )

End Sequence

Return( cNextKey )