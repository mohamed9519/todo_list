import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
      ),
      body: Padding(padding: EdgeInsets.all(36),
        child:  Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Your Email"
              ),
            ),
            SizedBox(height: 24,),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "password"
              ),
            ),
            SizedBox(height: 48,),
            Container(
              width: double.infinity,
              child: RaisedButton(onPressed:(){},
              child: Text("Login"),
              ),
            )
          ],
        ),

      ),
    );
  }
}
