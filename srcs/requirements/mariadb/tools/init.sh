#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql


    DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
    DB_PASSWORD=$(cat /run/secrets/db_password)

    cat > /tmp/init.sql << EOF
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOF

    unset DB_ROOT_PASSWORD
    unset DB_PASSWORD

    mariadbd --user=mysql --bootstrap < /tmp/init.sql
    rm -f /tmp/init.sql

fi

exec mariadbd --user=mysql