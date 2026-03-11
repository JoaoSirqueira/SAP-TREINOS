&---------------------------------------------------------------------
& Report ZEXERC6005
&---------------------------------------------------------------------
&
&---------------------------------------------------------------------
REPORT ZEXERC6005.

 Variáveis
DATA V_IMC TYPE P DECIMALS 2.

PARAMETERS P_PESO TYPE P DECIMALS 2,
           P_ALTU TYPE P DECIMALS 2.

 Cálculo
V_IMC = P_PESO  ( P_ALTU  P_ALTU ).

IF ( V_IMC  '17' ).
  WRITE  'IMC é ', V_IMC, 'e a situação é MUITO ABAIXO DO PESO'.
ELSEIF ( V_IMC = '17' AND V_IMC  '18.5' ).
  WRITE  'IMC é ', V_IMC, 'e a situação é ABAIXO DO PESO'.
ELSEIF ( V_IMC = '18.5' AND V_IMC  '25.0' ).
  WRITE  'IMC é ', V_IMC, 'e a situação é PESO NORMAL'.
ELSEIF ( V_IMC = '25.0' AND V_IMC  '30.0' ).
  WRITE  'IMC é ', V_IMC, 'e a situação é ACIMA DO PESO'.
ELSEIF ( V_IMC = '30.0' AND V_IMC  '35.0' ).
  WRITE  'IMC É ', V_IMC, 'Obesidade I'.
ELSEIF ( V_IMC = '35.0' AND V_IMC  '40.0' ).
  WRITE  'IMC É ', V_IMC, 'Obesidade II (SEVERA)'.
ELSEIF ( V_IMC = '40.0' ).
  WRITE  'IMC É ', V_IMC, 'Obesidade III (MÓRBIDA)'.
ENDIF.