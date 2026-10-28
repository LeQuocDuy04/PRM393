import '../../models/user.dart';
import '../datasources/user_alternate_datasource.dart';
import '../datasources/user_fake_datasource.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._fakeSource) : _activeSource = _fakeSource;

  final UserFakeDataSource _fakeSource;
  final UserAlternateDataSource _alternateSource = UserAlternateDataSource();
  Object _activeSource;

  bool get usingAlternateSource => _activeSource is UserAlternateDataSource;

  void useAlternateSource(bool useAlternate) {
    _activeSource = useAlternate ? _alternateSource : _fakeSource;
  }

  @override
  Future<List<User>> getUsers() {
    if (_activeSource is UserAlternateDataSource) {
      return (_activeSource as UserAlternateDataSource).getUsers();
    }
    return (_activeSource as UserFakeDataSource).getUsers();
  }
}
