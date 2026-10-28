import 'student.dart';

/// In-memory data store so every screen uses the same student list.
class StudentStore {
  StudentStore._();
  static final StudentStore instance = StudentStore._();

  final List<Student> students = [
    const Student(id: 'S001', name: 'Nguyễn Văn An', age: 20),
    const Student(id: 'S002', name: 'Trần Thị Bình', age: 21),
    const Student(id: 'S003', name: 'Lê Minh Châu', age: 19),
  ];

  Student? findById(String id) {
    for (final student in students) {
      if (student.id.toLowerCase() == id.toLowerCase()) return student;
    }
    return null;
  }

  bool containsId(String id, {String? exceptId}) => students.any(
        (student) => student.id.toLowerCase() == id.toLowerCase() &&
            student.id.toLowerCase() != exceptId?.toLowerCase(),
      );

  void add(Student student) => students.add(student);

  void update(Student updated) {
    final index = students.indexWhere((student) => student.id == updated.id);
    if (index != -1) students[index] = updated;
  }
}
