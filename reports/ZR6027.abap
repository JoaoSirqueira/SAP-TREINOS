*&---------------------------------------------------------------------*
*& Report ZR6027
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr6027.

* Tabelas transparentes
TABLES: zt6005.

* Tabelas internas
DATA: t_zt6001 TYPE TABLE OF zt6001 WITH HEADER LINE,
      t_zt6005 TYPE TABLE OF zt6005 WITH HEADER LINE.

* Tela de seleção
SELECT-OPTIONS: s_tpmat FOR zt6005-tpmat,
                s_mater FOR zt6005-mater.

* Início do processamento
START-OF-SELECTION.
  PERFORM f_seleciona_dados.

  PERFORM f_imprime_dados.

*&---------------------------------------------------------------------*
*& Form f_seleciona_dados
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_seleciona_dados .

  SELECT * FROM zt6005
    INTO TABLE t_zt6005
    WHERE mater IN s_mater
      AND tpmat IN s_tpmat.

  IF t_zt6005[] IS NOT INITIAL.

    SELECT * FROM zt6001
      INTO TABLE t_zt6001
      FOR ALL ENTRIES IN t_zt6005
      WHERE tpmat = t_zt6005-tpmat.
  ELSE.
    MESSAGE TEXT-001 TYPE 'I'. " Nenhum registro encontrado para esse critério de seleção
    STOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_imprime_dados
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_imprime_dados .

  SORT t_zt6005 BY mater tpmat.
  SORT t_zt6001 BY tpmat.

  LOOP AT t_zt6005.
    WRITE:/ t_zt6005-mater, t_zt6005-denom, t_zt6005-brgew, t_zt6005-ntgew,
            t_zt6005-tpmat.

    READ TABLE t_zt6001 WITH KEY tpmat = t_zt6005-tpmat BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      WRITE: t_zt6001-denom.
    ENDIF.

  ENDLOOP.

ENDFORM.