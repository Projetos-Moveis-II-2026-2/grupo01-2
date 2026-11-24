import 'package:mercadinho_matematico/data/local_user_storage.dart';
import 'package:mercadinho_matematico/models/user_profile.dart';

/// Fake para testes: não cria o plugin SharedPreferencesAsync.
class MemoryUserStorage implements LocalUserStorage {
  UserProfile? saved;

  @override
  Future<UserProfile?> loadProfile() async => saved;

  @override
  Future<void> saveProfile(UserProfile profile) async {
    // Passa pelo JSON para simular a serialização do perfil.
    saved = UserProfile.fromJson(Map<String, dynamic>.from(profile.toJson()));
  }
}
