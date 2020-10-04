import 'dart:core';

import 'package:test_app/models/user_model.dart';

class Message {
  final User sender;
  final String time; // puede ser date time
  final String text;

  Message({
    this.sender,
    this.time,
    this.text,
  });
}

// current user (tu mismo)
final User currentUser = User(
  id: 0,
  name: 'Grupo 3',
);

// Usuarios
final User perecic = User(
  id: 1,
  name: 'Perecic'
);
final User gerardo = User(
    id: 2,
    name: 'Gerardo'
);
final User lucas = User(
    id: 3,
    name: 'Lucas'
);
final User igo = User(
    id: 4,
    name: 'Igo'
);
final User ian = User(
    id: 5,
    name: 'Ian'
);

// Contactos favoritos (despues lo podemos cambiar a chat rooms)
List<User> favorites = [perecic, gerardo, lucas, igo, ian];

// Mensajes en el inicio
List<Message> chats = [
  Message(
    sender: perecic,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
  Message(
    sender: gerardo,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
  Message(
    sender: lucas,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
  Message(
    sender: igo,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
  Message(
    sender: ian,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
];

// Mensajes en el chat
List<Message> messages = [
  Message(
    sender: perecic,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
  Message(
    sender: gerardo,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
  Message(
    sender: lucas,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
  Message(
    sender: igo,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
  Message(
    sender: ian,
    time: '5:30 PM',
    text: 'Hola, que tal?',
  ),
  Message(
    sender: perecic,
    time: '5:30 PM',
    text: 'Que pasa loco',
  ),
];