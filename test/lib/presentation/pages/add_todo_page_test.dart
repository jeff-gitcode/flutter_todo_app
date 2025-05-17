// dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/pages/add_todo_page.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/viewmodels/todo_viewmodel.dart';
import 'package:flutter_clean_architecture_todo_app/domain/entities/todo.dart';

class MockTodoViewModel extends Mock implements TodoViewModel {}

void main() {
  late MockTodoViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockTodoViewModel();
  });

  Future<void> pumpAddTodoPage(WidgetTester tester, {Todo? todo}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AddTodoPage(viewModel: mockViewModel, todo: todo),
      ),
    );
  }

  testWidgets('renders with empty field for add', (tester) async {
    await pumpAddTodoPage(tester);
    expect(find.text('Add Todo'), findsNWidgets(2)); // AppBar and Button
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Enter todo title'), findsOneWidget);
    expect(find.text('Update Todo'), findsNothing);
    final textField = tester.widget<TextFormField>(find.byType(TextFormField));
    expect(textField.controller?.text, '');
  });

  testWidgets('renders with pre-filled field for update', (tester) async {
    final todo = Todo(id: 1, title: 'Existing', isDone: false);
    await pumpAddTodoPage(tester, todo: todo);
    expect(find.text('Update Todo'), findsNWidgets(2));
    expect(find.text('Existing'), findsOneWidget);
    final textField = tester.widget<TextFormField>(find.byType(TextFormField));
    expect(textField.controller?.text, 'Existing');
  });

  testWidgets('shows validation error for empty title', (tester) async {
    await pumpAddTodoPage(tester);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.text('Title cannot be empty'), findsOneWidget);
    verifyNever(mockViewModel.addTodo(any as String));
  });

  testWidgets('calls addTodo and pops on success', (tester) async {
    when(mockViewModel.addTodo(any)).thenAnswer((_) async {});
    await pumpAddTodoPage(tester);
    await tester.enterText(find.byType(TextFormField), 'New Task');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    verify(mockViewModel.addTodo('New Task')).called(1);
    expect(find.byType(AddTodoPage), findsNothing); // Page popped
  });

  testWidgets('calls updateTodo and pops on success', (tester) async {
    final todo = Todo(id: 2, title: 'Old', isDone: true);
    when(mockViewModel.updateTodo(any, any, any)).thenAnswer((_) async {});
    await pumpAddTodoPage(tester, todo: todo);
    await tester.enterText(find.byType(TextFormField), 'Updated');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    verify(mockViewModel.updateTodo(2, 'Updated', true)).called(1);
    expect(find.byType(AddTodoPage), findsNothing);
  });

  testWidgets('button label changes based on mode', (tester) async {
    await pumpAddTodoPage(tester);
    expect(find.widgetWithText(ElevatedButton, 'Add Todo'), findsOneWidget);
    final todo = Todo(id: 3, title: 'T', isDone: false);
    await pumpAddTodoPage(tester, todo: todo);
    expect(find.widgetWithText(ElevatedButton, 'Update Todo'), findsOneWidget);
  });
}
