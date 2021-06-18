#Include 'Protheus.ch'

User Function Pasta()
Local cPasta     := "PROCESSAMENTO"
Local aDiretorio := {}
//
If ! ExistDir("\PROCESSAMENTO")
	If MakeDir( "\PROCESSAMENTO" ) == 0
		 MakeDir( "\PROCESSAMENTO\Error" )
		 MakeDir( "\PROCESSAMENTO\Processado" )
	Else	 
		MsgStop("Erro ao criar o diretorio")
		Return( NIL )	
	Endif

Endif

aDiretorio := directory("\PROCESSAMENTO\*.*")

If Len(aDiretorio) <> 0
	For x:= 1 to Len(aDiretorio)
		If __CopyFile( "\PROCESSAMENTO\" + aDiretorio[X,1], "\PROCESSAMENTO\Processado\"+ aDiretorio[X,1])
			 FErase("\PROCESSAMENTO\" + aDiretorio[X,1])
		Endif
			 
	Next x


Endif

 