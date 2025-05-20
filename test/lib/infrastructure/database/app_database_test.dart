import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_clean_architecture_todo_app/infrastructure/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Insert and retrieve a todo', () async {
    final id = await db.into(db.todos).insert(
          TodosCompanion.insert(title: 'Test Todo'),
        );
    final todo =
        await (db.select(db.todos)..where((t) => t.id.equals(id))).getSingle();
    expect(todo.title, 'Test Todo');
    expect(todo.isDone, isFalse);
  });

// dart

  test('Default value of isDone is false', () async {
    final id = await db.into(db.todos).insert(
          TodosCompanion.insert(title: 'Check default'),
        );
    final todo =
        await (db.select(db.todos)..where((t) => t.id.equals(id))).getSingle();
    expect(todo.isDone, isFalse);
  });

  test('Update isDone field', () async {
    final id = await db.into(db.todos).insert(
          TodosCompanion.insert(title: 'Update isDone'),
        );
    await (db.update(db.todos)..where((t) => t.id.equals(id))).write(
      TodosCompanion(isDone: Value(true)),
    );
    final todo =
        await (db.select(db.todos)..where((t) => t.id.equals(id))).getSingle();
    expect(todo.isDone, isTrue);
  });

  test('Delete a todo', () async {
    final id = await db.into(db.todos).insert(
          TodosCompanion.insert(title: 'Delete me'),
        );
    await (db.delete(db.todos)..where((t) => t.id.equals(id))).go();
    final todos = await db.select(db.todos).get();
    expect(todos, isEmpty);
  });

  test('Insert multiple todos and retrieve all', () async {
    await db.into(db.todos).insert(TodosCompanion.insert(title: 'Todo 1'));
    await db.into(db.todos).insert(TodosCompanion.insert(title: 'Todo 2'));
    final todos = await db.select(db.todos).get();
    expect(todos.length, 2);
    expect(todos.map((t) => t.title), containsAll(['Todo 1', 'Todo 2']));
  });
}
