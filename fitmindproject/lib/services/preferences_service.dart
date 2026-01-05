import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Service for local data persistence
/// Step 3 requirement: Save and restore at least one user preference
class PreferencesService {
  // Keys for SharedPreferences
  static const String _themeModeKey = 'theme_mode';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _lastSelectedTabKey = 'last_selected_tab';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _unitsSystemKey = 'units_system'; // 'metric' or 'imperial'

  /// Save theme mode (Step 3 requirement: User preference)
  Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDark);
  }

  /// Get theme mode
  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeModeKey) ?? false; // Default: light mode
  }

  /// Save onboarding completion status
  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Save last selected tab (Step 3 requirement: User preference)
  Future<void> saveLastSelectedTab(int tabIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSelectedTabKey, tabIndex);
  }

  /// Get last selected tab
  Future<int> getLastSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastSelectedTabKey) ?? 0; // Default: first tab
  }

  /// Save notifications enabled status
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  /// Get notifications enabled status
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true; // Default: enabled
  }

  /// Save units system preference (metric/imperial)
  Future<void> saveUnitsSystem(String system) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitsSystemKey, system);
  }

  /// Get units system preference
  Future<String> getUnitsSystem() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_unitsSystemKey) ?? 'metric'; // Default: metric
  }

  /// Clear all preferences (for logout/reset)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Clear specific preference
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}



