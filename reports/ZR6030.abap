*&---------------------------------------------------------------------*
*& Report ZR6030
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr6030.

* Declarando tabela para o select-options
TABLES: z6030aula_curso.

" Selection-Screen: contorno na variável de entrada
SELECTION-SCREEN BEGIN OF BLOCK b11 WITH FRAME TITLE TEXT-001." Parâmetro de entrada
* Parâmetro
  SELECT-OPTIONS: so_curso FOR z6030aula_curso-nome_curso NO INTERVALS.
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



ENDFORM.