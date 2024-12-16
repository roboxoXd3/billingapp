// lib/core/services/preferences_service.dart
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class PreferencesService {
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyOnboardingCompleted = 'onboarding_completed';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  Future<bool> isFirstLaunch() async {
    return _prefs.getBool(keyIsFirstLaunch) ?? true;
  }

  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(keyIsFirstLaunch, value);
  }

  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(keyOnboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(keyOnboardingCompleted, value);
  }
}
