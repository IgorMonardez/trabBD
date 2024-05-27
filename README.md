# trabBD

## Populando o banco
1. Caso não tenha o python instalado, instale em sua máquina e execute `pip install Faker`
2. Certique-se de configurar os parâmetros de conexão com o postgres no arquivo [db_config.py](src/scripts/db_config.py)
3. Caso esteja tudo correto, basta executar o comando `make` para executar todos os scripts.
4. Se tudo ocorreu corretamente, você verá as seguintes mensagens:
```
Database configurada com sucesso
Primeiros registros inseridos com sucesso.
Usuários inseridos com sucesso!
Empresas patrocinadoras, canais, patrocínios e níveis de canal inseridos com sucesso!
Inscrições populadas com sucesso!
Vídeos e participantes inseridos com sucesso!
Comentários inseridos com sucesso!
```

## Configurando
Tenha em mente que os valores desse script podem ser alterados. Do jeito que está, ele está configurado para criar
100 streamers, cada um tem seu canal, são adicionados de 50 a 100 vídeos por streamer e 100 a 300 comentários por vídeo.
A parte que mais demora nessa configuração é dos comentários, com um tempo de mais de 2 horas para ser concluído a inserção.