
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_query_repository.dart';

class GetAllTodos {
  final TodoQueryRepository repository;

  GetAllTodos(this.repository);

  Future<List<Todo>> call() {
    return repository.getAllTodos();
  }
}
