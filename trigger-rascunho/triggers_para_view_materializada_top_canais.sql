-- Função para atualizar a view materializada top_canais

CREATE OR REPLACE FUNCTION refresh_top_canais()
RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW top_canais;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Insert Patrocinio
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_insert_patrocinio
AFTER INSERT ON trabbd2.patrocinio
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- UPDATE patrocinio
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_update_patrocinio
AFTER UPDATE ON trabbd2.patrocinio
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- DELETE patrocinio
CREATE OR REPLACE  TRIGGER trigger_refresh_top_canais_delete_patrocinio
AFTER DELETE ON trabbd2.patrocinio
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- INSERT inscricao
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_insert_inscricao
AFTER INSERT ON trabbd2.inscricao
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- UPDATE inscricao
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_update_inscricao
AFTER UPDATE ON trabbd2.inscricao
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- DELETE inscricao
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_delete_inscricao
AFTER DELETE ON trabbd2.inscricao
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- INSERT nivelcanal
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_insert_nivelcanal
AFTER INSERT ON trabbd2.nivelcanal
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- UPDATE nivelcanal
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_update_nivelcanal
AFTER UPDATE ON trabbd2.nivelcanal
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- DELETE  nivelcanal
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_delete_nivelcanal
AFTER DELETE ON trabbd2.nivelcanal
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- INSERT  doacao
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_insert_doacao
AFTER INSERT ON trabbd2.doacao
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- UPDATE doacao
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_update_doacao
AFTER UPDATE ON trabbd2.doacao
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- DELETE doacao
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_delete_doacao
AFTER DELETE ON trabbd2.doacao
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- INSERT video
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_insert_video
AFTER INSERT ON trabbd2.video
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- UPDATE video
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_update_video
AFTER UPDATE ON trabbd2.video
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();

-- DELETE video
CREATE OR REPLACE TRIGGER trigger_refresh_top_canais_delete_video
AFTER DELETE ON trabbd2.video
FOR EACH ROW
EXECUTE FUNCTION refresh_top_canais();