// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_architecture_todo_app/main.dart';
import 'package:flutter_clean_architecture_todo_app/presentation/viewmodels/todo_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'widget_test.mocks.dart';

@GenerateMocks([TodoViewModel])
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a mock instance of TodoViewModel
    final mockViewModel = MockTodoViewModel();

    // Stub any necessary methods on the mock
    when(mockViewModel.getTodos()).thenAnswer((_) async => []);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(viewModel: mockViewModel));

    // Wait for any asynchronous updates.
    await tester.pumpAndSettle();

    // Debug: Print the widget tree
    debugPrint(tester.allWidgets.toString());

    // Verify that the initial state matches the app's behavior
    expect(find.byType(ListView), findsOneWidget); // Verify that the ListView is present
    expect(find.byType(ListTile), findsNothing); // Verify that no todos are displayed initially

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Debug: Print the widget tree after tapping the '+' icon
    debugPrint(tester.allWidgets.toString());

    // Verify that the counter has incremented
    expect(find.text('1'), findsOneWidget); // Update this if the app displays something else
  });
}
