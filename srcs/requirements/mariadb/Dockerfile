FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R  mysql:mysql /run/mysqld

EXPOSE 3306

ENTRYPOINT [ "mysqld", "--user=mysql" ]