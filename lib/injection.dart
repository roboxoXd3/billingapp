import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/preference_service.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize SharedPreferences
  try {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Register SharedPreferences instance
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    // Register PreferencesService as a singleton
    getIt.registerSingleton<PreferencesService>(
      PreferencesService(sharedPreferences),
    );

    // Initialize other dependencies
    await getIt.init();
    await getIt.allReady();
  } catch (e) {
    debugPrint('Error initializing dependencies: $e');
    rethrow;
  }
}

// Add this module to provide SharedPreferences
@module
abstract class RegisterModule {
  @preResolve // This ensures SharedPreferences is initialized before use
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
