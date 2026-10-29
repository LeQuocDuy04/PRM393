import '../models/profile_model.dart';
import '../services/api_service.dart';

class ProfileRepository {
  ProfileRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<Profile> getProfile() => _apiService.fetchProfile();

  Future<void> updateProfile(Profile profile) =>
      _apiService.updateProfile(profile);

  void dispose() => _apiService.dispose();
}
