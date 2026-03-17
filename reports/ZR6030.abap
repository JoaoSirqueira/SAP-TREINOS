*&---------------------------------------------------------------------*
*& Report ZR6030
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr6030.

TYPE-POOLS: slis. " É tipodiretório com estruturas salvas.

* Declarando tabela para o select-options
TABLES: z6030aula_curso.

" Selection-Screen: contorno na variável de entrada
SELECTION-SCREEN BEGIN OF BLOCK b11 WITH FRAME TITLE TEXT-001." Parâmetro de entrada
* Parâmetro
  SELECT-OPTIONS: so_curso FOR z6030aula_curso-nome_curso NO INTERVALS.
  PARAMETERS: p_basic TYPE char1 RADIOBUTTON GROUP gr1,
              p_compl TYPE char1 RADIOBUTTON GROUP gr1 DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b11.

* Tabelas internas
DATA: lt_zt6030_curso  TYPE TABLE OF z6030aula_curso,
      lt_zt6030_alun   TYPE TABLE OF z6030aula_alun,

* Declaração de variáveis
      lo_grid_100      TYPE REF TO cl_gui_alv_grid,
      lo_container_100 TYPE REF TO cl_gui_alv_grid,
      lv_okcode_100    TYPE sy-ucomm,
      lt_fieldcat      TYPE lvc_t_fcat,
      ls_layout        TYPE lvc_s_layo,
      ls_variant       TYPE disvariant.

START-OF-SELECTION.
  PERFORM f_obtem_dados.

* Form
FORM f_obtem_dados.

  SELECT *
    FROM z6030aula_curso
    INTO TABLE lt_zt6030_curso[]
    WHERE nome_curso IN so_curso.


  SELECT *
    FROM z6030aula_alun
    INTO TABLE lt_zt6030_alun[]
    WHERE nome_curso IN so_curso.

  IF p_basic EQ 'X'.
    PERFORM f_visualizar_dados_alv_basico.
  ELSE.
    PERFORM f_visualizar_dados_alv_compl.
  ENDIF.

  PERFORM f_visualizar_dados_alv_basico.

ENDFORM.

FORM f_visualizar_dados_alv_compl.

  IF lt_zt6030_curso[] IS NOT INITIAL OR lt_zt6030_alun[] IS NOT INITIAL.
    CALL SCREEN 100.
  ELSE.
    MESSAGE 'Dados não localizados!' TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

ENDFORM.

FORM f_visualizar_dados_alv_basico.

  DATA: lt_fieldcat_basico TYPE slis_t_fieldcat_alv,
        ls_layout_basico   TYPE slis_layout_alv.

* Cria o lt_fieldcat[] com base em uma estrutura de dados criada na SE11
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'z6030aula_curso'
    CHANGING
      ct_fieldcat      = lt_fieldcat_basico[].

  ls_layout_basico-colwidth_optimize = 'X'.
  ls_layout_basico-zebra             = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout     = ls_layout_basico
      it_fieldcat   = lt_fieldcat_basico[]
    TABLES
      t_outtab      = lt_zt6030_curso[]
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

ENDFORM.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE lv_okcode_100.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.


*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS100'. " Status 100
  SET TITLEBAR 'TITLE100'. " Exemplo ALV completo
ENDMODULE.