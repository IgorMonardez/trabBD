-- Trigger para inserção em Doacao
CREATE TRIGGER refresh_total_arrecadado_insert
AFTER INSERT ON Doacao
FOR EACH STATEMENT
EXECUTE FUNCTION trigger_refresh_total_arrecadado();

-- Trigger para inserção em Inscricao
CREATE TRIGGER refresh_membros_ativos_insert
AFTER INSERT ON Inscricao
FOR EACH STATEMENT
EXECUTE FUNCTION trigger_refresh_membros_ativos();

-- Trigger para deleção em Inscricao
CREATE TRIGGER refresh_membros_ativos_delete
AFTER DELETE ON Inscricao
FOR EACH STATEMENT
EXECUTE FUNCTION trigger_refresh_membros_ativos();