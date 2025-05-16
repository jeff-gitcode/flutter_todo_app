abstract class TodoCommandRepository {
  Future<void> addTodo(String title);
  Future<void> deleteTodoById(int id);
  Future<void> updateTodo(int id, String title, bool isDone); // Add this method
}
