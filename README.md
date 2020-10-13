# IIC2173 - Entrega 1 - Levantando clusters hechos por estudiantes de arquitectura de sistemas de software

Esta segunda parte del proyecto sirve para que conozcan e implementen herramientas para tener escalabilidad y performance en sus aplicaciones. Para esto, cada grupo debe escoger una E0 de los integrantes de su grupo y trabajar desde ahí o implementar una nueva que cumpla con los requisitos de la E0 (poco recomendado). Eventualmente pueden complementar su solución entre los conocimientos aprendidos por todos los integrantes durante esa primera entrega. 

## Objetivo

La entrega tiene por objetivo separar el frontend del backend del chat. Para esto se implementará una *Content Delivery Network* (CDN) y se desacomplarán los servicios utilizando endpoints mediante HTTP.

---
---

# Entregable Grupo 3

## Consideraciones generales
Esta aplicación fue hecha mediante una App móvil en Flutter, conectada a una Api hecha en Rails. La Api y toda la configuración del backend se encuentra deployeada mediante los servidores de AWS, y para ocupar la App se debe correr el código desde Android Studio conectado con un celular o usando un emulador.

Además de esto, también debemos mencionar que no logramos redireccionar de HTTP a HTTPS, pero que estos se encuentran como puertos distintos en un mimsmo servidor, con una conexión interna sin redireccionar, el cuál se usa para la configuración de los *Endpoints*.

## Logrado y no logrado

### Sección mínima

