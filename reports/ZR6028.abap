*&---------------------------------------------------------------------*
*& Report ZR6028
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr6028.

* Tipos
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
       END OF ty_mara.

TYPES: BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
         spras TYPE makt-spras,
       END OF ty_makt.

TYPES: BEGIN OF ty_final,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
         spras TYPE makt-spras,
       END OF ty_final.

* Tabela interna
DATA: t_mara  TYPE TABLE OF ty_mara,
      t_makt  TYPE HASHED TABLE OF ty_makt WITH UNIQUE KEY matnr spras,
      t_final TYPE TABLE OF ty_final.

* Work area
DATA: w_mara  TYPE ty_mara,
      w_makt  TYPE ty_makt,
      w_final TYPE ty_final.

* Parâmetros
PARAMETERS: p_spras TYPE makt-spras DEFAULT sy-langu.

SELECT matnr mtart matkl
  FROM mara
  INTO TABLE t_mara.

IF t_mara[] IS NOT INITIAL.

  SELECT matnr maktx spras
    FROM makt
    INTO TABLE t_makt
    FOR ALL ENTRIES IN t_mara
    WHERE matnr = t_mara-matnr
    AND spras = p_spras.

ENDIF.

LOOP AT t_mara INTO w_mara.

  CLEAR: w_makt, w_final.

  READ TABLE t_makt INTO w_makt
       WITH KEY matnr = w_mara-matnr
                spras = p_spras.

  w_final-matnr = w_mara-matnr.
  w_final-spras = p_spras.

  IF sy-subrc IS INITIAL.
    w_final-maktx = w_makt-maktx.
  ELSE.
    w_final-maktx = 'SEM DESCRIÇÃO'.
  ENDIF.

  APPEND w_final TO t_final.

ENDLOOP.

LOOP AT t_final INTO w_final.

  WRITE: / w_final-matnr,
           w_final-maktx,
           w_final-spras.

ENDLOOP.