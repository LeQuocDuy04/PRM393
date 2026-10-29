import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_model.dart';

class DraftService {
  static const String draftKey = 'profile_draft';

  Future<void> saveDraft(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(draftKey, jsonEncode(profile.toJson()));
    // ignore: avoid_print
    print('Draft saved: ${jsonEncode(profile.toJson())}');
  }

  Future<Profile?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(draftKey);
    // ignore: avoid_print
    print('Draft loaded: $raw');

    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return Profile.fromJson(decoded);
    } on FormatException {
      // A damaged draft should not crash the screen.
      await clearDraft();
      return null;
    }
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(draftKey);
    // ignore: avoid_print
    print('Draft cleared');
  }
}
