*&---------------------------------------------------------------------*
*& Report ZR6012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6012.

* Declaração de variáveis
DATA: V_RESUL TYPE I.

* Tela de seleção
PARAMETERS: P_NUM1 TYPE I,
            P_NUM2 TYPE I,
            P_OPER TYPE C.

* Início do processamento
START-OF-SELECTION.
  PERFORM F_EXECUTA_CALCULO.

  PERFORM F_IMPRIME_RESULTADO.

*&---------------------------------------------------------------------*
*& Form F_EXECUTA_CALCULO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_EXECUTA_CALCULO .

  CALL FUNCTION 'Z_F6001'
    EXPORTING
      NUMERO1      = P_NUM1
      NUMERO2      = P_NUM2
      OPERACAO     = P_OPER
    IMPORTING
      RESULTADO    = V_RESUL
    EXCEPTIONS
      INV_OPERADOR = 1
      DIVI_ZERO    = 2
      OTHERS       = 3.
  IF SY-SUBRC <> 0.
    IF SY-SUBRC = 1.
      MESSAGE TEXT-001 TYPE 'I'. " Operador Inválido
      STOP.

    ELSEIF SY-SUBRC = 2.
      MESSAGE TEXT-002 TYPE 'I'. " Divisão por zero não permitido

    ELSE.
      MESSAGE TEXT-003 TYPE 'I'. " Erro não identificado
    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_IMPRIME_RESULTADO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F_IMPRIME_RESULTADO .

  WRITE: TEXT-004, V_RESUL. " Resultado: XX

ENDFORM.