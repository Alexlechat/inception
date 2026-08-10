NAME = inception

all: up

up:
	@mkdir -p /home/allefran/data/mariadb /home/allefran/data/wordpress
	docker compose -f srcs/docker-compose.yml up --build -d

down:
	docker compose -f srcs/docker-compose.yml down

stop:
	docker compose -f srcs/docker-compose.yml stop

start:
	docker compose -f srcs/docker-compose.yml start

clean: down

fclean:
	docker compose -f srcs/docker-compose.yml down -v
	docker system prune -af

re: fclean up

.PHONY: all up down stop start clean fclean re