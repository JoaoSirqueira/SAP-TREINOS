*&---------------------------------------------------------------------*
*& Report ZR6032
*&---------------------------------------------------------------------*
*& Relatório de Reservas de Passageiros
*&---------------------------------------------------------------------*
REPORT zr6032.

*&---------------------------------------------------------------------*
*& TABELAS
*&---------------------------------------------------------------------*
TABLES: sbook, sflight, scarr.

*&---------------------------------------------------------------------*
*& TIPOS
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.

TYPES:
  BEGIN OF ty_reserva,
    carrid      TYPE sbook-carrid,
    carrname    TYPE scarr-carrname,
    connid      TYPE sbook-connid,
    fldate      TYPE sbook-fldate,
    customid    TYPE sbook-customid,
    passname    TYPE sbook-passname,
    class       TYPE sbook-class,
    loccuram    TYPE sbook-loccuram,
    tipo_classe TYPE string,
  END OF ty_reserva.

*&---------------------------------------------------------------------*
*& DATAS
*&---------------------------------------------------------------------*
DATA: gt_reservas TYPE TABLE OF ty_reserva,
      gs_reserva  TYPE ty_reserva.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv.

DATA: gs_layout TYPE slis_layout_alv.

*&---------------------------------------------------------------------*
*& SELECT-OPTIONS
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b11 WITH FRAME TITLE TEXT-001." Parâmetro de entrada
  SELECT-OPTIONS:
    s_carrid FOR sbook-carrid NO INTERVALS,
    s_fldate FOR sbook-fldate NO INTERVALS,
    s_class  FOR sbook-class NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b11.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_exibir_dados.
  PERFORM f_monta_fieldcat.
  PERFORM f_exibir_alv.

*&---------------------------------------------------------------------*
*& FORM F_EXIBIR_DADOS.
*&---------------------------------------------------------------------*
FORM f_exibir_dados.

  SELECT
    sbook~carrid
    scarr~carrname
    sbook~connid
    sbook~fldate
    sbook~customid
    sbook~passname
    sbook~class
    sbook~loccuram
    INTO TABLE gt_reservas
    FROM sbook
    INNER JOIN scarr
      ON scarr~carrid = sbook~carrid
    INNER JOIN sflight
      ON sflight~carrid = sbook~carrid
      AND sflight~connid = sbook~connid
      AND sflight~fldate = sbook~fldate
    WHERE sbook~carrid IN s_carrid
    AND sbook~passname <> ''
    AND sbook~fldate IN s_fldate
    AND sbook~class IN s_class.

  IF gt_reservas IS NOT INITIAL.
    LOOP AT gt_reservas ASSIGNING FIELD-SYMBOL(<fs_reserva>).
      CASE <fs_reserva>-class.
        WHEN 'Y'.
          <fs_reserva>-tipo_classe = 'Econômica'.
        WHEN 'C'.
          <fs_reserva>-tipo_classe = 'Executiva'.
        WHEN 'F'.
          <fs_reserva>-tipo_classe = 'Primeira Classe'.
      ENDCASE.

    ENDLOOP.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_MONTA_FIELDCAT.
*&---------------------------------------------------------------------*
FORM f_monta_fieldcat.

  PERFORM f_add_fieldcat USING 'CARRID'      'Companhia'.
  PERFORM f_add_fieldcat USING 'CARRNAME'    'Nome da companhia'.
  PERFORM f_add_fieldcat USING 'CONNID'      'Conexão'.
  PERFORM f_add_fieldcat USING 'FLDATE'      'Data'.
  PERFORM f_add_fieldcat USING 'CUSTOMID'    'ID'.
  PERFORM f_add_fieldcat USING 'PASSNAME'    'Nome do passageiro'.
  PERFORM f_add_fieldcat USING 'TIPO_CLASSE' 'Classe'.
  PERFORM f_add_fieldcat USING 'LOCCURAM'    'Valor'.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_ADD_FIELDCAT.
*&---------------------------------------------------------------------*
FORM f_add_fieldcat USING p_field p_text.

  CLEAR gs_fieldcat.

  gs_fieldcat-fieldname = p_field.
  gs_fieldcat-seltext_l = p_text.

  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_EXIBIR_ALV.
*&---------------------------------------------------------------------*
FORM f_exibir_alv.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout   = gs_layout
      it_fieldcat = gt_fieldcat
    TABLES
      t_outtab    = gt_reservas.

ENDFORM.