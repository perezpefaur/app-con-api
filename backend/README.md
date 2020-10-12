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


#### **All Rooms** `GET`: `/api/v1/chatrooms``
En necesario agregar el siguiente request o el *header* `X-User-Token`.
```json
{
    "chatroom": {
        "authentication_token": TOKEN
    }
}
```

Reponse:
```json
[
    {
        "id": ROOM_ID,
        "name": ROOM_NAME,
        "description": ROOM_DESCRIPTION,
        "user_id": OWNER_ID,
        "private": ROOM_PRIVATE,
        "created_at": DATE,
        "updated_at": DATE,
        "room_code": ROOM_CODE
    },

    ...

    {
        "id": ROOM_ID,
        "name": ROOM_NAME,
        "description": ROOM_DESCRIPTION,
        "user_id": OWNER_ID,
        "private": ROOM_PRIVATE,
        "created_at": DATE,
        "updated_at": DATE,
        "room_code": ROOM_CODE
    }
]
```

#### **Show Room** `GET`: `/api/v1/chatrooms/:id`
Obtiene la información y todos los mensajes de la sala de id `:id`. Es necesario enviar credenciales y solo aceptará el request si el usuario es miembro de la sala.

Request:
```json
{
    "chatroom": {
        "authentication_token": TOKEN
    }
}
```

Response:
```json
{
    "room": {
        "id": ROOM_ID,
        "name": ROOM_NAME,
        "description": ROOM_DESCRIPTION,
        "user_id": OWNER_ID,
        "private": ROOM_PRIVATE,
        "created_at": DATE,
        "updated_at": DATE,
        "room_code": ROOM_CODE
    },
    "messages": [
        {
            "body": MSG_BODY,
            "user": USER_NICKNAME,
            "date": [DAY, MONTH, YEAR, HOURS, MINUTES],
            "isMe": BOOL,
            "system": BOOL
        },

        ...
        
        {
            "body": MSG_BODY,
            "user": USER_NICKNAME,
            "date": [DAY, MONTH, YEAR, HOURS, MINUTES],
            "isMe": BOOL,
            "system": BOOL
        }
    ]
}
```

Bad response:
```json
{
   "status": "No se ha podido acceder a la sala." 
}
```


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

#### **Join Room** `POST`: `api/v1/chatrooms/join``
Unirse a la sala de id `:id`.
```json
{
    "chatroom": {
        "authentication_token": TOKEN,
        "room_code": ROOM_CODE
    }
}
```

Reponse:

```json
{
    "room": {
        "id": ROOM_ID,
        "name": ROOM_NAME,
        "description": ROOM_DESCRIPTION,
        "user_id": OWNER_ID,
        "private": ROOM_PRIVATE,
        "created_at": DATE,
        "updated_at": DATE,
        "room_code": ROOM_CODE
    },
    "messages": [
        {
            "body": MSG_BODY,
            "user": USER_NICKNAME,
            "date": [DAY, MONTH, YEAR, HOURS, MINUTES],
            "isMe": BOOL,
            "system": BOOL
        },

        ...
        
        {
            "body": MSG_BODY,
            "user": USER_NICKNAME,
            "date": [DAY, MONTH, YEAR, HOURS, MINUTES],
            "isMe": BOOL,
            "system": BOOL
        }
    ]
}
```


#### **Room Messages** `GET`: `/api/v1/chatrooms/:id/messages`
Obtiene todos los mensajes de la sala de id `:id`. Es necesario enviar credenciales y solo aceptará el request si el usuario es miembro de la sala.

Request:
```json
{
    "authentication_token": TOKEN
}
```

Respoonse
```json
{
    "messages": [
        {
            "body": MSG_BODY,
            "user": USER_NICKNAME,
            "date": [DAY, MONTH, YEAR, HOURS, MINUTES],
            "isMe": BOOL,
            "system": BOOL
        },

        ...

        {
            "body": MSG_BODY,
            "user": USER_NICKNAME,
            "date": [DAY, MONTH, YEAR, HOURS, MINUTES],
            "isMe": BOOL,
            "system": BOOL
        }
    ],
    "status": 200
}
```


#### **Send Message** `POST`: `/api/v1/chatrooms/:id/messages`
Envía un mensaje a la sala de id `:id`. Es necesario enviar credenciales y solo aceptará el request si el usuario es miembro de la sala.

Request:
```json
{
    "authentication_token": TOKEN,
    "message": {
        "body": MSG_BODY
    }
}
```

Response:
```json
{
    "message": {
        "body": MSG_BODY,
        "username": USER_NICKNAME,
        "date": [DAY, MONTH, YEAR, HOURS, MINUTES],
    },
    "status": 200
}
```

BAD resonse:
```json
{
    "status": 400,
    "error": "Invalid room ID"
}
```

```json
{
    "status": 401,
    "error": "Invalid Credentials"
}
```

---

## Caché

EL uso de caché para esta entrega se implementó mediante el servicio de AWS ElastiCache con un cluster de Redis. Lo implementamos de esta forma para asegurar una escalabilidad, aprovechar su buen desempeño y simplificar la carga en la administración, monitoreo y el funcionamiento de la memoria, enfocandonos en la parte del desarrollo únicamente. Todo esto fue investigado desde su [página](https://aws.amazon.com/es/elasticache/) para una mejor elección.

Esta tecnología fue implementada en el desarrollo utilizando Redis instalado localmente, pero que al momento de pasar a producción, este se conecte al servicio ElastiCache con el cluster de Redis estando dentro de un mismo grupo de seguridad (y VPN). Con esto nos conectamos a su *Primary Endpoint* para ser utilizado.

### Publisher/Suscriber
En una primera instancia se implementó ElastiCache para Redis como un estándar **Pub/Sub** para chat y mensajería, que en este caso permitía la transmición de los mensajes en tiempo real y la intercomunicación entre servidores. Esto se hace mediante una configuración *FIFO*, pero que no es garantizada, ya que sigue el [protocolo de Redis](https://redis.io/topics/pubsub) específicamente. Este se usó como consecuencia directa del querer realizar un chat en tiempo real, donde esta configuración nos permitía asociar a un usuario como receptor de las nuevas publicaciones (mensajes) que se vayan enviando. 