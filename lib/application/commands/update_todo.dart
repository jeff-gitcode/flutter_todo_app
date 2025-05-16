import '../../domain/repositories/todo_command_repository.dart';

class UpdateTodo {
  final TodoCommandRepository repository;

  UpdateTodo(this.repository);

  Future<void> call(int id, String title, bool isDone) {
    return repository.updateTodo(id, title, isDone);
  }
}