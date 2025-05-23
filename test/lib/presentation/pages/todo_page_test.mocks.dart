// Mocks generated by Mockito 5.4.6 from annotations
// in flutter_clean_architecture_todo_app/test/lib/presentation/pages/todo_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:flutter_clean_architecture_todo_app/application/commands/add_todo.dart'
    as _i2;
import 'package:flutter_clean_architecture_todo_app/application/commands/delete_todo.dart'
    as _i4;
import 'package:flutter_clean_architecture_todo_app/application/commands/update_todo.dart'
    as _i5;
import 'package:flutter_clean_architecture_todo_app/application/queries/get_all_todos.dart'
    as _i3;
import 'package:flutter_clean_architecture_todo_app/domain/entities/todo.dart'
    as _i8;
import 'package:flutter_clean_architecture_todo_app/presentation/viewmodels/todo_viewmodel.dart'
    as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAddTodo_0 extends _i1.SmartFake implements _i2.AddTodo {
  _FakeAddTodo_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeGetAllTodos_1 extends _i1.SmartFake implements _i3.GetAllTodos {
  _FakeGetAllTodos_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDeleteTodo_2 extends _i1.SmartFake implements _i4.DeleteTodo {
  _FakeDeleteTodo_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUpdateTodo_3 extends _i1.SmartFake implements _i5.UpdateTodo {
  _FakeUpdateTodo_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TodoViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockTodoViewModel extends _i1.Mock implements _i6.TodoViewModel {
  MockTodoViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AddTodo get addTodoUseCase => (super.noSuchMethod(
        Invocation.getter(#addTodoUseCase),
        returnValue: _FakeAddTodo_0(
          this,
          Invocation.getter(#addTodoUseCase),
        ),
      ) as _i2.AddTodo);

  @override
  _i3.GetAllTodos get getAllTodosUseCase => (super.noSuchMethod(
        Invocation.getter(#getAllTodosUseCase),
        returnValue: _FakeGetAllTodos_1(
          this,
          Invocation.getter(#getAllTodosUseCase),
        ),
      ) as _i3.GetAllTodos);

  @override
  _i4.DeleteTodo get deleteTodoUseCase => (super.noSuchMethod(
        Invocation.getter(#deleteTodoUseCase),
        returnValue: _FakeDeleteTodo_2(
          this,
          Invocation.getter(#deleteTodoUseCase),
        ),
      ) as _i4.DeleteTodo);

  @override
  _i5.UpdateTodo get updateTodoUseCase => (super.noSuchMethod(
        Invocation.getter(#updateTodoUseCase),
        returnValue: _FakeUpdateTodo_3(
          this,
          Invocation.getter(#updateTodoUseCase),
        ),
      ) as _i5.UpdateTodo);

  @override
  _i7.Future<List<_i8.Todo>> getTodos() => (super.noSuchMethod(
        Invocation.method(
          #getTodos,
          [],
        ),
        returnValue: _i7.Future<List<_i8.Todo>>.value(<_i8.Todo>[]),
      ) as _i7.Future<List<_i8.Todo>>);

  @override
  _i7.Future<void> addTodo(String? title) => (super.noSuchMethod(
        Invocation.method(
          #addTodo,
          [title],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> deleteTodoById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteTodoById,
          [id],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> updateTodo(
    int? id,
    String? title,
    bool? isDone,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateTodo,
          [
            id,
            title,
            isDone,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
}
