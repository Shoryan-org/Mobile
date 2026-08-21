import 'package:shared_preferences/shared_preferences.dart';

/// Manages persistent storage of the authentication token.
class TokenStorage {
  static const String _tokenKey = 'auth_token';
  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  /// Retrieves the stored auth token, or null if not stored.
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Saves the auth token to persistent storage.
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Clears the stored auth token.
  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  /// Returns true if a token is currently stored.
  bool get hasToken => _prefs.containsKey(_tokenKey);

  /// Retrieves whether the user has completed onboarding.
  bool get hasSeenOnboarding => _prefs.getBool('has_seen_onboarding') ?? false;

  /// Sets the onboarding completion flag.
  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool('has_seen_onboarding', value);
  }
}
