
import '../entities/todo.dart';

abstract class TodoQueryRepository {
  Future<List<Todo>> getAllTodos();
}
