import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_clean_architecture_todo_app/domain/repositories/todo_command_repository.dart';
import 'package:flutter_clean_architecture_todo_app/application/commands/add_todo.dart';

import 'todo_test.mocks.dart';

@GenerateMocks([TodoCommandRepository])
void main() {
  group('AddTodo Use Case', () {
    late MockTodoCommandRepository mockRepository;
    late AddTodo addTodo;

    setUp(() {
      mockRepository = MockTodoCommandRepository();
      addTodo = AddTodo(mockRepository);
    });

    test('should call addTodo on the repository', () async {
      // Arrange
      const title = 'Test Todo';
      when(mockRepository.addTodo(title))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await addTodo(title);

      // Assert
      verify(mockRepository.addTodo(title)).called(1);
    });
  });
}
