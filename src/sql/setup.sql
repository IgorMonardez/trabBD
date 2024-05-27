CREATE SCHEMA trabBD2;

SET search_path TO trabBD2;

-- Cria a tabela Empresa
CREATE TABLE Empresa (
    nro SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255) NOT NULL
);

-- Cria a tabela Plataforma
CREATE TABLE Plataforma (
    nro SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    qtd_users INT NOT NULL, -- ATRIBUTO DERIVADO
    empresa_fund INT,
    empresa_respo INT,
    data_fund DATE,
    FOREIGN KEY (empresa_fund) REFERENCES Empresa(nro),
    FOREIGN KEY (empresa_respo) REFERENCES Empresa(nro)
);

-- Cria a tabela Conversao
CREATE TABLE Conversao (
    moeda VARCHAR(3) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    fator_conver DECIMAL(10, 4) NOT NULL
);

-- Cria a tabela País
CREATE TABLE Pais (
    DDI SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    moeda VARCHAR(3),
    FOREIGN KEY (moeda) REFERENCES Conversao(moeda)
);

-- Cria a tabela Usuário
CREATE TABLE Usuario (
    nick VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    data_nasc DATE NOT NULL,
    telefone VARCHAR(20),
    end_postal VARCHAR(255),
    pais_residencia INT,
    FOREIGN KEY (pais_residencia) REFERENCES Pais(DDI)
);

-- Cria a tabela PlataformaUsuario
CREATE TABLE PlataformaUsuario (
    nro_plataforma INT,
    nick_usuario VARCHAR(255),
    FOREIGN KEY (nro_plataforma) REFERENCES Plataforma(nro),
    FOREIGN KEY (nick_usuario) REFERENCES Usuario(nick),
    PRIMARY KEY (nro_plataforma, nick_usuario)
);

-- Criando a função para calcular a quantidade de usuários
CREATE OR REPLACE FUNCTION calcular_qtd_usuarios()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE trabbd2.plataforma
    SET qtd_users = (
        SELECT COUNT(DISTINCT nick_usuario)
        FROM trabbd2.plataformausuario
        WHERE nro_plataforma = NEW.nro_plataforma
    )
    WHERE nro = NEW.nro_plataforma;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Criando o trigger para acionar a função de cálculo de quantidade de usuários
CREATE TRIGGER atualizar_qtd_usuarios
AFTER INSERT OR UPDATE OR DELETE ON trabbd2.plataformausuario
FOR EACH ROW
EXECUTE FUNCTION calcular_qtd_usuarios();

-- Cria tabela StreamerPais
CREATE TABLE StreamerPais (
    nick_streamer VARCHAR(255),
    ddi_pais INT,
    nro_passaporte VARCHAR(255),
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick),
    FOREIGN KEY (ddi_pais) REFERENCES Pais(DDI),
    PRIMARY KEY (nick_streamer, ddi_pais)
);

-- Cria tabela EmpresaPais
CREATE TABLE EmpresaPais (
    nro_empresa INT,
    ddi_pais INT,
    id_nacional VARCHAR(255),
    FOREIGN KEY (nro_empresa) REFERENCES Empresa(nro),
    FOREIGN KEY (ddi_pais) REFERENCES Pais(DDI),
    PRIMARY KEY (nro_empresa, ddi_pais)
);

-- Cria a tabela Canal
CREATE TABLE Canal (
    nome VARCHAR(255) PRIMARY KEY,
    tipo VARCHAR(255),
    data DATE,
    descr TEXT,
    qtd_visualizacoes INT, -- ATRIBUTO DERIVADO
    nick_streamer VARCHAR(255),
    nro_plataforma INT,
    FOREIGN KEY (nro_plataforma) REFERENCES Plataforma(nro),
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick)
);

-- Cria a tabela Patrocinio
CREATE TABLE Patrocinio (
    nro_empresa INT,
    nome_canal VARCHAR(255),
    valor DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (nro_empresa) REFERENCES Empresa(nro),
    FOREIGN KEY (nome_canal) REFERENCES Canal(nome),
    PRIMARY KEY (nro_empresa, nome_canal)
);

-- Cria a tabela NivelCanal
CREATE TABLE NivelCanal (
    nome_canal VARCHAR(255),
    nivel VARCHAR(255),
    valor DECIMAL(10, 2) NOT NULL,
    gif bytea,
    FOREIGN KEY (nome_canal) REFERENCES Canal(nome),
    PRIMARY KEY (nome_canal, nivel)
);

-- Cria a tabela Inscricao
CREATE TABLE Inscricao (
    nome_canal VARCHAR(255),
    nick_membro VARCHAR(255),
    nivel VARCHAR(255),
    FOREIGN KEY (nick_membro) REFERENCES Usuario(nick),
    FOREIGN KEY (nome_canal, nivel) REFERENCES NivelCanal(nome_canal, nivel)
);

