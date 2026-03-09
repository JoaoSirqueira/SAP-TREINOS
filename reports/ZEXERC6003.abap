*&---------------------------------------------------------------------*
*& Report ZEXERC6003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXERC6003.

DATA V_RESUL TYPE P DECIMALS 2.

PARAMETERS: P_VALOR TYPE P DECIMALS 2,
            P_PERC TYPE P DECIMALS 2.

V_RESUL = ( P_VALOR / 100 ) * P_PERC.

WRITE: 'O valor percentual é ', V_RESUL.