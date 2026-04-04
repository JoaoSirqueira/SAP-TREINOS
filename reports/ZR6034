*&---------------------------------------------------------------------*
*& Report ZR6034
*&---------------------------------------------------------------------*
*& Relatório ALV - ALV de Matrículas.
*&---------------------------------------------------------------------*
REPORT zr6034.

INCLUDE <icon>.

TYPE-POOLS: slis.

*---------------------------------------------------------------------*
* TABELAS
*---------------------------------------------------------------------*
TABLES: z6033_zaluno,
        z6033_zcurso,
        z6033_zmatricula.

*---------------------------------------------------------------------*
* TIPOS
*---------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_dados,
    nome       TYPE z6033_zaluno-nome,
    nome_curso TYPE z6033_zcurso-nome_curso,
    valor      TYPE z6033_zcurso-valor,
    data       TYPE z6033_zmatricula-data,
    id         TYPE icon-id,
    color      TYPE char4,
  END OF ty_dados.

*---------------------------------------------------------------------*
* SELECTION SCREEN
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_aluno FOR z6033_zaluno-nome NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b1.

*---------------------------------------------------------------------*
* DATA
*---------------------------------------------------------------------*
DATA:

  gt_dados     TYPE TABLE OF ty_dados,
  gs_dados     TYPE ty_dados,

  lo_grid      TYPE REF TO cl_gui_alv_grid,
  lo_container TYPE REF TO cl_gui_custom_container,

  lt_fieldcat  TYPE lvc_t_fcat,
  ls_layout    TYPE lvc_s_layo.

*---------------------------------------------------------------------*
* START
*---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM f_obtem_dados.
  CALL SCREEN 100.

*---------------------------------------------------------------------*
* FORM F_OBTEM_DADOS.
*---------------------------------------------------------------------*
FORM f_obtem_dados.

  SELECT
  a~nome,
  b~nome_curso,
  b~valor,
  c~data
  FROM z6033_zmatricula AS c
  LEFT JOIN z6033_zaluno AS a
  ON a~id_aluno = c~id_aluno
  LEFT JOIN z6033_zcurso AS b
  ON b~id_curso = c~id_curso
  WHERE a~nome IN @s_aluno
  INTO TABLE @gt_dados.

  LOOP AT gt_dados ASSIGNING FIELD-SYMBOL(<fs>).

    IF <fs>-nome IS INITIAL OR <fs>-nome_curso IS INITIAL.

      <fs>-id = icon_red_light.
      <fs>-color = 'C600'.

    ELSE.

      <fs>-id = icon_green_light.
      <fs>-color = 'C500'.

    ENDIF.

  ENDLOOP.

ENDFORM.

*---------------------------------------------------------------------*
* MODULE STATUS_0100.
*---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS100'.
  SET TITLEBAR 'TITLE100'.

ENDMODULE.

*---------------------------------------------------------------------*
* MODULE M_SHOW_ALV.
*---------------------------------------------------------------------*
MODULE m_show_alv OUTPUT.

  IF lo_grid IS INITIAL.

    CREATE OBJECT lo_container
      EXPORTING
        container_name = 'CONTAINER'.

    CREATE OBJECT lo_grid
      EXPORTING
        i_parent = lo_container.

    PERFORM f_build_fieldcat.

    ls_layout-zebra = 'X'.
    ls_layout-cwidth_opt = 'X'.
    ls_layout-info_fname = 'COLOR'.

    lo_grid->set_table_for_first_display(

    EXPORTING
    is_layout = ls_layout

    CHANGING
    it_fieldcatalog = lt_fieldcat
    it_outtab = gt_dados

    ).

  ENDIF.

ENDMODULE.

*---------------------------------------------------------------------*
* FORM F_BUILD_FIELDCAT.
*---------------------------------------------------------------------*
FORM f_build_fieldcat.

  PERFORM f_add_fieldcat USING 'ID' 'Status' 'ICON'.
  PERFORM f_add_fieldcat USING 'NOME' 'Aluno' ''.
  PERFORM f_add_fieldcat USING 'NOME_CURSO' 'Curso' ''.
  PERFORM f_add_fieldcat USING 'VALOR' 'Valor' ''.
  PERFORM f_add_fieldcat USING 'DATA' 'Data Matrícula' ''.

ENDFORM.

*---------------------------------------------------------------------*
* FORM F_ADD_FIELDCAT.
*---------------------------------------------------------------------*
FORM f_add_fieldcat USING p_field p_text p_icon.

  DATA ls_fieldcat TYPE lvc_s_fcat.

  ls_fieldcat-fieldname = p_field.
  ls_fieldcat-coltext = p_text.

  IF p_icon = 'ICON'.
    ls_fieldcat-icon = 'X'.
  ENDIF.

  APPEND ls_fieldcat TO lt_fieldcat.

ENDFORM.

*---------------------------------------------------------------------*
* MODULE USER_COMMAND_0100.
*---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.

    WHEN 'BACK' OR 'EXIT' OR 'CANC' OR 'VOLTAR'.
      LEAVE TO SCREEN 0.

  ENDCASE.

ENDMODULE.