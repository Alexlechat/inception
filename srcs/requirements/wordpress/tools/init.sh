#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

until mariadb -h mariadb -u "${MYSQL_USER}" -p"${DB_PASSWORD}" -e "SELECT 1;" &>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done


if [ ! -f /var/www/html/wp-config.php ]; then

    wp core download --path=/var/www/html --allow-root

    wp config create \
        --path=/var/www/html \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root

    wp core install \
        --path=/var/www/html \
        --url="${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --path=/var/www/html \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

fi

exec /usr/sbin/php-fpm8.2 --nodaemonize