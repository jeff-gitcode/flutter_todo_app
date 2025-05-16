import 'package:drift/drift.dart';
import '../../domain/repositories/todo_command_repository.dart';
import '../database/app_database.dart';

class TodoCommandRepositoryImpl implements TodoCommandRepository {
  final AppDatabase db;

  TodoCommandRepositoryImpl(this.db);

  @override
  Future<void> addTodo(String title) async {
    await db.into(db.todos).insert(TodosCompanion(title: Value(title)));
  }
}
