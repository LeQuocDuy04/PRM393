class Task {
  final int? id;
  final String title;
  final bool isDone;
  final int createdAt;

  const Task({
    this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'is_done': isDone ? 1 : 0,
        'created_at': createdAt,
      };

  factory Task.fromMap(Map<String, Object?> map) => Task(
        id: map['id'] as int?,
        title: map['title'] as String,
        isDone: (map['is_done'] as int) == 1,
        createdAt: map['created_at'] as int,
      );
}
