-- Trigger to update qtd_user on INSERT
CREATE TRIGGER update_qtd_users_plataforma
AFTER INSERT ON PlataformaUsuario
FOR EACH ROW
BEGIN
    UPDATE Plataforma
    SET qtd_users = (
        SELECT COUNT(*)
        FROM PlataformaUsuario
        WHERE nro_plataforma = NEW.nro_plataforma
    )
    WHERE nro = NEW.nro_plataforma;
END;

-- Trigger to update qtd_users on DELETE
CREATE TRIGGER update_qtd_users_plataforma_delete
AFTER DELETE ON PlataformaUsuario
FOR EACH ROW
BEGIN
    UPDATE Plataforma
    SET qtd_users = (
        SELECT COUNT(*)
        FROM PlataformaUsuario
        WHERE nro_plataforma = OLD.nro_plataforma
    )
    WHERE nro = OLD.nro_plataforma;
END;