-- Procedure 1
DROP FUNCTION IF EXISTS get_valor_by_nome(VARCHAR(255));

CREATE OR REPLACE FUNCTION get_valor_by_nome(empresa_nome VARCHAR(255) DEFAULT NULL)
RETURNS TABLE (nome_canal VARCHAR(255), nome_empresa VARCHAR(255), valor DECIMAL)
LANGUAGE plpgsql
AS $$
BEGIN
    IF empresa_nome IS NULL THEN
        RETURN QUERY EXECUTE 'SELECT patr.nome_canal as CANAL, empr.nome as EMPRESA, patr.valor as VALOR
                              FROM trabbd2.patrocinio patr
                              INNER JOIN trabbd2.empresa empr on empr.nro = patr.nro_empresa
                              GROUP BY empr.nome, patr.nome_canal, patr.valor';
    ELSE
        RETURN QUERY EXECUTE 'SELECT patr.nome_canal as CANAL, empr.nome as EMPRESA, patr.valor as VALOR
                              FROM trabbd2.patrocinio patr
                              INNER JOIN trabbd2.empresa empr on empr.nro = patr.nro_empresa
                              WHERE empr.nome = $1
                              GROUP BY empr.nome, patr.nome_canal, patr.valor' USING empresa_nome;
    END IF;
END; $$;

SELECT * FROM get_valor_by_nome('Miller-Lowe');
SELECT * FROM get_valor_by_nome();

-- Procedure 2
DROP FUNCTION IF EXISTS get_user_subscriptions(VARCHAR(255));

CREATE OR REPLACE FUNCTION get_user_subscriptions(p_nick_membro VARCHAR(255) DEFAULT NULL)
RETURNS TABLE (
    usuario VARCHAR(255),
    total_canais BIGINT,
    total_gasto DECIMAL(10, 2)
) AS $$
BEGIN
    RETURN QUERY
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
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_user_subscriptions();
SELECT * FROM get_user_subscriptions('shannon48');

-- Procedure 3
DROP FUNCTION IF EXISTS get_user_subscriptions(VARCHAR(255), VARCHAR(255));

CREATE OR REPLACE FUNCTION get_canal_doacoes(p_nome_canal VARCHAR(255) DEFAULT NULL)
RETURNS TABLE (
    nome_canal VARCHAR(255),
    total_doacoes DECIMAL(10, 2)
) AS $$
BEGIN
    RETURN QUERY
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
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_canal_doacoes();
SELECT * FROM get_canal_doacoes('amber08_channel');

-- Procedure 4
DROP FUNCTION IF EXISTS get_user_subscriptions(VARCHAR(255), VARCHAR(255));

CREATE OR REPLACE FUNCTION get_video_doacoes(p_id_video INT DEFAULT NULL)
RETURNS TABLE (
    id_video INT,
    total_doacoes DECIMAL(10, 2)
) AS $$
BEGIN
    RETURN QUERY
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
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_video_doacoes();
SELECT * FROM get_video_doacoes(4040);