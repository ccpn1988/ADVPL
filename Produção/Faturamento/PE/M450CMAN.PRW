#INCLUDE "PROTHEUS.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M450CMAN � Autor � Renato Calabro'    � Data �  07/13/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada utilizado para validar libera��o/rejei��o ���
���          � do cr�dito antes de ser efetivado a gravacao               ���
�������������������������������������������������������������������������͹��
���Retorno   � lExpR - .T. liberar/rejeitar / .F. cancelar a opera��o     ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M450CMAN()

Local UsrBloq	:= GetMv("GEN_FAT119",, "")

Local nOpc		:= ParamIXB[1]

Local lRet		:= .T.

Local aAreas	:= GetArea()

If AllTrim(RetCodUsr()) $ AllTrim(UsrBloq)
	Aviso(	"Usu�rio sem permiss�o", "N�o � poss�vel prosseguir, pois voc� n�o possui permiss�o esta opera��o." + CRLF +;
			"Por favor, procure o administrador e solicite permiss�o para continuar." , {"&Cancelar"},, "Aten��o",, "MSGHIGH" )
	lRet := .F.
EndIf

RestArea(aAreas)

Return lRet
