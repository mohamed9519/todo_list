import 'package:ToDo/auth/login.dart';
import 'package:ToDo/todo/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController= TextEditingController();
  TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _autoValidation = false;
  bool _isLoading = false;
  String _error ;




  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create New Account"),
      ),
      body: _isLoading ? _Loading(context) : _form(context) ,
    );
  }
  Widget _form(BuildContext context){
    return SingleChildScrollView(
      child: Padding(padding: EdgeInsets.all(36),
        child: Form(
          autovalidate: _autoValidation,
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: "Name"
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24,),
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
              SizedBox(height: 24,),
              TextFormField(
                obscureText: true,
                controller: _confirmpasswordController,
                decoration: InputDecoration(
                    hintText: "Confirm password"
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Confirmation password is required';
                  }else if(_passwordController.text!=_confirmpasswordController.text){
                    return"password is not matched";
                  }
                  return null;
                },

              ),
              SizedBox(height: 36,),
              Container(
                width: double.infinity,
                child: RaisedButton(onPressed: _onClickRegister,
                  child: Text("Register"),
                ),
              ),
              SizedBox(height: 24,),
              _errorMessage(context),
              Row(
                children: <Widget>[
                  Text("Have a account ?"),
                  FlatButton(onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
                  },
                      child: Text("Login"))
                ],
              )
            ],
          ),
        ),

      ),
    );

  }
  Widget _Loading(BuildContext context){
    return Center(
      child: CircularProgressIndicator(),
    );
  }


  void _onClickRegister() async{
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autoValidation=true;
      });
    }else{
      setState(() {
        _isLoading = true;
        _autoValidation=false;
      });

      FirebaseAuth.
      instance.
      createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)
      .then((authResult){
        Firestore.instance.collection("porfile").document().setData({
          "name" : _nameController.text,
          "user_id" : authResult.user.uid
        }).then((_){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
        }).catchError((error){
          setState(() {
            _isLoading= false;
            _error=error.toString();
          });
        });

      })
      .catchError((error){
        setState(() {
          _isLoading= false;
          _error=error.toString();
        });
      });


    }
  }

  Widget _errorMessage(BuildContext context){
    if(_error==null){
      return Container();
    }else{
      return Container(
        child: Text(_error, style: TextStyle(color: Colors.red),),
      );
    }

  }
}
