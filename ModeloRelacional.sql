CREATE TABLE Empresa(
    nro integer primary key,
    nome varchar(255),
    nome_fantasia varchar(255)
);

CREATE TABLE Plataforma(
    nro integer primary key,
    nome varchar,
    empresa_fund integer,
    empresa_resp integer,
    data_fund timestamp,
    FOREIGN KEY (empresa_fund) REFERENCES Empresa(nro),
    FOREIGN KEY (empresa_resp) REFERENCES Empresa(nro)
);

CREATE TABLE Conversao(
    moeda varchar primary key ,
    nome varchar,
    fator_conver varchar
);

CREATE TABLE Pais(
    DDI integer primary key ,
    nome varchar,
    moeda varchar,
    FOREIGN KEY (moeda) REFERENCES Conversao(moeda)
);

CREATE TABLE Usuario(
    nick varchar primary key ,
    email varchar,
    data_nasc timestamp,
    telefone varchar,
    end_posta varchar,
    pais_residencia varchar
);

CREATE TABLE PlataformaUsuario(
    nro_plataforma integer,
    nick_usuario varchar,
    nro_usuario integer,
    FOREIGN KEY(nro_plataforma) REFERENCES Plataforma(nro),
    FOREIGN KEY(nick_usuario) REFERENCES Usuario(nick)
);

CREATE TABLE StreamerPais(
    nick_streamer varchar,
    ddi_pais integer,
    nro_passaporte varchar,
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick),
    FOREIGN KEY (ddi_pais) REFERENCES Pais(ddi)
);

CREATE TABLE EmpresaPais(
    nro_empresa int,
    ddi_pais int,
    id_nacional int,
    FOREIGN KEY (nro_empresa) REFERENCES Empresa(nro),
    FOREIGN KEY (ddi_pais) REFERENCES Pais(ddi)
);

-- Quantidade de vizualizações é atributo derivado e requer atualização
CREATE TABLE Canal(
    nome varchar primary key,
    tipo int,
    data timestamp,
    descricao varchar,
    qtd_visualizações int,
    nick_streamer varchar,
    nro_plataforma int,
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick),
    FOREIGN KEY(nro_plataforma) REFERENCES Plataforma(nro)
);

CREATE TABLE Patrocinio(
    nro_empresa int,
    nome_canal varchar,
    valor float,
    FOREIGN KEY (nro_empresa) REFERENCES Empresa(nro),
    FOREIGN KEY (nome_canal) REFERENCES Canal(nome)
);

CREATE TABLE NivelCanal(
    nome_canal varchar primary key,
    nivel int,
    valor float,
    gif bytea,
    FOREIGN KEY (nome_canal) REFERENCES Canal(nome)
);

CREATE TABLE Inscricao(
    nome_canal varchar,
    nick_membro varchar,
    nivel int,
    FOREIGN KEY (nome_canal, nivel) REFERENCES NivelCanal(nome_canal, nivel),
    FOREIGN KEY (nick_membro) REFERENCES Usuario(nick)
);

CREATE TABLE Video(
    id_video int primary key DEFAULT nextval('VideoSequence'),
    nome_canal varchar,
    titulo varchar,
    dataH timestamp,
    tema varchar,
    duracao time,
    visu_simultanea int,
    visu_total int,
    FOREIGN KEY (nome_canal) REFERENCES NivelCanal(nome_canal),
    UNIQUE (nome_canal, titulo, datah)
);
CREATE SEQUENCE VideoSequence START WITH 1 INCREMENT BY 1 NO MAXVALUE CACHE 1;
CREATE TABLE Participa(
    nome_canal varchar,
    titulo_video varchar,
    datah_video timestamp,
    nick_streamer varchar,
    FOREIGN KEY (nome_canal, titulo_video, datah_video) REFERENCES Video(nome_canal, titulo, dataH),
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick)
);

CREATE SEQUENCE ComentarioSequence START WITH 1 INCREMENT BY 1 NO MAXVALUE CACHE 1;
CREATE TABLE Comentario(
    nome_canal varchar,
    titulo_video varchar,
    datah_video timestamp,
    nick_usuario varchar,
    sequencial int PRIMARY KEY DEFAULT nextval('ComentarioSequence'),
    texto varchar,
    dataH timestamp,
    comment_on varchar,
    FOREIGN KEY (nome_canal, titulo_video, datah_video) REFERENCES Video(nome_canal, titulo, datah),
    FOREIGN KEY (nick_usuario) REFERENCES Usuario(nick),
    UNIQUE (sequencial),
    UNIQUE (nome_canal, titulo_video, datah_video)
);
ALTER TABLE Comentario ADD CONSTRAINT SET PRIMARY KEY (sequencial);
CREATE SEQUENCE DoacaoSequence START WITH 1 INCREMENT BY 1 NO MAXVALUE CACHE 1;
CREATE TABLE Doacao(
    nome_canal varchar,
    titulo_video varchar,
    datah_video timestamp,
    nick_usuario varchar,
    sequencial_comentario int,
    sequencial_pagamento int DEFAULT nextval('DoacaoSequence'),
    valor int,
    status varchar,
    FOREIGN KEY (nome_canal, titulo_video, datah_video, nick_usuario, sequencial_comentario) REFERENCES Comentario(nome_canal, titulo_video, datah_video, nick_usuario, sequencial),
    UNIQUE (sequencial_pagamento)
);