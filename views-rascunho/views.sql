-- View para mostrar os canais patrocinados e os valores de patrocínio por empresa

CREATE OR REPLACE VIEW canais_patrocinados AS
SELECT
    patr.nome_canal,
    empr.nome AS empresa_pagadora,
    patr.valor AS valor_patrocinio
FROM
    Patrocinio patr
INNER JOIN
    Empresa empr ON empr.nro = patr.nro_empresa;


-- View para mostrar a quantidade de canais que cada usuário é membro e o valor desembolsado

CREATE OR REPLACE VIEW user_subscriptions AS
SELECT
    i.nick_membro AS usuario,
    COUNT(i.nome_canal) AS total_canais,
    SUM(nc.valor) AS total_gasto
FROM
    trabbd2.inscricao i
JOIN
    trabbd2.nivelcanal nc
    ON
    i.nome_canal = nc.nome_canal AND i.nivel = nc.nivel
GROUP BY
    i.nick_membro;


-- View para listar os videos e a soma dos valores de doações recebidas

CREATE OR REPLACE VIEW video_doacoes AS
SELECT
    v.id_video AS id_video,
    SUM(d.valor) AS total_doacoes
FROM
    trabbd2.doacao d
JOIN
    trabbd2.video v ON d.id_video = v.id_video
JOIN
    trabbd2.comentario c ON d.id_video = c.id_video AND d.nick_usuario = c.nick_usuario AND d.seq_comentario = c.seq
WHERE c.coment_on = TRUE
GROUP BY
    v.id_video
ORDER BY
    total_doacoes DESC;



-- View para mostrar os maiores valores por canal

CREATE MATERIALIZED VIEW top_canais AS
SELECT
    c.nome AS nome_canal,
    COALESCE(SUM(p.total_patrocinio), 0) as total_patrocinio,
    COALESCE(SUM(m.total_aportes), 0) as total_aportes,
    COALESCE(SUM(d.total_doacoes), 0) as total_doacoes,
    total_patrocinio + total_aportes + total_doacoes AS total_faturamento
FROM
    trabbd2.canal c
LEFT JOIN (
    SELECT
    p.nome_canal,
    SUM(p.valor) AS total_patrocinio
    FROM
        trabbd2.patrocinio p
    GROUP BY
        p.nome_canal
    ) p ON c.nome = p.nome_canal
LEFT JOIN (
    SELECT
        nc.nome_canal,
        SUM(nc.valor) AS total_aportes
    FROM
        trabbd2.inscricao i
    JOIN
        trabbd2.nivelcanal nc ON i.nome_canal = nc.nome_canal AND i.nivel = nc.nivel
    GROUP BY
        nc.nome_canal
    ) m ON c.nome = m.nome_canal
LEFT JOIN (
    SELECT
        v.nome_canal,
        SUM(d.valor) AS total_doacoes
    FROM
        trabbd2.doacao d
    JOIN
        trabbd2.video v ON d.id_video = v.id_video
    GROUP BY
        v.nome_canal
    ) d ON c.nome = d.nome_canal
GROUP BY
    c.nome, p.total_patrocinio, m.total_aportes, d.total_doacoes;


-- Fazer hash em cima de nomes para indices,