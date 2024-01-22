import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodoList(title: 'My todo application'),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});
  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = <Todo>[];
  final TextEditingController _textEditingController = TextEditingController();

  void _addTodoItems(String name) {
    setState(() {
      _todos.add(Todo(name: name, completed: false, id: _todos.length));
    });
    _textEditingController.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.completed = !todo.completed;
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.removeWhere((element) => element.id == todo.id);
    });
  }

  void _editTodo(String name, Todo todo) {
    setState(() {
      _todos[todo.id].name = name;
    });
    _textEditingController.clear();
  }

  Future<void> _displayDialogue() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add a todo"),
            content: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(hintText: "Type your todo"),
              autofocus: true,
            ),
            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItems(_textEditingController.text);
                },
                child: const Text("Add"),
              ),
            ],
          );
        });
  }

    Future<void> _editDialogue(Todo todo) async {
      _textEditingController.text = todo.name;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit todo"),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: "Type new todo"),
            autofocus: true,
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _editTodo(_textEditingController.text, todo);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
              todo: todo,
              onTodoChange: _handleTodoChange,
              removeTodo: _deleteTodo,
              editTodo: _editDialogue);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialogue(),
        tooltip: 'Add a todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Todo {
  Todo({required this.name, required this.completed, required this.id});
  String name;
  bool completed;
  int id;
}

class TodoItem extends StatelessWidget {
  TodoItem(
      {required this.todo,
      required this.onTodoChange,
      required this.removeTodo,
      required this.editTodo})
      : super(key: ObjectKey(todo));

  final Todo todo;
  final void Function(Todo todo) onTodoChange;
  final void Function(Todo todo) removeTodo;
  final void Function(Todo todo) editTodo;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
        color: Colors.black54, decoration: TextDecoration.lineThrough);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChange(todo);
      },
      leading: Checkbox(
        checkColor: Colors.greenAccent,
        activeColor: Colors.red,
        value: todo.completed,
        onChanged: (value) {
          onTodoChange(todo);
        },
      ),
      title: Row(children: <Widget>[
        Expanded(
          child: Text(
            todo.name,
            style: _getTextStyle(todo.completed),
          ),
        ),
        IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.edit,
            color: Colors.red,
          ),
          onPressed: () {
            editTodo(todo);
          },
        ),
        IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          alignment: Alignment.centerRight,
          onPressed: () {
            removeTodo(todo);
          },
        ),
      ]),
    );
  }
}
