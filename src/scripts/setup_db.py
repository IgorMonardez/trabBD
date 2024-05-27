import psycopg2
from db_config import DB_CONFIG


def execute_sql_file(filename):
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()

    # Open and read the file
    with open(filename, 'r') as f:
        sql = f.read()

    # Execute the SQL commands
    cur.execute(sql)

    # Commit the transaction
    conn.commit()

    # Close the connection
    cur.close()
    conn.close()


execute_sql_file('src/sql/setup.sql')
print("Database configurada com sucesso")

execute_sql_file('src/sql/init_insert.sql')
print("Primeiros registros inseridos com sucesso.")
