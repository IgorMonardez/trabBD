-- View para mostrar o total arrecadado por streamer
CREATE OR REPLACE VIEW total_arrecadado_por_streamer AS
SELECT u.nick AS streamer_nick,
       SUM(d.valor) AS total_arrecadado
FROM Usuario u
JOIN Doacao d ON u.nick = d.nick_usuario
GROUP BY u.nick;


-- View para listar os comentários recentes (últimos 7 dias)
CREATE OR REPLACE VIEW comentarios_recentes AS
SELECT c.*
FROM Comentario c
WHERE c.dataH > NOW() - INTERVAL '7 days';


-- View materializada para armazenar o total arrecadado por streamer
CREATE MATERIALIZED VIEW total_arrecadado_por_streamer_mat AS
SELECT u.nick AS streamer_nick,
       SUM(d.valor) AS total_arrecadado
FROM Usuario u
JOIN Doacao d ON u.nick = d.nick_usuario
GROUP BY u.nick;


-- View materializada para mostrar membros ativos por canal
CREATE MATERIALIZED VIEW membros_ativos_por_canal AS
SELECT c.nome AS canal_nome,
       COUNT(i.nick_membro) AS total_membros
FROM Canal c
JOIN Inscricao i ON c.nome = i.nome_canal
GROUP BY c.nome;


-- View para mostrar visualizações totais por plataforma
CREATE OR REPLACE VIEW visualizacoes_por_plataforma AS
SELECT p.nome AS plataforma_nome,
       c.nome AS canal_nome,
       SUM(v.visu_total) AS total_visualizacoes
FROM Plataforma p
JOIN Canal c ON p.nro = c.nro_plataforma
JOIN Video v ON c.nome = v.nome_canal
GROUP BY p.nome, c.nome;