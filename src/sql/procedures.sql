-- Procedure 1
DROP FUNCTION IF EXISTS get_valor_by_nome(VARCHAR(255));

CREATE OR REPLACE FUNCTION get_valor_by_nome(empresa_nome VARCHAR(255) DEFAULT NULL)
RETURNS TABLE (CANAL_PATROCINADO VARCHAR(255), EMPRESA_PAGADORA VARCHAR(255), VALOR_PATROCINIO DECIMAL)
LANGUAGE SQL
AS $$
    SELECT patr.nome_canal, empr.nome, patr.valor
    FROM trabbd2.patrocinio patr
    INNER JOIN trabbd2.empresa empr on empr.nro = patr.nro_empresa
    WHERE empr.nome = empresa_nome OR empresa_nome IS NULL
    GROUP BY empr.nome, patr.nome_canal, patr.valor;
$$;

SELECT * FROM get_valor_by_nome('Powell, Johnson and Miller');
SELECT * FROM get_valor_by_nome();

-- Procedure 2
DROP FUNCTION IF EXISTS get_user_subscriptions(VARCHAR(255));

CREATE OR REPLACE FUNCTION get_user_subscriptions(p_nick_membro VARCHAR(255) DEFAULT NULL)
RETURNS TABLE (
    usuario VARCHAR(255),
    total_canais BIGINT,
    total_gasto DECIMAL(10, 2)
)
LANGUAGE SQL
AS $$
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
    WHERE
        p_nick_membro IS NULL OR i.nick_membro = p_nick_membro
    GROUP BY
        i.nick_membro;
$$;

SELECT * FROM get_user_subscriptions();
SELECT * FROM get_user_subscriptions('andrewfreeman');

-- Procedure 3
DROP FUNCTION IF EXISTS get_canal_doacoes(VARCHAR(255));

CREATE OR REPLACE FUNCTION get_canal_doacoes(p_nome_canal VARCHAR(255) DEFAULT NULL)
RETURNS TABLE (
    nome_canal VARCHAR(255),
    total_doacoes DECIMAL(10, 2)
)
LANGUAGE SQL
AS $$
    SELECT
        c.nome AS nome_canal,
        SUM(d.valor) AS total_doacoes
    FROM
        trabbd2.doacao d
    JOIN
        trabbd2.video v ON d.id_video = v.id_video
    JOIN
        trabbd2.canal c ON v.nome_canal = c.nome
    WHERE
        p_nome_canal IS NULL OR c.nome = p_nome_canal
    GROUP BY
        c.nome
    ORDER BY
        total_doacoes DESC;
$$;
SELECT * FROM get_canal_doacoes();
SELECT * FROM get_canal_doacoes('jamescasey_channel');

-- Procedure 4
DROP FUNCTION IF EXISTS get_video_doacoes(p_id_video INT);

CREATE OR REPLACE FUNCTION get_video_doacoes(p_id_video INT DEFAULT NULL)
RETURNS TABLE (
    id_video INT,
    total_doacoes DECIMAL(10, 2)
)
LANGUAGE SQL
AS $$
    SELECT
        d.id_video,
        SUM(d.valor) AS total_doacoes
    FROM
        trabbd2.doacao d
    JOIN
        trabbd2.comentario c ON d.id_video = c.id_video AND d.nick_usuario = c.nick_usuario AND d.seq_comentario = c.seq
    WHERE
        c.coment_on = TRUE AND
        (p_id_video IS NULL OR d.id_video = p_id_video)
    GROUP BY
        d.id_video
    ORDER BY
        total_doacoes DESC;
$$;
SELECT * FROM get_video_doacoes();
SELECT * FROM get_video_doacoes(4040);

-- Procedure 5
DROP FUNCTION IF EXISTS get_top_k_canais_patrocinio(INT);

CREATE OR REPLACE FUNCTION get_top_k_canais_patrocinio(k INT)
RETURNS TABLE (
    nome_canal VARCHAR(255),
    total_patrocinio DECIMAL(10, 2)
)
LANGUAGE sql
AS $$
    SELECT
        p.nome_canal,
        SUM(p.valor) AS total_patrocinio
    FROM
        trabbd2.patrocinio p
    GROUP BY
        p.nome_canal
    ORDER BY
        total_patrocinio DESC
    LIMIT k;
$$;

SELECT * FROM get_top_k_canais_patrocinio(10);

-- Procedure 6
DROP FUNCTION IF EXISTS get_top_k_canais_aportes(INT);

CREATE OR REPLACE FUNCTION get_top_k_canais_aportes(k INT)
RETURNS TABLE (
    nome_canal VARCHAR(255),
    total_aportes DECIMAL(10, 2)
)
LANGUAGE SQL
AS $$
    SELECT
        nc.nome_canal,
        SUM(nc.valor) AS total_aportes
    FROM
        trabbd2.inscricao i
    JOIN
        trabbd2.nivelcanal nc ON i.nome_canal = nc.nome_canal AND i.nivel = nc.nivel
    GROUP BY
        nc.nome_canal
    ORDER BY
        total_aportes DESC
    LIMIT k;
$$;

SELECT * FROM get_top_k_canais_aportes(10);

-- Procedure 7
DROP FUNCTION IF EXISTS get_top_k_canais_doacoes(INT);

CREATE OR REPLACE FUNCTION get_top_k_canais_doacoes(k INT)
RETURNS TABLE (
    nome_canal VARCHAR(255),
    total_doacoes DECIMAL(10, 2)
)
    LANGUAGE SQL
AS $$
    SELECT
        v.nome_canal,
        SUM(d.valor) AS total_doacoes
    FROM
        trabbd2.doacao d
    JOIN
        trabbd2.video v ON d.id_video = v.id_video
    GROUP BY
        v.nome_canal
    ORDER BY
        total_doacoes DESC
    LIMIT k;
$$;

SELECT * FROM get_top_k_canais_doacoes(10);

-- Procedure 8
DROP FUNCTION IF EXISTS get_top_k_canais_faturamento(INT);

CREATE OR REPLACE FUNCTION get_top_k_canais_faturamento(k INT)
RETURNS TABLE (
    nome_canal VARCHAR(255),
    total_faturamento DECIMAL(10, 2)
)
LANGUAGE sql
AS $$
    SELECT
        c.nome AS nome_canal,
        COALESCE(SUM(p.total_patrocinio), 0) +
        COALESCE(SUM(m.total_aportes), 0) +
        COALESCE(SUM(d.total_doacoes), 0) AS total_faturamento
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
        c.nome
    ORDER BY
        total_faturamento DESC
LIMIT k;
$$;

SELECT * FROM get_top_k_canais_faturamento(10);

-- procedure 9 para view materializada total_arrecadado_por_streamer_mat

DROP FUNCTION IF EXISTS refresh_top_canais_faturamento();

CREATE OR REPLACE FUNCTION refresh_top_canais_faturamento()
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    REFRESH MATERIALIZED VIEW top_canais_faturamento;
END;
$$;

