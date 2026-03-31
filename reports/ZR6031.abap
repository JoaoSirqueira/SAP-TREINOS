*&---------------------------------------------------------------------*
*& Report ZR6031
*&---------------------------------------------------------------------*
REPORT zr6031.

*&---------------------------------------------------------------------*
*& TABELAS
*&---------------------------------------------------------------------*
TABLES: sflight, scarr, spfli.

*&---------------------------------------------------------------------*
*& TIPOS
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.

TYPES:
  BEGIN OF ty_voo,
    carrid          TYPE sflight-carrid,
    carrname        TYPE scarr-carrname,
    connid          TYPE sflight-connid,
    cityfrom        TYPE spfli-cityfrom,
    cityto          TYPE spfli-cityto,
    fldate          TYPE sflight-fldate,
    seatsmax        TYPE sflight-seatsmax,
    seatsocc        TYPE sflight-seatsocc,
    assentos_livres TYPE i,
    ocupacao        TYPE p DECIMALS 2,
  END OF ty_voo.

*&---------------------------------------------------------------------*
*& DATAS
*&---------------------------------------------------------------------*
DATA: gt_voos TYPE TABLE OF ty_voo,
      gs_voo  TYPE ty_voo.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv.

*&---------------------------------------------------------------------*
*& SELECT-OPTIONS
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b11 WITH FRAME TITLE TEXT-001." Parâmetro de entrada
  SELECT-OPTIONS:
    s_carrid FOR sflight-carrid,
    s_fldate FOR sflight-fldate.
SELECTION-SCREEN END OF BLOCK b11.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_seleciona_dados.
  PERFORM f_montar_fieldcat.
  PERFORM f_exibir_alv.

*&---------------------------------------------------------------------*
*& FORM F_SELECIONA_DADOS
*&---------------------------------------------------------------------*
FORM f_seleciona_dados.

  SELECT
    sflight~carrid
    scarr~carrname
    sflight~connid
    spfli~cityfrom
    spfli~cityto
    sflight~fldate
    sflight~seatsmax
    sflight~seatsocc
    INTO TABLE gt_voos
    FROM sflight
    INNER JOIN scarr
      ON scarr~carrid = sflight~carrid
    INNER JOIN spfli
      ON spfli~carrid = sflight~carrid
     AND spfli~connid = sflight~connid
    WHERE sflight~carrid IN s_carrid
    AND sflight~fldate IN s_fldate.

  IF gt_voos IS NOT INITIAL.

    LOOP AT gt_voos ASSIGNING FIELD-SYMBOL(<fs_voo>).
*      gs_voo-assentos_livres = gs_voo-seatsmax - gs_voo-seatsocc.
*      gs_voo-ocupacao        = ( gs_voo-seatsocc / gs_voo-seatsmax ) * 100.

      <fs_voo>-assentos_livres = <fs_voo>-seatsmax - <fs_voo>-seatsocc.
      <fs_voo>-ocupacao        = ( <fs_voo>-seatsocc / <fs_voo>-seatsmax ) * 100.

    ENDLOOP.

  ELSE.
    MESSAGE 'Não foi encontrado registros!' TYPE 'I'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_MONTAR_FIELDCAT
*&---------------------------------------------------------------------*
FORM f_montar_fieldcat.

  PERFORM f_add_fieldcat USING 'CARRID'          'Companhia'.
  PERFORM f_add_fieldcat USING 'CARRNAME'        'Nome da companhia'.
  PERFORM f_add_fieldcat USING 'CONNID'          'Conexão'.
  PERFORM f_add_fieldcat USING 'CITYFROM'        'Origem'.
  PERFORM f_add_fieldcat USING 'CITYTO'          'Destino'.
  PERFORM f_add_fieldcat USING 'FLDATE'          'Data'.
  PERFORM f_add_fieldcat USING 'SEATSMAX'        'Total de assentos'.
  PERFORM f_add_fieldcat USING 'SEATSOCC'        'Assentos ocupados'.
  PERFORM f_add_fieldcat USING 'ASSENTOS_LIVRES' 'Assentos livres'.
  PERFORM f_add_fieldcat USING 'OCUPACAO'        'Ocupação'.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_ADD_FIELDCAT
*&---------------------------------------------------------------------*
FORM f_add_fieldcat USING p_field p_text.

  CLEAR gs_fieldcat.

  gs_fieldcat-fieldname = p_field.
  gs_fieldcat-seltext_l = p_text.

  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_EXIBIR_ALV
*&---------------------------------------------------------------------*
FORM f_exibir_alv.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout   = gs_layout
      it_fieldcat = gt_fieldcat
    TABLES
      t_outtab    = gt_voos.

ENDFORM.