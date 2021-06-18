#INCLUDE "PROTHEUS.CH"
/*/
зддддддддддбддддддддддбдддддбдддддддддддддддддддддддддбддддддбдддддддддд©
ЁPrograma  ЁMDJLIB23  ЁAutorЁMarinaldo de Jesus       Ё Data Ё11/11/2008Ё
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁBliblioteca de Funcoes Generica ( Geracao de ChaveID )     	Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                    Ё
цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё            ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL           Ё
цддддддддддддбддддддддддбдддддддддддбддддддддддддддддддддддддддддддддддд╢
ЁProgramador ЁData      ЁNro. Ocorr.ЁMotivo da Alteracao                Ё
цддддддддддддеддддддддддедддддддддддеддддддддддддддддддддддддддддддддддд╢
Ё            Ё          Ё           Ё                                   Ё
юддддддддддддаддддддддддадддддддддддаддддддддддддддддддддддддддддддддддды/*/
/*/
зддддддддддбддддддддддддддбддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁU_MDJLIB23ExecЁAutor ЁMarinaldo de Jesus   Ё Data Ё11/11/2008Ё
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁExecutar Funcoes Dentro de MDJLIB23                          Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   ЁU_MDJLIB23Exec( cExecIn , aFormParam )						 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁuRet                                                 	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁObserva┤└oЁ                                                      	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico 													 Ё
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
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
зддддддддддбддддддддддддддбддддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁGetNewKey     ЁAutor ЁMarinaldo de Jesus   Ё Data Ё11/11/2008Ё
цддддддддддеддддддддддддддаддддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁRetorna um Numero Sequencial Valido                          Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais>									 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais>									 Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁcNextKey                                               	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁObserva┤└oЁ                                                      	     Ё
цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico 													 Ё
юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
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