-- Cria a tabela Video
CREATE TABLE Video (
    id_video SERIAL PRIMARY KEY,
    nome_canal VARCHAR(255),
    titulo VARCHAR(255),
    dataH TIMESTAMP,
    tema VARCHAR(255),
    duracao INT,
    visu_simul INT,
    visu_total INT,
    FOREIGN KEY (nome_canal) REFERENCES Canal(nome)
    -- PRIMARY KEY (nome_canal, titulo, dataH): A combinação dessas três colunas garante a unicidade de cada linha na tabela,
    -- então não precisa adicionar um identificador artificial, mas usar um ID para o vídeo talvez seja uma opção mais fácil de trabalhar.
);

-- Criando a função para calcular a quantidade de visualizações de um canal
CREATE OR REPLACE FUNCTION calcular_qtd_visualizacoes()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE trabbd2.Canal
    SET qtd_visualizacoes = (
        SELECT SUM(visu_total)
        FROM trabbd2.Video
        WHERE nome_canal = NEW.nome_canal
    )
    WHERE nome = NEW.nome_canal;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Criando o trigger para acionar a função de cálculo de quantidade de visualizações de um canal
CREATE TRIGGER atualizar_qtd_visualizacoes
AFTER INSERT OR UPDATE OR DELETE ON trabbd2.Video
FOR EACH ROW
EXECUTE FUNCTION calcular_qtd_visualizacoes();

-- Daqui p/ baixo a tabela é diferente do que está definido no modelo relacionado devido a utilização do identificador virtual

-- Cria a tabela Participa
CREATE TABLE Participa (
    id_video INT,
    nick_streamer VARCHAR(255),
    FOREIGN KEY (id_video) REFERENCES Video(id_video),
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick),
    PRIMARY KEY (id_video, nick_streamer)
);

-- Cria a tabela Comentario
CREATE TABLE Comentario (
    id_video INT,
    nick_usuario VARCHAR(255),
    seq INT,
    texto TEXT,
    dataH TIMESTAMP,
    coment_on BOOLEAN,
    FOREIGN KEY (id_video) REFERENCES Video(id_video),
    FOREIGN KEY (nick_usuario) REFERENCES Usuario(nick),
    PRIMARY KEY (id_video, nick_usuario, seq)
);

-- Cria a tabela Doacao
CREATE TABLE Doacao (
    id_video INT,
    nick_usuario VARCHAR(255),
    seq_comentario INT,
    seq_pg INT,
    valor DECIMAL(10, 2) NOT NULL,
    status VARCHAR(255),
    FOREIGN KEY (id_video) REFERENCES Video(id_video),
    FOREIGN KEY (nick_usuario) REFERENCES Usuario(nick),
    PRIMARY KEY (id_video, nick_usuario, seq_comentario, seq_pg)
);

-- Cria a tabela BitCoin
CREATE TABLE BitCoin (
    id_video INT,
    nick_usuario VARCHAR(255),
    seq_comentario INT,
    seq_doacao INT,
    TxID VARCHAR(255),
    FOREIGN KEY (id_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES Doacao(id_video, nick_usuario, seq_comentario, seq_pg),
    PRIMARY KEY (id_video, nick_usuario, seq_comentario, seq_doacao)
);

-- Cria a tabela PayPal
CREATE TABLE PayPal (
    id_video INT,
    nick_usuario VARCHAR(255),
    seq_comentario INT,
    seq_doacao INT,
    IdPayPal VARCHAR(255),
    FOREIGN KEY (id_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES Doacao(id_video, nick_usuario, seq_comentario, seq_pg),
    PRIMARY KEY (id_video, nick_usuario, seq_comentario, seq_doacao)
);

-- Cria a tabela CartaoCredito
CREATE TABLE CartaoCredito (
    id_video INT,
    nick_usuario VARCHAR(255),
    seq_comentario INT,
    seq_doacao INT,
    nro VARCHAR(20),
    bandeira VARCHAR(20),
    FOREIGN KEY (id_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES Doacao(id_video, nick_usuario, seq_comentario, seq_pg),
    PRIMARY KEY (id_video, nick_usuario, seq_comentario, seq_doacao)
);

-- Cria a tabela MecanismoPlat
CREATE TABLE MecanismoPlat (
    id_video INT,
    nick_usuario VARCHAR(255),
    seq_comentario INT,
    seq_doacao INT,
    seq_plataforma INT,
    FOREIGN KEY (id_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES Doacao(id_video, nick_usuario, seq_comentario, seq_pg),
    PRIMARY KEY (id_video, nick_usuario, seq_comentario, seq_doacao)
);