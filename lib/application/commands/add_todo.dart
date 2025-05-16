
import '../../domain/repositories/todo_command_repository.dart';

class AddTodo {
  final TodoCommandRepository repository;

  AddTodo(this.repository);

  Future<void> call(String title) {
    return repository.addTodo(title);
  }
}
