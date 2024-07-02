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