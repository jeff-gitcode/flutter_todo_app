import 'package:flutter/material.dart';
import '../viewmodels/todo_viewmodel.dart';
import '../../domain/entities/todo.dart';

class AddTodoPage extends StatefulWidget {
  final TodoViewModel viewModel;
  final Todo? todo; // Optional Todo object for updating

  const AddTodoPage({super.key, required this.viewModel, this.todo});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      // If a Todo is provided, pre-fill the title
      _titleController.text = widget.todo!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = widget.todo != null; // Check if this is an update

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdating ? "Update Todo" : "Add Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  hintText: "Enter todo title",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Title cannot be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text.trim();
                    if (isUpdating) {
                      // Update the existing todo
                      await widget.viewModel.updateTodo(
                        widget.todo!.id,
                        title,
                        widget.todo!.isDone,
                      );
                    } else {
                      // Add a new todo
                      await widget.viewModel.addTodo(title);
                    }
                    Navigator.of(context).pop(); // Go back to the previous page
                  }
                },
                child: Text(isUpdating ? "Update Todo" : "Add Todo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