* **Backend RF1**: Logrado. Se pueden enviar mensajes, recibirlos y se registra su timestamp. Se muestran en tiempo real.
* **Backend RF2**: Logrado. Se exponen endpoints HTTP que realizan el procesamiento del chat. Su documentación se encuentra en la carpeta `/backend`.
* **Backend RF3**: Semi logrado. Se implementó un *Load Balancer*, pero no añadimos un header. 
* **Backend RF4**: Logrado. El servidor tiene un nombre de primer nivel y se puede acceder a el como [textgram.gq](http://www.textgram.gq/).
* **Backend RF4**: Semi logrado. El dominio está asegurado por un servicio de certificados de AWS, pero no redirige HTTP a HTTPS.
* **Frontend RF5**: Logrado. Se utiliza un CDN para exponer un *asset* público del frontend. Se usó *cludfront* con S3.
* **Frontend RF6**: Logrado. Relizamos una app móvil para frontend con flutter. Hace los llamados al servidor correctamente.

### Sección variable
* **Caché RF1**: Logrado. Se levanta la infraestructura mediante el servicio ElastiCache con un cluster Redis de AWS. Se menciona el funcionamiento más abajo.
* **Caché RF2**: Logrado. Se usa la herramienta de caché como *pub/sub* y como *session store*. Cada una con una configuración distinta mencionada más abajo.
* **Caché RF3**: Logrado. La documentación se encuentra más abajo.
* **Mensajes en tiempo real RF1**: Logrado. Se actualizan los mensajes en tiempo real sin refrescar la página.
* **Mensajes en tiempo real RF2**: Logrado. Se le envía una notificación al usuario.
* **Mensajes en tiempo real RF3**: Logrado. La documentación se encuentra más abajo.


## Caché
EL uso de caché para esta entrega se implementó mediante el servicio de AWS ElastiCache con un cluster de Redis. Lo implementamos de esta forma para asegurar una escalabilidad, aprovechar su buen desempeño y simplificar la carga en la administración, monitoreo y el funcionamiento de la memoria, enfocandonos en la parte del desarrollo únicamente. Todo esto fue investigado desde su [página](https://aws.amazon.com/es/elasticache/) para una mejor elección.

Esta tecnología fue implementada en el desarrollo utilizando Redis instalado localmente, pero que al momento de pasar a producción, este se conecte al servicio ElastiCache con el cluster de Redis estando dentro de un mismo grupo de seguridad (y VPN). Con esto nos conectamos a su *Primary Endpoint* para ser utilizado.

### Publisher/Suscriber
En una primera instancia se implementó ElastiCache para Redis como un estándar **Pub/Sub** para chat y mensajería, que en este caso permitía la transmición de los mensajes en tiempo real y la intercomunicación entre servidores. Esto se hace mediante una configuración *FIFO*, pero que no es garantizada, ya que sigue el [protocolo de Redis](https://redis.io/topics/pubsub) específicamente. Este se usó como consecuencia directa del querer realizar un chat en tiempo real, donde esta configuración nos permitía asociar a un usuario como receptor de las nuevas publicaciones (mensajes) que se vayan enviando. 

### Session Store
Utilizamos el caché en un segundo caso de uso como **Redis-backend session storage**. Esto lo utilizamos mediante una configuración de almacenamiento *hash*, para guardar la variable de sesión ya instanciada. Esta configuración la utilizamos para mejorar el control que tenemos sobre las *cookies* como variables de sesión, lo que esto puede permitir a futuro el poder compartir sesiones entre aplicaciones como incluso manejar la información del usuario que llegue después, según la [guía e información](https://medium.com/@kirill_shevch/configuration-cache-and-rails-session-store-with-redis-b3ce6f64d1fc). Además de esto, decidimos utilizarla para mejorar escalabilidad y eficiencia de la conexión entre distintas páginas, la Api y el frontend.


## Chat en tiempo real
Para la implementación de un chat en tiempo real, se utilizó ActionCable de Rails conectado a nuestro servidor de Redis mencionado en el punto anterior. Esa conexión se hace en parte del cliente y el servidor mediante una suscripción a los diferentes canales (canal único por sala de chat). Aquí se emplea un estilo Pub/Sub donde los usuarios se suscriben a los canales según entran a las salas de chat y reciben actualizaciones en base a los mensajes que envíen los demás usuarios. Además, cada usuario cuenta con un canal propio para el envío de notificaciones (en caso de menciones).
Toda la conexión entre clientes y servidor para la recepción de mensajes en tiempo real se hace mediante WebSockets de forma segura (`wss`).

### Limitaciones y restricciones
En general este tipo de estilos de arquitectura suelen ser bastante ventajosos al momento de crear envíos masivos y rápidos de información a distintos recpetores. Pero esto es más eficiente cuando hay muchos canales con un número moderado de suscriptores. Una vez que los canales se comienzan a llenar, la eficiencia del mecanismo comienza a decaer debido a la cantidad de receptores a los que hay que enviar información. Esto quiere decir que este mecanismo debido a la forma "paralela" de operar, puede ser un pcoo más dificil y cosotos (de recursos) de  escalar.

---
---

## Fecha límite

Debe ser entregada a más tardar a las 23:59 del domingo 11 de Octubre. Las condiciones de entrega están explicadas más abajo. De ser entregada el día lunes 12 de Octubre se obtendrá nota máxima 6.0.

### Método de entrega

Para esta entrega, deberan hacer una *demo* de 10-15 minutos acerca de lo que hicieron en la entrega y que al menos un tercio del grupo exponga sobre la solución. Se les pedirá mostrar su trabajo en la consola del servicio cloud y pruebas de usabilidad. Se les avisarán las fechas disponibles (es la semana entre entregas) y algunas pruebas obligatorias que deben hacer para evaluar la correctitud de su solución.

Deben subir el código de su solución (hasta donde aplique) en el repositorio que se les asignará vía github classroom a cada grupo. Deben inscribirse en el siguiente link

https://classroom.github.com/g/9f2h5kYm

Primero entra un miembro a crear el grupo y luego los demás pueden entrar a ese grupo. **Ojo con que entren al grupo correcto, puesto que es difícil cambiarlos.** 
Si se crean dos grupos con el mismo nombre, habra una penalizacion al grupo que se creo después.
También deben entregar el archivo .pem asociado al servidor EC2 para revisarla. Alternativamente pueden indicarnos para su disponibilidad para incorporarnos (ayudantes) a su lista de "_authorized_keys_". 

Además, para poder facilitar la corrección deben realizar un README.md que señale:

- Consideraciones generales
- Método de acceso al servidor con archivo .pem y _ssh_ (no publicar estas credenciales en el repositorio). 
- Logrado o no logrado y comentarios si son necesarios para cada aspecto a evaluar en la Parte mínima y en la Parte variable.
- De realizar un tercer requisito variable también explicitar en el readme.

Pueden sobreescribir este README sin problemas o cambiarle el nombre.

## Requisitos
Esta entrega consiste en dos partes, la parte mínima (que todos deben lograr) que vale **50%** de la nota final y una parte variable que también vale **50%**. Sobre la parte variable, tendrán 3 opciones para trabajar, de las que deberán escoger 2. Cada una de las que escojan para evaluar vale **25%** de la nota final, y realizar una tercera parte puede dar hasta 3 décimas.

---

## Parte mínima

### Sección mínima (50%) (30p)

#### **Backend**
* **RF1: (3p)** Se debe poder enviar mensajes y se debe registrar su timestamp. Estos mensajes deben aparecer en otro usuario, ya sea en tiempo real o refrescando la página. **El no cumplir este requisito completamente limita la nota a 3.9**
* **RF2: (5p)** Se deben exponer endpoints HTTP que realicen el procesamiento y cómputo del chat para permitir desacoplar la aplicación. **El no cumplir este requisito completamente limita la nota a 3.9**

* **RF3: (7p)** Establecer un AutoScalingGroup con una AMI de su instancia EC2 para lograr autoescalado direccionado desde un ELB (_Elastic Load Balancer_).
    * **(4p)** Debe estar implementado el Load Balancer
    * **(3p)** Se debe añadir al header del request información sobre cuál instancia fue utilizada para manejar el request. Se debe señalar en el Readme cuál fue el header agregado.
* **RF4: (2p)** El servidor debe tener un nombre de dominio de primer nivel (tech, me, tk, ml, ga, com, cl, etc).

* **RF4: (3p)** El dominio debe estar asegurado por SSL con Let's Encrypt. No se pide *auto renew*. Tambien pueden usar el servicio de certificados de AWS para el ELB
    * **(2p)** Debe tener SSL. 
    * **(1p)** Debe redirigir HTTP a HTTPS.

#### **Frontend**
* **RF5: (3p)** Utilizar un CDN para exponer los *assets* de su frontend. (ej. archivos estáticos, el mismo *frontend*, etc.). Para esto recomendamos fuertemente usar cloudfront en combinacion con S3.
* **RF6: (7p)** Realizar una aplicación para el *frontend* que permita ejecutar llamados a los endpoints HTTP del *backend*.
    * **(3p)** Debe hacer llamados al servidor correctamente.
    * Elegir **$1$** de los siguientes. No debe ser una aplicación compleja en diseño. No pueden usar una aplicacion que haga rendering via template de los sitios web. Debe ser una app que funcione via endpoints REST
        * **(4p)** Hacer una aplicación móvil (ej. Flutter, ReactNative)
        * **(4p)** Hacer una aplicación web (ej. ReactJS, Vue, Svelte)

---

## Sección variable

Deben completar al menos 2 de los 3 requisitos

### Caché (25%) (15p)
Para esta sección variable la idea es implementar una capa de Caché para almacenar información y reducir la carga en el sistema. Para almacenar información para la aplicación recomendamos el uso de **Redis**, así como recomendamos Memcached para fragmentos de HTML o respuestas de cara al cliente. 

* **RF1: (4p)** Levantar la infraestructura necesaria de caché. Se puede montar en otra máquina o usando el servicios administrado por AWS. Se debe indicar como funciona en local y en producción. 
* **RF2: (6p)** Utilizar la herramienta seleccionada de caché para almacenar las información para al menos 2 casos de uso. Por ejemplo las salas y sus últimos mensajes o credenciales de acceso (login). 
    * **Restricción** Por cada caso de uso debe utilizar alguna configuración distinta (reglas de entrada FIFO/LIFO, estructura de datos o bien el uso de reglas de expiración)
* **RF3: (5p)** Documentar y explicar la selección de la tecnología y su implementación en el sistema. Responder a preguntas como: "¿por qué se usó el FIFO/LRU o almacenar un hash/list/array?" para cada caso de uso implementado. 


### Trabajo delegado (25%) (15p)
Para esta sección de delegación de trabajo recomendamos el uso de "Functions as a Service" como el servicio administrado de AWS, _Lambda Functions_, o bien el uso de más herramientas como AWS SQS y AWS SNS. 

Se pide implementar al menos **3 casos de uso con distinto tipo de integración**.


1.- Mediante una llamada web (AWS API Gateway)
2.- Mediante código incluyendo la librería (sdk)
3.- Como evento a partir de una regla del AutoScalingGroup
4.- Mediante Eventbridge para eventos externos (NewRelic, Auth0 u otro)
5.- Cuando se esté haciendo un despliegue mediante CodeCommit 
6.- Cuando se cree/modifique un documento a S3

Alternativamente pueden integrar más servicios para realizar tareas más lentas de la siguiente forma: 
1.- Al crear un mensaje se registra en una cola (SQS) que llama a una función en lambda (directamente o a través de SNS)
2.- En Lambda se analiza ciertos criterios (si es positivo o negativo, si tiene "garabatos" o palabras prohibidas en el chat) y con este resultado se "taggea" el comentario. 
Si se crean en "tópics" distintos se consideran como 2 casos de uso (por el uso de distintas herramientas). 

Seguir el siguiente tutorial cuenta como 3 (https://read.acloud.guru/perform-sentiment-analysis-with-amazon-comprehend-triggered-by-aws-lambda-7363db23651f o https://medium.com/@manojf/sentiment-analysis-with-aws-comprehend-ai-ml-series-454c80a6114). No es necesaro que entiendan a cabalidad como funciona el código de estas funciones, pero sí que comprendan el flujo de la información y cómo es que se ejecuta.

Se deben documentar las decisiones tomadas. 

* **RF: (5p)** Por cada uno de los 3 tipos de integración.
    * **(3p)** Por la implementación.
    * **(2p)** Por la documentación.

### Mensajes en tiempo real (25%) (15p)
El objetivo de esta sección es implementar la capacidad de enviar actualizaciones hacia otros servicios. Servicios recomendados a utilizar: SNS, Sockets (front), AWS Pinpoint entre otras. 

* **RF1: (5p)** Cuando se escriben mensajes en un chat/sala que el usuario está viendo, se debe reflejar dicha acción sin que éste deba refrescar su aplicación. 
* **RF2: (5p)** Independientemente si el usuario está conectado o no, si es nombrado con @ o # se le debe enviar una notificación (al menos crear un servicio que diga que lo hace, servicio que imprime "se está enviando un correo")
* **RF3: (5p)** Debe documentar los mecanismos utilizados para cada uno de los puntos anteriores indicando sus limitaciones/restricciones. 


#### Caso borde
Si su grupo implementó varias funcionalidades como comandos en los chats, es posible utilizar dichas funciones en Lambdas y manejarlas en paralelo utilizando SQS y SNS en conjunto. Pueden aprovechar su desarrollo para implementar las secciones variables 2 y 3 en conjunto.


---
