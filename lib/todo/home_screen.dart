import 'package:ToDo/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'new_todo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseUser _User;
  String _errorMessage;
  bool _hasError= false;
  bool _isLoading= true;

  
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser()
        .then((user){


          setState(() {
            _User=user;
            _hasError=false;
            _isLoading=false;
          });

    })
        .catchError((error){
          setState(() {
            _hasError=true;
            _errorMessage=error.toString();
          });

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ToDo List"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            //DrawerHeader(),
            ListTile(
              title: Text("LogOut"),
              trailing: Icon(Icons.exit_to_app),
              onTap: () async {
                FirebaseAuth.instance.signOut().then((_){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>LoginScreen())
                  );

                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _addToDo,
        child: Icon(Icons.add),
      ),
      body: _content(context),
    );
  }


  Widget _content(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: _isLoading ? _loading(context) : ( _hasError ? _error(context, _errorMessage) : _base(context) ),
    );
  }

  Widget _error(BuildContext context, String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  void _addToDo() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewToDo()));
  }
  Widget _base(BuildContext context){
    return StreamBuilder(
        stream: Firestore.instance.collection("todos").where("user_id" , isEqualTo: _User.uid).orderBy("done").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _error(context, "No Internet Connection ");
              break;
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasError){
                return _error(context, snapshot.error.toString());
              }
              if(!snapshot.hasData){
                return _error(context, "No data");
              }
              return _drawScreen(context, snapshot.data);
              break;
          }
        });

  }
  Widget _loading(BuildContext context){
    return Center(
      child: CircularProgressIndicator(),
    );
  }


  Widget _drawScreen(BuildContext context,QuerySnapshot data) {
    return ListView.builder(
      itemCount: data.documents.length,
        itemBuilder: (BuildContext context , int position){
        return Card(
          child: ListTile(
            title: Text(data.documents[position]["body"],
              style: TextStyle(
                decoration: data.documents[position]["done"]? TextDecoration.lineThrough : TextDecoration.none
              ),
            ),
            trailing: IconButton(icon: Icon(Icons.delete,color: Colors.red.shade300,),
                onPressed: (){ Firestore.instance.collection("todos").
                document(data.documents[position].documentID).delete(); }),
            leading: IconButton(icon: Icon(Icons.assignment_turned_in,
              color: data.documents[position]["done"] ? Colors.teal : Colors.grey.shade300,

            ),
                onPressed: (){
              Firestore.instance.collection("todos").
              document(data.documents[position].documentID).updateData({"done":true});
            }),
          ),
        );

        },
    );

  }
}
