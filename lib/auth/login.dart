import 'package:ToDo/auth/register.dart';
import 'package:ToDo/todo/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _autoValidation = false;
  bool _isLoading = false;
  String _error ;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
      ),
      body: _isLoading ? _Loading(context) : _form(context),
    );
  }
  Widget _form(BuildContext context){
    return SingleChildScrollView(
      child: Padding(padding: EdgeInsets.all(36),
        child:  Form(
          autovalidate: _autoValidation,
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: "Email"
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24,),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: "Password"
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Password is required';
                  }else if(value.length<5){
                    return"Pasword must be more than 5 charcters";

                  }
                  return null;
                },
              ),
              SizedBox(height: 48,),
              Container(
                width: double.infinity,
                child: RaisedButton(onPressed:_onClickLogin,
                  child: Text("Login"),
                ),
              ),
              _errorMessage(context),
              SizedBox(height: 36,),
              Row(
                children: <Widget>[
                  Text("Don't have a account"),
                  FlatButton(onPressed:(){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>RegisterScreen()));
                  },
                      child: Text("Register"))
                ],
              )
            ],
          ),
        ),

      ),
    );
  }
  Widget _Loading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _onClickLogin() async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autoValidation = true;
      });
    } else {
      setState(() {
        _isLoading = true;
        _autoValidation = false;
      });
      FirebaseAuth.instance.
      signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).
      then((_){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      });


    }
  }
  Widget _errorMessage(BuildContext context) {
    if (_error == null) {
      return Container();
    } else {
      return Container(
        child: Text(
          _error,
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
