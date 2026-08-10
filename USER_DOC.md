# User Documentation

## Services provided

This stack provides a WordPress website served over HTTPS. It is made of
three services:

- **NGINX** — the web server and the only entry point, reachable at
  `https://allefran.42.fr` over HTTPS (port 443).
- **WordPress + php-fpm** — the website itself and its content management.
- **MariaDB** — the database storing the website data.

## Starting and stopping the project

From the project root:

    make          # build and start all services
    make down     # stop and remove the containers
    make stop     # pause the services without removing them
    make start    # resume paused services
    make re       # rebuild everything from scratch

## Accessing the website

- Public site: `https://allefran.42.fr`
- Administration panel: `https://allefran.42.fr/wp-admin`

Because the TLS certificate is self-signed, the browser will show a security
warning on first visit. This is expected; accept it to continue.

Log in to the administration panel with the administrator account (see below
for credentials).

## Managing credentials

Sensitive values are never stored in the code. They are kept in two places:

- Non-sensitive configuration (database name, user names, domain, emails) is
  in `srcs/.env`.
- Passwords are stored as Docker secrets in the `secrets/` directory, one file
  per password. These files are excluded from version control.

Inside a running container, secrets are mounted at `/run/secrets/` and can be
read from within the container, for example:

    docker exec mariadb ls -la /run/secrets/

Passwords never appear in the container environment, so they are not exposed
by `docker inspect`.

## Checking that the services run correctly

Check the state of all containers:

    docker compose -f srcs/docker-compose.yml ps

All three containers should show status `Up`.

Test the website from the command line:

    curl -k https://allefran.42.fr

This should return the WordPress home page HTML.

View the logs of a service if needed:

    docker compose -f srcs/docker-compose.yml logs nginx