# Practica-01-06
### Implantación de WordPress | Directorio raíz y su propio directorio

Para esta práctica se llevará a cabo la implanatación de Wordpress tanto en el directorio raíz de **Apache** `/var/www/html`, como en su propi directorio `/var/www/html/wordpress`.

Para ello, tendremos implementado el siguiente esquema de directorios:

``````
├── README.md
├── conf
│   └── 000-default.conf
├── htaccess
│   └── .htaccess
└── scripts
    ├── .env
    ├── install_lamp.sh
    ├── setup_letsencrypt_https.sh
    ├── deploy_wordpress_root_directory.sh    
    └── deploy_wordpress_own_directory.sh
``````
(Me ahorro explicar los pasos que hay que seguir para realizar cosas que he documentado en prácticas anteriores.)

## 1. Despliegue de Wordpress en directorio raíz

Primeramente me traeré el codigo fuente del **Wordpress** en su ultima versión, pero antes de ello **eliminaré descargas previas**:

```
rm -rf /tmp/latest.tar.gz
```

```
wget http://wordpress.org/latest.tar.gz -P /tmp
```

Despues de ello,  Descomprimimos el archivo **.tar.gz** que acabamos de descargar con el comando **tar**:

```
tar -xzvf /tmp/latest.tar.gz -C /tmp
```
Para que no se de algún tipo de conflicto se eliminarán las  instalaciones previas de **Wordpress**:

```
rm -rf /var/www/html/*
```

Y mediante el siguiente comando movemos hacia el **directorio raíz** el contenido que se descomprimió en la carpeta **Wordpress** en **/tmp**:

```
mv -f /tmp/wordpress/* /var/www/html
```

### 1.1 Creación de la base de datos y usuario para Wordpress

A continuación se crea la base de datos y el usuario, haciendo uso de las variables definidas en el **.env**:

![](images/env.png)


```
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
```