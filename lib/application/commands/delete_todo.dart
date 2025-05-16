import '../../domain/repositories/todo_command_repository.dart';

class DeleteTodo {
  final TodoCommandRepository repository;

  DeleteTodo(this.repository);

  Future<void> call(int id) {
    return repository.deleteTodoById(id);
  }
}
