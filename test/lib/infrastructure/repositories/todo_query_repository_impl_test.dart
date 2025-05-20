// dart
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_clean_architecture_todo_app/infrastructure/database/app_database.dart';
import 'package:flutter_clean_architecture_todo_app/infrastructure/repositories/todo_query_repository_impl.dart';

void main() {
  late AppDatabase db;
  late TodoQueryRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = TodoQueryRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('getAllTodos returns empty list when no todos exist', () async {
    final todos = await repository.getAllTodos();
    expect(todos, isEmpty);
  });

  test('getAllTodos returns all inserted todos with correct fields', () async {
    final id1 =
        await db.into(db.todos).insert(TodosCompanion.insert(title: 'First'));
    final id2 = await db
        .into(db.todos)
        .insert(TodosCompanion.insert(title: 'Second', isDone: Value(true)));
    final todos = await repository.getAllTodos();
    expect(todos.length, 2);
    final first = todos.firstWhere((t) => t.id == id1);
    final second = todos.firstWhere((t) => t.id == id2);
    expect(first.title, 'First');
    expect(first.isDone, isFalse);
    expect(second.title, 'Second');
    expect(second.isDone, isTrue);
  });

  test('getAllTodos returns todos with correct isDone values', () async {
    await db
        .into(db.todos)
        .insert(TodosCompanion.insert(title: 'A', isDone: Value(false)));
    await db
        .into(db.todos)
        .insert(TodosCompanion.insert(title: 'B', isDone: Value(true)));
    final todos = await repository.getAllTodos();
    expect(todos.any((t) => t.title == 'A' && t.isDone == false), isTrue);
    expect(todos.any((t) => t.title == 'B' && t.isDone == true), isTrue);
  });

  test('getAllTodos returns todos in insertion order', () async {
    final id1 =
        await db.into(db.todos).insert(TodosCompanion.insert(title: 'First'));
    final id2 =
        await db.into(db.todos).insert(TodosCompanion.insert(title: 'Second'));
    final todos = await repository.getAllTodos();
    expect(todos[0].id, id1);
    expect(todos[1].id, id2);
  });
}
