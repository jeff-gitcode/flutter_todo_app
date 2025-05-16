import 'package:flutter/material.dart';
import 'application/commands/delete_todo.dart';
import 'application/commands/update_todo.dart';
import 'core/di/injection.dart';
import 'infrastructure/database/app_database.dart';
import 'infrastructure/repositories/todo_command_repository_impl.dart';
import 'infrastructure/repositories/todo_query_repository_impl.dart';
import 'application/commands/add_todo.dart';
import 'application/queries/get_all_todos.dart';
import 'presentation/pages/todo_page.dart';
import 'presentation/viewmodels/todo_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final commandRepo = TodoCommandRepositoryImpl(db);
  final queryRepo = TodoQueryRepositoryImpl(db);

  final viewModel = TodoViewModel(
    addTodoUseCase: AddTodo(commandRepo),
    getAllTodosUseCase: GetAllTodos(queryRepo),
    deleteTodoUseCase: DeleteTodo(commandRepo),
    updateTodoUseCase: UpdateTodo(commandRepo), // Initialize UpdateTodo
  );

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final TodoViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoPage(viewModel: viewModel),
    );
  }
}
