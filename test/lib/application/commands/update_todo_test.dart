import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_clean_architecture_todo_app/domain/repositories/todo_command_repository.dart';
import 'package:flutter_clean_architecture_todo_app/application/commands/update_todo.dart';

import 'todo_test.mocks.dart';

@GenerateMocks([TodoCommandRepository])
void main() {
  group('UpdateTodo Use Case', () {
    late MockTodoCommandRepository mockRepository;
    late UpdateTodo updateTodo;

    setUp(() {
      mockRepository = MockTodoCommandRepository();
      updateTodo = UpdateTodo(mockRepository);
    });

    test('should call updateTodo on the repository', () async {
      // Arrange
      const id = 1;
      const title = 'Updated Todo';
      const isDone = true;
      when(mockRepository.updateTodo(id, title, isDone))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await updateTodo(id, title, isDone);

      // Assert
      verify(mockRepository.updateTodo(id, title, isDone)).called(1);
    });
  });
}