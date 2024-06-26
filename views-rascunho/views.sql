-- View para mostrar os canais patrocinados e os valores de patrocínio por empresa

CREATE OR REPLACE VIEW canais_patrocinados AS
SELECT
    patr.nome_canal,
    empr.nome AS empresa_pagadora,
    patr.valor AS valor_patrocinio
FROM
    Patrocionio patr
INNER JOIN
    Empresa empr ON empr.nro = patr.nro_empresa;


-- View para mostrar a quantidade de canais que cada usuário é membro e o valor desembolsado

CREATE OR REPLACE VIEW user_subscriptions AS
SELECT
    i.nick_membro AS usuario,
    COUNT(i.nome_canal) AS total_canais,
    SUM(nc.valor) AS total_gasto
FROM
    Inscrição i
JOIN
    NivelCanal nc ON i.nome_canal = nc.nome_canal AND i.nivel = nc.nivel
GROUP BY
    i.nick_membro;


-- View para listar os canais e a soma dos valores de doações recebidas

CREATE OR REPLACE VIEW canal_doacoes AS
SELECT
    c.nome AS nome_canal,
    SUM(d.valor) AS total_doacoes
FROM
    Doacao d
JOIN
    Video v ON d.nome_canal = v.nome_canal AND d.titulo_video = v.titulo AND d.dataH_video = v.dataH
JOIN
    Canal c ON v.nome_canal = c.nome
GROUP BY
    c.nome;



-- View para mostrar os valores de patrocínio por canal

CREATE OR REPLACE VIEW top_canais_patrocinio AS
SELECT
    p.nome_canal,
    SUM(p.valor) AS total_patrocinio
FROM
    Patrocionio p
GROUP BY
    p.nome_canal
ORDER BY
    total_patrocinio DESC;


-- View materializada para mostrar o faturamento total por canal

CREATE MATERIALIZED VIEW top_canais_faturamento AS
SELECT
    c.nome AS nome_canal,
    COALESCE(p.total_patrocinio, 0) +
    COALESCE(m.total_aportes, 0) +
    COALESCE(d.total_doacoes, 0) AS total_faturamento
FROM
    Canal c
LEFT JOIN (
    SELECT
        p.nome_canal,
        SUM(p.valor) AS total_patrocinio
    FROM
        Patrocionio p
    GROUP BY
        p.nome_canal
) p ON c.nome = p.nome_canal
LEFT JOIN (
    SELECT
        nc.nome_canal,
        SUM(nc.valor) AS total_aportes
    FROM
        Inscrição i
    JOIN
        NivelCanal nc ON i.nome_canal = nc.nome_canal AND i.nivel = nc.nivel
    GROUP BY
        nc.nome_canal
) m ON c.nome = m.nome_canal
LEFT JOIN (
    SELECT
        v.nome_canal,
        SUM(d.valor) AS total_doacoes
    FROM
        Doacao d
    JOIN
        Video v ON d.nome_canal = v.nome_canal AND d.titulo_video = v.titulo AND d.dataH_video = v.dataH
    GROUP BY
        v.nome_canal
) d ON c.nome = d.nome_canal
GROUP BY
    c.nome
ORDER BY
    total_faturamento DESC;
