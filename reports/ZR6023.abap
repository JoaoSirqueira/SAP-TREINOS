*&---------------------------------------------------------------------*
*& Report ZR6023
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*🥇 Exercício 1 – Operações Básicas
*
*Crie um REPORT Z que:
*
*Tenha 2 PARAMETERS do tipo I
*
*Tenha 1 PARAMETER para operação (+ - * /)
*
*Use CASE para decidir a operação
*
*Mostre o resultado com WRITE
*
*Se a divisão for por 0, trate o erro
*
*⚠ Não use PERFORM ainda.
*⚠ Faça direto no START-OF-SELECTION.

REPORT zr6023.

PARAMETERS: p_valor1 TYPE i,
            p_valor2 TYPE i,
            p_operac TYPE c.

DATA:       v_result TYPE i.

START-OF-SELECTION.

  CASE p_operac.
    WHEN '+'.
      v_result = p_valor1 + p_valor2.
      WRITE: 'O resultado da conta é: ', v_result.
    WHEN '-'.
      v_result = p_valor1 - p_valor2.
      WRITE: 'O resultado da conta é: ', v_result.
    WHEN '*'.
      v_result = p_valor1 * p_valor2.
      WRITE: 'O resultado da conta é: ', v_result.
    WHEN '/'.
      TRY.
          v_result = p_valor1 / p_valor2.
        CATCH cx_sy_zerodivide.
          MESSAGE 'Divisão por zero não é permitido!' TYPE 'I'.
      ENDTRY.
      STOP.
    WHEN OTHERS.
      MESSAGE 'Digite uma operação válida!' TYPE 'I'.

  ENDCASE.