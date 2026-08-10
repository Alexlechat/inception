*This project has been created as part of the 42 curriculum by allefran.*

# Inception

## Description

Inception is a system administration project that sets up a small web
infrastructure using Docker. The whole stack runs inside a virtual machine
and is composed of three services, each in its own container built from a
custom Dockerfile:

- **NGINX** — the only entry point, reachable over HTTPS (port 443, TLSv1.2/1.3)
- **WordPress + php-fpm** — the application, running as a FastCGI process
- **MariaDB** — the database

The services communicate over a dedicated Docker network. Two named volumes
persist the WordPress database and website files. Sensitive data is handled
through Docker secrets and environment variables.

## Instructions

The project runs inside a virtual machine with Docker and Docker Compose
installed.

Requirements before launching:
- create the secret files in `secrets/` (database passwords, WordPress
  passwords)
- create `srcs/.env` with the required variables (see DEV_DOC.md)
- add `127.0.0.1 <login>.42.fr` to `/etc/hosts`

To build and start the whole infrastructure:

    make

Other targets:

    make down    # stop and remove the containers
    make re      # rebuild everything from scratch
    make fclean  # full cleanup (containers, volumes, images)

The website is then available at `https://allefran.42.fr`.

## Project description

### Virtual Machines vs Docker

A virtual machine emulates a full computer, including its own kernel, on top
of a hypervisor. It is strongly isolated but heavy: it takes minutes to boot
and consumes gigabytes of resources. Docker containers share the host kernel
and isolate processes using kernel features (namespaces and cgroups). They
start in milliseconds and are far lighter, at the cost of weaker isolation.
Docker is well suited to running one service per container, which is the
approach of this project.

### Secrets vs Environment Variables

Environment variables are convenient for non-sensitive configuration (database
name, user name, domain). However, they can be read through `docker inspect`
or by dumping a process environment, which makes them a poor place for
passwords. Docker secrets store sensitive values in dedicated files mounted
inside the container at `/run/secrets/`, and are not exposed in the container
environment. In this project, names go in the `.env` file, while passwords are
stored as secrets.

### Docker Network vs Host Network

With the host network mode, a container shares the host's network stack
directly, removing isolation between the container and the host. A dedicated
Docker network (bridge) creates an isolated private network where containers
reach each other by service name through Docker's internal DNS, while only the
ports explicitly published are reachable from outside. This project uses a
dedicated network so that only NGINX exposes a port (443), while MariaDB and
php-fpm stay reachable only internally.

### Docker Volumes vs Bind Mounts

A bind mount maps a specific host directory into a container; the host path is
managed by the user. A named volume is managed by Docker itself, which handles
its lifecycle and location. The subject requires named volumes for the two
persistent storages. Here they are configured to store their data under
`/home/allefran/data` while remaining named volumes managed by Docker, not
bind mounts.

## Resources

- Docker official documentation (Dockerfile best practices, docker compose,
  volumes, secrets, networks)
- NGINX documentation (TLS configuration, FastCGI proxying)
- WordPress and WP-CLI documentation
- MariaDB documentation (bootstrap mode, user management)

AI was used as a learning and debugging aid throughout the project: to explain
Docker concepts (PID 1, daemons, layers), to review Dockerfiles and shell
scripts, and to help diagnose errors (container crashes, MariaDB bootstrap
issues, php-fpm socket vs port). All generated content was reviewed, tested,
and adapted to be fully understood before being used.