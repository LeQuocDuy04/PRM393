import 'dart:convert';
import '../models/todo.dart';

class JsonService {
  const JsonService();

  String exportTodos(List<Todo> todos) {
    final list = todos.map((todo) => todo.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(list);
  }

  List<Todo> importTodos(String jsonData) {
    final decoded = jsonDecode(jsonData);
    if (decoded is! List) {
      throw const FormatException('Backup JSON must be a list of todos.');
    }

    return decoded.map((item) {
      if (item is! Map) {
        throw const FormatException('Each todo must be a JSON object.');
      }
      return Todo.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }
}
