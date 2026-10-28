class Student {
  final int id;
  String name;
  double gpa;

  Student({required this.id, required this.name, required this.gpa});

  String get gpaLabel => gpa.toStringAsFixed(2);

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'gpa': gpa};

  @override
  String toString() => '$name (GPA: $gpaLabel)';
}
