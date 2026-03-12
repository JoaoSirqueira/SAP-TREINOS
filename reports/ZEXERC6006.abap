*&---------------------------------------------------------------------*
*& Report ZEXERC6006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERC6006.

DATA V_VFINAL TYPE P DECIMALS 2.
DATA V_PERCENT TYPE P DECIMALS 2.
DATA V_DESC_ACRES TYPE P DECIMALS 2.

PARAMETERS: P_VLRTOT TYPE P DECIMALS 2,
            P_PARC TYPE I.

IF ( P_VLRTOT <= '100.00'  AND P_PARC = 1 ).
  V_PERCENT = '-15'.
ELSEIF ( P_VLRTOT > '100.00' AND P_PARC = 1 ).
  V_PERCENT = '-20'.
ELSEIF ( P_VLRTOT <= '100.00' AND P_PARC <= 3 ).
  V_PERCENT = '-5'.
ELSEIF ( P_VLRTOT > '100.00' AND P_PARC <= 3 ).
  V_PERCENT = '-10'.
ELSEIF ( P_PARC > 3 ).
  V_PERCENT = '+10'.
ENDIF.


V_DESC_ACRES = ( P_VLRTOT / 100 ) * V_PERCENT.
V_VFINAL = P_VLRTOT + V_DESC_ACRES.

WRITE: / 'Valor original: ', P_VLRTOT.
WRITE: / 'Quantidade de parcela(s): ', P_PARC.
WRITE: / 'Percentual Desconto / Acréscimo: ', V_PERCENT, '%'.
WRITE: / 'Valor Desconto / Acréscimo: ', V_DESC_ACRES.
WRITE: / 'Valor Final: ', V_VFINAL.