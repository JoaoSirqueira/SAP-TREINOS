*&---------------------------------------------------------------------*
*& Report ZR6021
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

*🔹 Exercício 1 – Relatório simples com SELECT
*Crie um report que:
*
*Peça via PARAMETERS:
*
*p_bukrs (Company Code)
*
*Busque dados da tabela T001
*
*Exiba:
*
*BUKRS
*
*BUTXT
*
*WAERS
*
*Caso não encontre registros, mostrar mensagem.

REPORT zr6021.

* Tipos
TYPES: BEGIN OF ty_bukrs,
         bukrs LIKE t001-bukrs,
         butxt LIKE t001-butxt,
         waers LIKE t001-waers,
       END OF ty_bukrs.

* Tabela interna
DATA: t_t001 TYPE TABLE OF ty_bukrs.

* Work area
DATA: w_bukrs TYPE ty_bukrs.

* Parâmetro
PARAMETERS: p_bukrs TYPE t001-bukrs.

IF p_bukrs IS INITIAL.
  MESSAGE 'Informe um código de empresa' TYPE 'I'.
  EXIT.
ENDIF.

SELECT bukrs butxt waers FROM t001
  INTO TABLE t_t001
  WHERE bukrs = p_bukrs.

IF t_t001 IS NOT INITIAL.
  WRITE: / 'BUKRS', 10 'BUTXT', 40 'WAERS'.
  ULINE.

  LOOP AT t_t001 INTO w_bukrs.
    WRITE: / w_bukrs-bukrs UNDER 'BUKRS',
             w_bukrs-butxt UNDER 'BUTXT',
             w_bukrs-waers UNDER 'WAERS'.
  ENDLOOP.

ELSE.
  MESSAGE TEXT-001 TYPE 'I'. " Não foi encontrado nenhum registro com esses parâmetros
ENDIF.