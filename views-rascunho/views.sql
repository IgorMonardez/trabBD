-- Visão para mostrar o total arrecadado por streamer
CREATE VIEW total_arrecadado_streamer AS
SELECT s.nick, SUM(d.valor) AS total_arrecadado
FROM Streamer s
JOIN Doacao d ON s.nick = d.nick_usuario
GROUP BY s.nick;

-- Visão para listar os comentários recentes (últimos 7 dias)
CREATE VIEW comentarios_recentes AS
SELECT c.*
FROM Comentario c
WHERE c.dataH > NOW() - INTERVAL '7 days';

-- Visão materializada para armazenar o total arrecadado por streamer
CREATE MATERIALIZED VIEW total_arrecadado_streamer AS
SELECT s.nick, SUM(d.valor) AS total_arrecadado
FROM Streamer s
JOIN Doacao d ON s.nick = d.nick_usuario
GROUP BY s.nick;

-- Visão materializada para mostrar membros ativos por canal
CREATE MATERIALIZED VIEW membros_ativos_canal AS
SELECT c.nome, COUNT(i.nick_membro) AS total_membros
FROM Canal c
JOIN Inscricao i ON c.nome = i.nome_canal
GROUP BY c.nome;

-- Visão para mostrar visualizações totais por plataforma
CREATE VIEW visualizacoes_plataforma AS
SELECT p.nome, SUM(v.visu_total) AS total_visualizacoes
FROM Plataforma p
JOIN Canal c ON p.nro = c.nro_plataforma
JOIN Video v ON c.nome = v.nome_canal
GROUP BY p.nome;