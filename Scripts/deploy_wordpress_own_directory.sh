#!/bin/bash

# Este script es para instalar wordpress en su propio directorio

# Incluimos variables del .env

source .env

# Bajamos el codigo fuente:

wget http://wordpress.org/latest.tar.gz -P /tmp

# Descomprimimos el archivo .tar.gz que acabamos de descargar con el comando tar

tar -xzvf /tmp/latest.tar.gz -C /tmp

rm -rf /var/www/html/*

# esta vez movemos la carpeta de wordpress enteramente a  /var/www/html

mv -f /tmp/wordpress /var/www/html

# Creamos la base de datos y el usuario para WordPress de igual forma que en el otros .sh

mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

# Crear archivo de configuración a partir del archivo de ejemplo

cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Modificaremos el archivo mediante el comando sed para introducir el valor de las variables:

sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wordpress/wp-config.php

# Cambiar el propietario para que permite hacer el añadido de los siguientes comandos:

chown -R www-data:www-data /var/www/html/wordpress

# Pasamos a configurar el mapeo de las URL para que el usuario no tenga que introducir toda la ruta si no solo el dominio:

sed -i "/DB_COLLATE/a define('WP_SITEURL', 'https://$dominio/wordpress');" /var/www/html/wordpress/wp-config.php
sed -i "/WP_SITEURL/a define('WP_HOME', 'https://$dominio');" /var/www/html/wordpress/wp-config.php

# Copiamos el archivo /var/www/html/wordpress/index.php a /var/www/html

cp /var/www/html/wordpress/index.php /var/www/html

# Para el directorio requerido, haciendo uso del delimitador # sustituimos la primera cadena por la segunda para que este dentro de nuestra carpeta:

sed -i "s#wp-blog-header.php#wordpress/wp-blog-header.php#" /var/www/html/index.php 

# Habilitamos modulo rewrite de Apache:

a2enmod rewrite

# Copiar a /var/www/html/

cp /home/ubuntu/Practica-01-06/htaccess/.htaccess /var/www/html/

