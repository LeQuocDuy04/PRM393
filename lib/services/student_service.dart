import '../models/student.dart';

class StudentService {
  final List<Student> _students;
  StudentService(List<Student> initialStudents) : _students = List.of(initialStudents);

  List<Student> get allStudents => List.unmodifiable(_students);

  void addStudent(Student student) => _students.add(student);

  bool updateGpa(int id, double newGpa) {
    final index = _students.indexWhere((student) => student.id == id);
    if (index == -1) return false;
    _students[index].gpa = newGpa;
    return true;
  }

  List<Student> filterByMinimumGpa(double minimumGpa) =>
      _students.where((student) => student.gpa >= minimumGpa).toList();

  List<String> formatStudents({String Function(Student)? formatter}) {
    final format = formatter ?? (student) => '${student.name} - GPA ${student.gpaLabel}';
    return _students.map(format).toList();
  }

  double get averageGpa => _students.isEmpty
      ? 0
      : _students.map((student) => student.gpa).reduce((a, b) => a + b) / _students.length;
}
