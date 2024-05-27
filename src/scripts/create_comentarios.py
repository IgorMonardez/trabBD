import psycopg2
from faker import Faker
from random import randint, uniform, choice
import hashlib

from db_config import DB_CONFIG

# Conexão com o banco de dados
conn = psycopg2.connect(**DB_CONFIG)
cur = conn.cursor()

schema = "trabbd2"

fake = Faker()

# Selecionar todos os vídeos
cur.execute(f"SELECT id_video FROM {schema}.Video")
videos = cur.fetchall()

# Selecionar todos os usuários
cur.execute(f"SELECT nick FROM {schema}.Usuario")
usuarios = cur.fetchall()

# Populando a tabela Comentario
for video in videos:
    id_video = video[0]
    for _ in range(randint(100, 300)):  # Entre 1000 e 2000 comentários por vídeo
        nick_usuario = fake.random_element(usuarios)[0] # Nick de usuário existente

        cur.execute(f"SELECT MAX(seq) FROM {schema}.Comentario WHERE id_video = %s AND nick_usuario = %s",
                    (id_video, nick_usuario))
        seq_comentario = cur.fetchone()[0]
        if seq_comentario is None:
            seq_comentario = 1
        else:
            seq_comentario += 1

        texto = fake.paragraph()  # Texto do comentário aleatório
        dataH = fake.date_time_this_decade()  # Data e hora aleatórias
        coment_on = fake.boolean()  # Comentário online/offline

        # Inserindo comentário na tabela Comentario
        cur.execute(
            f"""
            INSERT INTO {schema}.Comentario (id_video, nick_usuario, seq, texto, dataH, coment_on)
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (id_video, nick_usuario, seq_comentario, texto, dataH, coment_on)
        )

        # Determinando se o comentário estará associado à uma doação
        if randint(1, 10) in [1, 2, 3, 4]:  # 40% de chance
            cur.execute(
                f"SELECT MAX(seq_pg) FROM {schema}.Doacao WHERE id_video = %s AND nick_usuario = %s AND seq_comentario = %s",
                (id_video, nick_usuario, seq_comentario))
            seq_pg = cur.fetchone()[0]
            if seq_pg is None:
                seq_pg = 1
            else:
                seq_pg += 1

            valor = uniform(1, 100)  # Valor aleatório
            status_list = ["Recusado"] * 5 + ["Recebido", "Lido"] * 47  # 5% "Recusado", 95% "Recebido" and "Lido"
            status = choice(status_list)  # Status aleatório

            # Associando comentário à uma doação
            cur.execute(
                f"""
                        INSERT INTO {schema}.Doacao (id_video, nick_usuario, seq_comentario, seq_pg, valor, status)
                        VALUES (%s, %s, %s, %s, %s, %s)
                        """,
                (id_video, nick_usuario, seq_comentario, seq_pg, valor, coment_on)
            )

            donations_type = ["BitCoin", "PayPal", "CartaoCredito", "MecanismoPlat"]

            if choice(donations_type) == "BitCoin":
                cur.execute(
                    f"SELECT MAX(seq_doacao) FROM {schema}.BitCoin WHERE id_video = %s AND nick_usuario = %s AND seq_comentario = %s",
                    (id_video, nick_usuario, seq_comentario))
                seq_doacao = cur.fetchone()[0]
                if seq_doacao is None:
                    seq_doacao = 1
                else:
                    seq_doacao += 1

                random_text = fake.text()
                hash_object = hashlib.sha256(random_text.encode())
                txid = hash_object.hexdigest()

                cur.execute(
                    f"""
                    INSERT INTO {schema}.BitCoin (id_video, nick_usuario, seq_comentario, seq_doacao, TxID)
                    VALUES (%s, %s, %s, %s, %s)
                    """,
                    (id_video, nick_usuario, seq_comentario, seq_doacao, txid)
                )
            elif choice(donations_type) == "PayPal":
                cur.execute(
                    f"SELECT MAX(seq_doacao) FROM {schema}.PayPal WHERE id_video = %s AND nick_usuario = %s AND seq_comentario = %s",
                    (id_video, nick_usuario, seq_comentario))
                seq_doacao = cur.fetchone()[0]
                if seq_doacao is None:
                    seq_doacao = 1
                else:
                    seq_doacao += 1

                id_paypal = fake.uuid4()

                cur.execute(
                    f"""
                    INSERT INTO {schema}.PayPal (id_video, nick_usuario, seq_comentario, seq_doacao, IdPayPal)
                    VALUES (%s, %s, %s, %s, %s)
                    """,
                    (id_video, nick_usuario, seq_comentario, seq_doacao, id_paypal)
                )
            elif choice(donations_type) == "CartaoCredito":
                cur.execute(
                    f"SELECT MAX(seq_doacao) FROM {schema}.CartaoCredito WHERE id_video = %s AND nick_usuario = %s AND seq_comentario = %s",
                    (id_video, nick_usuario, seq_comentario))
                seq_doacao = cur.fetchone()[0]
                if seq_doacao is None:
                    seq_doacao = 1
                else:
                    seq_doacao += 1

                bandeira = choice(["visa", "mastercard"])
                nro_cartao = fake.credit_card_number(card_type=bandeira)

                cur.execute(
                    f"""
                    INSERT INTO {schema}.CartaoCredito (id_video, nick_usuario, seq_comentario, seq_doacao, nro, bandeira)
                    VALUES (%s, %s, %s, %s, %s, %s)
                    """,
                    (id_video, nick_usuario, seq_comentario, seq_doacao, nro_cartao, bandeira)
                )
            elif choice(donations_type) == "MecanismoPlat":
                cur.execute(
                    f"SELECT MAX(seq_doacao) FROM {schema}.MecanismoPlat WHERE id_video = %s AND nick_usuario = %s AND seq_comentario = %s",
                    (id_video, nick_usuario, seq_comentario))
                seq_doacao = cur.fetchone()[0]
                if seq_doacao is None:
                    seq_doacao = 1
                else:
                    seq_doacao += 1

                cur.execute(
                    f"SELECT nro_plataforma FROM {schema}.PlataformaUsuario WHERE nick_usuario = %s",
                    (nick_usuario,)
                )
                nro_plataforma = cur.fetchone()[0]

                nro_plataforma_str = str(nro_plataforma)
                seq_comentario_str = str(seq_comentario)
                seq_doacao_str = str(seq_doacao)

                seq_plataforma_str = nro_plataforma_str + seq_comentario_str + seq_doacao_str
                seq_plataforma = int(seq_plataforma_str)


                cur.execute(
                    f"""
                    INSERT INTO {schema}.MecanismoPlat (id_video, nick_usuario, seq_comentario, seq_doacao, seq_plataforma)
                    VALUES (%s, %s, %s, %s, %s)
                    """,
                    (id_video, nick_usuario, seq_comentario, seq_doacao, seq_plataforma)
                )


# Commit e fechamento da conexão
conn.commit()
conn.close()

print('Comentários inseridos com sucesso!')
