
import 'package:flutter/material.dart';
import '../viewmodels/todo_viewmodel.dart';

class TodoPage extends StatelessWidget {
  final TodoViewModel viewModel;

  const TodoPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos")),
      body: FutureBuilder(
        future: viewModel.getTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(title: Text(todo.title));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.addTodo("New Todo"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
