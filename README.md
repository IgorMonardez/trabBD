# trabBD

## Setup Inicial
1. Com o postgres instalado e executando, execute os comandos no arquivo [setup.sql](src/sql/setup.sql)
2. Em sequência, execute os comandos no arquivo [init_insert.sql](src/sql/init_insert.sql)

## Populando o banco
1. Caso não tenha o python instalado, instale em sua máquina e execute `pip install Faker`
2. Certique-se de configurar os parâmetros de conexão com o postgres no arquivo [db_config.py](src/scripts/db_config.py)
3. Caso esteja tudo correto, basta executar o comando `make` para executar todos os scripts.
4. Se tudo ocorreu corretamente, você verá as seguintes mensagens:
```
Usuários inseridos com sucesso!
```