import 'dart:async';
import 'dart:math';

import 'package:cholotodo/todo.dart';
import 'package:cholotodo/todo_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controlador = TextEditingController();
  final List<Todo> _todos = <Todo>[];
  String itemDocId = '';
  bool isEditing = false;
  final _fireStore = FirebaseFirestore.instance;

  void _addRandomItem() {
    if (controlador.text.isEmpty) {
      return;
    }

    _fireStore.collection('items').add({
      'title': controlador.text,
      'descripcion': controlador.text,
      'timestamp': Timestamp.now()
    });

    controlador.clear();
  }

  void _deleteItem(String documentId) {
    _fireStore.collection('items').doc(documentId).delete();
  }

  void _editSelectedItem() {
    if (controlador.text.isEmpty) {
      return;
    }
    
    if (itemDocId.isNotEmpty) {
      String title = controlador.text;
      Map<String, Object> asd = {
        'title': title,
        'descripcion': title,
      };
      _fireStore.collection('items').doc(itemDocId).update(asd).then((value) {
        itemDocId = '';
      });

      isEditing = false;
      controlador.clear();
    }

  }

  @override
  Widget build(BuildContext context) {
    FloatingActionButton addNewButton = FloatingActionButton(
      onPressed: _addRandomItem,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
    FloatingActionButton editExisButton = FloatingActionButton(
      onPressed: _editSelectedItem,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: TextField(
              controller: controlador,
              decoration: const InputDecoration(
                hintText: 'Ingrese el título',
                contentPadding: EdgeInsets.all(8.0)
              ),
            ),
          ),
          Expanded(
            // child: _myListView(context),
            child: StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('items').orderBy('timestamp', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Has errors');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                
                final List<QueryDocumentSnapshot> list = snapshot.data?.docs ?? [];
                return _myList(list);
              }
            )
          )
        ],
      ),
      floatingActionButton: isEditing ? editExisButton : addNewButton,
    );
  }

  ListView _myList(List<dynamic> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final QueryDocumentSnapshot item = list[index];
        
        String date = '';
        bool containsData = (item.data() as Map<String,dynamic>).containsKey('timestamp');
        if (containsData) {
          // date = item['timestamp'].toString();
          Timestamp tm = item['timestamp'];
          date = tm.toDate().toString();
        } else {
          date = '';
        }
        
        String docId = item.id;
        return ListTile(
          title: Text(item['title']),
          subtitle: Text(date),
          onLongPress: () {
            _showAlertDialog(docId);
          },
          trailing: CircleAvatar(
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _onTrailIconPressed(item);
              },
            ),
          ),
        );
      }
    );
  }

  // TODO -  Convertir funcion en asincrona y esperar verdad o falso para continua operacion
  void _showAlertDialog(String documentId) {  // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
         Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        _deleteItem(documentId);
        Navigator.of(context).pop();
      },
    );  // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );  // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onTrailIconPressed(QueryDocumentSnapshot item) {
      isEditing = true;
      itemDocId = item.id;
      setState(() {
        controlador.text = item['title'];
      });
  }
}
