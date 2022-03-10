import 'dart:async';
import 'dart:math';

import 'package:cholotodo/todo.dart';
import 'package:cholotodo/todo_item.dart';
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
  int itemIndex = -1;
  bool isEditing = false;

  void _addRandomItem() {
    if (controlador.text.isEmpty) {
      return;
    }
    setState(() {
      String name = controlador.text;
      var rng = Random();
      int idx = rng.nextInt(10000);
      _todos.add(Todo(id: idx, name: name, checked: false));
    });

    controlador.clear();
  }

  void _editSelectedItem() {
    if (controlador.text.isEmpty) {
      return;
    }
    
    if (itemIndex > -1) {
      String name = controlador.text;
      Todo todo = _todos[itemIndex];
      todo.name = name;
      setState(() {
        _todos[itemIndex] = todo;
      });
      itemIndex = -1;
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
            child: _myListView(context),
          )
        ],
      ),
      floatingActionButton: isEditing ? editExisButton : addNewButton,
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView(
      children: _todos.map((Todo todo, ) {

        return TodoItem(
          todo: todo,
          onTodoChanged: _handleTodoChange,
          onTodoLongPress: _handleTodoLongPress,
          onTrailIconPressed: _onTrailIconPressed,
        );
      }).toList(),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _handleTodoLongPress(Todo todo) {
    _showAlertDialog(todo);
  }

  void _showAlertDialog(Todo todo) {  // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
         Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        setState(() {
          _todos.remove(todo);
        });
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

  void _onTrailIconPressed(Todo todo) {
    setState(() {
      isEditing = true;
      itemIndex = _todos.indexOf(todo);
      controlador.text = todo.name;
    });
  }
}
