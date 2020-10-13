import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/models/log_in_api.dart';
import 'package:test_app/screens/home_screen.dart';
import 'package:test_app/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

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

  _signup(){
    //Redirigimos a sign up
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => signupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 30.0,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (input) => !input.contains('@')
                          ? 'Please enter a valid email'
                          : null,
                      onSaved: (input) => _email = input,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 30.0,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (input) => input.length < 6
                          ? 'The password must have 6 characters'
                          : null,
                      onSaved: (input) => _password = input,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: _submit,
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: _signup,
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Sign Up',
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
