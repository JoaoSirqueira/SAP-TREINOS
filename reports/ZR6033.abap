*&---------------------------------------------------------------------*
*& Report ZR6033
*&---------------------------------------------------------------------*
*& Relatório ALV - ALV de Cursos e Quantidade de Alunos.
*&---------------------------------------------------------------------*
REPORT zr6033.

*&---------------------------------------------------------------------*
*& TABELAS
*&---------------------------------------------------------------------*
TABLES: z6033_zaluno, z6033_zcurso, z6033_zmatricula.

*&---------------------------------------------------------------------*
*& TIPOS
*&---------------------------------------------------------------------*
TYPE-POOLS: slis.

TYPES:
  BEGIN OF ty_cursoalv,
    id_curso   TYPE z6033_zcurso-id_curso,
    nome_curso TYPE z6033_zcurso-nome_curso,
    valor      TYPE z6033_zcurso-valor,
    qtd_alunos TYPE i,
  END OF ty_cursoalv,

  BEGIN OF ty_aluno,
    nome   TYPE z6033_zaluno-nome,
    cidade TYPE z6033_zaluno-cidade,
  END OF ty_aluno.

*&---------------------------------------------------------------------*
*& DATA
*&---------------------------------------------------------------------*
DATA: gt_curso     TYPE TABLE OF ty_cursoalv,
      gs_curso     TYPE ty_cursoalv,
      gt_alunos    TYPE TABLE OF ty_aluno,
      gt_fieldcat  TYPE slis_t_fieldcat_alv,
      gs_fieldcat  TYPE slis_fieldcat_alv,
      gt_fieldcat2 TYPE slis_t_fieldcat_alv,
      gs_fieldcat2 TYPE slis_fieldcat_alv,
      gs_layout    TYPE slis_layout_alv.

*&---------------------------------------------------------------------*
*& SELECT-OPTIONS
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-001. "Parâmetro de entrada
  SELECT-OPTIONS:
    s_curso FOR z6033_zcurso-nome_curso NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b.

*&---------------------------------------------------------------------*
*& START-OF-SELECTIONS
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_seleciona_dados.
  PERFORM f_monta_fieldcat.
  PERFORM f_exibe_alv.

*&---------------------------------------------------------------------*
*& FORM F_SELECIONA_DADOS.
*&---------------------------------------------------------------------*
FORM f_seleciona_dados.

  SELECT
    b~id_curso,
    b~nome_curso,
    b~valor,
    COUNT( c~id_aluno ) AS qtd_alunos
    FROM z6033_zcurso AS b
    INNER JOIN z6033_zmatricula AS c
      ON b~id_curso EQ c~id_curso
    WHERE b~nome_curso IN @s_curso
    GROUP BY b~id_curso,
             b~nome_curso,
             b~valor
    INTO TABLE @gt_curso.

  LOOP AT gt_curso INTO DATA(ls_curso).

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_MONTA_FIELDCAT.
*&---------------------------------------------------------------------*
FORM f_monta_fieldcat.

  PERFORM f_add_fieldcat USING 'ID_CURSO' 'ID Curso'.
  PERFORM f_add_fieldcat USING 'NOME_CURSO' 'Curso'.
  PERFORM f_add_fieldcat USING 'VALOR' 'Valor'.
  PERFORM f_add_fieldcat USING 'QTD_ALUNOS' 'Qtd. Alunos'.

  gs_fieldcat2-fieldname = 'NOME'.
  gs_fieldcat2-seltext_m = 'Aluno'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.

  gs_fieldcat2-fieldname = 'CIDADE'.
  gs_fieldcat2-seltext_m = 'Cidade'.
  APPEND gs_fieldcat2 TO gt_fieldcat2.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_ADD_FIELDCAT.
*&---------------------------------------------------------------------*
FORM f_add_fieldcat USING p_field p_text.

  gs_fieldcat-fieldname = p_field.
  gs_fieldcat-seltext_l = p_text.

  IF p_field = 'QTD_ALUNOS'.
    gs_fieldcat-hotspot = 'X'.
  ENDIF.

  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_EXIBE_ALV.
*&---------------------------------------------------------------------*
FORM f_exibe_alv.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      is_layout               = gs_layout
      it_fieldcat             = gt_fieldcat
      i_callback_user_command = 'USER_COMMAND'
    TABLES
      t_outtab                = gt_curso.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM F_EXIBE_ALV2.
*&---------------------------------------------------------------------*
FORM f_exibe_alv2.

  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout   = gs_layout
      it_fieldcat = gt_fieldcat2
    TABLES
      t_outtab    = gt_alunos.

ENDFORM.

*&---------------------------------------------------------------------*
*& FORM USER_COMMAND
*&---------------------------------------------------------------------*
FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.

  IF rs_selfield-fieldname = 'QTD_ALUNOS'.
    READ TABLE gt_curso INTO gs_curso INDEX rs_selfield-tabindex.

    IF sy-subrc EQ 0.
      CLEAR gt_alunos.

      SELECT a~nome
             a~cidade
        INTO TABLE gt_alunos
        FROM z6033_zaluno AS a
        INNER JOIN z6033_zmatricula AS m
          ON a~id_aluno EQ m~id_aluno
        WHERE m~id_curso EQ gs_curso-id_curso.

      PERFORM f_exibe_alv2.

    ENDIF.

    rs_selfield-refresh = 'X'.

  ENDIF.

ENDFORM.