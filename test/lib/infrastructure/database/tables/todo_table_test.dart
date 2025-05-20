// dart
import 'package:flutter_clean_architecture_todo_app/infrastructure/database/tables/todo_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

part 'todo_table_test.g.dart';

@DriftDatabase(tables: [Todos])
class TestDatabase extends _$TestDatabase {
  TestDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}

void main() {
  late TestDatabase db;

  setUp(() {
    db = TestDatabase();
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
}
