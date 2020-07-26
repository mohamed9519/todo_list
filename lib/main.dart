 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ToDo/auth/login.dart';
import 'package:ToDo/todo/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Widget homeScreen = HomeScreen();
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  if(user == null){
    homeScreen= LoginScreen();
  }
  runApp(ToDoApp(homeScreen));
}

class ToDoApp extends StatelessWidget{
  final Widget home;
  ToDoApp(this.home);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      home: this.home,

    );
  }
  
}

