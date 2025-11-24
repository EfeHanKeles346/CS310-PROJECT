import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_data.dart';

class UserDataService extends ChangeNotifier {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal() {
    _loadUserData();
  }
  
  UserData? _userData;
  static const String _userDataKey = 'user_data';
  
  UserData? get userData => _userData;
  
  bool get hasUserData => _userData != null;
  
  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);
      
      if (userDataString != null) {
        debugPrint('UserDataService: Loading data from storage');
        final Map<String, dynamic> dataMap = jsonDecode(userDataString);
        _userData = UserData.fromMap(dataMap);
        debugPrint('UserDataService: Loaded - Weight: ${_userData?.weight}, Initial: ${_userData?.initialWeight}, Target: ${_userData?.targetWeight}');
        notifyListeners();
      } else {
        debugPrint('UserDataService: No data found in storage');
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }
  
  // Save user data to SharedPreferences and memory
  Future<void> saveUserData(UserData data) async {
    _userData = data;
    debugPrint('UserDataService: Saving - Weight: ${data.weight}, Initial: ${data.initialWeight}, Target: ${data.targetWeight}, Goal: ${data.primaryGoal}');
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = jsonEncode(data.toMap());
      await prefs.setString(_userDataKey, userDataString);
      debugPrint('UserDataService: Data saved successfully to storage');
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }
  
  // Update user data partially
  Future<void> updateUserData(UserData data) async {
    if (_userData != null) {
      debugPrint('UserDataService: Updating - New Weight: ${data.weight}, Preserved Initial: ${_userData!.initialWeight}');
      _userData = _userData!.copyWith(
        name: data.name,
        age: data.age,
        height: data.height,
        weight: data.weight,
        initialWeight: data.initialWeight ?? _userData!.initialWeight, // Preserve initial weight
        gender: data.gender,
        primaryGoal: data.primaryGoal,
        targetWeight: data.targetWeight,
        trainingExperience: data.trainingExperience,
        bodyFatPercentage: data.bodyFatPercentage ?? _userData!.bodyFatPercentage,
        muscleMass: data.muscleMass ?? _userData!.muscleMass,
      );
      debugPrint('UserDataService: After update - Weight: ${_userData!.weight}, Initial: ${_userData!.initialWeight}');
    } else {
      debugPrint('UserDataService: No existing data, creating new');
      _userData = data;
    }
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = jsonEncode(_userData!.toMap());
      await prefs.setString(_userDataKey, userDataString);
      debugPrint('UserDataService: Data updated successfully in storage');
    } catch (e) {
      debugPrint('Error updating user data: $e');
    }
  }
  
  // Clear user data
  Future<void> clearUserData() async {
    _userData = null;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }
  
  // Refresh data from storage (useful for hot reload)
  Future<void> refresh() async {
    await _loadUserData();
  }
}
