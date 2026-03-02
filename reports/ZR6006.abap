*&---------------------------------------------------------------------*
*& Report ZR6006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6006 MESSAGE-ID ZC6001.

* Declaração de variável
DATA: V_RESUL TYPE I.

* Tela de seleção
PARAMETERS: P_NUM1 TYPE I,
            P_NUM2 TYPE I,
            P_SOMA RADIOBUTTON GROUP GR1,
            P_SUBT RADIOBUTTON GROUP GR1,
            P_MULT RADIOBUTTON GROUP GR1,
            P_DIVI RADIOBUTTON GROUP GR1.

* Efetuando cálculos
IF P_SOMA = 'X'.
  V_RESUL = P_NUM1 + P_NUM2.
ELSEIF P_SUBT = 'X'.
  V_RESUL = P_NUM1 - P_NUM2.
ELSEIF P_MULT = 'X'.
  V_RESUL = P_NUM1 * P_NUM2.
ELSEIF P_DIVI = 'X'.
  TRY.
  V_RESUL = P_NUM1 / P_NUM2.
  CATCH CX_SY_ZERODIVIDE.
*   MESSAGE 'DIVISÃO POR ZERO NÃO PERMITIDO' TYPE 'I'.
    MESSAGE I000.
  ENDTRY.
  STOP.
ENDIF.

* Imprimindo resultado
WRITE: 'RESULTADO:', V_RESUL.