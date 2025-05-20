import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/pages/add_todo_page.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/viewmodels/todo_viewmodel.dart';
import 'package:flutter_clean_architecture_todo_app/domain/entities/todo.dart';

@GenerateMocks([TodoViewModel])
import 'add_todo_page_test.mocks.dart';

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

  testWidgets('renders AddTodoPage for adding', (tester) async {
    await pumpAddTodoPage(tester);
    expect(find.text('Add Todo'), findsNWidgets(2)); // AppBar and button
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Update Todo'), findsNothing);
  });

  testWidgets('renders AddTodoPage for updating', (tester) async {
    final todo = Todo(id: 1, title: 'Existing', isDone: false);
    await pumpAddTodoPage(tester, todo: todo);
    expect(find.text('Update Todo'), findsNWidgets(2));
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Add Todo'), findsNothing);
    expect(find.widgetWithText(TextFormField, 'Existing'), findsOneWidget);
  });

  testWidgets('shows validation error for empty title', (tester) async {
    await pumpAddTodoPage(tester);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.text('Title cannot be empty'), findsOneWidget);
    verifyNever(mockViewModel.addTodo(argThat(isA<String>())));
  });

  testWidgets('calls addTodo and pops on valid input', (tester) async {
    when(mockViewModel.addTodo(any)).thenAnswer((_) async {});
    await pumpAddTodoPage(tester);
    await tester.enterText(find.byType(TextFormField), 'New Todo');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    verify(mockViewModel.addTodo('New Todo')).called(1);
    expect(find.byType(AddTodoPage), findsNothing);
  });

  testWidgets('calls updateTodo and pops on valid input', (tester) async {
    final todo = Todo(id: 42, title: 'Old', isDone: true);
    when(mockViewModel.updateTodo(todo.id, todo.title, todo.isDone))
        .thenAnswer((_) async {});
    await pumpAddTodoPage(tester, todo: todo);
    await tester.enterText(find.byType(TextFormField), 'Updated');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    verify(mockViewModel.updateTodo(42, 'Updated', true)).called(1);
    expect(find.byType(AddTodoPage), findsNothing);
  });

  testWidgets('button label changes based on add/update', (tester) async {
    await pumpAddTodoPage(tester);
    expect(find.widgetWithText(ElevatedButton, 'Add Todo'), findsOneWidget);

    final todo = Todo(id: 1, title: 'T', isDone: false);
    await pumpAddTodoPage(tester, todo: todo);
    expect(find.widgetWithText(ElevatedButton, 'Update Todo'), findsOneWidget);
  });
}
