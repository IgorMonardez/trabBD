.PHONY: all populate_db

all: populate_db

populate_db:
	python3 src/scripts/setup_db.py
	python3 src/scripts/create_users_streamers.py
	python3 src/scripts/create_canais.py
	python3 src/scripts/create_subs.py
	python3 src/scripts/create_videos_participantes.py
	python3 src/scripts/create_comentarios.py