import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_todo_app/domain/entities/todo.dart';
import '../viewmodels/todo_viewmodel.dart';
import 'add_todo_page.dart';

class TodoPage extends StatefulWidget {
  final TodoViewModel viewModel;

  const TodoPage({super.key, required this.viewModel});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late Future<List<Todo>> _todosFuture;

  @override
  void initState() {
    super.initState();
    _todosFuture = widget.viewModel.getTodos();
  }

  void _refreshTodos() {
    setState(() {
      _todosFuture = widget.viewModel.getTodos();
    });
  }

  void _showAddTodoDialog() {
    final TextEditingController _titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              hintText: "Enter todo title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  await widget.viewModel.addTodo(title);
                  _refreshTodos(); // Refresh the FutureBuilder
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos")),
      body: FutureBuilder(
        future: _todosFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddTodoPage(
                              viewModel: widget.viewModel,
                              todo: todo, // Pass the todo for updating
                            ),
                          ),
                        ).then((_) {
                          _refreshTodos(); // Refresh the FutureBuilder after returning
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await widget.viewModel.deleteTodoById(todo.id);
                        _refreshTodos(); // Refresh the FutureBuilder
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTodoPage(
                viewModel: widget.viewModel,
              ),
            ),
          ).then((_) {
            _refreshTodos(); // Refresh the FutureBuilder after returning
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
