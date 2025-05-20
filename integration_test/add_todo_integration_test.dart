// dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_todo_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add todo integration test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap the FAB to add a new todo
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // Enter a todo title
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'Integration Test Todo');

    // Tap the Add/Update button
    final addButton = find.widgetWithText(ElevatedButton, 'Add Todo');
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Verify the new todo appears in the list
    expect(find.text('Integration Test Todo'), findsOneWidget);
  });
}
