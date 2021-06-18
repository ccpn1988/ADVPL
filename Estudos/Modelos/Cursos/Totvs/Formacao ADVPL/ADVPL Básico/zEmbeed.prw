#include 'protheus.ch'
#include 'parmtype.ch'

user function zEmbeed()
	
BeginSql alias 'NomeAlias'

SELECT C7_NUM, C7_CC, C7_EMISSAO, F4_ESTOQUE, C7_MOEDA, C7_TOTAL FROM (
    SELECT  C7_NUM, C7_CC, C7_EMISSAO, F4_ESTOQUE, C7_MOEDA, C7_TOTAL = SUM(C7_TOTAL)
    
    FROM    %Table:SC7% SC7,
    %Table:SF4% SF4,
    %Table:CTT% CTT
    
    WHERE   SC7.%NotDel%
    AND     SF4.%NotDel%
    AND     CTT.%NotDel%
    
    AND     F4_FILIAL  = %xFilial:SF4%
    AND     C7_FILIAL  = %xFilial:SC7%
    AND     CTT_FILIAL = %xFilial:CTT%
    
    AND     C7_TES     = F4_CODIGO
    AND     C7_CC      = CTT_CUSTO
    
    AND     C7_RESIDUO  = %Exp:" "%                
    AND     C7_CONAPRO  = %Exp:"B"%                
    AND     C7_COMPRAD != %Exp:" "%                
    
    AND     CTT_GRPAPR IN (SELECT   AL_COD
    FROM    %Table:SAL% SAL1
    WHERE   SAL1.%NotDel%
    AND     AL_FILIAL = %xFilial:SAL%
    AND     AL_APROV = %Exp:SAK-&gt;AK_COD% )
    
    AND     C7_NUM      BETWEEN %Exp:_cPedDe% AND %Exp:_cPedAte%
    AND     C7_CC       BETWEEN %Exp:__cCCDe% AND %Exp:__cCCAte%
    AND     C7_EMISSAO  BETWEEN %Exp:_cEmisDe% AND %Exp:_cEmisAte%
    AND     C7_PRODUTO  BETWEEN %Exp:_cProdDe% AND %Exp:_cProdAte%   
    
    GROUP BY C7_NUM, C7_CC, F4_ESTOQUE, C7_MOEDA, C7_EMISSAO                                                 
) T
 
EndSql
return