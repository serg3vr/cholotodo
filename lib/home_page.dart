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

  void _addRandomItem() {
    setState(() {
      String text = controlador.text;
      _todos.add(Todo(name: text, checked: false));
    });
    controlador.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: TextField(
              controller: controlador,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
          ),
          Expanded(
            child: _myListView(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // heroTag: "button1",
        onPressed: _addRandomItem,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView(
      children: _todos.map((Todo todo) {
        return TodoItem(
          todo: todo,
          onTodoChanged: _handleTodoChange
        );
      }).toList(),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }
}


