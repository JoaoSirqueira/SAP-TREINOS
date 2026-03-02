*&---------------------------------------------------------------------*
*& Report ZR6008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR6008.

* Tabelas transparentes
TABLES ZT6001. "Tabela tipo de material

* Tela de seleção
PARAMETERS: P_TPMAT  LIKE ZT6001-TPMAT OBLIGATORY,
            P_DENOM  LIKE ZT6001-DENOM OBLIGATORY,
            P_INSERT RADIOBUTTON GROUP GR1,
            P_UPDATE RADIOBUTTON GROUP GR1,
            P_MODIFY RADIOBUTTON GROUP GR1,
            P_DELETE RADIOBUTTON GROUP GR1.

* Exemplo comando INSERT
IF P_INSERT = 'X'.
  CLEAR ZT6001. " Boa prática, ter certeza que não tem nenhuma sujeira na memória
  ZT6001-TPMAT = P_TPMAT.
  ZT6001-DENOM = P_DENOM.
  INSERT ZT6001.

* ROTINA DE VERIFICAÇÃO
  IF SY-SUBRC = 0.
    COMMIT WORK. " COMMIT WORK confirma a gravação no banco de dados
    MESSAGE 'Registro cadastrado com sucesso!' TYPE 'S'.
  ELSE.
    ROLLBACK WORK. " ROLLBACK WORK desfazer o cadastro.
    MESSAGE 'Erro no cadastro.' TYPE 'I'.
  ENDIF.

* Exemplo comando UPDATE
ELSEIF P_UPDATE = 'X'.
  UPDATE ZT6001
    SET DENOM = P_DENOM
  WHERE TPMAT = P_TPMAT.

* ROTINA DE VERIFICAÇÃO
  IF SY-SUBRC = 0.
    COMMIT WORK. " COMMIT WORK confirma a gravação no banco de dados
    MESSAGE 'Registro atualizado com sucesso!' TYPE 'S'.
  ELSE.
    ROLLBACK WORK. " ROLLBACK WORK desfazer o cadastro.
    MESSAGE 'Erro na atualização.' TYPE 'I'.
  ENDIF.

* Exemplo comando MODIFY
ELSEIF P_MODIFY = 'X'.
  CLEAR ZT6001.
  ZT6001-TPMAT = P_TPMAT.
  ZT6001-DENOM = P_DENOM.
  MODIFY ZT6001.

* ROTINA DE VERIFICAÇÃO
  IF SY-SUBRC = 0.
    COMMIT WORK. " COMMIT WORK confirma a gravação no banco de dados
    MESSAGE 'Processo realizado com sucesso!' TYPE 'S'.
  ELSE.
    ROLLBACK WORK. " ROLLBACK WORK desfazer o cadastro.
    MESSAGE 'Erro no processo.' TYPE 'I'.
  ENDIF.

* Exemplo comando DELETE
ELSEIF P_DELETE = 'X'.
  DELETE FROM ZT6001 WHERE TPMAT = P_TPMAT.

* ROTINA DE VERIFICAÇÃO
  IF SY-SUBRC = 0.
    COMMIT WORK. " COMMIT WORK confirma a gravação no banco de dados
    MESSAGE 'Registro eliminado com sucesso!' TYPE 'S'.
  ELSE.
    ROLLBACK WORK. " ROLLBACK WORK desfazer o cadastro.
    MESSAGE 'Erro ao eliminar.' TYPE 'I'.
  ENDIF.

ENDIF.