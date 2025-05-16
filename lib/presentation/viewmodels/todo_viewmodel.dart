
import '../../domain/entities/todo.dart';
import '../../application/commands/add_todo.dart';
import '../../application/queries/get_all_todos.dart';

class TodoViewModel {
  final AddTodo addTodoUseCase;
  final GetAllTodos getAllTodosUseCase;

  TodoViewModel({
    required this.addTodoUseCase,
    required this.getAllTodosUseCase,
  });

  Future<void> addTodo(String title) => addTodoUseCase(title);

  Future<List<Todo>> getTodos() => getAllTodosUseCase();
}
