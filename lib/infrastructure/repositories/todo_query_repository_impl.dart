import '../../domain/entities/todo.dart' as domain;
import '../../domain/repositories/todo_query_repository.dart';
import '../database/app_database.dart';

class TodoQueryRepositoryImpl implements TodoQueryRepository {
  final AppDatabase db;

  TodoQueryRepositoryImpl(this.db);

  @override
  Future<List<domain.Todo>> getAllTodos() async {
    final rows = await db.select(db.todos).get();
    return rows
        .map((row) => domain.Todo(
              id: row.id,
              title: row.title,
              isDone: row.isDone,
            ))
        .toList();
  }
}
