import '../../models/user.dart';

/// Alternative mock source to demonstrate changing the data source without changing UI.
class UserAlternateDataSource {
  Future<List<User>> getUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const [
      User(id: 101, name: 'Minh Hoang', email: 'minh@example.com', role: 'Backend Developer'),
      User(id: 102, name: 'Linh Do', email: 'linh@example.com', role: 'UI Designer'),
      User(id: 103, name: 'Khanh Bui', email: 'khanh@example.com', role: 'QA Engineer'),
    ];
  }
}
