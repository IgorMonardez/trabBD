import psycopg2
from faker import Faker
from random import randint, choice
from db_config import DB_CONFIG

# Conexão com o banco de dados
conn = psycopg2.connect(**DB_CONFIG)
cur = conn.cursor()

schema = "trabbd2"

fake = Faker()

# Selecionar todos os streamers
cur.execute(f"SELECT nick_streamer FROM {schema}.StreamerPais")
streamers = cur.fetchall()

# Mapeamento de temas para cada tipo de canal
canal_temas = {
    "Música": ["Música", "Concertos", "Instrumentos", "Bandas"],
    "Jogos": ["Gameplays", "Dicas de Jogo", "Game Shows", "Reviews de Jogos"],
    "Criatividade": ["Arte", "DIY", "Culinária", "Artesanato"],
    "IRL": ["Vlogs", "Rotina Diária", "Viagens", "Eventos"]
}


# Populando a tabela Video e Participa
for streamer in streamers:
    nick_streamer = streamer[0]
    # Consultar o tipo do canal usando o nick_streamer
    cur.execute(f"SELECT tipo FROM {schema}.Canal WHERE nick_streamer = %s", (nick_streamer,))
    tipo_canal = cur.fetchone()[0]  # Tipo do canal

    for _ in range(randint(50, 100)):  # Entre 50 e 100 vídeos por streamer
        nome_canal = f"{nick_streamer}_channel"
        titulo = fake.sentence()
        dataH = fake.date_time_this_year()  # Data e hora aleatórias
        tema = choice(canal_temas[tipo_canal])  # Escolhendo um tema relacionado ao tipo de canal
        duracao = randint(60, 600)  # Duração aleatória em segundos
        visu_simul = randint(500, 1000)  # Visualizações simultâneas aleatórias
        visu_total = randint(1000, 100000)  # Visualizações totais aleatórias

        # Inserindo vídeo na tabela Video
        cur.execute(
            f"""
            INSERT INTO {schema}.Video (nome_canal, titulo, dataH, tema, duracao, visu_simul, visu_total)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            RETURNING id_video
            """,
            (nome_canal, titulo, dataH, tema, duracao, visu_simul, visu_total)
        )

        # Pegando o id do vídeo inserido
        id_video = cur.fetchone()[0]

        # Inserindo participação na tabela Participa
        cur.execute(
            f"""
            INSERT INTO {schema}.Participa (id_video, nick_streamer)
            VALUES (%s, %s)
            """,
            (id_video, nick_streamer)
        )

        # Determinando se outro streamer deve participar
        if randint(1, 10) == 1:  # 10% de chance
            # Escolhendo um streamer diferente aleatoriamente
            outro_streamer = choice(streamers)
            while outro_streamer == streamer:  # Garantindo que seja um streamer diferente
                outro_streamer = choice(streamers)
            outro_nick_streamer = outro_streamer[0]

            # Inserindo participação do outro streamer na tabela Participa
            cur.execute(
                f"""
                            INSERT INTO {schema}.Participa (id_video, nick_streamer)
                            VALUES (%s, %s)
                            """,
                (id_video, outro_nick_streamer)
            )

# Commit e fechamento da conexão
conn.commit()
conn.close()

print('Vídeos e participantes inseridos com sucesso!')
