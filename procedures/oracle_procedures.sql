-- PROCEDURE 1: Registrar Manutencao
CREATE OR REPLACE PROCEDURE registrar_manutencao(p_aeronave IN NUMBER, p_severidade IN NUMBER) IS
BEGIN
    INSERT INTO ordem_manutencao (aeronave_id, nivel_severidade, status, data_abertura)
    VALUES (p_aeronave, p_severidade, 'ABERTA', TRUNC(SYSDATE));

    IF p_severidade = 1 THEN
        UPDATE voo 
        SET status = 'CANCELADO' 
        WHERE aeronave_id = p_aeronave AND status = 'AGENDADO';
    END IF;
END;
/

-- PROCEDURE 2: Cancelar Voo
CREATE OR REPLACE PROCEDURE cancelar_voo(p_voo_id IN NUMBER) IS
    v_status VARCHAR2(20);
BEGIN
    BEGIN
        SELECT status INTO v_status FROM voo WHERE voo_id = p_voo_id FOR UPDATE;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'AER-003: Voo ' || p_voo_id || ' inexistente');
    END;
    
    IF v_status = 'CONCLUIDO' THEN
        RAISE_APPLICATION_ERROR(-20004, 'AER-004: Voo ja concluido nao pode ser cancelado');
    END IF;

    UPDATE voo SET status = 'CANCELADO' WHERE voo_id = p_voo_id;
    DELETE FROM escala_voo WHERE voo_id = p_voo_id;
END;
/

-- TRIGGER: Validação de Peso (MTOW)
CREATE OR REPLACE TRIGGER trg_valida_peso_voo
BEFORE INSERT OR UPDATE ON voo
FOR EACH ROW
DECLARE
    v_mtow NUMBER(10,2);
BEGIN
    SELECT m.mtow_kg INTO v_mtow
    FROM aeronave a
    JOIN modelo_aeronave m ON a.modelo_id = m.modelo_id
    WHERE a.aeronave_id = :NEW.aeronave_id;

    IF :NEW.peso_total_kg > v_mtow THEN
        RAISE_APPLICATION_ERROR(-20002, 'AER-002: Peso (' || :NEW.peso_total_kg || ') excede o MTOW (' || v_mtow || ')');
    END IF;
END;
/