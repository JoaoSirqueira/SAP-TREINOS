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
        NOME(35)   TYPE C,
      END OF T_FORNEC.

* Inserindo registros na tabela interna (APPEND)
* INÍCIO - Exemplo APPEND tabela interna COM HEADER LINE
T_FORNEC-CODFOR = 'FORN-0001'.
T_FORNEC-NOME = 'APPLE'.
APPEND T_FORNEC.

CLEAR T_FORNEC. " CLEAR Limpa somente a HEADER LINE
T_FORNEC-CODFOR = 'FORN-0002'.
T_FORNEC-NOME = 'SAMSUNG'.
APPEND T_FORNEC.
* FIM - Exemplo APPEND com tabela interna COM HEADER LINE

* INÍCIO - Exemplo APPEND tabela interna SEM HEADER LINE
W_MATERIAL-CODMAT = 'MAT-0001'.
W_MATERIAL-DESCRI = 'IPHONE 6'.
APPEND W_MATERIAL TO T_MATERIAL.

CLEAR W_MATERIAL.
W_MATERIAL-CODMAT = 'MAT-0002'.
W_MATERIAL-DESCRI = 'GALAXY 6'.
APPEND W_MATERIAL TO T_MATERIAL.
* FIM - Exemplo APPEND com tabela interna SEM HEADER LINE

* Utilizando o comando LOOP
* LOOP tabela interna COM HEADER LINE
LOOP AT T_FORNEC WHERE CODFOR = 'FORN-0001'.
  WRITE: / T_FORNEC-CODFOR, T_FORNEC-NOME, 'LOOP'.
ENDLOOP.

ULINE.
* LOOP tabela interna SEM HEADER LINE
LOOP AT T_MATERIAL INTO W_MATERIAL.
  WRITE: / W_MATERIAL-CODMAT, W_MATERIAL-DESCRI, 'LOOP'.
ENDLOOP.

ULINE.