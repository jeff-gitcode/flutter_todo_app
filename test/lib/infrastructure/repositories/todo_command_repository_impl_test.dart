// dart
import 'package:flutter_clean_architecture_todo_app/infrastructure/database/app_database.dart';
import 'package:flutter_clean_architecture_todo_app/infrastructure/repositories/todo_command_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';

void main() {
  late AppDatabase db;
  late TodoCommandRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = TodoCommandRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('addTodo inserts a todo', () async {
    await repository.addTodo('Test Todo');
    final todos = await db.select(db.todos).get();
    expect(todos.length, 1);
    expect(todos.first.title, 'Test Todo');
    expect(todos.first.isDone, isFalse);
  });

  test('deleteTodoById removes the correct todo', () async {
    final id = await db
        .into(db.todos)
        .insert(TodosCompanion.insert(title: 'To Delete'));
    await repository.deleteTodoById(id);
    final todos = await db.select(db.todos).get();
    expect(todos, isEmpty);
  });

  test('deleteTodoById does nothing if id does not exist', () async {
    await repository.deleteTodoById(999);
    final todos = await db.select(db.todos).get();
    expect(todos, isEmpty);
  });

  test('updateTodo updates title and isDone', () async {
    final id = await db
        .into(db.todos)
        .insert(TodosCompanion.insert(title: 'Old Title'));
    await repository.updateTodo(id, 'New Title', true);
    final todo =
        await (db.select(db.todos)..where((t) => t.id.equals(id))).getSingle();
    expect(todo.title, 'New Title');
    expect(todo.isDone, isTrue);
  });

  test('updateTodo does nothing if id does not exist', () async {
    await repository.updateTodo(999, 'Does Not Exist', true);
    final todos = await db.select(db.todos).get();
    expect(todos, isEmpty);
  });

  test('addTodo with empty title inserts a todo with empty title', () async {
    await repository.addTodo('');
    final todos = await db.select(db.todos).get();
    expect(todos.length, 1);
    expect(todos.first.title, '');
  });
}
