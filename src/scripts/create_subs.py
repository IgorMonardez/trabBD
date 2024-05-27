import psycopg2
from random import randint
from db_config import DB_CONFIG

# Conexão com o banco de dados
conn = psycopg2.connect(**DB_CONFIG)
cur = conn.cursor()

schema = "trabbd2"

# Selecionar todos os usuários
cur.execute(f"SELECT nick FROM {schema}.Usuario")
usuarios = cur.fetchall()

# Selecionar todos os canais
cur.execute(f"SELECT nome FROM {schema}.Canal")
canais = cur.fetchall()

# Populando a tabela de inscrições
for usuario in usuarios:
    nick_usuario = usuario[0]
    # Escolher aleatoriamente 30 canais para inscrição
    canais_inscricao = set()
    while len(canais_inscricao) < 30:
        canal = canais[randint(0, len(canais) - 1)][0]
        canais_inscricao.add(canal)

    # Inserir as inscrições para o usuário nos canais selecionados
    for canal in canais_inscricao:
        nivel = randint(1, 5)  # Nível de inscrição aleatório entre 1 e 5
        cur.execute(
            f"INSERT INTO {schema}.Inscricao (nome_canal, nick_membro, nivel) VALUES (%s, %s, %s)",
            (canal, nick_usuario, f"Nível {nivel}")
        )

# Commit e fechamento da conexão
conn.commit()
conn.close()

print('Inscrições populadas com sucesso!')
