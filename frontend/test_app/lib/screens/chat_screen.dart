import 'package:flutter/material.dart';
import 'package:test_app/models/user_model.dart';

class ChatScreen extends StatefulWidget {

  final User user; // Aca le vamos a pasar el chatroom id

  ChatScreen({this.user});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
