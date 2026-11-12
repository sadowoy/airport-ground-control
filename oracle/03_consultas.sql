-- Q01 (Agregacao + JOIN): Total de horas voadas por cada tripulante (apenas os que tem horas)
SELECT t.nome, SUM(e.horas_computadas) AS total_horas
FROM tripulante t
JOIN escala_voo e ON t.tripulante_id = e.tripulante_id
GROUP BY t.nome
ORDER BY total_horas DESC;

-- Q02 (Agregacao + JOIN + HAVING): Modelos de aeronaves com peso maximo de decolagem (MTOW) superior a 75.000 kg, com a contagem de voos agendados
SELECT m.nome, COUNT(v.voo_id) AS qtd_voos_agendados
FROM modelo_aeronave m
JOIN aeronave a ON m.modelo_id = a.modelo_id
JOIN voo v ON a.aeronave_id = v.aeronave_id
WHERE v.status = 'AGENDADO'
GROUP BY m.nome
HAVING m.mtow_kg > 75000;

-- Q03 (Window Function - RANK): Ranking das pistas mais utilizadas para voos (pistas com o mesmo numero de voos recebem a mesma posicao)
SELECT p.numero_identificacao, COUNT(v.voo_id) AS total_voos,
       RANK() OVER (ORDER BY COUNT(v.voo_id) DESC) AS posicao_uso
FROM pista p
LEFT JOIN voo v ON p.pista_id = v.pista_id
GROUP BY p.numero_identificacao;

-- Q04 (Window Function - ROW_NUMBER): Lista dos 5 voos mais pesados (ordem estrita, sem empates na posicao)
SELECT v.voo_id, a.prefixo, v.peso_total_kg,
       ROW_NUMBER() OVER (ORDER BY v.peso_total_kg DESC) AS linha
FROM voo v
JOIN aeronave a ON v.aeronave_id = a.aeronave_id
FETCH FIRST 5 ROWS ONLY;

-- Q05 (Anti-join com NOT EXISTS): Aeronaves que nunca tiveram uma ordem de manutencao registada
SELECT a.prefixo
FROM aeronave a
WHERE NOT EXISTS (
    SELECT 1 
    FROM ordem_manutencao o 
    WHERE o.aeronave_id = a.aeronave_id
);

-- Q06 (Agregacao + ROLLUP): Relatorio de voos por pista e status, incluindo subtotais por pista e o total geral
SELECT p.numero_identificacao, v.status, COUNT(v.voo_id) AS total_voos
FROM pista p
JOIN voo v ON p.pista_id = v.pista_id
GROUP BY ROLLUP(p.numero_identificacao, v.status);

-- Q07 (Subconsulta correlacionada): Aeronaves cujo peso do voo agendado atingiu 100% da capacidade (MTOW) do seu modelo
SELECT a.prefixo, v.peso_total_kg
FROM aeronave a
JOIN voo v ON a.aeronave_id = v.aeronave_id
WHERE v.peso_total_kg = (
    SELECT m.mtow_kg 
    FROM modelo_aeronave m 
    WHERE m.modelo_id = a.modelo_id
);

-- Q08 (Agregacao simples): Numero de ordens de manutencao por nivel de severidade (1 a 5)
SELECT nivel_severidade, COUNT(ordem_id) AS total_ordens
FROM ordem_manutencao
GROUP BY nivel_severidade
ORDER BY nivel_severidade ASC;

-- Q09 (JOIN complexo): Lista de tripulantes escalados para voos em pistas com mais de 2000 metros
SELECT DISTINCT t.nome, t.cargo
FROM tripulante t
JOIN escala_voo e ON t.tripulante_id = e.tripulante_id
JOIN voo v ON e.voo_id = v.voo_id
JOIN pista p ON v.pista_id = p.pista_id
WHERE p.tamanho_metros > 2000;

-- Q10 (Window Function - SUM OVER): Soma acumulada de horas de voo por tripulante, ordenada pelo identificador do voo
SELECT t.nome, e.voo_id, e.horas_computadas,
       SUM(e.horas_computadas) OVER (PARTITION BY t.tripulante_id ORDER BY e.voo_id) AS horas_acumuladas
FROM tripulante t
JOIN escala_voo e ON t.tripulante_id = e.tripulante_id;