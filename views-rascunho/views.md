# Visão para Mostrar o Total Arrecadado por Streamer

### Tipo: visão virtual

```sql
CREATE VIEW total_arrecadado_streamer AS
SELECT s.nick, SUM(d.valor) AS total_arrecadado
FROM Streamer s
JOIN Doacao d ON s.nick = d.nick_usuario
GROUP BY s.nick;
```

### Justificativa:

Esta view é usada para simplificar a consulta do total arrecadado por cada streamer ao agregar as doações diretamente. No model relacional, esta view faz referência às tabelas Streamer e Doacao. A criação desta view melhora a performance ao evitar a repetição de junções e agregações complexas em consultas frequentes.


# Visão para Listar os Comentários dos últimos 7 Dias

### Tipo: visão virtual

```sql
CREATE VIEW comentarios_recentes AS
SELECT c.*
FROM Comentario c
WHERE c.dataH > NOW() - INTERVAL '7 days';
```

### Justificativa:

Esta view facilita obter os comentarios recentes, tirando a necessidade de repetir a condição de tempo a cada consulta. No model relacional, esta view faz referencia a tabela Comentarios que armazena os comentarios feitos pelos usuarios. Esta view é util para consultas frequentes sobre interações recentes, melhorando a eficiencia das operações que dependem dessas informações.


# Visão para Armazenar o Total Arrecadado por Streamer

### Tipo: visão materializada


```sql
CREATE MATERIALIZED VIEW total_arrecadado_streamer AS
SELECT s.nick, SUM(d.valor) AS total_arrecadado
FROM Streamer s
JOIN Doacao d ON s.nick = d.nick_usuario
GROUP BY s.nick;
```

Esta view armazena fisicamente os resultados da consulta, otimizando assim o desempenho das consultas frequentes sobre o total arrecadado por cada streamer, No model relacional, esta view faz referencia a tabela Streamer e Doação.


# Visão para Mostrar Membros Ativos por Canal

### Tipo: visão materializada

```sql
CREATE MATERIALIZED VIEW membros_ativos_canal AS
SELECT c.nome, COUNT(i.nick_membro) AS total_membros
FROM Canal c
JOIN Inscricao i ON c.nome = i.nome_canal
GROUP BY c.nome;
```

Esta view melhora o desempenho de consultas frequentes sobre o numero de membros ativos. No model relacional, esta view faz referencia a tabela Canal e Inscricao.

# Visão para Mostrar Visualizações Totais por Plataforma

### Tipo: visão virtual

```sql
CREATE VIEW visualizacoes_plataforma AS
SELECT p.nome, SUM(v.visu_total) AS total_visualizacoes
FROM Plataforma p
JOIN Canal c ON p.nro = c.nro_plataforma
JOIN Video v ON c.nome = v.nome_canal
GROUP BY p.nome;
```
Esta view facilita a consulta do total de visualizações por plataforma. No model relacional, esta view faz referencia a tabela Plataforma, Canal e Video
