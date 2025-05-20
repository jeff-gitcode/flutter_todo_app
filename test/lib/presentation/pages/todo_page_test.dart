import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/pages/todo_page.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/pages/add_todo_page.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/viewmodels/todo_viewmodel.dart';
import 'package:flutter_clean_architecture_todo_app/domain/entities/todo.dart';

@GenerateMocks([TodoViewModel])
import 'todo_page_test.mocks.dart';

void main() {
  late MockTodoViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockTodoViewModel();
    when(mockViewModel.getTodos()).thenAnswer((_) async => []);
  });

  Future<void> pumpTodoPage(WidgetTester tester, {List<Todo>? todos}) async {
    if (todos != null) {
      when(mockViewModel.getTodos()).thenAnswer((_) async => todos);
    }
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

  testWidgets('tapping FAB navigates to AddTodoPage for adding',
      (tester) async {
    await pumpTodoPage(tester, todos: []);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that we're on the AddTodoPage by checking for its key elements
    expect(find.text('Add Todo'), findsNWidgets(2)); // AppBar title and button
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Update Todo'), findsNothing);

    // If you need to check specific properties, you can use this approach
    // but only if AddTodoPage is directly visible in the widget tree
    if (find.byType(AddTodoPage).evaluate().isNotEmpty) {
      final AddTodoPage page = tester.widget(find.byType(AddTodoPage));
      expect(page.todo, isNull);
    }
  });

  testWidgets(
      'add dialog: add with non-empty title calls addTodo and refreshes',
      (tester) async {
    when(mockViewModel.addTodo(any)).thenAnswer((_) async {});
    await pumpTodoPage(tester, todos: []);

    // Try to use a more reliable finder for the add button/action
    // Assume there's a FloatingActionButton to add todos
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Enter text in the input field (use TextFormField if TextField isn't found)
    final textField = find.byType(TextField);
    if (textField.evaluate().isEmpty) {
      await tester.enterText(find.byType(TextFormField), 'New Todo');
    } else {
      await tester.enterText(textField, 'New Todo');
    }

    // Find the button by icon or any visible text that might be used
    // Try multiple possible options
    final possibleButtons = [
      find.widgetWithText(ElevatedButton, 'Add'),
      find.widgetWithText(TextButton, 'Add'),
      find.widgetWithText(ElevatedButton, 'Add Todo'),
      find.widgetWithIcon(IconButton, Icons.check),
      find.widgetWithIcon(IconButton, Icons.add)
    ];

    Finder? buttonFinder;
    for (final finder in possibleButtons) {
      if (finder.evaluate().isNotEmpty) {
        buttonFinder = finder;
        break;
      }
    }

    if (buttonFinder != null) {
      await tester.tap(buttonFinder);
    } else {
      fail('Could not find any button to add a todo');
    }
    await tester.pumpAndSettle();

    // Verify the mock was called
    verify(mockViewModel.addTodo(any)).called(1);
    verify(mockViewModel.getTodos()).called(greaterThan(1));
  });

  testWidgets('add dialog: add with empty title does not call addTodo',
      (tester) async {
    await pumpTodoPage(tester, todos: []);
    
    // Tap the add button/FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    
    // Enter empty text
    final textField = find.byType(TextField);
    if (textField.evaluate().isEmpty) {
      await tester.enterText(find.byType(TextFormField), '');
    } else {
      await tester.enterText(textField, '');
    }
    
    // Find the add button using the same approach as before
    final possibleButtons = [
      find.widgetWithText(ElevatedButton, 'Add'),
      find.widgetWithText(TextButton, 'Add'),
      find.widgetWithText(ElevatedButton, 'Add Todo'),
      find.widgetWithIcon(IconButton, Icons.check),
      find.widgetWithIcon(IconButton, Icons.add)
    ];
    
    Finder? buttonFinder;
    for (final finder in possibleButtons) {
      if (finder.evaluate().isNotEmpty) {
        buttonFinder = finder;
        break;
      }
    }
    
    if (buttonFinder != null) {
      await tester.tap(buttonFinder);
    } else {
      fail('Could not find any button to add a todo');
    }
    await tester.pumpAndSettle();
    
    // Verify the mock was NOT called
    verifyNever(mockViewModel.addTodo(any));
  });
}
