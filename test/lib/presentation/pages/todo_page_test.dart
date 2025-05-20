// dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/pages/todo_page.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/pages/add_todo_page.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/viewmodels/todo_viewmodel.dart';
import 'package:flutter_clean_architecture_todo_app/domain/entities/todo.dart';

class MockTodoViewModel extends Mock implements TodoViewModel {}

void main() {
  late MockTodoViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockTodoViewModel();
    when(mockViewModel.getTodos()).thenAnswer((_) async => []);
  });

  Future<void> pumpTodoPage(WidgetTester tester, {List<Todo>? todos}) async {
    when(mockViewModel.getTodos()).thenAnswer((_) async => todos ?? []);
    await tester.pumpWidget(
      MaterialApp(
        home: TodoPage(viewModel: mockViewModel),
      ),
    );
    // Let FutureBuilder complete
    await tester.pumpAndSettle();
  }

  testWidgets('shows loading indicator while loading', (tester) async {
    when(mockViewModel.getTodos()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return [];
    });
    await tester.pumpWidget(
      MaterialApp(home: TodoPage(viewModel: mockViewModel)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('renders todos when loaded', (tester) async {
    final todos = [
      Todo(id: 1, title: 'A', isDone: false),
      Todo(id: 2, title: 'B', isDone: true),
    ];
    await pumpTodoPage(tester, todos: todos);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsNWidgets(2));
    expect(find.byIcon(Icons.delete), findsNWidgets(2));
  });

  testWidgets('tapping delete calls deleteTodoById and refreshes',
      (tester) async {
    final todos = [Todo(id: 1, title: 'A', isDone: false)];
    // Override getTodos for this test before using the widget
    when(mockViewModel.getTodos()).thenAnswer((_) async => todos);
    when(mockViewModel.deleteTodoById(1)).thenAnswer((_) async {});
    await pumpTodoPage(tester, todos: todos);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    verify(mockViewModel.deleteTodoById(1)).called(1);
    verify(mockViewModel.getTodos()).called(greaterThan(1));
  });

  testWidgets('tapping edit navigates to AddTodoPage with correct todo',
      (tester) async {
    final todos = [Todo(id: 1, title: 'A', isDone: false)];
    await pumpTodoPage(tester, todos: todos);
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.byType(AddTodoPage), findsOneWidget);
    final AddTodoPage page = tester.widget(find.byType(AddTodoPage));
    expect(page.todo, todos[0]);
  });

  testWidgets('tapping FAB navigates to AddTodoPage for adding',
      (tester) async {
    await pumpTodoPage(tester, todos: []);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.byType(AddTodoPage), findsOneWidget);
    final AddTodoPage page = tester.widget(find.byType(AddTodoPage));
    expect(page.todo, isNull);
  });

  testWidgets('tapping edit or FAB then returning refreshes todos',
      (tester) async {
    final todos = [Todo(id: 1, title: 'A', isDone: false)];
    await pumpTodoPage(tester, todos: todos);
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    // Simulate pop
    Navigator.of(tester.element(find.byType(AddTodoPage))).pop();
    await tester.pumpAndSettle();
    verify(mockViewModel.getTodos()).called(greaterThan(1));

    // FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(AddTodoPage))).pop();
    await tester.pumpAndSettle();
    verify(mockViewModel.getTodos()).called(greaterThan(2));
  });

  testWidgets(
      'add dialog: add with non-empty title calls addTodo and refreshes',
      (tester) async {
    when(mockViewModel.addTodo('New Todo')).thenAnswer((_) async {});
    await pumpTodoPage(tester, todos: []);
    await tester.runAsync(() async {
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pumpAndSettle();
      verify(mockViewModel.addTodo('New Todo')).called(1);
      verify(mockViewModel.getTodos()).called(greaterThan(1));
    });
  });

  testWidgets('add dialog: add with empty title does not call addTodo',
      (tester) async {
    await pumpTodoPage(tester, todos: []);
    await tester.runAsync(() async {
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pumpAndSettle();
      verifyNever(mockViewModel.addTodo(any as String));
    });
  });
}
