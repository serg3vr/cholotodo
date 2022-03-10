import 'package:cholotodo/todo.dart';
import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
    required this.onTodoLongPress,
    required this.onTrailIconPressed,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;
  final onTodoLongPress;
  final onTrailIconPressed;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      onLongPress: () {
        onTodoLongPress(todo);
      },
      leading: CircleAvatar(
        child: Text(todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
      trailing: CircleAvatar(
        child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            onTrailIconPressed(todo);
          },
        ),
      ),
    );
  }
}