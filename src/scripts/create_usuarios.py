import psycopg2
import re
from random import randint
from faker import Faker
from datetime import datetime, timedelta
from db_config import DB_CONFIG

conn = psycopg2.connect(**DB_CONFIG)

cur = conn.cursor()

schema = "trabbd2"

fake = Faker()

# Lista para armazenar os nomes de usuário gerados
generated_usernames = set()

def random_birthdate():
    end_date = datetime.now() - timedelta(days=18*365)
    start_date = end_date - timedelta(days=65*365)
    return fake.date_between(start_date=start_date, end_date=end_date)

def remove_special_characters(phone_number):
    return re.sub(r'\D', '', phone_number)

# Inserindo usuários e associando-os à alguma plataforma
for platform_id in range(1, 4):  # Para 3 plataformas
    users_to_insert = randint(500, 601) # Insere um número de usuários entre 500 e 600 em cada plataforma
    for _ in range(users_to_insert):
        while True:
            nick = fake.user_name()
            if nick not in generated_usernames:
                generated_usernames.add(nick)
                break
        email = fake.email()
        data_nasc = random_birthdate()
        telefone = remove_special_characters(fake.phone_number())[:20]  # Remove caracteres especiais e limita o comprimento a 20 caracteres
        end_postal = fake.address()
        pais_residencia = randint(1, 4)  # Para 4 países

        # Inserindo o usuário na tabela Usuario
        cur.execute(
            f"INSERT INTO {schema}.Usuario (nick, email, data_nasc, telefone, end_postal, pais_residencia) VALUES (%s, %s, %s, %s, %s, %s)",
            (nick, email, data_nasc, telefone, end_postal, pais_residencia))
        # Inserindo o usuário na tabela PlataformaUsuario
        cur.execute(f"INSERT INTO {schema}.PlataformaUsuario (nro_plataforma, nick_usuario) VALUES (%s, %s)",
                    (platform_id, nick))


# Commit e fechamento da conexão
conn.commit()
conn.close()

print('Usuários inseridos com sucesso!')