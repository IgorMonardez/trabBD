-- Procedure 1
DROP FUNCTION IF EXISTS get_valor_by_nome(VARCHAR(255));

CREATE OR REPLACE FUNCTION get_valor_by_nome(empresa_nome VARCHAR(255) DEFAULT NULL)
RETURNS TABLE (CANAL_PATROCINADO VARCHAR(255), EMPRESA_PAGADORA VARCHAR(255), VALOR_PATROCINIO DECIMAL)
LANGUAGE SQL
AS $$
SELECT
    nome_canal, empresa_pagadora, valor_patrocinio
FROM
    trabbd2.canais_patrocinados
WHERE
    empresa_pagadora = empresa_nome OR empresa_nome IS NULL
ORDER BY valor_patrocinio DESC;
$$;

SELECT * FROM get_valor_by_nome('Green, Bass and Hernandez');
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
        usuario,
        total_canais,
        total_gasto
    FROM
        trabbd2.user_subscriptions
    WHERE
        p_nick_membro IS NULL OR usuario = p_nick_membro;
$$;

SELECT * FROM get_user_subscriptions();
SELECT * FROM get_user_subscriptions('adamsingleton');

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
        nome_canal,
        total_doacoes
    FROM
        trabbd2.top_canais
    WHERE
        p_nome_canal IS NULL OR nome_canal = p_nome_canal
    ORDER BY
        total_doacoes DESC;
$$;
SELECT * FROM get_canal_doacoes();
SELECT * FROM get_canal_doacoes('marialynn_channel');

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
        id_video,
        total_doacoes
    FROM
        trabbd2.video_doacoes
    WHERE
        (p_id_video IS NULL OR id_video = p_id_video)
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
        nome_canal,
        total_patrocinio
    FROM
        trabbd2.top_canais
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
        nome_canal,
        total_aportes
    FROM
        trabbd2.top_canais
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
        nome_canal,
        total_doacoes
    FROM
        trabbd2.top_canais
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
        nome_canal,
        total_faturamento
    FROM
        trabbd2.top_canais
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

