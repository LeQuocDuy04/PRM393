import '../../models/user.dart';

/// Simulates a remote data source. UI must never import this class directly.
class UserFakeDataSource {
  Future<List<User>> getUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return const [
      User(id: 1, name: 'Alice Nguyen', email: 'alice@example.com', role: 'Designer'),
      User(id: 2, name: 'Bob Tran', email: 'bob@example.com', role: 'Developer'),
      User(id: 3, name: 'Charlie Le', email: 'charlie@example.com', role: 'Tester'),
      User(id: 4, name: 'Diana Pham', email: 'diana@example.com', role: 'Project Manager'),
      User(id: 5, name: 'Ethan Vo', email: 'ethan@example.com', role: 'Developer'),
    ];
  }
}
