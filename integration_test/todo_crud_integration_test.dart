// dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_todo_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Todo list, update, and delete integration test',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    // Add a todo
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byType(TextFormField), 'Integration Todo');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Todo'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    // Verify todo appears in the list
    expect(find.text('Integration Todo'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));

    // Update the todo
    await tester.tap(find.widgetWithIcon(IconButton, Icons.edit).first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byType(TextFormField), 'Updated Todo');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Update Todo'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    // Verify updated todo appears
    expect(find.text('Updated Todo'), findsOneWidget);
    expect(find.text('Integration Todo'), findsNothing);
    await tester.pump(const Duration(seconds: 1));

    // Delete the todo
    await tester.tap(find.widgetWithIcon(IconButton, Icons.delete).first);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    // Verify todo is removed
    expect(find.text('Updated Todo'), findsNothing);
    await tester.pump(const Duration(seconds: 1));
  });
}
