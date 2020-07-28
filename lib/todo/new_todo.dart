import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewToDo extends StatefulWidget {
  @override
  _NewToDoState createState() => _NewToDoState();
}

class _NewToDoState extends State<NewToDo> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidation = false;
  bool _isLoading = false;
  TextEditingController _todoController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("NEW TODO"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _newToDo,
        child: Icon(Icons.save),
      ),
      body: _isLoading ? _Loading(context) : _form(context),
    );
  }

  Widget _Loading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _form(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(padding: EdgeInsets.all(36),
        child: Form(
            key: _formKey,
            autovalidate: _autoValidation,

            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _todoController,
                  decoration: InputDecoration(
                      hintText: "Enter todo"
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                )
              ],
            )),
      ),
    );
  }

  void _newToDo() async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autoValidation = true;
      });
    } else {
      setState(() {
        _isLoading = true;
        //_autoValidation=false;
      });
      FirebaseAuth.instance.currentUser().then((user) {
        Firestore.instance.collection("todos").document().setData({
          "body": _todoController.text,
          "done" : false,
          "user_id": user.uid
        }).then((_) {
          Navigator.of(context).pop();
        });
      });
    }
  }
}
