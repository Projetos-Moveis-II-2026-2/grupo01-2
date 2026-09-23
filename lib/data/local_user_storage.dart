import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

/// Armazena o único perfil local como JSON em uma chave de preferências.
class LocalUserStorage {
  static const _profileKey = 'mercadinho_user_profile_v1';

  final SharedPreferencesAsync _preferences;

  LocalUserStorage({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  Future<UserProfile?> loadProfile() async {
    final jsonString = await _preferences.getString(_profileKey);
    if (jsonString == null) return null;

    final decoded = jsonDecode(jsonString);
    if (decoded is! Map) return null;

    return UserProfile.fromJson(Map<String, dynamic>.from(decoded));
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _preferences.setString(_profileKey, jsonEncode(profile.toJson()));
  }
}
