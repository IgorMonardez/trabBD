-- Trigger to update qtd_visualizacoes to CANAL on INSERT
CREATE TRIGGER update_qtd_visualizacoes
AFTER INSERT ON Video
FOR EACH ROW
BEGIN
    UPDATE Canal
    SET qtd_visualizacoes = (
        SELECT SUM(visu_total)
        FROM Video
        WHERE nome_canal = NEW.nome_canal
    )
    WHERE nome = NEW.nome_canal;
END;

-- Precisa do trigger on delete? - faz sentido ter sim