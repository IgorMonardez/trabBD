CREATE OR REPLACE FUNCTION refresh_top_canais()
RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW top_canais;
    RETURN NULL;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER refresh_top_canais_after_insert_or_update_or_delete
AFTER INSERT OR UPDATE OR DELETE ON Patrocinio
FOR EACH ROW EXECUTE FUNCTION refresh_top_canais();

CREATE TRIGGER refresh_top_canais_after_insert_or_update_or_delete
AFTER INSERT OR UPDATE OR DELETE ON Inscricao
FOR EACH ROW EXECUTE FUNCTION refresh_top_canais();

CREATE TRIGGER refresh_top_canais_after_insert_or_update_or_delete
AFTER INSERT OR UPDATE OR DELETE ON Doacao
FOR EACH ROW EXECUTE FUNCTION refresh_top_canais();