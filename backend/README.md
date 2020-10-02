# README APP-WEB E0

## Configuraciones

Al clonar el repositorio e iniciar la aplicación por primeroa vez, se deben considerar las siguientes configuraciones.

* Crear el archivo de entrono `.env` con los siguientes parámetros:
    * DB_HOST=db
    * DB_NAME=postgres
    * DB_USERNAME={completar}
    * DB_PASSWORD={completar}
    * REDIS_URL=redis://redis:6379
    * RAILS_SERVE_STATIC_FILES=true
    * RAILS_ENV={completar}

* Agregar la llave `master.key` en `config/` para la aplicación RAILS.
* Montar la aplicación con `docker-compose build`.
* Crear la base de datos con `docker-compose run web rails db:create`.
* Iniciar la aplicacion con `docker-compose up`.

## Imágenes de Docker

Esta aplicación se compone de tres imágenes:
### DB

Imágen conrrespondiente a la base de datos POSTGRES. Para ella es necesario la configuración de las variables de entorno antes mencionadas.
* Puerto: 5432

### WEB

Corresonde a la imágen de la apliciación web en RAILS. Depende de la imágen DB para su funcionamiento.
* Puerto: 3000
* Dependencias: DB

### DNS

Imagén con NGINX que permite el direccionamiento desde los puertos HTTP (80) y HTTPS (443) hacia la aplicación RAILS (3000).
* Puertos: 80 - 443
* Dependencias: WEB -> DB
