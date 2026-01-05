import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Preferences Provider using ChangeNotifier
/// Step 3 requirement: SharedPreferences for user preferences
class PreferencesProvider extends ChangeNotifier {
  final PreferencesService _prefsService = PreferencesService();
  
  bool _isDarkMode = false;
  bool _isOnboardingCompleted = false;
  int _lastSelectedTab = 0;
  bool _notificationsEnabled = true;
  String _unitsSystem = 'metric'; // 'metric' or 'imperial'

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  int get lastSelectedTab => _lastSelectedTab;
  bool get notificationsEnabled => _notificationsEnabled;
  String get unitsSystem => _unitsSystem;
  bool get isMetric => _unitsSystem == 'metric';

  PreferencesProvider() {
    _loadPreferences();
  }

  /// Load all preferences on initialization
  Future<void> _loadPreferences() async {
    _isDarkMode = await _prefsService.getThemeMode();
    _isOnboardingCompleted = await _prefsService.isOnboardingCompleted();
    _lastSelectedTab = await _prefsService.getLastSelectedTab();
    _notificationsEnabled = await _prefsService.areNotificationsEnabled();
    _unitsSystem = await _prefsService.getUnitsSystem();
    notifyListeners();
  }

  /// Toggle theme mode (Step 3 requirement: User preference persistence)
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefsService.saveThemeMode(_isDarkMode);
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(bool isDark) async {
    _isDarkMode = isDark;
    await _prefsService.saveThemeMode(_isDarkMode);
    notifyListeners();
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    _isOnboardingCompleted = true;
    await _prefsService.setOnboardingCompleted(true);
    notifyListeners();
  }

  /// Save last selected tab (Step 3 requirement: User preference persistence)
  Future<void> saveLastSelectedTab(int tabIndex) async {
    _lastSelectedTab = tabIndex;
    await _prefsService.saveLastSelectedTab(tabIndex);
    notifyListeners();
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await _prefsService.setNotificationsEnabled(_notificationsEnabled);
    notifyListeners();
  }

  /// Set notifications enabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _prefsService.setNotificationsEnabled(enabled);
    notifyListeners();
  }

  /// Set units system
  Future<void> setUnitsSystem(String system) async {
    if (system == 'metric' || system == 'imperial') {
      _unitsSystem = system;
      await _prefsService.saveUnitsSystem(system);
      notifyListeners();
    }
  }

  /// Toggle units system
  Future<void> toggleUnitsSystem() async {
    _unitsSystem = _unitsSystem == 'metric' ? 'imperial' : 'metric';
    await _prefsService.saveUnitsSystem(_unitsSystem);
    notifyListeners();
  }

  /// Clear all preferences
  Future<void> clearAll() async {
    await _prefsService.clearAll();
    _isDarkMode = false;
    _isOnboardingCompleted = false;
    _lastSelectedTab = 0;
    _notificationsEnabled = true;
    _unitsSystem = 'metric';
    notifyListeners();
  }

  /// Weight conversion helpers
  double convertWeight(double kg) {
    if (_unitsSystem == 'imperial') {
      return kg * 2.20462; // kg to lbs
    }
    return kg;
  }

  String getWeightUnit() {
    return _unitsSystem == 'metric' ? 'kg' : 'lbs';
  }

  /// Height conversion helpers
  double convertHeight(double cm) {
    if (_unitsSystem == 'imperial') {
      return cm * 0.393701; // cm to inches
    }
    return cm;
  }

  String getHeightUnit() {
    return _unitsSystem == 'metric' ? 'cm' : 'in';
  }

  /// Distance conversion helpers
  double convertDistance(double km) {
    if (_unitsSystem == 'imperial') {
      return km * 0.621371; // km to miles
    }
    return km;
  }

  String getDistanceUnit() {
    return _unitsSystem == 'metric' ? 'km' : 'mi';
  }
}



