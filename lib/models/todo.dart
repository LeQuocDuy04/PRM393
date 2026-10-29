class Todo {
  final String title;
  bool done;

  Todo({required this.title, this.done = false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': done,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final done = json['done'];

    if (title is! String || done is! bool) {
      throw const FormatException('Todo JSON must contain a String title and bool done.');
    }

    return Todo(title: title, done: done);
  }
}
