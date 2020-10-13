import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Session> createSession(String email, String password) async {
  final http.Response response = await http.post(
    'http://api.textgram.gq//api/v1/users/sign_in',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Map<String, String>>{
      "v1_user": {"email": email, "password": password}
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Session.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw  Exception('Failed to load user');
  }
}

class Session {
  final int id;
  final String email;
  final String nickname;
  final String created;
  final String updated;
  final String token;

  Session(
      {this.id,
      this.email,
      this.nickname,
      this.created,
      this.updated,
      this.token});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      created: json['created_at'],
      updated: json['updated_at'],
      token: json['authentication_token'],
    );
  }
}
