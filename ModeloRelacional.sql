CREATE TABLE Empresa(
    nro integer primary key,
    nome varchar(255),
    nome_fantasia varchar(255)
);

CREATE TABLE Plataforma(
    nro integer primary key,
    nome varchar,
    empresa_fund integer references Empresa(nro),
    empresa_resp integer references Empresa(nro),
    data_fund timestamp
);

CREATE TABLE Conversao(
    moeda varchar primary key ,
    nome varchar,
    fator_conver varchar
);

CREATE TABLE Pais(
    DDI integer primary key ,
    nome varchar,
    moeda varchar references COnversao(moeda)
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
    nro_plataforma integer primary key references Plataforma(nro),
    nick_usuario varchar primary key references Usuario(nick),
    nro_usuario integer
);

