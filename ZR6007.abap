*&---------------------------------------------------------------------*
*& Report ZR6007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6007.

* Declaração de tipos
TYPES: BEGIN OF TY_MATERIAL,
  CODMAT(10) TYPE C,
  DESCRI(35) TYPE C,
END OF TY_MATERIAL.

* Declaração de estrutura (work area)
* Nesse exemplo estamos declarando 2 estruturas, porém de maneira diferente
DATA W_MATERIAL TYPE TY_MATERIAL.

DATA: BEGIN OF W_CLIENTE,
  CODCLI(10) TYPE C,
  NOME(35)   TYPE C,
END OF W_CLIENTE.

* Declarando tabela interna
* Nesse exemplo estamos declarando 2 tabelas, porém de maneira diferente
DATA T_MATERIAL TYPE TABLE OF TY_MATERIAL. " RECOMENDADO

DATA: BEGIN OF T_FORNEC OCCURS 0,
  CODFOR(10) TYPE C,
  NOME(35)    TYPE C,
END OF T_FORNEC.