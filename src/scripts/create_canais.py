import psycopg2
from random import randint, choice, uniform
from faker import Faker
from db_config import DB_CONFIG

# Conectando ao banco de dados
conn = psycopg2.connect(**DB_CONFIG)
cur = conn.cursor()

# Inicializando Faker
fake = Faker()

schema = "trabbd2"

# Definindo os tipos de canal específicos
channel_types = ["Jogos", "IRL", "Música", "Criatividade"]

# Inserir empresas patrocinadoras fictícias
number_of_companies = 20  # Número de empresas fictícias a serem criadas
company_ids = []
for _ in range(number_of_companies):
    nome = fake.company()
    nome_fantasia = fake.company_suffix()
    cur.execute(
        f"INSERT INTO {schema}.Empresa (nome, nome_fantasia) VALUES (%s, %s) RETURNING nro",
        (nome, nome_fantasia)
    )
    company_ids.append(cur.fetchone()[0])  # Recupera o ID da empresa inserida

# Selecionar todos os streamers
cur.execute(f"SELECT nick_streamer FROM {schema}.StreamerPais")
streamers = cur.fetchall()

# Inserir canais para cada streamer
for streamer in streamers:
    nick_streamer = streamer[0]
    nome_canal = f"{nick_streamer}_channel"
    tipo = choice(channel_types)
    data = fake.date_this_decade()  # Data de criação do canal aleatória
    descr = fake.text(max_nb_chars=200)  # Descrição aleatória do canal
    nro_plataforma = randint(1, 3)  # Plataforma aleatória (1 a 3)

    # Inserir o canal na tabela Canal
    cur.execute(
        f"""
        INSERT INTO {schema}.Canal (nome, tipo, data, descr, qtd_visualizacoes, nick_streamer, nro_plataforma)
        VALUES (%s, %s, %s, %s, 0, %s, %s)
        """,
        (nome_canal, tipo, data, descr, nick_streamer, nro_plataforma)
    )

    # Inserir patrocínios para o canal
    numero_patrocinios = randint(1, 3)  # Cada canal pode ter de 1 a 3 patrocínios
    empresas_pat = fake.random_sample(company_ids,
                                      numero_patrocinios)  # Seleciona um conjunto de empresas aleatoriamente
    for nro_empresa in empresas_pat:
        valor = round(uniform(1000, 10000), 2)  # Valor do patrocínio entre 1000 e 10000
        cur.execute(
            f"INSERT INTO {schema}.Patrocinio (nro_empresa, nome_canal, valor) VALUES (%s, %s, %s)",
            (nro_empresa, nome_canal, valor)
        )

    # Inserir níveis de canal para o canal
    valor_base = uniform(5, 100)  # Valor base do primeiro nível

    for i in range(5):
        nivel = f"Nível {i+1}"  # Nome do nível
        valor_nivel = valor_base * (i + 1)  # Calcula o valor do nível baseado no valor base e no índice do nível
        gif = fake.binary(length=100)  # Gera dados binários aleatórios para o GIF

        cur.execute(
            f"""
            INSERT INTO {schema}.NivelCanal (nome_canal, nivel, valor, gif)
            VALUES (%s, %s, %s, %s)
            """,
            (nome_canal, nivel, valor_nivel, gif)
        )

# Commit e fechamento da conexão
conn.commit()
conn.close()

print('Empresas patrocinadoras, canais, patrocínios e níveis de canal inseridos com sucesso!')
