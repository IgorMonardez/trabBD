CREATE INDEX index_nick_usuario ON usuario USING hash(nick);

CREATE UNIQUE INDEX index_nro_empresa ON empresa USING btree(nro);

CREATE UNIQUE INDEX index_id_video ON video USING btree(id_video);

CREATE INDEX index_nome_canal ON canal USING hash(nome);
