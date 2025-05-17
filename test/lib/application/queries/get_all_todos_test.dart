import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_clean_architecture_todo_app/domain/repositories/todo_query_repository.dart';
import 'package:flutter_clean_architecture_todo_app/application/queries/get_all_todos.dart';
import 'package:flutter_clean_architecture_todo_app/domain/entities/todo.dart';

import 'get_all_todos_test.mocks.dart';

@GenerateMocks([TodoQueryRepository])
void main() {
  group('GetAllTodos Use Case', () {
    late MockTodoQueryRepository mockRepository;
    late GetAllTodos getAllTodos;

    setUp(() {
      mockRepository = MockTodoQueryRepository();
      getAllTodos = GetAllTodos(mockRepository);
    });

    test('should return list of todos from repository', () async {
      // Arrange
      final todos = [
        Todo(id: 1, title: 'Test Todo 1', isDone: false),
        Todo(id: 2, title: 'Test Todo 2', isDone: true),
      ];
      when(mockRepository.getAllTodos()).thenAnswer((_) async => todos);

      // Act
      final result = await getAllTodos();

      // Assert
      expect(result, equals(todos));
      verify(mockRepository.getAllTodos()).called(1);
    });
  });
}
