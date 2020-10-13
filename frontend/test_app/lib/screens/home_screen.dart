import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/models/log_in_api.dart';
import 'package:test_app/widgets/category_selector.dart';
import 'package:test_app/widgets/recent_chats.dart';
import 'package:test_app/widgets/rooms_favoritas.dart';

class HomeScreen extends StatefulWidget{
  final Session session;

  HomeScreen({this.session});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {} ,
        ),
        title: Text(
          'Hello ${widget.session.nickname}',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {} ,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          CategorySelector(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  RoomsFavoritas(),
                  RecentsChats(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}