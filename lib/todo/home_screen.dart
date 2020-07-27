import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'new_todo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ToDo List"),
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
      padding: EdgeInsets.all(36),
      child: StreamBuilder(
          stream: Firestore.instance.collection("todos").snapshots(),
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
          }),
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

  Widget _drawScreen(BuildContext context,QuerySnapshot data) {
    return ListView.builder(
      itemCount: data.documents.length,
        itemBuilder: (BuildContext context , int position){
        return ListTile(
          title: Text(data.documents[position]["body"]),
        );

        },
    );

  }
}
