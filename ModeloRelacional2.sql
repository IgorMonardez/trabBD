-- Create Empresa table
CREATE TABLE Empresa (
    nro INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255) NOT NULL
);

-- Create Plataforma table
CREATE TABLE Plataforma (
    nro INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    qtd_users INT NOT NULL, -- ATRIBUTO DERIVADO
    empresa_fund INT,
    empresa_respo INT,
    data_fund DATE,
    FOREIGN KEY (empresa_fund) REFERENCES Empresa(nro),
    FOREIGN KEY (empresa_respo) REFERENCES Empresa(nro)
);

-- Create Conversao table
CREATE TABLE Conversao (
    moeda VARCHAR(3) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    fator_conver DECIMAL(10, 4) NOT NULL
);

-- Create Pais table
CREATE TABLE Pais (
    DDI INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    moeda VARCHAR(3),
    FOREIGN KEY (moeda) REFERENCES Conversao(moeda)
);

-- Create Usuario table
CREATE TABLE Usuario (
    nick VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    data_nasc DATE NOT NULL,
    telefone VARCHAR(20),
    end_postal VARCHAR(255),
    pais_residencia INT,
    FOREIGN KEY (pais_residencia) REFERENCES Pais(DDI)
);

-- Create PlataformaUsuario table
CREATE TABLE PlataformaUsuario (
    nro_plataforma INT,
    nick_usuario VARCHAR(255),
    nro_usuario INT,
    FOREIGN KEY (nro_plataforma) REFERENCES Plataforma(nro),
    FOREIGN KEY (nick_usuario) REFERENCES Usuario(nick),
    PRIMARY KEY (nro_plataforma, nick_usuario)
);

-- Create StreamerPais table
CREATE TABLE StreamerPais (
    nick_streamer VARCHAR(255),
    ddi_pais INT,
    nro_passaporte VARCHAR(255),
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick),
    FOREIGN KEY (ddi_pais) REFERENCES Pais(DDI),
    PRIMARY KEY (nick_streamer, ddi_pais)
);

-- Create EmpresaPais table
CREATE TABLE EmpresaPais (
    nro_empresa INT,
    ddi_pais INT,
    id_nacional VARCHAR(255),
    FOREIGN KEY (nro_empresa) REFERENCES Empresa(nro),
    FOREIGN KEY (ddi_pais) REFERENCES Pais(DDI),
    PRIMARY KEY (nro_empresa, ddi_pais)
);

-- Create Canal table
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

-- Create Patrocinio table
CREATE TABLE Patrocinio (
    nro_empresa INT,
    nome_canal VARCHAR(255),
    valor DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (nro_empresa) REFERENCES Empresa(nro),
    FOREIGN KEY (nome_canal) REFERENCES Canal(nome),
    PRIMARY KEY (nro_empresa, nome_canal)
);

-- Create NivelCanal table
CREATE TABLE NivelCanal (
    nome_canal VARCHAR(255),
    nivel VARCHAR(255),
    valor DECIMAL(10, 2) NOT NULL,
    gif bytea,
    FOREIGN KEY (nome_canal) REFERENCES Canal(nome),
    PRIMARY KEY (nome_canal, nivel)
);

-- Create Inscricao table
CREATE TABLE Inscricao (
    nome_canal VARCHAR(255),
    nick_membro VARCHAR(255),
    nivel VARCHAR(255),
    FOREIGN KEY (nick_membro) REFERENCES Usuario(nick),
    FOREIGN KEY (nome_canal, nivel) REFERENCES NivelCanal(nome_canal, nivel),
    PRIMARY KEY (nome_canal, nick_membro)
);

-- Create Video table
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
);

-- Create Participa table
CREATE TABLE Participa (
    id_video INT,
    nick_streamer VARCHAR(255),
    FOREIGN KEY (id_video) REFERENCES Video(id_video),
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick),
    PRIMARY KEY (id_video, nick_streamer)
);

-- Create Comentario table
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

-- Create Doacao table
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

-- Create BitCoin table
CREATE TABLE BitCoin (
    id_video INT,
    nick_usuario VARCHAR(255),
    seq_comentario INT,
    seq_doacao INT,
    TxID VARCHAR(255),
    FOREIGN KEY (id_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES Doacao(id_video, nick_usuario, seq_comentario, seq_pg),
    PRIMARY KEY (id_video, nick_usuario, seq_comentario, seq_doacao)
);

-- Create PayPal table
CREATE TABLE PayPal (
    id_video INT,
    nick_usuario VARCHAR(255),
    seq_comentario INT,
    seq_doacao INT,
    IdPayPal VARCHAR(255),
    FOREIGN KEY (id_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES Doacao(id_video, nick_usuario, seq_comentario, seq_pg),
    PRIMARY KEY (id_video, nick_usuario, seq_comentario, seq_doacao)
);

-- Create CartaoCredito table
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

-- Create MecanismoPlat table
CREATE TABLE MecanismoPlat (
    id_video INT,
    nick_usuario VARCHAR(255),
    seq_comentario INT,
    seq_doacao INT,
    seq_plataforma INT,
    FOREIGN KEY (id_video, nick_usuario, seq_comentario, seq_doacao) REFERENCES Doacao(id_video, nick_usuario, seq_comentario, seq_pg),
    PRIMARY KEY (id_video, nick_usuario, seq_comentario, seq_doacao)
);

