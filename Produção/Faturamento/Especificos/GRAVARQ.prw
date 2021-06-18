
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GRAVARQ   �Autor  �Angelo Henrique     � Data �  18/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel por gravar em arquivo .TXT os dados do   ���
���          �array para troca de informa��es do RPC                      ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GravArq1(_aItmPd)

Local _cFile := "\" + GetNextAlias() + ".txt"
Local _nFile := Nil
Local _cLogPd	:= GetMv("GEN_FAT007") //Cont�m o caminho que ser� gravado o log de erro

If Len(_aItmPd) > 0
	_nFile := fCreate(_cFile)
	If !File(_cFile)
		_cFile := "\"
		_cMsg := "GravArq - Falha ao criar arquivo .txt " + str(ferror())
		Conout(_cMsg)
		MemoWrite(_cLogPd+"_GRAVAARQ1_.txt",_cMsg)
	Else
		For _ni := 1 To Len(_aItmPd)
			_cLinTmp := ""
			For _nz:=1 To Len(_aItmPd[_ni])
				_cLinTmp += _aItmPd[_ni][_nz][1] + ";" + Valtype(_aItmPd[_ni][_nz][2]) + ";" + cValToChar(_aItmPd[_ni][_nz][2]) + "|"
			Next _nz
			fWrite(_nFile, _cLinTmp + chr(13)+chr(10) )
		Next _ni
		fClose(_nFile)
	Endif
Else
	_cFile := "\"
	_cMsg := "GravArq - Arquivo sem itens." + str(ferror())
	Conout(_cMsg)
	MemoWrite(_cLogPd+"_GRAVAARQ1_.txt",_cMsg)
EndIf

Return _cFile


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LeArq1    �Autor  �Angelo Henrique     � Data �  18/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina respons�vel por pegar os dados no arquivo .txt e     ���
���          �colocar na array e ap�s o tratamento o arquivo � exclu�do.  ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LeArq1(_cFile)

Local _aCampos 	:= {}
Local _aRet	   	:= {}

FT_FUSE(_cFile)
FT_FGOTOP()

If File(_cFile)
	While !FT_FEOF()
		//Leitura da primeira linha com o cabe�alho dos campos
		_cBuffer := FT_FREADLN()
		_aPrep   := {}
		_aLinha  := Separa(_cBuffer,"|",.F.)
		
		For _nz:=1 To Len(_aLinha)
			_aExec := {}
			_aCampos := Separa(_aLinha[_nz],";",.F.)
			If _aCampos[2] == "D"
				_cRec := cToD(_aCampos[3])
			ElseIf _aCampos[2] == "C"
				_cRec := Padr(_aCampos[3],TamSx3(_aCampos[1])[1])
			ElseIf _aCampos[2] == "N"
				_cRec := Val(_aCampos[3])
			Else
				_cRec := ""
			EndIf
			_aExec := {_aCampos[1],_cRec,Nil}
			AADD(_aPrep,_aExec)
		Next _nz
		
		AADD(_aRet,_aPrep)
		
		FT_FSKIP()
	EndDo

	FT_FUSE()
	fErase(_cFile)

Else
	_cMsg := "LeArq1 - Arquivo sem itens." + str(ferror())
	Conout(_cMsg)
	MemoWrite(_cLogPd+"_GRAVAARQ1_.txt",_cMsg)
Endif

Return _aRet
