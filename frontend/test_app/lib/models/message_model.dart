import 'dart:core';

import 'package:test_app/models/user_model.dart';

class Message {
  final User sender;
  final String time; // puede ser date time
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
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
    unread: true,
  ),
  Message(
    sender: gerardo,
    time: '5:30 PM',
    text: 'Hola, que tal?',
    unread: true,
  ),
  Message(
    sender: lucas,
    time: '5:30 PM',
    text: 'Hola, que tal?',
    unread: true,
  ),
  Message(
    sender: igo,
    time: '5:30 PM',
    text: 'Hola, que tal?',
    unread: false,
  ),
  Message(
    sender: ian,
    time: '5:30 PM',
    text: 'Hola, que tal?',
    unread: true,
  ),
];

// Mensajes en el chat
List<Message> messages = [
  Message(
    sender: perecic,
    time: '7:00 PM',
    text: 'Me eché el ramo',
    unread: true,
  ),
  Message(
    sender: gerardo,
    time: '5:52 PM',
    text: 'La API también grande cabros',
    unread: true,
  ),
  Message(
    sender: lucas,
    time: '5:50 PM',
    text: 'Quedo pulenta la interfaz',
    unread: true,
  ),
  Message(
    sender: igo,
    time: '5:40 PM',
    text: 'Que es esto',
    unread: false,
  ),
  Message(
    sender: ian,
    time: '5:36 PM',
    text: 'Hola, que tal?',
    unread: true,
  ),
  Message(
    sender: perecic,
    time: '5:30 PM',
    text: 'Que pasa loco',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '5:20 PM',
    text: "Buena grupo 3, se sacaron un 7",
    unread: false,
  ),
];