SET search_path TO trabBD2;

-- Inserindo registros na tabela Empresa
INSERT INTO Empresa (nome, nome_fantasia) VALUES
    ('Alphabet Inc.', 'Google'),
    ('Amazon.com, Inc.', 'Amazon'),
    ('Meta Platforms, Inc.', 'Facebook');

-- Inserindo registros na tabela Plataforma
INSERT INTO Plataforma (nome, qtd_users, empresa_fund, empresa_respo, data_fund) VALUES
    ('YouTube', 0, 1, 1, '2005-02-14'),
    ('Twitch', 0, 2, 2, '2011-06-06'),
    ('Facebook', 0, 3, 3, '2004-02-04');

-- Inserindo registros na tabela Conversao
INSERT INTO Conversao (moeda, nome, fator_conver) VALUES
    ('BRL', 'Real brasileiro', 5.1400),
    ('ARS', 'Peso argentino', 0.0011),
    ('UYU', 'Peso uruguaio', 0.0260),
    ('USD', 'Dólar americano', 1.0000);

-- Inserindo registros na tabela Pais
INSERT INTO Pais (nome, moeda) VALUES
    ('Brasil', 'BRL'),
    ('Argentina', 'ARS'),
    ('Uruguai', 'UYU'),
    ('Estados Unidos', 'USD');

-- Inserindo registros na tabela EmpresaPais
INSERT INTO EmpresaPais (nro_empresa, ddi_pais, id_nacional) VALUES
    (1, 1, '06.947.284/0001-04'),
    (2, 1, '15.436.940/0020-68'),
    (3, 1, '13.347.016/0001-17');