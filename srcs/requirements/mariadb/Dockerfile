FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]