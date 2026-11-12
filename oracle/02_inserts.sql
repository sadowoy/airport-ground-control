-- 1. Inserindo Modelos de Aeronave
INSERT INTO modelo_aeronave (fabricante, nome, mtow_kg) VALUES ('Boeing', '737-800', 79015.00);
INSERT INTO modelo_aeronave (fabricante, nome, mtow_kg) VALUES ('Airbus', 'A320neo', 79000.00);

-- 2. Inserindo Aeronaves
INSERT INTO aeronave (modelo_id, prefixo, ano_fabricacao) VALUES (1, 'PR-GOL', 2015);
INSERT INTO aeronave (modelo_id, prefixo, ano_fabricacao) VALUES (2, 'PR-LAT', 2018);

-- 3. Inserindo Pistas
INSERT INTO pista (numero_identificacao, tamanho_metros, status) VALUES ('09R/27L', 3200, 'OPERANTE');
INSERT INTO pista (numero_identificacao, tamanho_metros, status) VALUES ('09L/27R', 1500, 'OPERANTE');

-- 4. Inserindo Tripulantes
INSERT INTO tripulante (matricula, nome, cargo) VALUES ('TRP001', 'Comandante Silva', 'Piloto');
INSERT INTO tripulante (matricula, nome, cargo) VALUES ('TRP002', 'Comissaria Souza', 'Chefe de Cabine');

-- 5. Inserindo Voos
-- Voo normal agendado para amanha (Oracle soma dias inteiros com + 1)
INSERT INTO voo (aeronave_id, pista_id, data_hora_prevista, peso_total_kg, status) VALUES (1, 1, SYSTIMESTAMP + 1, 70000.00, 'AGENDADO');
-- DADO DE FRONTEIRA: Voo exatamente no peso maximo da aeronave 2 (MTOW 79000)
INSERT INTO voo (aeronave_id, pista_id, data_hora_prevista, peso_total_kg, status) VALUES (2, 2, SYSTIMESTAMP + 2, 79000.00, 'AGENDADO');

-- 6. Inserindo Escala de Voo
INSERT INTO escala_voo (voo_id, tripulante_id, funcao_exercida, horas_computadas) VALUES (1, 1, 'Piloto em Comando', 4.5);
INSERT INTO escala_voo (voo_id, tripulante_id, funcao_exercida, horas_computadas) VALUES (1, 2, 'Chefe de Cabine', 4.5);

-- 7. Inserindo Ordens de Manutencao
INSERT INTO ordem_manutencao (aeronave_id, nivel_severidade, status, data_abertura) VALUES (1, 3, 'CONCLUIDA', TRUNC(SYSDATE) - 10);
-- DADO DE FRONTEIRA: Manutencao de Severidade 1 (Critica) aberta hoje para a Aeronave 2
INSERT INTO ordem_manutencao (aeronave_id, nivel_severidade, status, data_abertura) VALUES (2, 1, 'ABERTA', TRUNC(SYSDATE));