import '../../application/commands/delete_todo.dart';
import '../../domain/entities/todo.dart';
import '../../application/commands/add_todo.dart';
import '../../application/queries/get_all_todos.dart';
import '../../application/commands/update_todo.dart'; // Import UpdateTodo

class TodoViewModel {
  final AddTodo addTodoUseCase;
  final GetAllTodos getAllTodosUseCase;
  final DeleteTodo deleteTodoUseCase;
  final UpdateTodo updateTodoUseCase; // Add UpdateTodo use case

  TodoViewModel({
    required this.addTodoUseCase,
    required this.deleteTodoUseCase,
    required this.getAllTodosUseCase,
    required this.updateTodoUseCase, // Initialize UpdateTodo
  });

  Future<List<Todo>> getTodos() {
    return getAllTodosUseCase();
  }

  Future<void> addTodo(String title) async {
    await addTodoUseCase(title);
    // Notify listeners or refresh the UI
  }

  Future<void> deleteTodoById(int id) async {
    await deleteTodoUseCase(id); // Call DeleteTodo use case
    // Optionally refresh the UI or notify listeners
  }

  Future<void> updateTodo(int id, String title, bool isDone) async {
    await updateTodoUseCase(id, title, isDone); // Call UpdateTodo use case
  }
}
