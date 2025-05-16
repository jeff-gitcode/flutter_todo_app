import 'package:drift/drift.dart';
import '../../domain/repositories/todo_command_repository.dart';
import '../database/app_database.dart';

class TodoCommandRepositoryImpl implements TodoCommandRepository {
  final AppDatabase db;

  TodoCommandRepositoryImpl(this.db);

  @override
  Future<void> addTodo(String title) async {
    print("Adding todo: $title");
    await db.into(db.todos).insert(TodosCompanion(title: Value(title)));
  }

  @override
  Future<void> deleteTodoById(int id) async {
    print("Deleting todo with id: $id");
    await (db.delete(db.todos)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> updateTodo(int id, String title, bool isDone) async {
    print("Updating todo with id: $id");
    await (db.update(db.todos)
          ..where((tbl) => tbl.id.equals(id)))
        .write(TodosCompanion(
          title: Value(title),
          isDone: Value(isDone),
        ));
  }
}
