*&---------------------------------------------------------------------*
*& Report ZR6029
*&---------------------------------------------------------------------*
*& Relatório de Reservas por Passageiro
*&---------------------------------------------------------------------*
REPORT zr6029.

TABLES: sbook, scarr, spfli.

* Dados para exibir no ALV
TYPES:
  BEGIN OF ty_passageiro,
    customid  TYPE sbook-customid,
    passname  TYPE sbook-passname,
    bookid    TYPE sbook-bookid,
    forcurkey TYPE sbook-forcurkey,
  END OF ty_passageiro,

  BEGIN OF ty_voos,
    carrid    TYPE sbook-carrid,
    carrname  TYPE scarr-carrname,
    connid    TYPE sbook-connid,
    fldate    TYPE sbook-fldate,
    cityfrom  TYPE spfli-cityfrom,
    cityto    TYPE spfli-cityto,
    price     TYPE sbook-loccuram,
    forcurkey TYPE sbook-forcurkey,
  END OF ty_voos.

DATA:
  gt_dados TYPE TABLE OF ty_passageiro.

DATA: gt_fieldcat1 TYPE slis_t_fieldcat_alv,
      gt_fieldcat2 TYPE slis_t_fieldcat_alv,
      gs_fieldcat1 TYPE slis_fieldcat_alv,
      gs_fieldcat2 TYPE slis_fieldcat_alv,
      gt_sort      TYPE slis_t_sortinfo_alv,
      gs_sort      TYPE slis_sortinfo_alv,
      gs_layout    TYPE slis_layout_alv,
      gt_voos      TYPE TABLE OF ty_voos.

SELECT-OPTIONS:
  s_carr FOR sbook-carrid,
  s_conn FOR sbook-connid,
  s_date FOR sbook-fldate.

SELECT-OPTIONS: s_moeda FOR sbook-forcurkey.

START-OF-SELECTION.
  PERFORM f_busca_dados.
  PERFORM f_monta_fieldcat.
  PERFORM f_monta_layout.
  PERFORM f_monta_sort.
  PERFORM f_visualiza_alv1.

*&---------------------------------------------------------------------*
*& Form f_visualiza_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_visualiza_alv1 .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      is_layout               = gs_layout
      it_fieldcat             = gt_fieldcat1
    TABLES
      t_outtab                = gt_dados.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_busca_dados
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_busca_dados .

  SELECT
      sbook~customid
      sbook~passname
      sbook~bookid
      sbook~forcurkey
      INTO TABLE gt_dados
      FROM sbook
      WHERE sbook~carrid    IN s_carr
        AND sbook~connid    IN s_conn
        AND sbook~fldate    IN s_date
        AND sbook~forcurkey IN s_moeda
        AND sbook~passname <> ''.

  IF gt_dados IS INITIAL.
    MESSAGE 'Nenhum dado encontrado' TYPE 'S' DISPLAY LIKE 'W'.
    STOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_monta_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_monta_fieldcat .

  CLEAR gs_fieldcat1.
  gs_fieldcat1-fieldname = 'CUSTOMID'.
  gs_fieldcat1-seltext_m = 'ID passageiro'.
  APPEND gs_fieldcat1 TO gt_fieldcat1.

  CLEAR gs_fieldcat1.
  gs_fieldcat1-fieldname = 'PASSNAME'.
  gs_fieldcat1-seltext_m = 'Nome do passageiro'.
  gs_fieldcat1-hotspot   = 'X'. " Quando o usuário clicar no campo ID passageiro transferir para o ALV de INFO VOO
  APPEND gs_fieldcat1 TO gt_fieldcat1.

  CLEAR gs_fieldcat1.
  gs_fieldcat1-fieldname = 'BOOKID'.
  gs_fieldcat1-seltext_m = 'Reserva'.
  APPEND gs_fieldcat1 TO gt_fieldcat1.

  CLEAR gs_fieldcat1.
  gs_fieldcat1-fieldname = 'FORCURKEY'.
  gs_fieldcat1-seltext_m = 'Moeda'.
  APPEND gs_fieldcat1 TO gt_fieldcat1.

  " ---------------- 2

  CLEAR gs_fieldcat2.
  gs_fieldcat2-fieldname = 'CARRID'.
  gs_fieldcat2-seltext_m = 'Companhia'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.

  CLEAR gs_fieldcat2.
  gs_fieldcat2-fieldname = 'CARRNAME'.
  gs_fieldcat2-seltext_m = 'Nome da companhia'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.

  CLEAR gs_fieldcat2.
  gs_fieldcat2-fieldname = 'CONNID'.
  gs_fieldcat2-seltext_m = 'N° do vôo'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.

  CLEAR gs_fieldcat2.
  gs_fieldcat2-fieldname = 'FLDATE'.
  gs_fieldcat2-seltext_m = 'Data do vôo'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.

  CLEAR gs_fieldcat2.
  gs_fieldcat2-fieldname = 'CITYFROM'.
  gs_fieldcat2-seltext_m = 'Cidade origem'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.

  CLEAR gs_fieldcat2.
  gs_fieldcat2-fieldname = 'CITYTO'.
  gs_fieldcat2-seltext_m = 'Cidade destino'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.

  CLEAR gs_fieldcat2.
  gs_fieldcat2-fieldname = 'PRICE'.
  gs_fieldcat2-seltext_m = 'Valor da reserva'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.

  CLEAR gs_fieldcat2.
  gs_fieldcat2-fieldname = 'FORCURKEY'.
  gs_fieldcat2-seltext_m = 'Moeda'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_monta_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_monta_layout .

  gs_layout-zebra = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_monta_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_monta_sort .

  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.
  APPEND gs_sort TO gt_sort.

  gs_sort-fieldname = 'FLDATE'.
  gs_sort-up = 'X'.
  APPEND gs_sort TO gt_sort.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_visualiza_alv2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_visualiza_alv2 .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout   = gs_layout
      it_fieldcat = gt_fieldcat2
      it_sort     = gt_sort
    TABLES
      t_outtab    = gt_voos.

ENDFORM.

FORM user_command USING r_ucomm     LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  DATA ls_dados TYPE ty_passageiro.

  IF rs_selfield-fieldname = 'PASSNAME'.

    READ TABLE gt_dados INTO ls_dados INDEX rs_selfield-tabindex.
    IF sy-subrc = 0.

      PERFORM f_busca_voos USING ls_dados-customid.
      PERFORM f_visualiza_alv2.

    ENDIF.

    rs_selfield-refresh = 'X'.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_busca_voos
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_DADOS_CUSTOMID
*&---------------------------------------------------------------------*
FORM f_busca_voos  USING  p_customid.

  CLEAR gt_voos.

  SELECT
    sbook~carrid
    scarr~carrname
    sbook~connid
    sbook~fldate
    spfli~cityfrom
    spfli~cityto
    sbook~loccuram
    sbook~forcurkey
    INTO TABLE gt_voos
    FROM sbook
    INNER JOIN scarr
      ON scarr~carrid = sbook~carrid
    INNER JOIN spfli
      ON spfli~carrid = sbook~carrid
     AND spfli~connid = sbook~connid
    WHERE sbook~customid = p_customid.

ENDFORM.