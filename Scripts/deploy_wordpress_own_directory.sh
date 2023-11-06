# Este script es para instalar wordpress en su propio directorio

# Bajamos el codigo fuente:

wget http://wordpress.org/latest.tar.gz -P /tmp

# Descomprimimos el archivo .tar.gz que acabamos de descargar con el comando tar

tar -xzvf /tmp/latest.tar.gz -C /tmp

# mover la carpeta de wordpress

mv -f /tmp/wordpress /var/www/html