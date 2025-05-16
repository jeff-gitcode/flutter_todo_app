
import '../../domain/entities/todo.dart';

class TodoModel {
  final int id;
  final String title;
  final bool isDone;

  TodoModel({required this.id, required this.title, required this.isDone});

  Todo toEntity() => Todo(id: id, title: title, isDone: isDone);
}
