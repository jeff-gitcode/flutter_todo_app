import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_clean_architecture_todo_app/domain/repositories/todo_command_repository.dart';
import 'package:flutter_clean_architecture_todo_app/application/commands/delete_todo.dart';

import './todo_test.mocks.dart';

@GenerateMocks([TodoCommandRepository])
void main() {
  group('DeleteTodo Use Case', () {
    late MockTodoCommandRepository mockRepository;
    late DeleteTodo deleteTodo;

    setUp(() {
      mockRepository = MockTodoCommandRepository();
      deleteTodo = DeleteTodo(mockRepository);
    });

    test('should call deleteTodoById on the repository', () async {
      // Arrange
      const id = 1;
      when(mockRepository.deleteTodoById(id))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await deleteTodo(id);

      // Assert
      verify(mockRepository.deleteTodoById(id)).called(1);
    });
  });
}