import '../../models/user.dart';

/// Contract used by the UI. It does not expose how users are loaded.
abstract class UserRepository {
  Future<List<User>> getUsers();

  /// Demo control for switching between two mock data sources.
  bool get usingAlternateSource;
  void useAlternateSource(bool useAlternate);
}
