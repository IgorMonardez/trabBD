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
    u.nick AS usuario,
    COUNT(i.nome_canal) AS total_canais,
    SUM(nc.valor) AS total_gasto
FROM
    trabbd2.usuario u
JOIN
    inscricao i
ON
    i.nick_membro = u.nick
JOIN
    trabbd2.nivelcanal nc
ON
    i.nome_canal = nc.nome_canal AND i.nivel = nc.nivel
GROUP BY
    u.nick;


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

drop materialized view top_canais;

CREATE MATERIALIZED VIEW top_canais AS
SELECT
    c.nome AS nome_canal,
    p.qtd_patrocinio,
    COALESCE(SUM(p.total_patrocinio), 0) as total_patrocinio,
    m.qtd_aportes,
    COALESCE(SUM(m.total_aportes), 0) as total_aportes,
    d.qtd_doacoes,
    COALESCE(SUM(d.total_doacoes), 0) as total_doacoes,
    total_patrocinio + total_aportes + total_doacoes AS total_faturamento
FROM
    trabbd2.canal c
LEFT JOIN (
    SELECT
    p.nome_canal,
    COUNT(p.valor) AS qtd_patrocinio,
    SUM(p.valor) AS total_patrocinio
    FROM
        trabbd2.patrocinio p
    GROUP BY
        p.nome_canal
    ) p ON c.nome = p.nome_canal
LEFT JOIN (
    SELECT
        nc.nome_canal,
        COUNT(nc.valor) AS qtd_aportes,
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
        COUNT(d.valor) AS qtd_doacoes,
        SUM(d.valor) AS total_doacoes
    FROM
        trabbd2.doacao d
    JOIN
        trabbd2.video v ON d.id_video = v.id_video
    GROUP BY
        v.nome_canal
    ) d ON c.nome = d.nome_canal
GROUP BY
    c.nome, p.qtd_patrocinio, c.nome, m.qtd_aportes, d.qtd_doacoes, total_patrocinio + total_aportes + total_doacoes;


-- Trigger para top_canais
CREATE OR REPLACE FUNCTION refresh_top_canais()
RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW top_canais;
    RETURN NULL;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER refresh_top_canais_dml_patr
AFTER INSERT OR UPDATE OR DELETE ON Patrocinio
FOR EACH ROW EXECUTE FUNCTION refresh_top_canais();

CREATE TRIGGER refresh_top_canais_dml_inscr
AFTER INSERT OR UPDATE OR DELETE ON Inscricao
FOR EACH ROW EXECUTE FUNCTION refresh_top_canais();

CREATE TRIGGER refresh_top_canais_dml_doac
AFTER INSERT OR UPDATE OR DELETE ON Doacao
FOR EACH ROW EXECUTE FUNCTION refresh_top_canais();