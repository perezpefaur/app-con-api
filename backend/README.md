# README APP-WEB E0

## Configuraciones

Al clonar el repositorio e iniciar la aplicación por primeroa vez, se deben considerar las siguientes configuraciones.

* Crear el archivo de entrono `.env` con los siguientes parámetros:
```env
DB_HOST=db
DB_NAME=postgres
DB_USERNAME=postgres
DB_PASSWORD=docker
REDIS_URL=redis://redis:6379
RAILS_SERVE_STATIC_FILES=true
RAILS_ENV={completar}
```

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

---

## API Endpoints

### Users `/api/v1/users`

Estos endpoint sirven para crear usuario o iniciar y cerrar sesión con los `TOKEN` obtenidos.
Todos los request que necesiten autenticación para su funcionamiento, deberán incluir en el request lo siguiente: 
```json
"v1_user": {
    "authentication_token": TOKEN
}
```
o en el header `X-User-Token` con el valor `TOKEN`.

Donde `TOKEN` es el token obtenido al iniciar sesión o crear el usuario.

---

#### **Sing Up** `POST`: `/api/v1/users`
Registro con el siguiente requests
```json
{
    "v1_user": {
        "email": EMAIL,
        "nickname": NICKNAME,
        "password": PASSWORD,
        "password_confirmation": PASSWORD
    }
}
```
Response:
```json
{
    "errors": [ ERROR, ERROR]
}
```
```json
{
    "account": {
        "id": ID,
        "email": EMAIL,
        "nickname": NICKNAME,
        "created_at": DATE,
        "updated_at": DATE,
        "authentication_token": TOKEN

    }
}
```

#### **Update** `PATCH`: `/api/v1/users`
Para editar los datos del usuario, se utiliza el siguiente request:
```json
{
    "v1_user": {
        "email": NEW_EMAIL,
        "nickname": NEW_NICKNAME,
        "new_password": NEW_PASSWORD,
        "password_confirmation": NEW_PASSWORD,
        "authentication_token": TOKEN
    }
}
```
Acá solo se deben incluir los atributos que se quieran modificar.
El `TOKEN` puede ir como un atributo o en el header como se expresó anteriormente.

#### **Log In** `POST`: `/api/v1/users/sign_in`
Inicio de sesión con el siguiente request
```json
{
    "v1_user": {
        "email": EMAIL,
        "password": PASSWORD
    }
}
```

Responses:
```json
{
    "error": "Invalid Email or password."
}
```

```json
{
    "account": {
        "id": ID,
        "email": EMAIL,
        "nickname": NICKNAME,
        "created_at": DATE,
        "updated_at": DATE,
        "authentication_token": TOKEN

    }
}
```



#### **Log Out** `DELETE`: `/api/v1/users/sign_out`
Cierre de sesión con el siguiente request
```json
{
    "v1_user": {
        "authentication_token": TOKEN
    }
}
```
O un request vacío con el header`X-User-Token=TOKEN`.

Response:
```json
{
    "error": "Invalid Credentials"
}
```
O un response `204` vacío cuando el cierre de sesión fue correcto.


#### **Create Room** `POST`: `/api/v1/chatrooms`
Crear una sala con el siguiente request
```json
{
    "chatroom" :
    {
        "authentication_token": TOKEN,
        "name" : NAME ,
        "private" : BOOL,
        "description" : DESCRIPTION
   }
}
```

Responses:

```json
{
    "id": ID,
    "name": NAME,
    "description": DESCRIPTION,
    "user_id": USER_ID,
    "private": BOOL,
    "created_at": DATE,
    "updated_at": DATE,
    "room_code": ROOM_CODE
}
```