import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/models/log_in_api.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class signupScreen extends StatefulWidget {
  @override
  _signupScreenState createState() => _signupScreenState();
}

class _signupScreenState extends State<signupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _nickname;
  String _password;
  String _passwordconfirmation;

  _submit() {
    // Acá estamos revisando el input del usuario
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      dynamic session = createSession(_email, _password);
      print("IGO");
      print(session);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(session: session,),
        ),
      );
    }
  }

  _return() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Guatsap',
              style: TextStyle(fontSize: 50.0),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 300.0,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 15.0,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Nickname'),
                            validator: (input) =>
                            input.length < 3
                                ? 'The password must have 3 characters'
                                : null,
                            onSaved: (input) => _nickname = input,
                            obscureText: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 15.0,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Email'),
                            validator: (input) =>
                            !input.contains('@')
                                ? 'Please enter a valid email'
                                : null,
                            onSaved: (input) => _email = input,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 15.0,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            validator: (input) =>
                            input.length < 6
                                ? 'The password must have 6 characters'
                                : null,
                            onSaved: (input) => _password = input,
                            obscureText: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 15.0,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Password Confirmation'),
                            validator: (input) =>
                            input == _password
                                ? 'The passwords must match'
                                : null,
                            onSaved: (input) => _passwordconfirmation = input,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: _submit,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Create User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
