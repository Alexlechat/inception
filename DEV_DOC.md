# Developer Documentation

## Setting up the environment from scratch

Prerequisites:
- a virtual machine running Debian
- Docker and Docker Compose installed
- the domain name mapped to the local IP in `/etc/hosts`:

      127.0.0.1 allefran.42.fr

Clone the repository. Because secrets and the `.env` file are excluded from
version control, they must be created manually after cloning.

Create the environment file `srcs/.env` with:

    DOMAIN_NAME=allefran.42.fr
    MYSQL_DATABASE=wordpress
    MYSQL_USER=wpuser
    WP_ADMIN_USER=bossman
    WP_ADMIN_EMAIL=bossman@allefran.42.fr
    WP_USER=alex
    WP_USER_EMAIL=alex@allefran.42.fr

Create the secret files in `secrets/`, one password per file:

    secrets/db_password.txt
    secrets/db_root_password.txt
    secrets/wp_admin_password.txt
    secrets/wp_user_password.txt

## Building and launching the project

From the project root:

    make

This runs `docker compose` with `srcs/docker-compose.yml`, builds the three
images from their Dockerfiles and starts the containers in the background.

## Managing containers and volumes

    docker compose -f srcs/docker-compose.yml ps       # list containers
    docker compose -f srcs/docker-compose.yml logs -f  # follow logs
    docker exec -it mariadb bash                        # shell into a container
    docker volume ls                                    # list volumes

Full cleanup (containers, volumes and unused images):

    make fclean

## Where the data is stored and how it persists

The project uses two named volumes:

- `db_data` — the MariaDB database
- `wp_data` — the WordPress website files

Both are configured to store their data under `/home/allefran/data`:

- `/home/allefran/data/mariadb`
- `/home/allefran/data/wordpress`

They remain named volumes managed by Docker (not bind mounts). Because the
data lives in these volumes, it persists across container restarts and
rebuilds: running `make down` then `make` keeps the database and website
intact. The data is only removed by `make fclean` (or any `down -v`), which
deletes the volumes.